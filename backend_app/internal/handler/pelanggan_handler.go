package handler

import (
	"errors"
	"net/http"
	"strings"

	"backend-app/internal/dto"
	"backend-app/internal/repository"
	"backend-app/internal/service"

	"github.com/gin-gonic/gin"
)

type PelangganHandler struct{ svc *service.PelangganService }

func NewPelangganHandler(svc *service.PelangganService) *PelangganHandler {
	return &PelangganHandler{svc: svc}
}

func (h *PelangganHandler) List(c *gin.Context) {
	pg := dto.ParsePagination(c)
	outletID, ok := parseOptionalUint64Query(c, "outlet_id")
	if !ok {
		return
	}
	items, meta, err := h.svc.List(repository.PelangganFilter{
		Q: strings.TrimSpace(c.Query("q")), OutletID: outletID, Offset: pg.Offset(), Limit: pg.Limit,
	})
	if err != nil {
		dto.Fail(c, http.StatusInternalServerError, "gagal mengambil data pelanggan")
		return
	}
	dto.OKWithMeta(c, items, meta)
}

func (h *PelangganHandler) GetByID(c *gin.Context) {
	id, ok := parseIDParam(c)
	if !ok {
		return
	}
	item, err := h.svc.GetByID(id)
	if err != nil {
		if errors.Is(err, service.ErrPelangganNotFound) {
			dto.Fail(c, http.StatusNotFound, "pelanggan tidak ditemukan")
			return
		}
		dto.Fail(c, http.StatusInternalServerError, "gagal mengambil data pelanggan")
		return
	}
	dto.OK(c, item)
}

func (h *PelangganHandler) Create(c *gin.Context) {
	var req dto.CreatePelangganRequest
	if err := c.ShouldBindJSON(&req); err != nil {
		dto.ValidationError(c, err)
		return
	}
	item, err := h.svc.Create(req)
	if err != nil {
		if errors.Is(err, service.ErrInvalidGender) {
			dto.FailWithDetails(c, http.StatusBadRequest, "validasi gagal", map[string]interface{}{
				"gender": "harus Laki-laki atau Perempuan",
			})
			return
		}
		dto.Fail(c, http.StatusInternalServerError, "gagal membuat pelanggan")
		return
	}
	dto.Created(c, item)
}

func (h *PelangganHandler) Update(c *gin.Context) {
	id, ok := parseIDParam(c)
	if !ok {
		return
	}
	var req dto.UpdatePelangganRequest
	if err := c.ShouldBindJSON(&req); err != nil {
		dto.ValidationError(c, err)
		return
	}
	item, err := h.svc.Update(id, req)
	if err != nil {
		if errors.Is(err, service.ErrPelangganNotFound) {
			dto.Fail(c, http.StatusNotFound, "pelanggan tidak ditemukan")
			return
		}
		if errors.Is(err, service.ErrInvalidGender) {
			dto.FailWithDetails(c, http.StatusBadRequest, "validasi gagal", map[string]interface{}{
				"gender": "harus Laki-laki atau Perempuan",
			})
			return
		}
		dto.Fail(c, http.StatusInternalServerError, "gagal memperbarui pelanggan")
		return
	}
	dto.OK(c, item)
}

func (h *PelangganHandler) Delete(c *gin.Context) {
	id, ok := parseIDParam(c)
	if !ok {
		return
	}
	if err := h.svc.Delete(id); err != nil {
		if errors.Is(err, service.ErrPelangganNotFound) {
			dto.Fail(c, http.StatusNotFound, "pelanggan tidak ditemukan")
			return
		}
		dto.Fail(c, http.StatusInternalServerError, "gagal menghapus pelanggan")
		return
	}
	dto.OK(c, gin.H{"message": "pelanggan berhasil dihapus"})
}
