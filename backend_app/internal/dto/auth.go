package dto

type LoginRequest struct {
	Email    string `json:"email" binding:"required,email"`
	Password string `json:"password" binding:"required"`
}

type RegisterRequest struct {
	Name     string  `json:"name" binding:"required,min=2,max=100"`
	Email    string  `json:"email" binding:"required,email"`
	Password string  `json:"password" binding:"required,min=6,max=72"`
	Phone    *string `json:"phone"`
	Role     string  `json:"role"` // optional: owner | kasir | produksi (default: owner)
}

type UserResponse struct {
	ID    uint64  `json:"id"`
	Name  string  `json:"name"`
	Email string  `json:"email"`
	Role  string  `json:"role"`
	Phone *string `json:"phone,omitempty"`
}

type LoginResponse struct {
	Token string       `json:"token"`
	User  UserResponse `json:"user"`
}

type LogoutResponse struct {
	Message string `json:"message"`
}

func UserResponseFrom(id uint64, name, email, role string, phone *string) UserResponse {
	return UserResponse{
		ID:    id,
		Name:  name,
		Email: email,
		Role:  role,
		Phone: phone,
	}
}
