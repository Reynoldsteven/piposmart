package handler

import (
	"errors"
	"net/http"
	"strconv"
	"strings"

	"backend-app/internal/dto"
	"backend-app/internal/repository"
	"backend-app/internal/service"

	"github.com/gin-gonic/gin"
)

type LayananHandler struct {
	svc *service.LayananService
}

func NewLayananHandler(svc *service.LayananService) *LayananHandler {
	return &LayananHandler{svc: svc}
}

// List godoc
// @Summary      List layanan
// @Description  Get paginated layanan with optional filters
// @Tags         layanan
// @Produce      json
// @Security     BearerAuth
// @Param        page       query     int     false  "Page number"
// @Param        limit      query     int     false  "Items per page"
// @Param        kategori   query     string  false  "Filter by kategori"
// @Param        is_active  query     bool    false  "Filter by active status"
// @Param        q          query     string  false  "Search by name or kode"
// @Success      200  {object}  dto.SuccessResponse
// @Failure      401  {object}  dto.ErrorResponse
// @Router       /layanan [get]
func (h *LayananHandler) List(c *gin.Context) {
	pg := dto.ParsePagination(c)

	filter := repository.LayananFilter{
		Offset: pg.Offset(),
		Limit:  pg.Limit,
		Q:      strings.TrimSpace(c.Query("q")),
	}

	if kategori := strings.TrimSpace(c.Query("kategori")); kategori != "" {
		filter.Kategori = &kategori
	}
	if raw := c.Query("is_active"); raw != "" {
		v, err := strconv.ParseBool(raw)
		if err != nil {
			dto.FailWithDetails(c, http.StatusBadRequest, "validasi gagal", map[string]interface{}{
				"is_active": "harus true atau false",
			})
			return
		}
		filter.IsActive = &v
	}

	items, meta, err := h.svc.List(filter)
	if err != nil {
		dto.Fail(c, http.StatusInternalServerError, "gagal mengambil data layanan")
		return
	}

	dto.OKWithMeta(c, items, meta)
}

// GetByID godoc
// @Summary      Get layanan by ID
// @Tags         layanan
// @Produce      json
// @Security     BearerAuth
// @Param        id   path      int  true  "Layanan ID"
// @Success      200  {object}  dto.SuccessResponse
// @Failure      404  {object}  dto.ErrorResponse
// @Router       /layanan/{id} [get]
func (h *LayananHandler) GetByID(c *gin.Context) {
	id, ok := parseIDParam(c)
	if !ok {
		return
	}

	item, err := h.svc.GetByID(id)
	if err != nil {
		if errors.Is(err, service.ErrLayananNotFound) {
			dto.Fail(c, http.StatusNotFound, "layanan tidak ditemukan")
			return
		}
		dto.Fail(c, http.StatusInternalServerError, "gagal mengambil data layanan")
		return
	}

	dto.OK(c, item)
}

// Create godoc
// @Summary      Create layanan
// @Tags         layanan
// @Accept       json
// @Produce      json
// @Security     BearerAuth
// @Param        body  body      dto.CreateLayananRequest  true  "Layanan payload"
// @Success      201   {object}  dto.SuccessResponse
// @Failure      400   {object}  dto.ErrorResponse
// @Router       /layanan [post]
func (h *LayananHandler) Create(c *gin.Context) {
	var req dto.CreateLayananRequest
	if err := c.ShouldBindJSON(&req); err != nil {
		dto.ValidationError(c, err)
		return
	}

	item, err := h.svc.Create(req)
	if err != nil {
		if writeLayananValidationError(c, err) {
			return
		}
		dto.Fail(c, http.StatusInternalServerError, "gagal membuat layanan")
		return
	}

	dto.Created(c, item)
}

// Update godoc
// @Summary      Update layanan
// @Tags         layanan
// @Accept       json
// @Produce      json
// @Security     BearerAuth
// @Param        id    path      int                       true  "Layanan ID"
// @Param        body  body      dto.UpdateLayananRequest  true  "Layanan payload"
// @Success      200   {object}  dto.SuccessResponse
// @Failure      400   {object}  dto.ErrorResponse
// @Failure      404   {object}  dto.ErrorResponse
// @Router       /layanan/{id} [put]
func (h *LayananHandler) Update(c *gin.Context) {
	id, ok := parseIDParam(c)
	if !ok {
		return
	}

	var req dto.UpdateLayananRequest
	if err := c.ShouldBindJSON(&req); err != nil {
		dto.ValidationError(c, err)
		return
	}

	item, err := h.svc.Update(id, req)
	if err != nil {
		if errors.Is(err, service.ErrLayananNotFound) {
			dto.Fail(c, http.StatusNotFound, "layanan tidak ditemukan")
			return
		}
		if writeLayananValidationError(c, err) {
			return
		}
		dto.Fail(c, http.StatusInternalServerError, "gagal memperbarui layanan")
		return
	}

	dto.OK(c, item)
}

// Delete godoc
// @Summary      Delete layanan
// @Description  Hard delete. Returns 409 if layanan is still referenced by pesanan_item.
// @Tags         layanan
// @Produce      json
// @Security     BearerAuth
// @Param        id   path      int  true  "Layanan ID"
// @Success      200  {object}  dto.SuccessResponse
// @Failure      404  {object}  dto.ErrorResponse
// @Failure      409  {object}  dto.ErrorResponse
// @Router       /layanan/{id} [delete]
func (h *LayananHandler) Delete(c *gin.Context) {
	id, ok := parseIDParam(c)
	if !ok {
		return
	}

	err := h.svc.Delete(id)
	if err != nil {
		if errors.Is(err, service.ErrLayananNotFound) {
			dto.Fail(c, http.StatusNotFound, "layanan tidak ditemukan")
			return
		}

		var inUse *service.LayananInUseError
		if errors.As(err, &inUse) {
			dto.FailWithDetails(c, http.StatusConflict, "layanan masih digunakan di pesanan", map[string]interface{}{
				"usage_count": inUse.UsageCount,
				"options": []string{
					"nonaktifkan lewat PUT /layanan/:id dengan is_active=false",
					"hapus/ubah item pesanan terkait dulu, lalu coba DELETE lagi",
				},
			})
			return
		}

		dto.Fail(c, http.StatusInternalServerError, "gagal menghapus layanan")
		return
	}

	dto.OK(c, gin.H{"message": "layanan berhasil dihapus"})
}

func writeLayananValidationError(c *gin.Context, err error) bool {
	switch {
	case errors.Is(err, service.ErrInvalidKategori):
		dto.FailWithDetails(c, http.StatusBadRequest, "validasi gagal", map[string]interface{}{
			"kategori": "harus salah satu dari: Cuci, Cuci & Setrika, Setrika, Spesial",
		})
		return true
	case errors.Is(err, service.ErrInvalidSatuan):
		dto.FailWithDetails(c, http.StatusBadRequest, "validasi gagal", map[string]interface{}{
			"satuan": "harus salah satu dari: kg, pcs, pasang, set",
		})
		return true
	default:
		return false
	}
}
