package model

import "github.com/shopspring/decimal"

type PesananItem struct {
	ID          uint64           `gorm:"column:id;primaryKey;autoIncrement" json:"id"`
	PesananID   uint64           `gorm:"column:pesanan_id;not null;index:idx_pi_pesanan" json:"pesanan_id"`
	LayananID   *uint64          `gorm:"column:layanan_id" json:"layanan_id,omitempty"`
	NamaLayanan string           `gorm:"column:nama_layanan;type:varchar(150);not null" json:"nama_layanan"`
	Harga       decimal.Decimal  `gorm:"column:harga;type:decimal(12,2);not null" json:"harga"`
	Satuan      string           `gorm:"column:satuan;type:varchar(20);not null" json:"satuan"`
	Qty         decimal.Decimal  `gorm:"column:qty;type:decimal(8,2);not null;default:1" json:"qty"`
	Subtotal    decimal.Decimal  `gorm:"column:subtotal;type:decimal(14,2);not null" json:"subtotal"`

	Pesanan *Pesanan `gorm:"foreignKey:PesananID;constraint:OnDelete:CASCADE" json:"pesanan,omitempty"`
	Layanan *Layanan `gorm:"foreignKey:LayananID;constraint:OnDelete:SET NULL" json:"layanan,omitempty"`
}

func (PesananItem) TableName() string {
	return "pesanan_item"
}
