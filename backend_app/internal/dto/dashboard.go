package dto

type DashboardSummaryResponse struct {
	PesananAktif       int64   `json:"pesanan_aktif"`
	LabaHariIni        float64 `json:"laba_hari_ini"`
	PenjualanHariIni   int64   `json:"penjualan_hari_ini"`
	PengeluaranHariIni float64 `json:"pengeluaran_hari_ini"`
	TotalSelesai       int64   `json:"total_selesai"`
}

type StatusSummaryResponse struct {
	Selesai      int64 `json:"selesai"`
	Terlambat    int64 `json:"terlambat"`
	HarusSelesai int64 `json:"harus_selesai"`
}
