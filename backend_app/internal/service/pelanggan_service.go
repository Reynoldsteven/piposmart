package service

import (
	"errors"
	"slices"
	"time"

	"backend-app/internal/dto"
	"backend-app/internal/model"
	"backend-app/internal/repository"
)

var (
	ErrPelangganNotFound = errors.New("pelanggan tidak ditemukan")
	ErrInvalidGender     = errors.New("gender tidak valid")
)

type PelangganService struct {
	repo *repository.PelangganRepository
}

func NewPelangganService(repo *repository.PelangganRepository) *PelangganService {
	return &PelangganService{repo: repo}
}

func (s *PelangganService) List(f repository.PelangganFilter) ([]dto.PelangganResponse, dto.Meta, error) {
	items, total, err := s.repo.List(f)
	if err != nil {
		return nil, dto.Meta{}, err
	}
	out := make([]dto.PelangganResponse, 0, len(items))
	for i := range items {
		out = append(out, mapPelanggan(&items[i]))
	}
	page := 1
	if f.Limit > 0 {
		page = f.Offset/f.Limit + 1
	}
	return out, dto.BuildMeta(page, f.Limit, total), nil
}

func (s *PelangganService) GetByID(id uint64) (*dto.PelangganResponse, error) {
	item, err := s.repo.FindByID(id)
	if err != nil {
		if errors.Is(err, repository.ErrPelangganNotFound) {
			return nil, ErrPelangganNotFound
		}
		return nil, err
	}
	resp := mapPelanggan(item)
	return &resp, nil
}

func (s *PelangganService) Create(req dto.CreatePelangganRequest) (*dto.PelangganResponse, error) {
	if err := validateGender(req.Gender); err != nil {
		return nil, err
	}
	item := &model.Pelanggan{
		Name: req.Name, Phone: req.Phone, Address: req.Address, Gender: req.Gender, OutletID: req.OutletID,
	}
	if err := s.repo.Create(item); err != nil {
		return nil, err
	}
	created, _ := s.repo.FindByID(item.ID)
	if created == nil {
		created = item
	}
	resp := mapPelanggan(created)
	return &resp, nil
}

func (s *PelangganService) Update(id uint64, req dto.UpdatePelangganRequest) (*dto.PelangganResponse, error) {
	if err := validateGender(req.Gender); err != nil {
		return nil, err
	}
	item, err := s.repo.FindByID(id)
	if err != nil {
		if errors.Is(err, repository.ErrPelangganNotFound) {
			return nil, ErrPelangganNotFound
		}
		return nil, err
	}
	item.Name = req.Name
	item.Phone = req.Phone
	item.Address = req.Address
	item.Gender = req.Gender
	item.OutletID = req.OutletID
	if err := s.repo.Update(item); err != nil {
		if errors.Is(err, repository.ErrPelangganNotFound) {
			return nil, ErrPelangganNotFound
		}
		return nil, err
	}
	updated, _ := s.repo.FindByID(id)
	if updated == nil {
		updated = item
	}
	resp := mapPelanggan(updated)
	return &resp, nil
}

func (s *PelangganService) Delete(id uint64) error {
	if err := s.repo.Delete(id); err != nil {
		if errors.Is(err, repository.ErrPelangganNotFound) {
			return ErrPelangganNotFound
		}
		return err
	}
	return nil
}

func validateGender(g *string) error {
	if g == nil || *g == "" {
		return nil
	}
	if !slices.Contains([]string{model.GenderLakiLaki, model.GenderPerempuan}, *g) {
		return ErrInvalidGender
	}
	return nil
}

func mapPelanggan(m *model.Pelanggan) dto.PelangganResponse {
	resp := dto.PelangganResponse{
		ID: m.ID, Name: m.Name, Phone: m.Phone, Address: m.Address, Gender: m.Gender, OutletID: m.OutletID,
		CreatedAt: m.CreatedAt.Format(time.RFC3339), UpdatedAt: m.UpdatedAt.Format(time.RFC3339),
	}
	if m.Outlet != nil {
		name := m.Outlet.Name
		resp.OutletName = &name
	}
	return resp
}
