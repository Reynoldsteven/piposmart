package handler

import (
	"strconv"

	"backend-app/internal/dto"

	"github.com/gin-gonic/gin"
	"net/http"
)

func parseIDParam(c *gin.Context) (uint64, bool) {
	id, err := strconv.ParseUint(c.Param("id"), 10, 64)
	if err != nil || id == 0 {
		dto.FailWithDetails(c, http.StatusBadRequest, "validasi gagal", map[string]interface{}{
			"id": "harus berupa angka positif",
		})
		return 0, false
	}
	return id, true
}

func parseOptionalUint64Query(c *gin.Context, key string) (*uint64, bool) {
	raw := c.Query(key)
	if raw == "" {
		return nil, true
	}
	v, err := strconv.ParseUint(raw, 10, 64)
	if err != nil {
		dto.FailWithDetails(c, http.StatusBadRequest, "validasi gagal", map[string]interface{}{
			key: "harus berupa angka",
		})
		return nil, false
	}
	return &v, true
}
