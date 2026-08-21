package router

import (
	"net/http"

	"backend-app/internal/config"
	"backend-app/internal/handler"
	"backend-app/internal/middleware"
	"backend-app/internal/model"
	jwtmanager "backend-app/internal/pkg/jwt"
	"backend-app/internal/repository"
	"backend-app/internal/service"

	"github.com/gin-gonic/gin"
	"gorm.io/gorm"
)

func Setup(cfg *config.Config, db *gorm.DB) *gin.Engine {
	r := gin.New()
	r.Use(gin.Recovery())
	r.Use(middleware.RequestLogger())
	r.Use(middleware.CORS(cfg.CORSOrigin))

	jwtManager := jwtmanager.NewManager(cfg.JWTSecret, cfg.JWTExpireHours)

	userRepo := repository.NewUserRepository(db)
	authService := service.NewAuthService(userRepo, jwtManager)
	authHandler := handler.NewAuthHandler(authService)

	layananHandler := handler.NewLayananHandler(service.NewLayananService(repository.NewLayananRepository(db)))
	outletHandler := handler.NewOutletHandler(service.NewOutletService(repository.NewOutletRepository(db)))
	pelangganHandler := handler.NewPelangganHandler(service.NewPelangganService(repository.NewPelangganRepository(db)))
	karyawanHandler := handler.NewKaryawanHandler(service.NewKaryawanService(repository.NewKaryawanRepository(db)))
	pesananHandler := handler.NewPesananHandler(service.NewPesananService(repository.NewPesananRepository(db)))
	dashboardHandler := handler.NewDashboardHandler(service.NewDashboardService(repository.NewDashboardRepo(db)))

	r.GET("/health", func(c *gin.Context) {
		sqlDB, err := db.DB()
		if err != nil {
			c.JSON(http.StatusServiceUnavailable, gin.H{"success": false, "error": "database unavailable"})
			return
		}
		if err := sqlDB.Ping(); err != nil {
			c.JSON(http.StatusServiceUnavailable, gin.H{"success": false, "error": "database ping failed"})
			return
		}
		c.JSON(http.StatusOK, gin.H{"success": true, "data": gin.H{"status": "ok", "database": "connected"}})
	})

	auth := r.Group("/auth")
	{
		auth.POST("/register", authHandler.Register)
		auth.POST("/login", authHandler.Login)
		protected := auth.Group("")
		protected.Use(middleware.JWTAuth(jwtManager))
		{
			protected.GET("/me", authHandler.Me)
			protected.DELETE("/session", authHandler.Logout)
		}
	}

	api := r.Group("")
	api.Use(middleware.JWTAuth(jwtManager))
	{
		layanan := api.Group("/layanan")
		{
			layanan.GET("", layananHandler.List)
			layanan.GET("/:id", layananHandler.GetByID)
			layanan.POST("", layananHandler.Create)
			layanan.PUT("/:id", layananHandler.Update)
			layanan.DELETE("/:id", layananHandler.Delete)
		}

		outlets := api.Group("/outlets")
		{
			outlets.GET("", outletHandler.List)
			outlets.GET("/:id", outletHandler.GetByID)
			outlets.POST("", outletHandler.Create)
			outlets.PUT("/:id", outletHandler.Update)
			outlets.DELETE("/:id", outletHandler.Delete)
		}

		pelanggan := api.Group("/pelanggan")
		{
			pelanggan.GET("", pelangganHandler.List)
			pelanggan.GET("/:id", pelangganHandler.GetByID)
			pelanggan.POST("", pelangganHandler.Create)
			pelanggan.PUT("/:id", pelangganHandler.Update)
			pelanggan.DELETE("/:id", pelangganHandler.Delete)
		}

		karyawan := api.Group("/karyawan")
		karyawan.Use(middleware.RequireRoles(model.RoleOwner))
		{
			karyawan.GET("", karyawanHandler.List)
			karyawan.GET("/:id", karyawanHandler.GetByID)
			karyawan.POST("", karyawanHandler.Create)
			karyawan.PUT("/:id", karyawanHandler.Update)
			karyawan.DELETE("/:id", karyawanHandler.Delete)
		}

		pesanan := api.Group("/pesanan")
		{
			pesanan.GET("", pesananHandler.List)
			pesanan.GET("/:id", pesananHandler.GetByID)
			pesanan.POST("", pesananHandler.Create)
			pesanan.PUT("/:id", pesananHandler.Update)
			pesanan.DELETE("/:id", pesananHandler.Delete)
		}

		api.GET("/transactions", pesananHandler.ListTransactions)
		api.GET("/dashboard/summary", dashboardHandler.Summary)
		api.GET("/orders/status-summary", dashboardHandler.StatusSummary)
	}

	return r
}
