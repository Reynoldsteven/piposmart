class Layanan {
  final int id;
  final String kode;
  final String name;
  final String kategori;
  final double harga;
  final String satuan;
  final bool isActive;

  const Layanan({
    required this.id,
    required this.kode,
    required this.name,
    required this.kategori,
    required this.harga,
    required this.satuan,
    required this.isActive,
  });

  factory Layanan.fromJson(Map<String, dynamic> json) => Layanan(
        id: (json['id'] as num).toInt(),
        kode: json['kode']?.toString() ?? '',
        name: json['name']?.toString() ?? '',
        kategori: json['kategori']?.toString() ?? '',
        harga: (json['harga'] as num?)?.toDouble() ?? 0,
        satuan: json['satuan']?.toString() ?? '',
        isActive: json['is_active'] == true || json['is_active'] == 1,
      );

  String get statusLabel => isActive ? 'Aktif' : 'Tidak Aktif';
}

class Pelanggan {
  final int id;
  final String name;
  final String? phone;
  final String? address;
  final String? gender;
  final int? outletId;
  final String? outletName;

  const Pelanggan({
    required this.id,
    required this.name,
    this.phone,
    this.address,
    this.gender,
    this.outletId,
    this.outletName,
  });

  factory Pelanggan.fromJson(Map<String, dynamic> json) => Pelanggan(
        id: (json['id'] as num).toInt(),
        name: json['name']?.toString() ?? '',
        phone: json['phone']?.toString(),
        address: json['address']?.toString(),
        gender: json['gender']?.toString(),
        outletId: (json['outlet_id'] as num?)?.toInt(),
        outletName: json['outlet_name']?.toString(),
      );
}

class Outlet {
  final int id;
  final String name;
  final String? address;
  final String? provinsi;
  final String? kota;
  final String? kecamatan;

  const Outlet({
    required this.id,
    required this.name,
    this.address,
    this.provinsi,
    this.kota,
    this.kecamatan,
  });

  factory Outlet.fromJson(Map<String, dynamic> json) => Outlet(
        id: (json['id'] as num).toInt(),
        name: json['name']?.toString() ?? '',
        address: json['address']?.toString(),
        provinsi: json['provinsi']?.toString(),
        kota: json['kota']?.toString(),
        kecamatan: json['kecamatan']?.toString(),
      );
}

class Karyawan {
  final int id;
  final String name;
  final String email;
  final String? phone;
  final String role;
  final List<String> outletNames;
  final String? joinDate;

  const Karyawan({
    required this.id,
    required this.name,
    required this.email,
    this.phone,
    required this.role,
    this.outletNames = const [],
    this.joinDate,
  });

  factory Karyawan.fromJson(Map<String, dynamic> json) {
    final outlets = <String>[];
    String? joinDate;
    final rawOutlets = json['outlets'];
    if (rawOutlets is List) {
      for (final o in rawOutlets) {
        if (o is Map) {
          outlets.add(o['name']?.toString() ?? '');
          joinDate ??= o['join_date']?.toString();
        }
      }
    }
    return Karyawan(
      id: (json['id'] as num).toInt(),
      name: json['name']?.toString() ?? '',
      email: json['email']?.toString() ?? '',
      phone: json['phone']?.toString(),
      role: json['role']?.toString() ?? '',
      outletNames: outlets.where((e) => e.isNotEmpty).toList(),
      joinDate: joinDate,
    );
  }
}

class Pesanan {
  final int id;
  final String kode;
  final int outletId;
  final String outletName;
  final int? pelangganId;
  final String? pelangganName;
  final String status;
  final bool isLunas;
  final double total;
  final String? pickupEstimate;
  final String? notes;
  final String layananSummary;
  final String createdAt;
  final List<PesananItem> items;

  const Pesanan({
    required this.id,
    required this.kode,
    required this.outletId,
    required this.outletName,
    this.pelangganId,
    this.pelangganName,
    required this.status,
    required this.isLunas,
    required this.total,
    this.pickupEstimate,
    this.notes,
    this.layananSummary = '',
    required this.createdAt,
    this.items = const [],
  });

  factory Pesanan.fromJson(Map<String, dynamic> json) {
    final items = <PesananItem>[];
    final rawItems = json['items'];
    if (rawItems is List) {
      for (final e in rawItems) {
        if (e is Map<String, dynamic>) {
          items.add(PesananItem.fromJson(e));
        } else if (e is Map) {
          items.add(PesananItem.fromJson(Map<String, dynamic>.from(e)));
        }
      }
    }
    return Pesanan(
      id: (json['id'] as num).toInt(),
      kode: json['kode']?.toString() ?? '',
      outletId: (json['outlet_id'] as num?)?.toInt() ?? 0,
      outletName: json['outlet_name']?.toString() ?? '',
      pelangganId: (json['pelanggan_id'] as num?)?.toInt(),
      pelangganName: json['pelanggan_name']?.toString(),
      status: json['status']?.toString() ?? '',
      isLunas: json['is_lunas'] == true || json['is_lunas'] == 1,
      total: (json['total'] as num?)?.toDouble() ?? 0,
      pickupEstimate: json['pickup_estimate']?.toString(),
      notes: json['notes']?.toString(),
      layananSummary: json['layanan_summary']?.toString() ?? '',
      createdAt: json['created_at']?.toString() ?? '',
      items: items,
    );
  }
}

class PesananItem {
  final int id;
  final String namaLayanan;
  final double harga;
  final String satuan;
  final double qty;
  final double subtotal;

  const PesananItem({
    required this.id,
    required this.namaLayanan,
    required this.harga,
    required this.satuan,
    required this.qty,
    required this.subtotal,
  });

  factory PesananItem.fromJson(Map<String, dynamic> json) => PesananItem(
        id: (json['id'] as num).toInt(),
        namaLayanan: json['nama_layanan']?.toString() ?? '',
        harga: (json['harga'] as num?)?.toDouble() ?? 0,
        satuan: json['satuan']?.toString() ?? '',
        qty: (json['qty'] as num?)?.toDouble() ?? 0,
        subtotal: (json['subtotal'] as num?)?.toDouble() ?? 0,
      );
}

class Transaction {
  final String kode;
  final String outletName;
  final String tanggal;
  final String status;
  final bool isLunas;
  final double total;
  final String? pickupEstimate;
  final int jumlahItemLayanan;
  final String? pelangganName;

  const Transaction({
    required this.kode,
    required this.outletName,
    required this.tanggal,
    required this.status,
    required this.isLunas,
    required this.total,
    this.pickupEstimate,
    required this.jumlahItemLayanan,
    this.pelangganName,
  });

  factory Transaction.fromJson(Map<String, dynamic> json) => Transaction(
        kode: json['kode']?.toString() ?? '',
        outletName: json['outlet_name']?.toString() ?? '',
        tanggal: json['tanggal']?.toString() ?? '',
        status: json['status']?.toString() ?? '',
        isLunas: json['is_lunas'] == true || json['is_lunas'] == 1,
        total: (json['total'] as num?)?.toDouble() ?? 0,
        pickupEstimate: json['pickup_estimate']?.toString(),
        jumlahItemLayanan: (json['jumlah_item_layanan'] as num?)?.toInt() ?? 0,
        pelangganName: json['pelanggan_name']?.toString(),
      );
}

class DashboardSummary {
  final int pesananAktif;
  final double labaHariIni;
  final int penjualanHariIni;
  final double pengeluaranHariIni;
  final int totalSelesai;

  const DashboardSummary({
    required this.pesananAktif,
    required this.labaHariIni,
    required this.penjualanHariIni,
    required this.pengeluaranHariIni,
    required this.totalSelesai,
  });

  factory DashboardSummary.fromJson(Map<String, dynamic> json) => DashboardSummary(
        pesananAktif: (json['pesanan_aktif'] as num?)?.toInt() ?? 0,
        labaHariIni: (json['laba_hari_ini'] as num?)?.toDouble() ?? 0,
        penjualanHariIni: (json['penjualan_hari_ini'] as num?)?.toInt() ?? 0,
        pengeluaranHariIni: (json['pengeluaran_hari_ini'] as num?)?.toDouble() ?? 0,
        totalSelesai: (json['total_selesai'] as num?)?.toInt() ?? 0,
      );
}

class StatusSummary {
  final int selesai;
  final int terlambat;
  final int harusSelesai;

  const StatusSummary({
    required this.selesai,
    required this.terlambat,
    required this.harusSelesai,
  });

  factory StatusSummary.fromJson(Map<String, dynamic> json) => StatusSummary(
        selesai: (json['selesai'] as num?)?.toInt() ?? 0,
        terlambat: (json['terlambat'] as num?)?.toInt() ?? 0,
        harusSelesai: (json['harus_selesai'] as num?)?.toInt() ?? 0,
      );
}
