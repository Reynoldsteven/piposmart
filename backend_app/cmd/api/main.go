package main

import (
	"log"

	"backend-app/internal/config"
	"backend-app/internal/router"

	"github.com/gin-gonic/gin"
)

func main() {
	cfg, err := config.Load()
	if err != nil {
		log.Fatalf("config error: %v", err)
	}

	gin.SetMode(cfg.GinMode)

	db, err := config.ConnectDB(cfg.DBDSN, cfg.GinMode)
	if err != nil {
		log.Fatalf("database error: %v", err)
	}

	r := router.Setup(cfg, db)

	addr := ":" + cfg.Port
	log.Printf("PipoSmart API listening on %s", addr)
	if err := r.Run(addr); err != nil {
		log.Fatalf("server error: %v", err)
	}
}
