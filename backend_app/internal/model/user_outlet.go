package model

import (
	"time"

	"gorm.io/datatypes"
)

type UserOutlet struct {
	ID       uint64          `gorm:"column:id;primaryKey;autoIncrement" json:"id"`
	UserID   uint64          `gorm:"column:user_id;not null;uniqueIndex:uq_user_outlet,priority:1" json:"user_id"`
	OutletID uint64          `gorm:"column:outlet_id;not null;uniqueIndex:uq_user_outlet,priority:2" json:"outlet_id"`
	JoinDate *datatypes.Date `gorm:"column:join_date;type:date" json:"join_date,omitempty"`

	User   User   `gorm:"foreignKey:UserID;constraint:OnDelete:CASCADE" json:"user,omitempty"`
	Outlet Outlet `gorm:"foreignKey:OutletID;constraint:OnDelete:CASCADE" json:"outlet,omitempty"`
}

func (UserOutlet) TableName() string {
	return "user_outlets"
}

// JoinDateFromTime converts a time.Time to datatypes.Date for assignment.
func JoinDateFromTime(t time.Time) datatypes.Date {
	return datatypes.Date(t)
}
