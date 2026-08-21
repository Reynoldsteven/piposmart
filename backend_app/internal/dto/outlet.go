package dto

type CreateOutletRequest struct {
	Name      string  `json:"name" binding:"required,max=150"`
	Address   *string `json:"address"`
	Provinsi  *string `json:"provinsi"`
	Kota      *string `json:"kota"`
	Kecamatan *string `json:"kecamatan"`
}

type UpdateOutletRequest struct {
	Name      string  `json:"name" binding:"required,max=150"`
	Address   *string `json:"address"`
	Provinsi  *string `json:"provinsi"`
	Kota      *string `json:"kota"`
	Kecamatan *string `json:"kecamatan"`
}

type OutletResponse struct {
	ID        uint64  `json:"id"`
	Name      string  `json:"name"`
	Address   *string `json:"address,omitempty"`
	Provinsi  *string `json:"provinsi,omitempty"`
	Kota      *string `json:"kota,omitempty"`
	Kecamatan *string `json:"kecamatan,omitempty"`
	CreatedAt string  `json:"created_at"`
	UpdatedAt string  `json:"updated_at"`
}
