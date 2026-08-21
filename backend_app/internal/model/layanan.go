package model

import (
	"time"

	"github.com/shopspring/decimal"
)

type Layanan struct {
	ID        uint64          `gorm:"column:id;primaryKey;autoIncrement" json:"id"`
	Kode      string          `gorm:"column:kode;type:varchar(20);not null;uniqueIndex" json:"kode"`
	Name      string          `gorm:"column:name;type:varchar(150);not null" json:"name"`
	Kategori  string          `gorm:"column:kategori;type:varchar(100);not null;index:idx_layanan_kategori" json:"kategori"`
	Harga     decimal.Decimal `gorm:"column:harga;type:decimal(12,2);not null" json:"harga"`
	Satuan    string          `gorm:"column:satuan;type:varchar(20);not null" json:"satuan"`
	IsActive  bool            `gorm:"column:is_active;type:tinyint(1);not null;default:1;index:idx_layanan_is_active" json:"is_active"`
	CreatedAt time.Time       `gorm:"column:created_at;autoCreateTime" json:"created_at"`
	UpdatedAt time.Time       `gorm:"column:updated_at;autoUpdateTime" json:"updated_at"`
}

func (Layanan) TableName() string {
	return "layanan"
}
