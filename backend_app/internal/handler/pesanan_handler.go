package handler

import (
	"errors"
	"net/http"
	"strings"

	"backend-app/internal/dto"
	"backend-app/internal/middleware"
	"backend-app/internal/repository"
	"backend-app/internal/service"

	"github.com/gin-gonic/gin"
)

type PesananHandler struct{ svc *service.PesananService }

func NewPesananHandler(svc *service.PesananService) *PesananHandler {
	return &PesananHandler{svc: svc}
}

func (h *PesananHandler) List(c *gin.Context) {
	pg := dto.ParsePagination(c)
	outletID, ok := parseOptionalUint64Query(c, "outlet_id")
	if !ok {
		return
	}
	var status *string
	if s := strings.TrimSpace(c.Query("status")); s != "" {
		status = &s
	}
	items, meta, err := h.svc.List(repository.PesananFilter{
		OutletID: outletID, Status: status, Q: strings.TrimSpace(c.Query("q")),
		Offset: pg.Offset(), Limit: pg.Limit,
	})
	if err != nil {
		dto.Fail(c, http.StatusInternalServerError, "gagal mengambil data pesanan")
		return
	}
	dto.OKWithMeta(c, items, meta)
}

func (h *PesananHandler) ListTransactions(c *gin.Context) {
	pg := dto.ParsePagination(c)
	outletID, ok := parseOptionalUint64Query(c, "outlet_id")
	if !ok {
		return
	}
	var status *string
	if s := strings.TrimSpace(c.Query("status")); s != "" {
		status = &s
	}
	items, meta, err := h.svc.ListTransactions(repository.PesananFilter{
		OutletID: outletID, Status: status, Q: strings.TrimSpace(c.Query("q")),
		Offset: pg.Offset(), Limit: pg.Limit,
	})
	if err != nil {
		dto.Fail(c, http.StatusInternalServerError, "gagal mengambil data transaksi")
		return
	}
	dto.OKWithMeta(c, items, meta)
}

func (h *PesananHandler) GetByID(c *gin.Context) {
	id, ok := parseIDParam(c)
	if !ok {
		return
	}
	item, err := h.svc.GetByID(id)
	if err != nil {
		if errors.Is(err, service.ErrPesananNotFound) {
			dto.Fail(c, http.StatusNotFound, "pesanan tidak ditemukan")
			return
		}
		dto.Fail(c, http.StatusInternalServerError, "gagal mengambil data pesanan")
		return
	}
	dto.OK(c, item)
}

func (h *PesananHandler) Create(c *gin.Context) {
	var req dto.CreatePesananRequest
	if err := c.ShouldBindJSON(&req); err != nil {
		dto.ValidationError(c, err)
		return
	}
	userIDVal, _ := c.Get(middleware.ContextUserIDKey)
	userID, _ := userIDVal.(uint64)
	item, err := h.svc.Create(userID, req)
	if err != nil {
		if errors.Is(err, service.ErrEmptyPesananItem) || strings.Contains(err.Error(), "layanan") || strings.Contains(err.Error(), "pickup") {
			dto.Fail(c, http.StatusBadRequest, err.Error())
			return
		}
		dto.Fail(c, http.StatusInternalServerError, "gagal membuat pesanan")
		return
	}
	dto.Created(c, item)
}

func (h *PesananHandler) Update(c *gin.Context) {
	id, ok := parseIDParam(c)
	if !ok {
		return
	}
	var req dto.UpdatePesananRequest
	if err := c.ShouldBindJSON(&req); err != nil {
		dto.ValidationError(c, err)
		return
	}
	item, err := h.svc.Update(id, req)
	if err != nil {
		switch {
		case errors.Is(err, service.ErrPesananNotFound):
			dto.Fail(c, http.StatusNotFound, "pesanan tidak ditemukan")
		case errors.Is(err, service.ErrInvalidStatus):
			dto.FailWithDetails(c, http.StatusBadRequest, "validasi gagal", map[string]interface{}{
				"status": "status tidak valid",
			})
		default:
			dto.Fail(c, http.StatusInternalServerError, "gagal memperbarui pesanan")
		}
		return
	}
	dto.OK(c, item)
}

func (h *PesananHandler) Delete(c *gin.Context) {
	id, ok := parseIDParam(c)
	if !ok {
		return
	}
	if err := h.svc.Delete(id); err != nil {
		if errors.Is(err, service.ErrPesananNotFound) {
			dto.Fail(c, http.StatusNotFound, "pesanan tidak ditemukan")
			return
		}
		dto.Fail(c, http.StatusInternalServerError, "gagal menghapus pesanan")
		return
	}
	dto.OK(c, gin.H{"message": "pesanan berhasil dihapus"})
}

type DashboardHandler struct{ svc *service.DashboardService }

func NewDashboardHandler(svc *service.DashboardService) *DashboardHandler {
	return &DashboardHandler{svc: svc}
}

func (h *DashboardHandler) Summary(c *gin.Context) {
	outletID, ok := parseOptionalUint64Query(c, "outlet_id")
	if !ok {
		return
	}
	item, err := h.svc.Summary(outletID)
	if err != nil {
		dto.Fail(c, http.StatusInternalServerError, "gagal mengambil ringkasan dashboard")
		return
	}
	dto.OK(c, item)
}

func (h *DashboardHandler) StatusSummary(c *gin.Context) {
	outletID, ok := parseOptionalUint64Query(c, "outlet_id")
	if !ok {
		return
	}
	item, err := h.svc.StatusSummary(outletID)
	if err != nil {
		dto.Fail(c, http.StatusInternalServerError, "gagal mengambil ringkasan status")
		return
	}
	dto.OK(c, item)
}
