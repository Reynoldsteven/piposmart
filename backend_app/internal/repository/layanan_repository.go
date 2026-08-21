package repository

import (
	"errors"
	"fmt"
	"strconv"
	"strings"

	"backend-app/internal/model"

	"gorm.io/gorm"
)

var ErrLayananNotFound = errors.New("layanan not found")

type LayananFilter struct {
	Kategori *string
	IsActive *bool
	Q        string
	Offset   int
	Limit    int
}

type LayananRepository struct {
	db *gorm.DB
}

func NewLayananRepository(db *gorm.DB) *LayananRepository {
	return &LayananRepository{db: db}
}

func (r *LayananRepository) List(f LayananFilter) ([]model.Layanan, int64, error) {
	q := r.db.Model(&model.Layanan{})

	if f.Kategori != nil && *f.Kategori != "" {
		q = q.Where("kategori = ?", *f.Kategori)
	}
	if f.IsActive != nil {
		q = q.Where("is_active = ?", *f.IsActive)
	}
	if f.Q != "" {
		like := "%" + f.Q + "%"
		q = q.Where("name LIKE ? OR kode LIKE ?", like, like)
	}

	var total int64
	if err := q.Count(&total).Error; err != nil {
		return nil, 0, err
	}

	var items []model.Layanan
	err := q.Order("id DESC").Offset(f.Offset).Limit(f.Limit).Find(&items).Error
	if err != nil {
		return nil, 0, err
	}
	return items, total, nil
}

func (r *LayananRepository) FindByID(id uint64) (*model.Layanan, error) {
	var item model.Layanan
	err := r.db.First(&item, id).Error
	if err != nil {
		if errors.Is(err, gorm.ErrRecordNotFound) {
			return nil, ErrLayananNotFound
		}
		return nil, err
	}
	return &item, nil
}

func (r *LayananRepository) Create(item *model.Layanan) error {
	return r.db.Create(item).Error
}

func (r *LayananRepository) Update(item *model.Layanan) error {
	result := r.db.Model(&model.Layanan{}).
		Where("id = ?", item.ID).
		Updates(map[string]interface{}{
			"name":      item.Name,
			"kategori":  item.Kategori,
			"harga":     item.Harga,
			"satuan":    item.Satuan,
			"is_active": item.IsActive,
		})
	if result.Error != nil {
		return result.Error
	}
	if result.RowsAffected == 0 {
		return ErrLayananNotFound
	}
	return nil
}

func (r *LayananRepository) Delete(id uint64) error {
	result := r.db.Delete(&model.Layanan{}, id)
	if result.Error != nil {
		return result.Error
	}
	if result.RowsAffected == 0 {
		return ErrLayananNotFound
	}
	return nil
}

func (r *LayananRepository) CountUsageInPesananItem(layananID uint64) (int64, error) {
	var count int64
	err := r.db.Model(&model.PesananItem{}).
		Where("layanan_id = ?", layananID).
		Count(&count).Error
	return count, err
}

// NextKode returns the next LYN-xxx code based on the highest existing numeric suffix.
func (r *LayananRepository) NextKode() (string, error) {
	var lastKode string
	err := r.db.Model(&model.Layanan{}).
		Select("kode").
		Where("kode LIKE ?", "LYN-%").
		Order("id DESC").
		Limit(1).
		Scan(&lastKode).Error
	if err != nil {
		return "", err
	}

	next := 1
	if lastKode != "" {
		parts := strings.Split(lastKode, "-")
		if len(parts) == 2 {
			if n, parseErr := strconv.Atoi(parts[1]); parseErr == nil {
				next = n + 1
			}
		}
	}

	return fmt.Sprintf("LYN-%03d", next), nil
}
