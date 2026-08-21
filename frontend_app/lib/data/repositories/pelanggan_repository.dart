import 'package:drift/drift.dart';

import '../../models/entities.dart';
import '../../services/app_api.dart';
import '../local/app_database.dart';

class PelangganRepository {
  PelangganRepository({
    required AppDatabase db,
    AppApi? api,
  })  : _db = db,
        _api = api ?? AppApi();

  final AppDatabase _db;
  final AppApi _api;

  static const int pageSize = 20;
  static const Duration staleAfter = Duration(seconds: 45);

  static DateTime? _lastSyncAt;
  static Future<void>? _inflightSync;

  /// Stream murni dari cache lokal (cepat). Sync dipanggil terpisah.
  Stream<List<Pelanggan>> watchAll({String? query, String? gender}) {
    final q = _db.select(_db.pelangganEntries)
      ..orderBy([(t) => OrderingTerm.desc(t.id)]);

    if (query != null && query.trim().isNotEmpty) {
      final like = '%${query.trim()}%';
      q.where((t) => t.name.like(like) | t.phone.like(like));
    }
    if (gender != null && gender.isNotEmpty) {
      q.where((t) => t.gender.equals(gender));
    }

    return q.watch().map((rows) => rows.map(_mapRow).toList());
  }

  Future<void> refresh() => syncIfNeeded(force: true);

  Future<void> loadMore(int page) => _syncFromServer(page: page);

  Future<void> syncIfNeeded({bool force = false}) {
    if (!force &&
        _lastSyncAt != null &&
        DateTime.now().difference(_lastSyncAt!) < staleAfter) {
      return Future.value();
    }
    return _inflightSync ??= _syncFromServer(page: 1).whenComplete(() {
      _inflightSync = null;
      _lastSyncAt = DateTime.now();
    });
  }

  Future<List<Pelanggan>> search(String query) async {
    final like = '%${query.trim()}%';
    final rows = await (_db.select(_db.pelangganEntries)
          ..where((t) => t.name.like(like) | t.phone.like(like))
          ..orderBy([(t) => OrderingTerm.desc(t.id)]))
        .get();
    return rows.map(_mapRow).toList();
  }

  Future<void> upsertLocal(Pelanggan item) async {
    await _db.into(_db.pelangganEntries).insertOnConflictUpdate(_toCompanion(item));
  }

  Future<void> deleteLocal(int id) async {
    await (_db.delete(_db.pelangganEntries)..where((t) => t.id.equals(id))).go();
  }

  Future<void> _syncFromServer({required int page}) async {
    try {
      final result = await _api.listPelanggan(page: page, limit: pageSize);
      if (result.items.isEmpty) return;

      await _db.batch((batch) {
        batch.insertAllOnConflictUpdate(
          _db.pelangganEntries,
          result.items.map(_toCompanion).toList(),
        );
      });
    } catch (_) {
      // Offline / API error: keep existing cache silently.
    }
  }

  PelangganEntriesCompanion _toCompanion(Pelanggan p) {
    return PelangganEntriesCompanion(
      id: Value(p.id),
      name: Value(p.name),
      phone: Value(p.phone),
      address: Value(p.address),
      gender: Value(p.gender),
      outletId: Value(p.outletId),
      outletName: Value(p.outletName),
      syncedAt: Value(DateTime.now()),
    );
  }

  Pelanggan _mapRow(PelangganEntry row) {
    return Pelanggan(
      id: row.id,
      name: row.name,
      phone: row.phone,
      address: row.address,
      gender: row.gender,
      outletId: row.outletId,
      outletName: row.outletName,
    );
  }
}
