package dto

import (
	"errors"
	"net/http"

	"github.com/gin-gonic/gin"
	"github.com/go-playground/validator/v10"
)

type Meta struct {
	Page       int   `json:"page,omitempty"`
	Limit      int   `json:"limit,omitempty"`
	Total      int64 `json:"total,omitempty"`
	TotalPages int   `json:"total_pages,omitempty"`
}

type SuccessResponse struct {
	Success bool        `json:"success"`
	Data    interface{} `json:"data"`
	Meta    *Meta       `json:"meta,omitempty"`
}

type ErrorResponse struct {
	Success bool                   `json:"success"`
	Error   string                 `json:"error"`
	Details map[string]interface{} `json:"details,omitempty"`
}

func OK(c *gin.Context, data interface{}) {
	c.JSON(http.StatusOK, SuccessResponse{Success: true, Data: data})
}

func Created(c *gin.Context, data interface{}) {
	c.JSON(http.StatusCreated, SuccessResponse{Success: true, Data: data})
}

func OKWithMeta(c *gin.Context, data interface{}, meta Meta) {
	c.JSON(http.StatusOK, SuccessResponse{Success: true, Data: data, Meta: &meta})
}

func Fail(c *gin.Context, status int, message string) {
	c.JSON(status, ErrorResponse{Success: false, Error: message})
}

func FailWithDetails(c *gin.Context, status int, message string, details map[string]interface{}) {
	c.JSON(status, ErrorResponse{Success: false, Error: message, Details: details})
}

func ValidationError(c *gin.Context, err error) {
	details := map[string]interface{}{}

	var ve validator.ValidationErrors
	if errors.As(err, &ve) {
		for _, fe := range ve {
			details[fe.Field()] = validationMessage(fe)
		}
	} else {
		details["message"] = err.Error()
	}

	FailWithDetails(c, http.StatusBadRequest, "validasi gagal", details)
}

func validationMessage(fe validator.FieldError) string {
	switch fe.Tag() {
	case "required":
		return "wajib diisi"
	case "email":
		return "format email tidak valid"
	case "min":
		return "terlalu pendek"
	case "max":
		return "terlalu panjang"
	default:
		return "tidak valid"
	}
}
