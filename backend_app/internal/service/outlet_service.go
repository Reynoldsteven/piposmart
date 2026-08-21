package service

import (
	"errors"
	"time"

	"backend-app/internal/dto"
	"backend-app/internal/model"
	"backend-app/internal/repository"
)

var ErrOutletNotFound = errors.New("outlet tidak ditemukan")
var ErrOutletInUse = errors.New("outlet masih digunakan")

type OutletService struct {
	repo *repository.OutletRepository
}

func NewOutletService(repo *repository.OutletRepository) *OutletService {
	return &OutletService{repo: repo}
}

func (s *OutletService) List(f repository.OutletFilter) ([]dto.OutletResponse, dto.Meta, error) {
	items, total, err := s.repo.List(f)
	if err != nil {
		return nil, dto.Meta{}, err
	}
	out := make([]dto.OutletResponse, 0, len(items))
	for i := range items {
		out = append(out, mapOutlet(&items[i]))
	}
	page := 1
	if f.Limit > 0 {
		page = f.Offset/f.Limit + 1
	}
	return out, dto.BuildMeta(page, f.Limit, total), nil
}

func (s *OutletService) GetByID(id uint64) (*dto.OutletResponse, error) {
	item, err := s.repo.FindByID(id)
	if err != nil {
		if errors.Is(err, repository.ErrOutletNotFound) {
			return nil, ErrOutletNotFound
		}
		return nil, err
	}
	resp := mapOutlet(item)
	return &resp, nil
}

func (s *OutletService) Create(req dto.CreateOutletRequest) (*dto.OutletResponse, error) {
	item := &model.Outlet{
		Name: req.Name, Address: req.Address, Provinsi: req.Provinsi, Kota: req.Kota, Kecamatan: req.Kecamatan,
	}
	if err := s.repo.Create(item); err != nil {
		return nil, err
	}
	created, _ := s.repo.FindByID(item.ID)
	if created == nil {
		created = item
	}
	resp := mapOutlet(created)
	return &resp, nil
}

func (s *OutletService) Update(id uint64, req dto.UpdateOutletRequest) (*dto.OutletResponse, error) {
	item, err := s.repo.FindByID(id)
	if err != nil {
		if errors.Is(err, repository.ErrOutletNotFound) {
			return nil, ErrOutletNotFound
		}
		return nil, err
	}
	item.Name = req.Name
	item.Address = req.Address
	item.Provinsi = req.Provinsi
	item.Kota = req.Kota
	item.Kecamatan = req.Kecamatan
	if err := s.repo.Update(item); err != nil {
		if errors.Is(err, repository.ErrOutletNotFound) {
			return nil, ErrOutletNotFound
		}
		return nil, err
	}
	updated, _ := s.repo.FindByID(id)
	if updated == nil {
		updated = item
	}
	resp := mapOutlet(updated)
	return &resp, nil
}

func (s *OutletService) Delete(id uint64) error {
	if err := s.repo.Delete(id); err != nil {
		if errors.Is(err, repository.ErrOutletNotFound) {
			return ErrOutletNotFound
		}
		if err.Error() == "outlet masih digunakan" {
			return ErrOutletInUse
		}
		return err
	}
	return nil
}

func mapOutlet(m *model.Outlet) dto.OutletResponse {
	return dto.OutletResponse{
		ID: m.ID, Name: m.Name, Address: m.Address, Provinsi: m.Provinsi, Kota: m.Kota, Kecamatan: m.Kecamatan,
		CreatedAt: m.CreatedAt.Format(time.RFC3339), UpdatedAt: m.UpdatedAt.Format(time.RFC3339),
	}
}
