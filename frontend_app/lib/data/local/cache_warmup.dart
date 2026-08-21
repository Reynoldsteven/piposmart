import 'database_provider.dart';
import '../repositories/karyawan_repository.dart';
import '../repositories/pelanggan_repository.dart';
import '../repositories/pesanan_repository.dart';

/// Prefetch cache setelah login agar list langsung terasa cepat.
Future<void> warmLocalCaches() async {
  final db = DatabaseProvider.instance;
  await Future.wait([
    PelangganRepository(db: db).syncIfNeeded(force: true),
    KaryawanRepository(db: db).syncIfNeeded(force: true),
    PesananRepository(db: db).syncIfNeeded(force: true),
  ]);
}
