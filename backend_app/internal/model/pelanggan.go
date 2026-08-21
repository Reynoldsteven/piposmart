package model

import "time"

type Pelanggan struct {
	ID        uint64    `gorm:"column:id;primaryKey;autoIncrement" json:"id"`
	Name      string    `gorm:"column:name;type:varchar(100);not null;index:idx_pelanggan_name" json:"name"`
	Phone     *string   `gorm:"column:phone;type:varchar(20);index:idx_pelanggan_phone" json:"phone,omitempty"`
	Address   *string   `gorm:"column:address;type:text" json:"address,omitempty"`
	Gender    *string   `gorm:"column:gender;type:varchar(10)" json:"gender,omitempty"`
	OutletID  *uint64   `gorm:"column:outlet_id" json:"outlet_id,omitempty"`
	CreatedAt time.Time `gorm:"column:created_at;autoCreateTime" json:"created_at"`
	UpdatedAt time.Time `gorm:"column:updated_at;autoUpdateTime" json:"updated_at"`

	Outlet *Outlet `gorm:"foreignKey:OutletID;constraint:OnDelete:SET NULL" json:"outlet,omitempty"`
}

func (Pelanggan) TableName() string {
	return "pelanggan"
}
