package repository

import (
	"errors"
	"time"

	"backend-app/internal/model"

	"gorm.io/datatypes"
	"gorm.io/gorm"
)

var ErrKaryawanNotFound = errors.New("karyawan not found")

type KaryawanFilter struct {
	Q      string
	Role   *string
	Offset int
	Limit  int
}

type KaryawanRepository struct {
	db *gorm.DB
}

func NewKaryawanRepository(db *gorm.DB) *KaryawanRepository {
	return &KaryawanRepository{db: db}
}

func (r *KaryawanRepository) List(f KaryawanFilter) ([]model.User, int64, error) {
	q := r.db.Model(&model.User{}).Preload("UserOutlets.Outlet")
	if f.Role != nil && *f.Role != "" {
		q = q.Where("role = ?", *f.Role)
	}
	if f.Q != "" {
		like := "%" + f.Q + "%"
		q = q.Where("name LIKE ? OR email LIKE ? OR phone LIKE ?", like, like, like)
	}
	var total int64
	if err := q.Count(&total).Error; err != nil {
		return nil, 0, err
	}
	var items []model.User
	err := q.Order("id DESC").Offset(f.Offset).Limit(f.Limit).Find(&items).Error
	return items, total, err
}

func (r *KaryawanRepository) FindByID(id uint64) (*model.User, error) {
	var item model.User
	err := r.db.Preload("UserOutlets.Outlet").First(&item, id).Error
	if errors.Is(err, gorm.ErrRecordNotFound) {
		return nil, ErrKaryawanNotFound
	}
	return &item, err
}

func (r *KaryawanRepository) CreateWithOutlets(user *model.User, outletIDs []uint64, joinDate *datatypes.Date) error {
	return r.db.Transaction(func(tx *gorm.DB) error {
		if err := tx.Create(user).Error; err != nil {
			if isDuplicateKey(err) {
				return ErrUserEmailConflict
			}
			return err
		}
		for _, oid := range outletIDs {
			uo := model.UserOutlet{UserID: user.ID, OutletID: oid, JoinDate: joinDate}
			if err := tx.Create(&uo).Error; err != nil {
				return err
			}
		}
		return nil
	})
}

func (r *KaryawanRepository) UpdateWithOutlets(user *model.User, password *string, outletIDs *[]uint64, joinDate *datatypes.Date) error {
	return r.db.Transaction(func(tx *gorm.DB) error {
		updates := map[string]interface{}{
			"name":  user.Name,
			"email": user.Email,
			"phone": user.Phone,
			"role":  user.Role,
		}
		if password != nil && *password != "" {
			updates["password"] = *password
		}
		result := tx.Model(&model.User{}).Where("id = ?", user.ID).Updates(updates)
		if result.Error != nil {
			if isDuplicateKey(result.Error) {
				return ErrUserEmailConflict
			}
			return result.Error
		}
		if result.RowsAffected == 0 {
			return ErrKaryawanNotFound
		}
		if outletIDs != nil {
			if err := tx.Where("user_id = ?", user.ID).Delete(&model.UserOutlet{}).Error; err != nil {
				return err
			}
			for _, oid := range *outletIDs {
				uo := model.UserOutlet{UserID: user.ID, OutletID: oid, JoinDate: joinDate}
				if err := tx.Create(&uo).Error; err != nil {
					return err
				}
			}
		}
		return nil
	})
}

func (r *KaryawanRepository) Delete(id uint64) error {
	result := r.db.Delete(&model.User{}, id)
	if result.Error != nil {
		return result.Error
	}
	if result.RowsAffected == 0 {
		return ErrKaryawanNotFound
	}
	return nil
}

func ParseJoinDate(raw *string) (*datatypes.Date, error) {
	if raw == nil || *raw == "" {
		return nil, nil
	}
	t, err := time.Parse("2006-01-02", *raw)
	if err != nil {
		return nil, err
	}
	d := model.JoinDateFromTime(t)
	return &d, nil
}
