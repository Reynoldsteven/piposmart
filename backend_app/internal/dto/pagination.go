package dto

import (
	"strconv"

	"github.com/gin-gonic/gin"
)

const (
	DefaultPage  = 1
	DefaultLimit = 20
	MaxLimit     = 100
)

type PaginationQuery struct {
	Page  int
	Limit int
}

func (p PaginationQuery) Offset() int {
	return (p.Page - 1) * p.Limit
}

func ParsePagination(c *gin.Context) PaginationQuery {
	page := parsePositiveInt(c.Query("page"), DefaultPage)
	limit := parsePositiveInt(c.Query("limit"), DefaultLimit)
	if limit > MaxLimit {
		limit = MaxLimit
	}
	return PaginationQuery{Page: page, Limit: limit}
}

func BuildMeta(page, limit int, total int64) Meta {
	totalPages := 0
	if limit > 0 {
		totalPages = int((total + int64(limit) - 1) / int64(limit))
	}
	return Meta{
		Page:       page,
		Limit:      limit,
		Total:      total,
		TotalPages: totalPages,
	}
}

func parsePositiveInt(raw string, fallback int) int {
	if raw == "" {
		return fallback
	}
	v, err := strconv.Atoi(raw)
	if err != nil || v < 1 {
		return fallback
	}
	return v
}
