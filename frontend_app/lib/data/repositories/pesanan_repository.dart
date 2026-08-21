import 'package:drift/drift.dart';

import '../../models/entities.dart';
import '../../services/app_api.dart';
import '../local/app_database.dart';

class PesananRepository {
  PesananRepository({
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

  Stream<List<Pesanan>> watchAll({String? query, String? status}) {
    final q = _db.select(_db.pesananEntries)
      ..orderBy([(t) => OrderingTerm.desc(t.id)]);

    if (query != null && query.trim().isNotEmpty) {
      final like = '%${query.trim()}%';
      q.where((t) => t.kode.like(like) | t.pelangganName.like(like));
    }
    if (status != null && status.isNotEmpty) {
      q.where((t) => t.status.equals(status));
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

  Future<List<Pesanan>> search(String query) async {
    final like = '%${query.trim()}%';
    final rows = await (_db.select(_db.pesananEntries)
          ..where((t) => t.kode.like(like) | t.pelangganName.like(like))
          ..orderBy([(t) => OrderingTerm.desc(t.id)]))
        .get();
    return rows.map(_mapRow).toList();
  }

  Future<void> upsertLocal(Pesanan item) async {
    await _db.into(_db.pesananEntries).insertOnConflictUpdate(_toCompanion(item));
  }

  Future<void> deleteLocal(int id) async {
    await (_db.delete(_db.pesananEntries)..where((t) => t.id.equals(id))).go();
  }

  Future<void> _syncFromServer({required int page}) async {
    try {
      final result = await _api.listPesanan(page: page, limit: pageSize);
      if (result.items.isEmpty) return;
      await _db.batch((batch) {
        batch.insertAllOnConflictUpdate(
          _db.pesananEntries,
          result.items.map(_toCompanion).toList(),
        );
      });
    } catch (_) {}
  }

  PesananEntriesCompanion _toCompanion(Pesanan p) {
    return PesananEntriesCompanion(
      id: Value(p.id),
      kode: Value(p.kode),
      outletId: Value(p.outletId),
      outletName: Value(p.outletName),
      pelangganId: Value(p.pelangganId),
      pelangganName: Value(p.pelangganName),
      status: Value(p.status),
      isLunas: Value(p.isLunas),
      total: Value(p.total),
      pickupEstimate: Value(p.pickupEstimate),
      notes: Value(p.notes),
      layananSummary: Value(p.layananSummary),
      createdAt: Value(p.createdAt),
      syncedAt: Value(DateTime.now()),
    );
  }

  Pesanan _mapRow(PesananEntry row) {
    return Pesanan(
      id: row.id,
      kode: row.kode,
      outletId: row.outletId,
      outletName: row.outletName,
      pelangganId: row.pelangganId,
      pelangganName: row.pelangganName,
      status: row.status,
      isLunas: row.isLunas,
      total: row.total,
      pickupEstimate: row.pickupEstimate,
      notes: row.notes,
      layananSummary: row.layananSummary,
      createdAt: row.createdAt,
    );
  }
}
