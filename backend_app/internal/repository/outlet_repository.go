package repository

import (
	"errors"
	"strings"

	"backend-app/internal/model"

	"gorm.io/gorm"
)

var ErrOutletNotFound = errors.New("outlet not found")

type OutletFilter struct {
	Q      string
	Offset int
	Limit  int
}

type OutletRepository struct {
	db *gorm.DB
}

func NewOutletRepository(db *gorm.DB) *OutletRepository {
	return &OutletRepository{db: db}
}

func (r *OutletRepository) List(f OutletFilter) ([]model.Outlet, int64, error) {
	q := r.db.Model(&model.Outlet{})
	if f.Q != "" {
		like := "%" + f.Q + "%"
		q = q.Where("name LIKE ? OR address LIKE ? OR kota LIKE ?", like, like, like)
	}
	var total int64
	if err := q.Count(&total).Error; err != nil {
		return nil, 0, err
	}
	var items []model.Outlet
	err := q.Order("id DESC").Offset(f.Offset).Limit(f.Limit).Find(&items).Error
	return items, total, err
}

func (r *OutletRepository) FindByID(id uint64) (*model.Outlet, error) {
	var item model.Outlet
	err := r.db.First(&item, id).Error
	if errors.Is(err, gorm.ErrRecordNotFound) {
		return nil, ErrOutletNotFound
	}
	return &item, err
}

func (r *OutletRepository) Create(item *model.Outlet) error {
	return r.db.Create(item).Error
}

func (r *OutletRepository) Update(item *model.Outlet) error {
	result := r.db.Model(&model.Outlet{}).Where("id = ?", item.ID).Updates(map[string]interface{}{
		"name":      item.Name,
		"address":   item.Address,
		"provinsi":  item.Provinsi,
		"kota":      item.Kota,
		"kecamatan": item.Kecamatan,
	})
	if result.Error != nil {
		return result.Error
	}
	if result.RowsAffected == 0 {
		return ErrOutletNotFound
	}
	return nil
}

func (r *OutletRepository) Delete(id uint64) error {
	result := r.db.Delete(&model.Outlet{}, id)
	if result.Error != nil {
		if strings.Contains(result.Error.Error(), "1451") {
			return errors.New("outlet masih digunakan")
		}
		return result.Error
	}
	if result.RowsAffected == 0 {
		return ErrOutletNotFound
	}
	return nil
}
