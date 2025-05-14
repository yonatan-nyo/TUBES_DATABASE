package models

import (
	"gorm.io/gorm"
)

// AutoMigrateAll will migrate all registered models
func AutoMigrateAll(db *gorm.DB) {
	db.AutoMigrate(
		&Kreator{},
		&Supporter{},
		&Konten{},
		&MembershipTier{},
		&Komentar{},
		&Langganan{},
		&OrderSpecialContent{},
		&KontenGambar{},
		&KontenVideo{},
		&KontenAudio{},
		&KontenTeks{},
		&Merchandise{},
		&Pembelian{},
		&AksesKonten{},
	)
}
