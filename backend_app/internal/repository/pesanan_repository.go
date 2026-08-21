package repository

import (
	"errors"
	"fmt"
	"strconv"
	"strings"
	"time"

	"backend-app/internal/model"

	"github.com/shopspring/decimal"
	"gorm.io/gorm"
)

var ErrPesananNotFound = errors.New("pesanan not found")

type PesananFilter struct {
	OutletID *uint64
	Status   *string
	Q        string
	Offset   int
	Limit    int
}

type PesananRepository struct {
	db *gorm.DB
}

func NewPesananRepository(db *gorm.DB) *PesananRepository {
	return &PesananRepository{db: db}
}

func (r *PesananRepository) DB() *gorm.DB {
	return r.db
}

func (r *PesananRepository) List(f PesananFilter) ([]model.Pesanan, int64, error) {
	q := r.db.Model(&model.Pesanan{}).
		Preload("Outlet").
		Preload("Pelanggan").
		Preload("Items")

	if f.OutletID != nil {
		q = q.Where("outlet_id = ?", *f.OutletID)
	}
	if f.Status != nil && *f.Status != "" {
		q = q.Where("status = ?", *f.Status)
	}
	if f.Q != "" {
		like := "%" + f.Q + "%"
		q = q.Joins("LEFT JOIN pelanggan ON pelanggan.id = pesanan.pelanggan_id").
			Where("pesanan.kode LIKE ? OR pelanggan.name LIKE ?", like, like)
	}

	var total int64
	if err := q.Count(&total).Error; err != nil {
		return nil, 0, err
	}
	var items []model.Pesanan
	err := q.Order("pesanan.id DESC").Offset(f.Offset).Limit(f.Limit).Find(&items).Error
	return items, total, err
}

func (r *PesananRepository) FindByID(id uint64) (*model.Pesanan, error) {
	var item model.Pesanan
	err := r.db.Preload("Outlet").Preload("Pelanggan").Preload("Items").First(&item, id).Error
	if errors.Is(err, gorm.ErrRecordNotFound) {
		return nil, ErrPesananNotFound
	}
	return &item, err
}

func (r *PesananRepository) CreateWithItems(pesanan *model.Pesanan, items []model.PesananItem) error {
	return r.db.Transaction(func(tx *gorm.DB) error {
		if err := tx.Create(pesanan).Error; err != nil {
			return err
		}
		for i := range items {
			items[i].PesananID = pesanan.ID
			if err := tx.Create(&items[i]).Error; err != nil {
				return err
			}
		}
		return nil
	})
}

func (r *PesananRepository) UpdateFields(id uint64, fields map[string]interface{}) error {
	result := r.db.Model(&model.Pesanan{}).Where("id = ?", id).Updates(fields)
	if result.Error != nil {
		return result.Error
	}
	if result.RowsAffected == 0 {
		return ErrPesananNotFound
	}
	return nil
}

func (r *PesananRepository) Delete(id uint64) error {
	result := r.db.Delete(&model.Pesanan{}, id)
	if result.Error != nil {
		return result.Error
	}
	if result.RowsAffected == 0 {
		return ErrPesananNotFound
	}
	return nil
}

func (r *PesananRepository) NextKode() (string, error) {
	var last string
	err := r.db.Model(&model.Pesanan{}).
		Select("kode").
		Where("kode LIKE ?", "ORD-%").
		Order("id DESC").
		Limit(1).
		Scan(&last).Error
	if err != nil {
		return "", err
	}
	next := 1001
	if last != "" {
		parts := strings.Split(last, "-")
		if len(parts) == 2 {
			if n, e := strconv.Atoi(parts[1]); e == nil {
				next = n + 1
			}
		}
	}
	return fmt.Sprintf("ORD-%04d", next), nil
}

func (r *PesananRepository) FindLayananByID(id uint64) (*model.Layanan, error) {
	var l model.Layanan
	err := r.db.First(&l, id).Error
	if errors.Is(err, gorm.ErrRecordNotFound) {
		return nil, errors.New("layanan tidak ditemukan")
	}
	return &l, err
}

type DashboardRepo struct {
	db *gorm.DB
}

func NewDashboardRepo(db *gorm.DB) *DashboardRepo {
	return &DashboardRepo{db: db}
}

func (r *DashboardRepo) Summary(outletID *uint64) (aktif, penjualanHariIni, totalSelesai int64, labaHariIni decimal.Decimal, err error) {
	base := func() *gorm.DB {
		q := r.db.Model(&model.Pesanan{})
		if outletID != nil {
			q = q.Where("outlet_id = ?", *outletID)
		}
		return q
	}

	err = base().Where("status IN ?", []string{
		model.StatusBaru, model.StatusDiproses, model.StatusSiapDiambil,
	}).Count(&aktif).Error
	if err != nil {
		return
	}

	today := time.Now().Format("2006-01-02")
	err = base().Where("DATE(created_at) = ?", today).Count(&penjualanHariIni).Error
	if err != nil {
		return
	}

	var sum *float64
	err = base().Select("COALESCE(SUM(total),0)").
		Where("DATE(created_at) = ? AND is_lunas = 1", today).
		Scan(&sum).Error
	if err != nil {
		return
	}
	if sum != nil {
		labaHariIni = decimal.NewFromFloat(*sum)
	}

	err = base().Where("status = ?", model.StatusSelesai).Count(&totalSelesai).Error
	return
}

func (r *DashboardRepo) StatusSummary(outletID *uint64) (selesai, terlambat, harusSelesai int64, err error) {
	base := func() *gorm.DB {
		q := r.db.Model(&model.Pesanan{})
		if outletID != nil {
			q = q.Where("outlet_id = ?", *outletID)
		}
		return q
	}

	err = base().Where("status = ?", model.StatusSelesai).Count(&selesai).Error
	if err != nil {
		return
	}

	now := time.Now()
	err = base().
		Where("pickup_estimate IS NOT NULL AND pickup_estimate < ? AND status NOT IN ?", now, []string{model.StatusSelesai, model.StatusDibatalkan}).
		Count(&terlambat).Error
	if err != nil {
		return
	}

	today := now.Format("2006-01-02")
	err = base().
		Where("DATE(pickup_estimate) = ? AND status NOT IN ?", today, []string{model.StatusSelesai, model.StatusDibatalkan}).
		Count(&harusSelesai).Error
	return
}
