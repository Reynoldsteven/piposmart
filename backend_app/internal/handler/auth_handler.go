package handler

import (
	"errors"
	"net/http"

	"backend-app/internal/dto"
	"backend-app/internal/service"

	"github.com/gin-gonic/gin"
)

type AuthHandler struct {
	auth *service.AuthService
}

func NewAuthHandler(auth *service.AuthService) *AuthHandler {
	return &AuthHandler{auth: auth}
}

// Register godoc
// @Summary      Register
// @Description  Create a new user account with bcrypt-hashed password
// @Tags         auth
// @Accept       json
// @Produce      json
// @Param        body  body      dto.RegisterRequest  true  "Register payload"
// @Success      201   {object}  dto.SuccessResponse
// @Failure      400   {object}  dto.ErrorResponse
// @Failure      409   {object}  dto.ErrorResponse
// @Router       /auth/register [post]
func (h *AuthHandler) Register(c *gin.Context) {
	var req dto.RegisterRequest
	if err := c.ShouldBindJSON(&req); err != nil {
		dto.ValidationError(c, err)
		return
	}

	resp, err := h.auth.Register(req)
	if err != nil {
		switch {
		case errors.Is(err, service.ErrEmailAlreadyUsed):
			dto.Fail(c, http.StatusConflict, "email sudah terdaftar")
		case errors.Is(err, service.ErrInvalidRole):
			dto.FailWithDetails(c, http.StatusBadRequest, "validasi gagal", map[string]interface{}{
				"role": "harus salah satu dari: owner, kasir, produksi",
			})
		default:
			dto.Fail(c, http.StatusInternalServerError, "gagal register")
		}
		return
	}

	dto.Created(c, resp)
}

// Login godoc
// @Summary      Login
// @Description  Authenticate user and return JWT token
// @Tags         auth
// @Accept       json
// @Produce      json
// @Param        body  body      dto.LoginRequest  true  "Login credentials"
// @Success      200   {object}  dto.SuccessResponse
// @Failure      400   {object}  dto.ErrorResponse
// @Failure      401   {object}  dto.ErrorResponse
// @Router       /auth/login [post]
func (h *AuthHandler) Login(c *gin.Context) {
	var req dto.LoginRequest
	if err := c.ShouldBindJSON(&req); err != nil {
		dto.ValidationError(c, err)
		return
	}

	resp, err := h.auth.Login(req)
	if err != nil {
		if errors.Is(err, service.ErrInvalidCredentials) {
			dto.Fail(c, http.StatusUnauthorized, "email atau password salah")
			return
		}
		dto.Fail(c, http.StatusInternalServerError, "gagal login")
		return
	}

	dto.OK(c, resp)
}

// Me godoc
// @Summary      Current user
// @Description  Get authenticated user profile
// @Tags         auth
// @Produce      json
// @Security     BearerAuth
// @Success      200  {object}  dto.SuccessResponse
// @Failure      401  {object}  dto.ErrorResponse
// @Router       /auth/me [get]
func (h *AuthHandler) Me(c *gin.Context) {
	userID, ok := c.Get("user_id")
	if !ok {
		dto.Fail(c, http.StatusUnauthorized, "tidak terautentikasi")
		return
	}

	resp, err := h.auth.GetMe(userID.(uint64))
	if err != nil {
		if errors.Is(err, service.ErrInvalidCredentials) {
			dto.Fail(c, http.StatusUnauthorized, "user tidak ditemukan")
			return
		}
		dto.Fail(c, http.StatusInternalServerError, "gagal mengambil data user")
		return
	}

	dto.OK(c, resp)
}

// Logout godoc
// @Summary      Logout
// @Description  End session (client-side token removal)
// @Tags         auth
// @Produce      json
// @Security     BearerAuth
// @Success      200  {object}  dto.SuccessResponse
// @Router       /auth/session [delete]
func (h *AuthHandler) Logout(c *gin.Context) {
	dto.OK(c, dto.LogoutResponse{Message: "logout berhasil"})
}
