package dto

type PesananItemInput struct {
	LayananID uint64  `json:"layanan_id" binding:"required"`
	Qty       float64 `json:"qty" binding:"required,gt=0"`
}

type CreatePesananRequest struct {
	OutletID       uint64             `json:"outlet_id" binding:"required"`
	PelangganID    *uint64            `json:"pelanggan_id"`
	Items          []PesananItemInput `json:"items" binding:"required,min=1,dive"`
	PickupEstimate *string            `json:"pickup_estimate"` // RFC3339 or "2006-01-02 15:04:05"
	Notes          *string            `json:"notes"`
}

type UpdatePesananRequest struct {
	Status         *string `json:"status"`
	IsLunas        *bool   `json:"is_lunas"`
	Notes          *string `json:"notes"`
	PickupEstimate *string `json:"pickup_estimate"`
}

type PesananItemResponse struct {
	ID          uint64  `json:"id"`
	LayananID   *uint64 `json:"layanan_id,omitempty"`
	NamaLayanan string  `json:"nama_layanan"`
	Harga       float64 `json:"harga"`
	Satuan      string  `json:"satuan"`
	Qty         float64 `json:"qty"`
	Subtotal    float64 `json:"subtotal"`
}

type PesananResponse struct {
	ID             uint64                `json:"id"`
	Kode           string                `json:"kode"`
	OutletID       uint64                `json:"outlet_id"`
	OutletName     string                `json:"outlet_name"`
	PelangganID    *uint64               `json:"pelanggan_id,omitempty"`
	PelangganName  *string               `json:"pelanggan_name,omitempty"`
	UserID         *uint64               `json:"user_id,omitempty"`
	Status         string                `json:"status"`
	IsLunas        bool                  `json:"is_lunas"`
	Total          float64               `json:"total"`
	PickupEstimate *string               `json:"pickup_estimate,omitempty"`
	Notes          *string               `json:"notes,omitempty"`
	Items          []PesananItemResponse `json:"items,omitempty"`
	LayananSummary string                `json:"layanan_summary,omitempty"`
	CreatedAt      string                `json:"created_at"`
	UpdatedAt      string                `json:"updated_at"`
}

type TransactionResponse struct {
	Kode              string  `json:"kode"`
	OutletName        string  `json:"outlet_name"`
	Tanggal           string  `json:"tanggal"`
	Status            string  `json:"status"`
	IsLunas           bool    `json:"is_lunas"`
	Total             float64 `json:"total"`
	PickupEstimate    *string `json:"pickup_estimate,omitempty"`
	JumlahItemLayanan int     `json:"jumlah_item_layanan"`
	PelangganName     *string `json:"pelanggan_name,omitempty"`
}
