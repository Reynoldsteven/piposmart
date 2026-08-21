package repository

import (
	"errors"

	"backend-app/internal/model"

	"gorm.io/gorm"
)

var ErrPelangganNotFound = errors.New("pelanggan not found")

type PelangganFilter struct {
	Q        string
	OutletID *uint64
	Offset   int
	Limit    int
}

type PelangganRepository struct {
	db *gorm.DB
}

func NewPelangganRepository(db *gorm.DB) *PelangganRepository {
	return &PelangganRepository{db: db}
}

func (r *PelangganRepository) List(f PelangganFilter) ([]model.Pelanggan, int64, error) {
	q := r.db.Model(&model.Pelanggan{}).Preload("Outlet")
	if f.OutletID != nil {
		q = q.Where("outlet_id = ?", *f.OutletID)
	}
	if f.Q != "" {
		like := "%" + f.Q + "%"
		q = q.Where("name LIKE ? OR phone LIKE ?", like, like)
	}
	var total int64
	if err := q.Count(&total).Error; err != nil {
		return nil, 0, err
	}
	var items []model.Pelanggan
	err := q.Order("id DESC").Offset(f.Offset).Limit(f.Limit).Find(&items).Error
	return items, total, err
}

func (r *PelangganRepository) FindByID(id uint64) (*model.Pelanggan, error) {
	var item model.Pelanggan
	err := r.db.Preload("Outlet").First(&item, id).Error
	if errors.Is(err, gorm.ErrRecordNotFound) {
		return nil, ErrPelangganNotFound
	}
	return &item, err
}

func (r *PelangganRepository) Create(item *model.Pelanggan) error {
	return r.db.Create(item).Error
}

func (r *PelangganRepository) Update(item *model.Pelanggan) error {
	result := r.db.Model(&model.Pelanggan{}).Where("id = ?", item.ID).Updates(map[string]interface{}{
		"name":      item.Name,
		"phone":     item.Phone,
		"address":   item.Address,
		"gender":    item.Gender,
		"outlet_id": item.OutletID,
	})
	if result.Error != nil {
		return result.Error
	}
	if result.RowsAffected == 0 {
		return ErrPelangganNotFound
	}
	return nil
}

func (r *PelangganRepository) Delete(id uint64) error {
	result := r.db.Delete(&model.Pelanggan{}, id)
	if result.Error != nil {
		return result.Error
	}
	if result.RowsAffected == 0 {
		return ErrPelangganNotFound
	}
	return nil
}
