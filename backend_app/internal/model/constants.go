package model

// User roles
const (
	RoleOwner    = "owner"
	RoleKasir    = "kasir"
	RoleProduksi = "produksi"
)

// Pesanan status
const (
	StatusBaru         = "Baru"
	StatusDiproses     = "Diproses"
	StatusSiapDiambil  = "Siap Diambil"
	StatusSelesai      = "Selesai"
	StatusDibatalkan   = "Dibatalkan"
)

// Layanan kategori
const (
	KategoriCuci          = "Cuci"
	KategoriCuciSetrika   = "Cuci & Setrika"
	KategoriSetrika       = "Setrika"
	KategoriSpesial       = "Spesial"
)

// Layanan satuan
const (
	SatuanKg     = "kg"
	SatuanPcs    = "pcs"
	SatuanPasang = "pasang"
	SatuanSet    = "set"
)

// Pelanggan gender
const (
	GenderLakiLaki = "Laki-laki"
	GenderPerempuan = "Perempuan"
)
