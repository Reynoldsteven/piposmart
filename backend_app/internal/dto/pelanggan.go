package dto

type CreatePelangganRequest struct {
	Name     string  `json:"name" binding:"required,max=100"`
	Phone    *string `json:"phone"`
	Address  *string `json:"address"`
	Gender   *string `json:"gender"`
	OutletID *uint64 `json:"outlet_id"`
}

type UpdatePelangganRequest struct {
	Name     string  `json:"name" binding:"required,max=100"`
	Phone    *string `json:"phone"`
	Address  *string `json:"address"`
	Gender   *string `json:"gender"`
	OutletID *uint64 `json:"outlet_id"`
}

type PelangganResponse struct {
	ID         uint64  `json:"id"`
	Name       string  `json:"name"`
	Phone      *string `json:"phone,omitempty"`
	Address    *string `json:"address,omitempty"`
	Gender     *string `json:"gender,omitempty"`
	OutletID   *uint64 `json:"outlet_id,omitempty"`
	OutletName *string `json:"outlet_name,omitempty"`
	CreatedAt  string  `json:"created_at"`
	UpdatedAt  string  `json:"updated_at"`
}
