package dto

type CreateKaryawanRequest struct {
	Name      string   `json:"name" binding:"required,max=100"`
	Email     string   `json:"email" binding:"required,email"`
	Password  string   `json:"password" binding:"required,min=6,max=72"`
	Phone     *string  `json:"phone"`
	Role      string   `json:"role" binding:"required"`
	OutletIDs []uint64 `json:"outlet_ids"`
	JoinDate  *string  `json:"join_date"` // YYYY-MM-DD
}

type UpdateKaryawanRequest struct {
	Name      string   `json:"name" binding:"required,max=100"`
	Email     string   `json:"email" binding:"required,email"`
	Password  *string  `json:"password"` // omit/empty = keep old
	Phone     *string  `json:"phone"`
	Role      string   `json:"role" binding:"required"`
	OutletIDs *[]uint64 `json:"outlet_ids"`
	JoinDate  *string  `json:"join_date"`
}

type KaryawanOutletResponse struct {
	ID       uint64  `json:"id"`
	Name     string  `json:"name"`
	JoinDate *string `json:"join_date,omitempty"`
}

type KaryawanResponse struct {
	ID        uint64                    `json:"id"`
	Name      string                    `json:"name"`
	Email     string                    `json:"email"`
	Phone     *string                   `json:"phone,omitempty"`
	Role      string                    `json:"role"`
	Outlets   []KaryawanOutletResponse  `json:"outlets"`
	CreatedAt string                    `json:"created_at"`
	UpdatedAt string                    `json:"updated_at"`
}
