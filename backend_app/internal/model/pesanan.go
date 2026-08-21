package model

import (
	"time"

	"github.com/shopspring/decimal"
)

type Pesanan struct {
	ID             uint64          `gorm:"column:id;primaryKey;autoIncrement" json:"id"`
	Kode           string          `gorm:"column:kode;type:varchar(30);not null;uniqueIndex" json:"kode"`
	OutletID       uint64          `gorm:"column:outlet_id;not null;index:idx_pesanan_outlet" json:"outlet_id"`
	PelangganID    *uint64         `gorm:"column:pelanggan_id;index:idx_pesanan_pelanggan" json:"pelanggan_id,omitempty"`
	UserID         *uint64         `gorm:"column:user_id" json:"user_id,omitempty"`
	Status         string          `gorm:"column:status;type:varchar(30);not null;default:Baru;index:idx_pesanan_status" json:"status"`
	IsLunas        bool            `gorm:"column:is_lunas;type:tinyint(1);not null;default:0;index:idx_pesanan_is_lunas" json:"is_lunas"`
	Total          decimal.Decimal `gorm:"column:total;type:decimal(14,2);not null;default:0" json:"total"`
	PickupEstimate *time.Time      `gorm:"column:pickup_estimate;type:datetime" json:"pickup_estimate,omitempty"`
	Notes          *string         `gorm:"column:notes;type:text" json:"notes,omitempty"`
	CreatedAt      time.Time       `gorm:"column:created_at;autoCreateTime;index:idx_pesanan_created_at" json:"created_at"`
	UpdatedAt      time.Time       `gorm:"column:updated_at;autoUpdateTime" json:"updated_at"`

	Outlet    Outlet        `gorm:"foreignKey:OutletID;constraint:OnDelete:RESTRICT" json:"outlet,omitempty"`
	Pelanggan *Pelanggan    `gorm:"foreignKey:PelangganID;constraint:OnDelete:SET NULL" json:"pelanggan,omitempty"`
	User      *User         `gorm:"foreignKey:UserID;constraint:OnDelete:SET NULL" json:"user,omitempty"`
	Items     []PesananItem `gorm:"foreignKey:PesananID;constraint:OnDelete:CASCADE" json:"items,omitempty"`
}

func (Pesanan) TableName() string {
	return "pesanan"
}
