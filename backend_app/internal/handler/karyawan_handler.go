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

type KaryawanHandler struct{ svc *service.KaryawanService }

func NewKaryawanHandler(svc *service.KaryawanService) *KaryawanHandler {
	return &KaryawanHandler{svc: svc}
}

func (h *KaryawanHandler) List(c *gin.Context) {
	pg := dto.ParsePagination(c)
	var role *string
	if r := strings.TrimSpace(c.Query("role")); r != "" {
		role = &r
	}
	items, meta, err := h.svc.List(repository.KaryawanFilter{
		Q: strings.TrimSpace(c.Query("q")), Role: role, Offset: pg.Offset(), Limit: pg.Limit,
	})
	if err != nil {
		dto.Fail(c, http.StatusInternalServerError, "gagal mengambil data karyawan")
		return
	}
	dto.OKWithMeta(c, items, meta)
}

func (h *KaryawanHandler) GetByID(c *gin.Context) {
	id, ok := parseIDParam(c)
	if !ok {
		return
	}
	item, err := h.svc.GetByID(id)
	if err != nil {
		if errors.Is(err, service.ErrKaryawanNotFound) {
			dto.Fail(c, http.StatusNotFound, "karyawan tidak ditemukan")
			return
		}
		dto.Fail(c, http.StatusInternalServerError, "gagal mengambil data karyawan")
		return
	}
	dto.OK(c, item)
}

func (h *KaryawanHandler) Create(c *gin.Context) {
	var req dto.CreateKaryawanRequest
	if err := c.ShouldBindJSON(&req); err != nil {
		dto.ValidationError(c, err)
		return
	}
	item, err := h.svc.Create(req)
	if err != nil {
		switch {
		case errors.Is(err, service.ErrInvalidRole):
			dto.FailWithDetails(c, http.StatusBadRequest, "validasi gagal", map[string]interface{}{
				"role": "harus owner, kasir, atau produksi",
			})
		case errors.Is(err, service.ErrEmailAlreadyUsed):
			dto.Fail(c, http.StatusConflict, "email sudah terdaftar")
		case strings.Contains(err.Error(), "join_date"):
			dto.FailWithDetails(c, http.StatusBadRequest, "validasi gagal", map[string]interface{}{
				"join_date": err.Error(),
			})
		default:
			dto.Fail(c, http.StatusInternalServerError, "gagal membuat karyawan")
		}
		return
	}
	dto.Created(c, item)
}

func (h *KaryawanHandler) Update(c *gin.Context) {
	id, ok := parseIDParam(c)
	if !ok {
		return
	}
	var req dto.UpdateKaryawanRequest
	if err := c.ShouldBindJSON(&req); err != nil {
		dto.ValidationError(c, err)
		return
	}
	item, err := h.svc.Update(id, req)
	if err != nil {
		switch {
		case errors.Is(err, service.ErrKaryawanNotFound):
			dto.Fail(c, http.StatusNotFound, "karyawan tidak ditemukan")
		case errors.Is(err, service.ErrInvalidRole):
			dto.FailWithDetails(c, http.StatusBadRequest, "validasi gagal", map[string]interface{}{
				"role": "harus owner, kasir, atau produksi",
			})
		case errors.Is(err, service.ErrEmailAlreadyUsed):
			dto.Fail(c, http.StatusConflict, "email sudah terdaftar")
		default:
			dto.Fail(c, http.StatusInternalServerError, "gagal memperbarui karyawan")
		}
		return
	}
	dto.OK(c, item)
}

func (h *KaryawanHandler) Delete(c *gin.Context) {
	id, ok := parseIDParam(c)
	if !ok {
		return
	}
	if err := h.svc.Delete(id); err != nil {
		if errors.Is(err, service.ErrKaryawanNotFound) {
			dto.Fail(c, http.StatusNotFound, "karyawan tidak ditemukan")
			return
		}
		dto.Fail(c, http.StatusInternalServerError, "gagal menghapus karyawan")
		return
	}
	dto.OK(c, gin.H{"message": "karyawan berhasil dihapus"})
}
