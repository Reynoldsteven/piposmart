package service

import (
	"errors"
	"log"
	"strings"
	"time"

	"backend-app/internal/dto"
	"backend-app/internal/model"
	"backend-app/internal/pkg/jwt"
	"backend-app/internal/repository"

	"golang.org/x/crypto/bcrypt"
)

var (
	ErrInvalidCredentials = errors.New("email atau password salah")
	ErrEmailAlreadyUsed   = errors.New("email sudah terdaftar")
	ErrInvalidRole        = errors.New("role tidak valid")
)

type AuthService struct {
	users *repository.UserRepository
	jwt   *jwt.Manager
}

func NewAuthService(users *repository.UserRepository, jwtManager *jwt.Manager) *AuthService {
	return &AuthService{
		users: users,
		jwt:   jwtManager,
	}
}

func (s *AuthService) Register(req dto.RegisterRequest) (*dto.LoginResponse, error) {
	role := strings.TrimSpace(req.Role)
	if role == "" {
		role = model.RoleOwner // bootstrap default agar langsung bisa pakai app
	}
	if !isValidRole(role) {
		return nil, ErrInvalidRole
	}

	exists, err := s.users.ExistsByEmail(req.Email)
	if err != nil {
		return nil, err
	}
	if exists {
		return nil, ErrEmailAlreadyUsed
	}

	hash, err := bcrypt.GenerateFromPassword([]byte(req.Password), bcrypt.DefaultCost)
	if err != nil {
		return nil, err
	}

	user := &model.User{
		Name:     strings.TrimSpace(req.Name),
		Email:    strings.TrimSpace(strings.ToLower(req.Email)),
		Password: string(hash),
		Phone:    req.Phone,
		Role:     role,
	}

	if err := s.users.Create(user); err != nil {
		if errors.Is(err, repository.ErrUserEmailConflict) {
			return nil, ErrEmailAlreadyUsed
		}
		return nil, err
	}

	token, err := s.jwt.Generate(user.ID, user.Role)
	if err != nil {
		return nil, err
	}

	return &dto.LoginResponse{
		Token: token,
		User: dto.UserResponseFrom(
			user.ID,
			user.Name,
			user.Email,
			user.Role,
			user.Phone,
		),
	}, nil
}

func isValidRole(role string) bool {
	switch role {
	case model.RoleOwner, model.RoleKasir, model.RoleProduksi:
		return true
	default:
		return false
	}
}

func (s *AuthService) Login(req dto.LoginRequest) (*dto.LoginResponse, error) {
	user, err := s.users.FindByEmail(req.Email)
	if err != nil {
		if errors.Is(err, repository.ErrUserNotFound) {
			return nil, ErrInvalidCredentials
		}
		return nil, err
	}

	if err := bcrypt.CompareHashAndPassword([]byte(user.Password), []byte(req.Password)); err != nil {
		return nil, ErrInvalidCredentials
	}

	// Non-blocking: login tetap berhasil meski update last_login_at gagal
	// (mis. kolom belum dimigrasi).
	if err := s.users.UpdateLastLogin(user.ID, time.Now()); err != nil {
		log.Printf("warning: gagal update last_login_at user_id=%d: %v", user.ID, err)
	}

	token, err := s.jwt.Generate(user.ID, user.Role)
	if err != nil {
		return nil, err
	}

	return &dto.LoginResponse{
		Token: token,
		User: dto.UserResponseFrom(
			user.ID,
			user.Name,
			user.Email,
			user.Role,
			user.Phone,
		),
	}, nil
}

func (s *AuthService) GetMe(userID uint64) (*dto.UserResponse, error) {
	user, err := s.users.FindByID(userID)
	if err != nil {
		if errors.Is(err, repository.ErrUserNotFound) {
			return nil, ErrInvalidCredentials
		}
		return nil, err
	}

	resp := dto.UserResponseFrom(
		user.ID,
		user.Name,
		user.Email,
		user.Role,
		user.Phone,
	)
	return &resp, nil
}
