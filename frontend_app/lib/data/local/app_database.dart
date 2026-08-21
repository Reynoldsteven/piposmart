import 'package:drift/drift.dart';
import 'package:drift_flutter/drift_flutter.dart';

part 'app_database.g.dart';

class PelangganEntries extends Table {
  IntColumn get id => integer()();
  TextColumn get name => text()();
  TextColumn get phone => text().nullable()();
  TextColumn get address => text().nullable()();
  TextColumn get gender => text().nullable()();
  IntColumn get outletId => integer().nullable()();
  TextColumn get outletName => text().nullable()();
  DateTimeColumn get syncedAt => dateTime().withDefault(currentDateAndTime)();

  @override
  Set<Column> get primaryKey => {id};
}

class KaryawanEntries extends Table {
  IntColumn get id => integer()();
  TextColumn get name => text()();
  TextColumn get email => text()();
  TextColumn get phone => text().nullable()();
  TextColumn get role => text()();
  TextColumn get outletNames => text().withDefault(const Constant(''))();
  TextColumn get joinDate => text().nullable()();
  DateTimeColumn get syncedAt => dateTime().withDefault(currentDateAndTime)();

  @override
  Set<Column> get primaryKey => {id};
}

class PesananEntries extends Table {
  IntColumn get id => integer()();
  TextColumn get kode => text()();
  IntColumn get outletId => integer()();
  TextColumn get outletName => text().withDefault(const Constant(''))();
  IntColumn get pelangganId => integer().nullable()();
  TextColumn get pelangganName => text().nullable()();
  TextColumn get status => text()();
  BoolColumn get isLunas => boolean().withDefault(const Constant(false))();
  RealColumn get total => real().withDefault(const Constant(0))();
  TextColumn get pickupEstimate => text().nullable()();
  TextColumn get notes => text().nullable()();
  TextColumn get layananSummary => text().withDefault(const Constant(''))();
  TextColumn get createdAt => text().withDefault(const Constant(''))();
  DateTimeColumn get syncedAt => dateTime().withDefault(currentDateAndTime)();

  @override
  Set<Column> get primaryKey => {id};
}

@DriftDatabase(tables: [PelangganEntries, KaryawanEntries, PesananEntries])
class AppDatabase extends _$AppDatabase {
  AppDatabase([QueryExecutor? executor]) : super(executor ?? _openConnection());

  @override
  int get schemaVersion => 1;

  static QueryExecutor _openConnection() {
    return driftDatabase(name: 'piposmart_cache');
  }
}
