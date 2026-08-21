import 'package:drift/drift.dart';

import '../../models/entities.dart';
import '../../services/app_api.dart';
import '../local/app_database.dart';

class KaryawanRepository {
  KaryawanRepository({
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

  Stream<List<Karyawan>> watchAll({String? query, String? role}) {
    final q = _db.select(_db.karyawanEntries)
      ..orderBy([(t) => OrderingTerm.desc(t.id)]);

    if (query != null && query.trim().isNotEmpty) {
      final like = '%${query.trim()}%';
      q.where((t) => t.name.like(like) | t.email.like(like) | t.phone.like(like));
    }
    if (role != null && role.isNotEmpty) {
      q.where((t) => t.role.equals(role));
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

  Future<List<Karyawan>> search(String query) async {
    final like = '%${query.trim()}%';
    final rows = await (_db.select(_db.karyawanEntries)
          ..where((t) => t.name.like(like) | t.email.like(like) | t.phone.like(like))
          ..orderBy([(t) => OrderingTerm.desc(t.id)]))
        .get();
    return rows.map(_mapRow).toList();
  }

  Future<void> upsertLocal(Karyawan item) async {
    await _db.into(_db.karyawanEntries).insertOnConflictUpdate(_toCompanion(item));
  }

  Future<void> deleteLocal(int id) async {
    await (_db.delete(_db.karyawanEntries)..where((t) => t.id.equals(id))).go();
  }

  Future<void> _syncFromServer({required int page}) async {
    try {
      final result = await _api.listKaryawan(page: page, limit: pageSize);
      if (result.items.isEmpty) return;
      await _db.batch((batch) {
        batch.insertAllOnConflictUpdate(
          _db.karyawanEntries,
          result.items.map(_toCompanion).toList(),
        );
      });
    } catch (_) {}
  }

  KaryawanEntriesCompanion _toCompanion(Karyawan k) {
    return KaryawanEntriesCompanion(
      id: Value(k.id),
      name: Value(k.name),
      email: Value(k.email),
      phone: Value(k.phone),
      role: Value(k.role),
      outletNames: Value(k.outletNames.join('|')),
      joinDate: Value(k.joinDate),
      syncedAt: Value(DateTime.now()),
    );
  }

  Karyawan _mapRow(KaryawanEntry row) {
    return Karyawan(
      id: row.id,
      name: row.name,
      email: row.email,
      phone: row.phone,
      role: row.role,
      outletNames: row.outletNames.isEmpty
          ? const []
          : row.outletNames.split('|').where((e) => e.isNotEmpty).toList(),
      joinDate: row.joinDate,
    );
  }
}
