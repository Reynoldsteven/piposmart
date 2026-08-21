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

type OutletHandler struct{ svc *service.OutletService }

func NewOutletHandler(svc *service.OutletService) *OutletHandler { return &OutletHandler{svc: svc} }

func (h *OutletHandler) List(c *gin.Context) {
	pg := dto.ParsePagination(c)
	items, meta, err := h.svc.List(repository.OutletFilter{Q: strings.TrimSpace(c.Query("q")), Offset: pg.Offset(), Limit: pg.Limit})
	if err != nil {
		dto.Fail(c, http.StatusInternalServerError, "gagal mengambil data outlet")
		return
	}
	dto.OKWithMeta(c, items, meta)
}

func (h *OutletHandler) GetByID(c *gin.Context) {
	id, ok := parseIDParam(c)
	if !ok {
		return
	}
	item, err := h.svc.GetByID(id)
	if err != nil {
		if errors.Is(err, service.ErrOutletNotFound) {
			dto.Fail(c, http.StatusNotFound, "outlet tidak ditemukan")
			return
		}
		dto.Fail(c, http.StatusInternalServerError, "gagal mengambil data outlet")
		return
	}
	dto.OK(c, item)
}

func (h *OutletHandler) Create(c *gin.Context) {
	var req dto.CreateOutletRequest
	if err := c.ShouldBindJSON(&req); err != nil {
		dto.ValidationError(c, err)
		return
	}
	item, err := h.svc.Create(req)
	if err != nil {
		dto.Fail(c, http.StatusInternalServerError, "gagal membuat outlet")
		return
	}
	dto.Created(c, item)
}

func (h *OutletHandler) Update(c *gin.Context) {
	id, ok := parseIDParam(c)
	if !ok {
		return
	}
	var req dto.UpdateOutletRequest
	if err := c.ShouldBindJSON(&req); err != nil {
		dto.ValidationError(c, err)
		return
	}
	item, err := h.svc.Update(id, req)
	if err != nil {
		if errors.Is(err, service.ErrOutletNotFound) {
			dto.Fail(c, http.StatusNotFound, "outlet tidak ditemukan")
			return
		}
		dto.Fail(c, http.StatusInternalServerError, "gagal memperbarui outlet")
		return
	}
	dto.OK(c, item)
}

func (h *OutletHandler) Delete(c *gin.Context) {
	id, ok := parseIDParam(c)
	if !ok {
		return
	}
	if err := h.svc.Delete(id); err != nil {
		if errors.Is(err, service.ErrOutletNotFound) {
			dto.Fail(c, http.StatusNotFound, "outlet tidak ditemukan")
			return
		}
		if errors.Is(err, service.ErrOutletInUse) {
			dto.Fail(c, http.StatusConflict, "outlet masih digunakan")
			return
		}
		dto.Fail(c, http.StatusInternalServerError, "gagal menghapus outlet")
		return
	}
	dto.OK(c, gin.H{"message": "outlet berhasil dihapus"})
}
