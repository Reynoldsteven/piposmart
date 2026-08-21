package model

import "time"

type Outlet struct {
	ID        uint64    `gorm:"column:id;primaryKey;autoIncrement" json:"id"`
	Name      string    `gorm:"column:name;type:varchar(150);not null;index:idx_outlets_name" json:"name"`
	Address   *string   `gorm:"column:address;type:text" json:"address,omitempty"`
	Provinsi  *string   `gorm:"column:provinsi;type:varchar(100)" json:"provinsi,omitempty"`
	Kota      *string   `gorm:"column:kota;type:varchar(100)" json:"kota,omitempty"`
	Kecamatan *string   `gorm:"column:kecamatan;type:varchar(100)" json:"kecamatan,omitempty"`
	CreatedAt time.Time `gorm:"column:created_at;autoCreateTime" json:"created_at"`
	UpdatedAt time.Time `gorm:"column:updated_at;autoUpdateTime" json:"updated_at"`

	Users       []User       `gorm:"many2many:user_outlets" json:"users,omitempty"`
	UserOutlets []UserOutlet `gorm:"foreignKey:OutletID" json:"user_outlets,omitempty"`
}

func (Outlet) TableName() string {
	return "outlets"
}
