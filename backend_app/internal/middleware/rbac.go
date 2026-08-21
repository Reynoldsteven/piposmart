package middleware

import (
	"net/http"
	"slices"

	"backend-app/internal/dto"

	"github.com/gin-gonic/gin"
)

// RequireRoles restricts access to users with one of the allowed roles.
func RequireRoles(roles ...string) gin.HandlerFunc {
	return func(c *gin.Context) {
		roleValue, exists := c.Get(ContextUserRoleKey)
		if !exists {
			dto.Fail(c, http.StatusUnauthorized, "tidak terautentikasi")
			c.Abort()
			return
		}

		role, ok := roleValue.(string)
		if !ok || !slices.Contains(roles, role) {
			dto.Fail(c, http.StatusForbidden, "akses ditolak")
			c.Abort()
			return
		}

		c.Next()
	}
}
