package service

import (
	"errors"
	"fmt"
	"slices"

	"backend-app/internal/dto"
	"backend-app/internal/model"
	"backend-app/internal/repository"
)

var (
	ErrLayananNotFound   = errors.New("layanan tidak ditemukan")
	ErrLayananInUse      = errors.New("layanan masih digunakan di pesanan")
	ErrInvalidKategori   = errors.New("kategori tidak valid")
	ErrInvalidSatuan     = errors.New("satuan tidak valid")
)

type LayananInUseError struct {
	UsageCount int64
}

func (e *LayananInUseError) Error() string {
	return ErrLayananInUse.Error()
}

func (e *LayananInUseError) Unwrap() error {
	return ErrLayananInUse
}

type LayananService struct {
	repo *repository.LayananRepository
}

func NewLayananService(repo *repository.LayananRepository) *LayananService {
	return &LayananService{repo: repo}
}

func (s *LayananService) List(f repository.LayananFilter) ([]dto.LayananResponse, dto.Meta, error) {
	items, total, err := s.repo.List(f)
	if err != nil {
		return nil, dto.Meta{}, err
	}

	page := 1
	limit := f.Limit
	if limit > 0 {
		page = (f.Offset / limit) + 1
	}

	return dto.LayananListFromModels(items), dto.BuildMeta(page, limit, total), nil
}

func (s *LayananService) GetByID(id uint64) (*dto.LayananResponse, error) {
	item, err := s.repo.FindByID(id)
	if err != nil {
		if errors.Is(err, repository.ErrLayananNotFound) {
			return nil, ErrLayananNotFound
		}
		return nil, err
	}
	resp := dto.LayananFromModel(item)
	return &resp, nil
}

func (s *LayananService) Create(req dto.CreateLayananRequest) (*dto.LayananResponse, error) {
	if err := validateLayananEnums(req.Kategori, req.Satuan); err != nil {
		return nil, err
	}

	kode, err := s.repo.NextKode()
	if err != nil {
		return nil, fmt.Errorf("gagal generate kode: %w", err)
	}

	isActive := true
	if req.IsActive != nil {
		isActive = *req.IsActive
	}

	item := &model.Layanan{
		Kode:     kode,
		Name:     req.Name,
		Kategori: req.Kategori,
		Harga:    dto.DecimalFromFloat(req.Harga),
		Satuan:   req.Satuan,
		IsActive: isActive,
	}

	if err := s.repo.Create(item); err != nil {
		return nil, err
	}

	created, err := s.repo.FindByID(item.ID)
	if err != nil {
		resp := dto.LayananFromModel(item)
		return &resp, nil
	}
	resp := dto.LayananFromModel(created)
	return &resp, nil
}

func (s *LayananService) Update(id uint64, req dto.UpdateLayananRequest) (*dto.LayananResponse, error) {
	if err := validateLayananEnums(req.Kategori, req.Satuan); err != nil {
		return nil, err
	}

	existing, err := s.repo.FindByID(id)
	if err != nil {
		if errors.Is(err, repository.ErrLayananNotFound) {
			return nil, ErrLayananNotFound
		}
		return nil, err
	}

	existing.Name = req.Name
	existing.Kategori = req.Kategori
	existing.Harga = dto.DecimalFromFloat(req.Harga)
	existing.Satuan = req.Satuan
	if req.IsActive != nil {
		existing.IsActive = *req.IsActive
	}

	if err := s.repo.Update(existing); err != nil {
		if errors.Is(err, repository.ErrLayananNotFound) {
			return nil, ErrLayananNotFound
		}
		return nil, err
	}

	updated, err := s.repo.FindByID(id)
	if err != nil {
		resp := dto.LayananFromModel(existing)
		return &resp, nil
	}
	resp := dto.LayananFromModel(updated)
	return &resp, nil
}

func (s *LayananService) Delete(id uint64) error {
	if _, err := s.repo.FindByID(id); err != nil {
		if errors.Is(err, repository.ErrLayananNotFound) {
			return ErrLayananNotFound
		}
		return err
	}

	usage, err := s.repo.CountUsageInPesananItem(id)
	if err != nil {
		return err
	}
	if usage > 0 {
		return &LayananInUseError{UsageCount: usage}
	}

	if err := s.repo.Delete(id); err != nil {
		if errors.Is(err, repository.ErrLayananNotFound) {
			return ErrLayananNotFound
		}
		return err
	}
	return nil
}

func validateLayananEnums(kategori, satuan string) error {
	validKategori := []string{
		model.KategoriCuci,
		model.KategoriCuciSetrika,
		model.KategoriSetrika,
		model.KategoriSpesial,
	}
	validSatuan := []string{
		model.SatuanKg,
		model.SatuanPcs,
		model.SatuanPasang,
		model.SatuanSet,
	}

	if !slices.Contains(validKategori, kategori) {
		return ErrInvalidKategori
	}
	if !slices.Contains(validSatuan, satuan) {
		return ErrInvalidSatuan
	}
	return nil
}
