package model

import "time"

type User struct {
	ID        uint64    `gorm:"column:id;primaryKey;autoIncrement" json:"id"`
	Name      string    `gorm:"column:name;type:varchar(100);not null" json:"name"`
	Email     string    `gorm:"column:email;type:varchar(150);not null;uniqueIndex" json:"email"`
	Password  string    `gorm:"column:password;type:varchar(255);not null" json:"-"`
	Phone     *string   `gorm:"column:phone;type:varchar(20)" json:"phone,omitempty"`
	Role         string     `gorm:"column:role;type:varchar(50);not null;default:kasir;index:idx_users_role" json:"role"`
	CreatedAt    time.Time  `gorm:"column:created_at;autoCreateTime" json:"created_at"`
	UpdatedAt    time.Time  `gorm:"column:updated_at;autoUpdateTime" json:"updated_at"`
	LastLoginAt  *time.Time `gorm:"column:last_login_at" json:"last_login_at,omitempty"`

	Outlets     []Outlet     `gorm:"many2many:user_outlets" json:"outlets,omitempty"`
	UserOutlets []UserOutlet `gorm:"foreignKey:UserID" json:"user_outlets,omitempty"`
}

func (User) TableName() string {
	return "users"
}
