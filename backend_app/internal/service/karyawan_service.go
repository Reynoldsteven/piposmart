package service

import (
	"errors"
	"strings"
	"time"

	"backend-app/internal/dto"
	"backend-app/internal/model"
	"backend-app/internal/repository"

	"golang.org/x/crypto/bcrypt"
)

var ErrKaryawanNotFound = errors.New("karyawan tidak ditemukan")

type KaryawanService struct {
	repo *repository.KaryawanRepository
}

func NewKaryawanService(repo *repository.KaryawanRepository) *KaryawanService {
	return &KaryawanService{repo: repo}
}

func (s *KaryawanService) List(f repository.KaryawanFilter) ([]dto.KaryawanResponse, dto.Meta, error) {
	items, total, err := s.repo.List(f)
	if err != nil {
		return nil, dto.Meta{}, err
	}
	out := make([]dto.KaryawanResponse, 0, len(items))
	for i := range items {
		out = append(out, mapKaryawan(&items[i]))
	}
	page := 1
	if f.Limit > 0 {
		page = f.Offset/f.Limit + 1
	}
	return out, dto.BuildMeta(page, f.Limit, total), nil
}

func (s *KaryawanService) GetByID(id uint64) (*dto.KaryawanResponse, error) {
	item, err := s.repo.FindByID(id)
	if err != nil {
		if errors.Is(err, repository.ErrKaryawanNotFound) {
			return nil, ErrKaryawanNotFound
		}
		return nil, err
	}
	resp := mapKaryawan(item)
	return &resp, nil
}

func (s *KaryawanService) Create(req dto.CreateKaryawanRequest) (*dto.KaryawanResponse, error) {
	if !isValidRole(req.Role) {
		return nil, ErrInvalidRole
	}
	hash, err := bcrypt.GenerateFromPassword([]byte(req.Password), bcrypt.DefaultCost)
	if err != nil {
		return nil, err
	}
	joinDate, err := repository.ParseJoinDate(req.JoinDate)
	if err != nil {
		return nil, errors.New("format join_date harus YYYY-MM-DD")
	}
	user := &model.User{
		Name:     strings.TrimSpace(req.Name),
		Email:    strings.ToLower(strings.TrimSpace(req.Email)),
		Password: string(hash),
		Phone:    req.Phone,
		Role:     req.Role,
	}
	if err := s.repo.CreateWithOutlets(user, req.OutletIDs, joinDate); err != nil {
		if errors.Is(err, repository.ErrUserEmailConflict) {
			return nil, ErrEmailAlreadyUsed
		}
		return nil, err
	}
	created, err := s.repo.FindByID(user.ID)
	if err != nil {
		resp := mapKaryawan(user)
		return &resp, nil
	}
	resp := mapKaryawan(created)
	return &resp, nil
}

func (s *KaryawanService) Update(id uint64, req dto.UpdateKaryawanRequest) (*dto.KaryawanResponse, error) {
	if !isValidRole(req.Role) {
		return nil, ErrInvalidRole
	}
	user, err := s.repo.FindByID(id)
	if err != nil {
		if errors.Is(err, repository.ErrKaryawanNotFound) {
			return nil, ErrKaryawanNotFound
		}
		return nil, err
	}
	user.Name = strings.TrimSpace(req.Name)
	user.Email = strings.ToLower(strings.TrimSpace(req.Email))
	user.Phone = req.Phone
	user.Role = req.Role

	var hashed *string
	if req.Password != nil && strings.TrimSpace(*req.Password) != "" {
		h, err := bcrypt.GenerateFromPassword([]byte(*req.Password), bcrypt.DefaultCost)
		if err != nil {
			return nil, err
		}
		hs := string(h)
		hashed = &hs
	}
	joinDate, err := repository.ParseJoinDate(req.JoinDate)
	if err != nil {
		return nil, errors.New("format join_date harus YYYY-MM-DD")
	}
	if err := s.repo.UpdateWithOutlets(user, hashed, req.OutletIDs, joinDate); err != nil {
		if errors.Is(err, repository.ErrKaryawanNotFound) {
			return nil, ErrKaryawanNotFound
		}
		if errors.Is(err, repository.ErrUserEmailConflict) {
			return nil, ErrEmailAlreadyUsed
		}
		return nil, err
	}
	updated, _ := s.repo.FindByID(id)
	if updated == nil {
		updated = user
	}
	resp := mapKaryawan(updated)
	return &resp, nil
}

func (s *KaryawanService) Delete(id uint64) error {
	if err := s.repo.Delete(id); err != nil {
		if errors.Is(err, repository.ErrKaryawanNotFound) {
			return ErrKaryawanNotFound
		}
		return err
	}
	return nil
}

func mapKaryawan(m *model.User) dto.KaryawanResponse {
	outlets := make([]dto.KaryawanOutletResponse, 0, len(m.UserOutlets))
	for _, uo := range m.UserOutlets {
		var jd *string
		if uo.JoinDate != nil {
			s := time.Time(*uo.JoinDate).Format("2006-01-02")
			jd = &s
		}
		outlets = append(outlets, dto.KaryawanOutletResponse{
			ID: uo.OutletID, Name: uo.Outlet.Name, JoinDate: jd,
		})
	}
	return dto.KaryawanResponse{
		ID: m.ID, Name: m.Name, Email: m.Email, Phone: m.Phone, Role: m.Role, Outlets: outlets,
		CreatedAt: m.CreatedAt.Format(time.RFC3339), UpdatedAt: m.UpdatedAt.Format(time.RFC3339),
	}
}
