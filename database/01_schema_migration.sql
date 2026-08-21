-- ============================================================
-- PIPOSMART — MySQL 8.x Migration Script
-- Order: users → outlets → karyawan → pelanggan → layanan → pesanan → pesanan_item
-- ============================================================

CREATE DATABASE IF NOT EXISTS piposmart CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
USE piposmart;

-- ── 1. USERS ─────────────────────────────────────────────────
-- Menyimpan akun login untuk semua role (Owner, Admin/Kasir, Bagian Produksi).
-- Email adalah identitas unik untuk login.
-- Password disimpan sebagai bcrypt hash.
-- role tidak menggunakan ENUM agar mudah dikembangkan.
CREATE TABLE users (
    id          BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    name        VARCHAR(100)  NOT NULL,
    email       VARCHAR(150)  NOT NULL UNIQUE,
    password    VARCHAR(255)  NOT NULL COMMENT 'bcrypt hash',
    phone       VARCHAR(20)   NULL,
    role        VARCHAR(50)   NOT NULL DEFAULT 'kasir'
                              COMMENT 'owner | kasir | produksi',
    created_at  TIMESTAMP     NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at  TIMESTAMP     NOT NULL DEFAULT CURRENT_TIMESTAMP
                              ON UPDATE CURRENT_TIMESTAMP,
    INDEX idx_users_role (role)
);

-- ── 2. OUTLETS ───────────────────────────────────────────────
-- Master data outlet/cabang laundry.
-- Setiap entitas data (karyawan, pesanan) berelasi ke outlet.
CREATE TABLE outlets (
    id            BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    name          VARCHAR(150)  NOT NULL,
    address       TEXT          NULL,
    provinsi      VARCHAR(100)  NULL,
    kota          VARCHAR(100)  NULL,
    kecamatan     VARCHAR(100)  NULL,
    created_at    TIMESTAMP     NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at    TIMESTAMP     NOT NULL DEFAULT CURRENT_TIMESTAMP
                                ON UPDATE CURRENT_TIMESTAMP,
    INDEX idx_outlets_name (name)
);

-- ── 3. USER_OUTLETS (relasi many-to-many) ──────────────────
-- Satu user (karyawan) bisa bekerja di satu outlet.
-- Tabel ini menghubungkan user ke outlet tempatnya bekerja.
CREATE TABLE user_outlets (
    id          BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    user_id     BIGINT UNSIGNED NOT NULL,
    outlet_id   BIGINT UNSIGNED NOT NULL,
    join_date   DATE            NULL,
    CONSTRAINT fk_uo_user   FOREIGN KEY (user_id)   REFERENCES users(id)   ON DELETE CASCADE,
    CONSTRAINT fk_uo_outlet FOREIGN KEY (outlet_id) REFERENCES outlets(id) ON DELETE CASCADE,
    UNIQUE KEY uq_user_outlet (user_id, outlet_id)
);

-- ── 4. PELANGGAN ─────────────────────────────────────────────
-- Master data pelanggan laundry. Tidak memiliki akun login.
CREATE TABLE pelanggan (
    id          BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    name        VARCHAR(100)  NOT NULL,
    phone       VARCHAR(20)   NULL,
    address     TEXT          NULL,
    gender      VARCHAR(10)   NULL COMMENT 'Laki-laki | Perempuan',
    outlet_id   BIGINT UNSIGNED NULL COMMENT 'outlet pertama kali daftar',
    created_at  TIMESTAMP     NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at  TIMESTAMP     NOT NULL DEFAULT CURRENT_TIMESTAMP
                              ON UPDATE CURRENT_TIMESTAMP,
    CONSTRAINT fk_pelanggan_outlet FOREIGN KEY (outlet_id) REFERENCES outlets(id) ON DELETE SET NULL,
    INDEX idx_pelanggan_name  (name),
    INDEX idx_pelanggan_phone (phone)
);

-- ── 5. LAYANAN ───────────────────────────────────────────────
-- Master data layanan/jasa laundry yang tersedia.
CREATE TABLE layanan (
    id          BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    kode        VARCHAR(20)   NOT NULL UNIQUE COMMENT 'e.g. LYN-001',
    name        VARCHAR(150)  NOT NULL,
    kategori    VARCHAR(100)  NOT NULL COMMENT 'Cuci | Cuci & Setrika | Setrika | Spesial',
    harga       DECIMAL(12,2) NOT NULL,
    satuan      VARCHAR(20)   NOT NULL COMMENT 'kg | pcs | pasang | set',
    is_active   TINYINT(1)    NOT NULL DEFAULT 1,
    created_at  TIMESTAMP     NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at  TIMESTAMP     NOT NULL DEFAULT CURRENT_TIMESTAMP
                              ON UPDATE CURRENT_TIMESTAMP,
    INDEX idx_layanan_kategori  (kategori),
    INDEX idx_layanan_is_active (is_active)
);

-- ── 6. PESANAN ───────────────────────────────────────────────
-- Transaksi/pesanan laundry. Setiap pesanan milik 1 pelanggan di 1 outlet,
-- dikerjakan oleh 1 user (kasir), dan memiliki status proses.
CREATE TABLE pesanan (
    id              BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    kode            VARCHAR(30)   NOT NULL UNIQUE COMMENT 'e.g. TR/9127/23 atau ORD-1001',
    outlet_id       BIGINT UNSIGNED NOT NULL,
    pelanggan_id    BIGINT UNSIGNED NULL,
    user_id         BIGINT UNSIGNED NULL COMMENT 'kasir yang membuat pesanan',
    status          VARCHAR(30)   NOT NULL DEFAULT 'Baru'
                                  COMMENT 'Baru | Diproses | Siap Diambil | Selesai | Dibatalkan',
    is_lunas        TINYINT(1)    NOT NULL DEFAULT 0,
    total           DECIMAL(14,2) NOT NULL DEFAULT 0,
    pickup_estimate DATETIME      NULL,
    notes           TEXT          NULL,
    created_at      TIMESTAMP     NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at      TIMESTAMP     NOT NULL DEFAULT CURRENT_TIMESTAMP
                                  ON UPDATE CURRENT_TIMESTAMP,
    CONSTRAINT fk_pesanan_outlet    FOREIGN KEY (outlet_id)    REFERENCES outlets(id)    ON DELETE RESTRICT,
    CONSTRAINT fk_pesanan_pelanggan FOREIGN KEY (pelanggan_id) REFERENCES pelanggan(id)  ON DELETE SET NULL,
    CONSTRAINT fk_pesanan_user      FOREIGN KEY (user_id)      REFERENCES users(id)      ON DELETE SET NULL,
    INDEX idx_pesanan_status     (status),
    INDEX idx_pesanan_outlet     (outlet_id),
    INDEX idx_pesanan_pelanggan  (pelanggan_id),
    INDEX idx_pesanan_created_at (created_at),
    INDEX idx_pesanan_is_lunas   (is_lunas)
);

-- ── 7. PESANAN_ITEM ──────────────────────────────────────────
-- Detail layanan yang dipilih dalam satu pesanan.
-- Harga disimpan snapshot agar tidak berubah jika harga layanan diubah.
CREATE TABLE pesanan_item (
    id          BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    pesanan_id  BIGINT UNSIGNED NOT NULL,
    layanan_id  BIGINT UNSIGNED NULL,
    nama_layanan VARCHAR(150)  NOT NULL COMMENT 'snapshot nama layanan saat transaksi',
    harga       DECIMAL(12,2)  NOT NULL COMMENT 'snapshot harga saat transaksi',
    satuan      VARCHAR(20)    NOT NULL,
    qty         DECIMAL(8,2)   NOT NULL DEFAULT 1,
    subtotal    DECIMAL(14,2)  NOT NULL,
    CONSTRAINT fk_pi_pesanan FOREIGN KEY (pesanan_id) REFERENCES pesanan(id)  ON DELETE CASCADE,
    CONSTRAINT fk_pi_layanan FOREIGN KEY (layanan_id) REFERENCES layanan(id)  ON DELETE SET NULL,
    INDEX idx_pi_pesanan (pesanan_id)
);
