package service

import (
	"errors"
	"fmt"
	"slices"
	"strings"
	"time"

	"backend-app/internal/dto"
	"backend-app/internal/model"
	"backend-app/internal/repository"

	"github.com/shopspring/decimal"
)

var (
	ErrPesananNotFound  = errors.New("pesanan tidak ditemukan")
	ErrInvalidStatus    = errors.New("status tidak valid")
	ErrEmptyPesananItem = errors.New("items wajib diisi")
)

type PesananService struct {
	repo *repository.PesananRepository
}

func NewPesananService(repo *repository.PesananRepository) *PesananService {
	return &PesananService{repo: repo}
}

func (s *PesananService) List(f repository.PesananFilter) ([]dto.PesananResponse, dto.Meta, error) {
	items, total, err := s.repo.List(f)
	if err != nil {
		return nil, dto.Meta{}, err
	}
	out := make([]dto.PesananResponse, 0, len(items))
	for i := range items {
		out = append(out, mapPesanan(&items[i], false))
	}
	page := 1
	if f.Limit > 0 {
		page = f.Offset/f.Limit + 1
	}
	return out, dto.BuildMeta(page, f.Limit, total), nil
}

func (s *PesananService) ListTransactions(f repository.PesananFilter) ([]dto.TransactionResponse, dto.Meta, error) {
	items, total, err := s.repo.List(f)
	if err != nil {
		return nil, dto.Meta{}, err
	}
	out := make([]dto.TransactionResponse, 0, len(items))
	for i := range items {
		p := &items[i]
		var pickup *string
		if p.PickupEstimate != nil {
			s := p.PickupEstimate.Format(time.RFC3339)
			pickup = &s
		}
		var pelanggan *string
		if p.Pelanggan != nil {
			pelanggan = &p.Pelanggan.Name
		}
		totalF, _ := p.Total.Float64()
		out = append(out, dto.TransactionResponse{
			Kode: p.Kode, OutletName: p.Outlet.Name, Tanggal: p.CreatedAt.Format(time.RFC3339),
			Status: p.Status, IsLunas: p.IsLunas, Total: totalF, PickupEstimate: pickup,
			JumlahItemLayanan: len(p.Items), PelangganName: pelanggan,
		})
	}
	page := 1
	if f.Limit > 0 {
		page = f.Offset/f.Limit + 1
	}
	return out, dto.BuildMeta(page, f.Limit, total), nil
}

func (s *PesananService) GetByID(id uint64) (*dto.PesananResponse, error) {
	item, err := s.repo.FindByID(id)
	if err != nil {
		if errors.Is(err, repository.ErrPesananNotFound) {
			return nil, ErrPesananNotFound
		}
		return nil, err
	}
	resp := mapPesanan(item, true)
	return &resp, nil
}

func (s *PesananService) Create(userID uint64, req dto.CreatePesananRequest) (*dto.PesananResponse, error) {
	if len(req.Items) == 0 {
		return nil, ErrEmptyPesananItem
	}
	kode, err := s.repo.NextKode()
	if err != nil {
		return nil, err
	}
	pickup, err := parseDateTime(req.PickupEstimate)
	if err != nil {
		return nil, fmt.Errorf("pickup_estimate tidak valid")
	}

	items := make([]model.PesananItem, 0, len(req.Items))
	total := decimal.Zero
	for _, in := range req.Items {
		layanan, err := s.repo.FindLayananByID(in.LayananID)
		if err != nil {
			return nil, err
		}
		qty := decimal.NewFromFloat(in.Qty)
		sub := layanan.Harga.Mul(qty)
		total = total.Add(sub)
		lid := layanan.ID
		items = append(items, model.PesananItem{
			LayananID: &lid, NamaLayanan: layanan.Name, Harga: layanan.Harga,
			Satuan: layanan.Satuan, Qty: qty, Subtotal: sub,
		})
	}

	uid := userID
	pesanan := &model.Pesanan{
		Kode: kode, OutletID: req.OutletID, PelangganID: req.PelangganID, UserID: &uid,
		Status: model.StatusBaru, IsLunas: false, Total: total, PickupEstimate: pickup, Notes: req.Notes,
	}
	if err := s.repo.CreateWithItems(pesanan, items); err != nil {
		return nil, err
	}
	created, err := s.repo.FindByID(pesanan.ID)
	if err != nil {
		return nil, err
	}
	resp := mapPesanan(created, true)
	return &resp, nil
}

func (s *PesananService) Update(id uint64, req dto.UpdatePesananRequest) (*dto.PesananResponse, error) {
	if _, err := s.repo.FindByID(id); err != nil {
		if errors.Is(err, repository.ErrPesananNotFound) {
			return nil, ErrPesananNotFound
		}
		return nil, err
	}
	fields := map[string]interface{}{}
	if req.Status != nil {
		if !isValidPesananStatus(*req.Status) {
			return nil, ErrInvalidStatus
		}
		fields["status"] = *req.Status
	}
	if req.IsLunas != nil {
		fields["is_lunas"] = *req.IsLunas
	}
	if req.Notes != nil {
		fields["notes"] = *req.Notes
	}
	if req.PickupEstimate != nil {
		pickup, err := parseDateTime(req.PickupEstimate)
		if err != nil {
			return nil, fmt.Errorf("pickup_estimate tidak valid")
		}
		fields["pickup_estimate"] = pickup
	}
	if len(fields) == 0 {
		return s.GetByID(id)
	}
	if err := s.repo.UpdateFields(id, fields); err != nil {
		if errors.Is(err, repository.ErrPesananNotFound) {
			return nil, ErrPesananNotFound
		}
		return nil, err
	}
	return s.GetByID(id)
}

func (s *PesananService) Delete(id uint64) error {
	if err := s.repo.Delete(id); err != nil {
		if errors.Is(err, repository.ErrPesananNotFound) {
			return ErrPesananNotFound
		}
		return err
	}
	return nil
}

func isValidPesananStatus(status string) bool {
	return slices.Contains([]string{
		model.StatusBaru, model.StatusDiproses, model.StatusSiapDiambil, model.StatusSelesai, model.StatusDibatalkan,
	}, status)
}

func parseDateTime(raw *string) (*time.Time, error) {
	if raw == nil || strings.TrimSpace(*raw) == "" {
		return nil, nil
	}
	layouts := []string{time.RFC3339, "2006-01-02 15:04:05", "2006-01-02T15:04:05"}
	for _, layout := range layouts {
		if t, err := time.Parse(layout, strings.TrimSpace(*raw)); err == nil {
			return &t, nil
		}
	}
	return nil, errors.New("invalid datetime")
}

func mapPesanan(m *model.Pesanan, withItems bool) dto.PesananResponse {
	total, _ := m.Total.Float64()
	var pickup *string
	if m.PickupEstimate != nil {
		s := m.PickupEstimate.Format(time.RFC3339)
		pickup = &s
	}
	var pelangganName *string
	if m.Pelanggan != nil {
		pelangganName = &m.Pelanggan.Name
	}
	names := make([]string, 0, len(m.Items))
	items := make([]dto.PesananItemResponse, 0, len(m.Items))
	for _, it := range m.Items {
		names = append(names, it.NamaLayanan)
		if withItems {
			harga, _ := it.Harga.Float64()
			qty, _ := it.Qty.Float64()
			sub, _ := it.Subtotal.Float64()
			items = append(items, dto.PesananItemResponse{
				ID: it.ID, LayananID: it.LayananID, NamaLayanan: it.NamaLayanan,
				Harga: harga, Satuan: it.Satuan, Qty: qty, Subtotal: sub,
			})
		}
	}
	resp := dto.PesananResponse{
		ID: m.ID, Kode: m.Kode, OutletID: m.OutletID, OutletName: m.Outlet.Name,
		PelangganID: m.PelangganID, PelangganName: pelangganName, UserID: m.UserID,
		Status: m.Status, IsLunas: m.IsLunas, Total: total, PickupEstimate: pickup, Notes: m.Notes,
		LayananSummary: strings.Join(names, ", "),
		CreatedAt: m.CreatedAt.Format(time.RFC3339), UpdatedAt: m.UpdatedAt.Format(time.RFC3339),
	}
	if withItems {
		resp.Items = items
	}
	return resp
}

type DashboardService struct {
	repo *repository.DashboardRepo
}

func NewDashboardService(repo *repository.DashboardRepo) *DashboardService {
	return &DashboardService{repo: repo}
}

func (s *DashboardService) Summary(outletID *uint64) (*dto.DashboardSummaryResponse, error) {
	aktif, penjualan, selesai, laba, err := s.repo.Summary(outletID)
	if err != nil {
		return nil, err
	}
	labaF, _ := laba.Float64()
	return &dto.DashboardSummaryResponse{
		PesananAktif: aktif, LabaHariIni: labaF, PenjualanHariIni: penjualan,
		PengeluaranHariIni: 0, TotalSelesai: selesai,
	}, nil
}

func (s *DashboardService) StatusSummary(outletID *uint64) (*dto.StatusSummaryResponse, error) {
	selesai, terlambat, harus, err := s.repo.StatusSummary(outletID)
	if err != nil {
		return nil, err
	}
	return &dto.StatusSummaryResponse{Selesai: selesai, Terlambat: terlambat, HarusSelesai: harus}, nil
}
