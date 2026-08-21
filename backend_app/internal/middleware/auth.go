package middleware

import (
	"net/http"
	"strings"

	"backend-app/internal/dto"
	jwtmanager "backend-app/internal/pkg/jwt"

	"github.com/gin-gonic/gin"
)

const (
	ContextUserIDKey   = "user_id"
	ContextUserRoleKey = "user_role"
)

func JWTAuth(jwtManager *jwtmanager.Manager) gin.HandlerFunc {
	return func(c *gin.Context) {
		authHeader := c.GetHeader("Authorization")
		if authHeader == "" {
			dto.Fail(c, http.StatusUnauthorized, "token tidak ditemukan")
			c.Abort()
			return
		}

		parts := strings.SplitN(authHeader, " ", 2)
		if len(parts) != 2 || !strings.EqualFold(parts[0], "Bearer") {
			dto.Fail(c, http.StatusUnauthorized, "format token tidak valid")
			c.Abort()
			return
		}

		claims, err := jwtManager.Parse(parts[1])
		if err != nil {
			dto.Fail(c, http.StatusUnauthorized, "token tidak valid atau sudah expired")
			c.Abort()
			return
		}

		c.Set(ContextUserIDKey, claims.UserID)
		c.Set(ContextUserRoleKey, claims.Role)
		c.Next()
	}
}
