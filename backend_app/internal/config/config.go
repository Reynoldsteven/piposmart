package config

import (
	"fmt"
	"os"
	"strconv"

	"github.com/joho/godotenv"
)

// Config holds application configuration loaded from environment variables.
type Config struct {
	Port           string
	DBDSN          string
	JWTSecret      string
	JWTExpireHours int
	CORSOrigin     string
	GinMode        string
}

// Load reads configuration from .env (if present) and environment variables.
func Load() (*Config, error) {
	// .env is optional; production may inject env vars directly.
	_ = godotenv.Load()

	jwtExpireHours, err := strconv.Atoi(getEnv("JWT_EXPIRE_HOURS", "24"))
	if err != nil {
		return nil, fmt.Errorf("invalid JWT_EXPIRE_HOURS: %w", err)
	}

	cfg := &Config{
		Port:           getEnv("PORT", "8080"),
		DBDSN:          os.Getenv("DB_DSN"),
		JWTSecret:      os.Getenv("JWT_SECRET"),
		JWTExpireHours: jwtExpireHours,
		CORSOrigin:     getEnv("CORS_ORIGIN", "*"),
		GinMode:        getEnv("GIN_MODE", "debug"),
	}

	if cfg.DBDSN == "" {
		return nil, fmt.Errorf("DB_DSN is required")
	}
	if cfg.JWTSecret == "" {
		return nil, fmt.Errorf("JWT_SECRET is required")
	}

	return cfg, nil
}

func getEnv(key, fallback string) string {
	if v := os.Getenv(key); v != "" {
		return v
	}
	return fallback
}
