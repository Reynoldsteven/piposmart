package dto

import (
	"time"

	"backend-app/internal/model"

	"github.com/shopspring/decimal"
)

type CreateLayananRequest struct {
	Name     string  `json:"name" binding:"required,max=150"`
	Kategori string  `json:"kategori" binding:"required"`
	Harga    float64 `json:"harga" binding:"required,gt=0"`
	Satuan   string  `json:"satuan" binding:"required"`
	IsActive *bool   `json:"is_active"`
}

type UpdateLayananRequest struct {
	Name     string  `json:"name" binding:"required,max=150"`
	Kategori string  `json:"kategori" binding:"required"`
	Harga    float64 `json:"harga" binding:"required,gt=0"`
	Satuan   string  `json:"satuan" binding:"required"`
	IsActive *bool   `json:"is_active"`
}

type LayananResponse struct {
	ID        uint64    `json:"id"`
	Kode      string    `json:"kode"`
	Name      string    `json:"name"`
	Kategori  string    `json:"kategori"`
	Harga     float64   `json:"harga"`
	Satuan    string    `json:"satuan"`
	IsActive  bool      `json:"is_active"`
	CreatedAt time.Time `json:"created_at"`
	UpdatedAt time.Time `json:"updated_at"`
}

func LayananFromModel(m *model.Layanan) LayananResponse {
	harga, _ := m.Harga.Float64()
	return LayananResponse{
		ID:        m.ID,
		Kode:      m.Kode,
		Name:      m.Name,
		Kategori:  m.Kategori,
		Harga:     harga,
		Satuan:    m.Satuan,
		IsActive:  m.IsActive,
		CreatedAt: m.CreatedAt,
		UpdatedAt: m.UpdatedAt,
	}
}

func LayananListFromModels(items []model.Layanan) []LayananResponse {
	out := make([]LayananResponse, 0, len(items))
	for i := range items {
		out = append(out, LayananFromModel(&items[i]))
	}
	return out
}

func DecimalFromFloat(v float64) decimal.Decimal {
	return decimal.NewFromFloat(v)
}
