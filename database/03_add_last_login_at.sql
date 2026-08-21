-- PIPOSMART — tambah jejak login terakhir di tabel users
-- Jalankan setelah 01_schema_migration.sql dan 02_seed_data.sql

USE piposmart;

ALTER TABLE users
    ADD COLUMN last_login_at TIMESTAMP NULL DEFAULT NULL
        COMMENT 'waktu login terakhir berhasil'
        AFTER updated_at;
