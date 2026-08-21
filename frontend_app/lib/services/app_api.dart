import '../models/entities.dart';
import 'api_client.dart';

class AppApi {
  AppApi({ApiClient? client}) : _api = client ?? ApiClient();

  final ApiClient _api;

  Future<PagedResult<Layanan>> listLayanan({int page = 1, int limit = 50, String? q, String? kategori}) {
    return _api.getPaged(
      '/layanan',
      queryParameters: {
        'page': page,
        'limit': limit,
        if (q != null && q.isNotEmpty) 'q': q,
        if (kategori != null && kategori.isNotEmpty) 'kategori': kategori,
      },
      itemParser: Layanan.fromJson,
    );
  }

  Future<Layanan> getLayanan(int id) =>
      _api.get('/layanan/$id', parser: (raw) => Layanan.fromJson(raw as Map<String, dynamic>));

  Future<Layanan> createLayanan(Map<String, dynamic> body) =>
      _api.post('/layanan', data: body, parser: (raw) => Layanan.fromJson(raw as Map<String, dynamic>));

  Future<Layanan> updateLayanan(int id, Map<String, dynamic> body) =>
      _api.put('/layanan/$id', data: body, parser: (raw) => Layanan.fromJson(raw as Map<String, dynamic>));

  Future<void> deleteLayanan(int id) => _api.delete('/layanan/$id');

  Future<PagedResult<Pelanggan>> listPelanggan({int page = 1, int limit = 50, String? q}) {
    return _api.getPaged(
      '/pelanggan',
      queryParameters: {'page': page, 'limit': limit, if (q != null && q.isNotEmpty) 'q': q},
      itemParser: Pelanggan.fromJson,
    );
  }

  Future<Pelanggan> getPelanggan(int id) =>
      _api.get('/pelanggan/$id', parser: (raw) => Pelanggan.fromJson(raw as Map<String, dynamic>));

  Future<Pelanggan> createPelanggan(Map<String, dynamic> body) =>
      _api.post('/pelanggan', data: body, parser: (raw) => Pelanggan.fromJson(raw as Map<String, dynamic>));

  Future<Pelanggan> updatePelanggan(int id, Map<String, dynamic> body) =>
      _api.put('/pelanggan/$id', data: body, parser: (raw) => Pelanggan.fromJson(raw as Map<String, dynamic>));

  Future<void> deletePelanggan(int id) => _api.delete('/pelanggan/$id');

  Future<PagedResult<Outlet>> listOutlets({int page = 1, int limit = 50, String? q}) {
    return _api.getPaged(
      '/outlets',
      queryParameters: {'page': page, 'limit': limit, if (q != null && q.isNotEmpty) 'q': q},
      itemParser: Outlet.fromJson,
    );
  }

  Future<Outlet> getOutlet(int id) =>
      _api.get('/outlets/$id', parser: (raw) => Outlet.fromJson(raw as Map<String, dynamic>));

  Future<Outlet> createOutlet(Map<String, dynamic> body) =>
      _api.post('/outlets', data: body, parser: (raw) => Outlet.fromJson(raw as Map<String, dynamic>));

  Future<Outlet> updateOutlet(int id, Map<String, dynamic> body) =>
      _api.put('/outlets/$id', data: body, parser: (raw) => Outlet.fromJson(raw as Map<String, dynamic>));

  Future<void> deleteOutlet(int id) => _api.delete('/outlets/$id');

  Future<PagedResult<Karyawan>> listKaryawan({int page = 1, int limit = 50, String? q, String? role}) {
    return _api.getPaged(
      '/karyawan',
      queryParameters: {
        'page': page,
        'limit': limit,
        if (q != null && q.isNotEmpty) 'q': q,
        if (role != null && role.isNotEmpty) 'role': role,
      },
      itemParser: Karyawan.fromJson,
    );
  }

  Future<Karyawan> getKaryawan(int id) =>
      _api.get('/karyawan/$id', parser: (raw) => Karyawan.fromJson(raw as Map<String, dynamic>));

  Future<Karyawan> createKaryawan(Map<String, dynamic> body) =>
      _api.post('/karyawan', data: body, parser: (raw) => Karyawan.fromJson(raw as Map<String, dynamic>));

  Future<Karyawan> updateKaryawan(int id, Map<String, dynamic> body) =>
      _api.put('/karyawan/$id', data: body, parser: (raw) => Karyawan.fromJson(raw as Map<String, dynamic>));

  Future<void> deleteKaryawan(int id) => _api.delete('/karyawan/$id');

  Future<PagedResult<Pesanan>> listPesanan({int page = 1, int limit = 50, String? status, String? q}) {
    return _api.getPaged(
      '/pesanan',
      queryParameters: {
        'page': page,
        'limit': limit,
        if (status != null && status.isNotEmpty) 'status': status,
        if (q != null && q.isNotEmpty) 'q': q,
      },
      itemParser: Pesanan.fromJson,
    );
  }

  Future<Pesanan> getPesanan(int id) =>
      _api.get('/pesanan/$id', parser: (raw) => Pesanan.fromJson(raw as Map<String, dynamic>));

  Future<Pesanan> createPesanan(Map<String, dynamic> body) =>
      _api.post('/pesanan', data: body, parser: (raw) => Pesanan.fromJson(raw as Map<String, dynamic>));

  Future<Pesanan> updatePesanan(int id, Map<String, dynamic> body) =>
      _api.put('/pesanan/$id', data: body, parser: (raw) => Pesanan.fromJson(raw as Map<String, dynamic>));

  Future<void> deletePesanan(int id) => _api.delete('/pesanan/$id');

  Future<PagedResult<Transaction>> listTransactions({int page = 1, int limit = 20, String? status, String? q}) {
    return _api.getPaged(
      '/transactions',
      queryParameters: {
        'page': page,
        'limit': limit,
        if (status != null && status.isNotEmpty) 'status': status,
        if (q != null && q.isNotEmpty) 'q': q,
      },
      itemParser: Transaction.fromJson,
    );
  }

  Future<DashboardSummary> dashboardSummary() => _api.get(
        '/dashboard/summary',
        parser: (raw) => DashboardSummary.fromJson(raw as Map<String, dynamic>),
      );

  Future<StatusSummary> statusSummary() => _api.get(
        '/orders/status-summary',
        parser: (raw) => StatusSummary.fromJson(raw as Map<String, dynamic>),
      );
}
