-- ============================================================
-- PIPOSMART — Seed / Dummy Data
-- Jalankan SETELAH 01_schema_migration.sql
-- Password test: "password123" → bcrypt hash di bawah
-- ============================================================
USE piposmart;

-- ── USERS ─────────────────────────────────────────────────────
-- Password untuk semua user: password123
INSERT INTO users (id, name, email, password, phone, role) VALUES
(1,  'Reynold',  'reynold@gmail.com',  '$2a$12$LQv3c1yqBWVHxkd0LHAkCOYz6TiGJFnXr8QkKxVn9hQzGlM1sXWu6', '081234567890', 'owner'),
(2,  'Budi Santoso',     'budi@mewinglaundry.com',   '$2a$12$LQv3c1yqBWVHxkd0LHAkCOYz6TiGJFnXr8QkKxVn9hQzGlM1sXWu6', '081298765432', 'kasir'),
(3,  'Siti Aminah',      'siti@mewinglaundry.com',   '$2a$12$LQv3c1yqBWVHxkd0LHAkCOYz6TiGJFnXr8QkKxVn9hQzGlM1sXWu6', '081355667788', 'produksi'),
(4,  'Rina Kastuti',     'rina@amm.com',             '$2a$12$LQv3c1yqBWVHxkd0LHAkCOYz6TiGJFnXr8QkKxVn9hQzGlM1sXWu6', '082100112233', 'kasir'),
(5,  'Ahmad Fauzi',      'ahmad@amm.com',            '$2a$12$LQv3c1yqBWVHxkd0LHAkCOYz6TiGJFnXr8QkKxVn9hQzGlM1sXWu6', '082199887766', 'produksi');

-- ── OUTLETS ───────────────────────────────────────────────────
INSERT INTO outlets (id, name, address, provinsi, kota, kecamatan) VALUES
(1, 'Mewing Laundry · Nagoya',   'Jl. Nagoya Hill No. 12',    'Kepulauan Riau', 'Batam',        'Lubuk Baja'),
(2, 'Mewing Laundry · Cab. 2',   'Jl. Sudirman No. 45',       'Kepulauan Riau', 'Batam',        'Sagulung'),
(3, 'AMM Laundry Palu',          'Jl. Diponegoro No. 88',     'Sulawesi Tengah','Palu',         'Palu Selatan');

-- ── USER_OUTLETS ───────────────────────────────────────────────
INSERT INTO user_outlets (user_id, outlet_id, join_date) VALUES
(1, 1, '2024-01-01'),
(2, 1, '2024-02-15'),
(3, 1, '2024-03-01'),
(4, 3, '2024-04-10'),
(5, 3, '2024-05-20');

-- ── PELANGGAN ─────────────────────────────────────────────────
INSERT INTO pelanggan (id, name, phone, address, gender, outlet_id) VALUES
(1,  'Andi Susanto',     '081234567890', 'Jl. Sudirman No. 10, Batam',             'Laki-laki',  1),
(2,  'Rina Melati',      '082198765432', 'Jl. Imam Bonjol No. 5, Batam',           'Perempuan',  1),
(3,  'Budi Wijaya',      '083177665544', 'Jl. Hang Tuah No. 20, Batam',            'Laki-laki',  1),
(4,  'Siti Rahayu',      '084155443322', 'Jl. Raja Ali Haji No. 8, Batam',         'Perempuan',  1),
(5,  'Deni Kurniawan',   '085133221100', 'Jl. Seraya No. 15, Batam',               'Laki-laki',  2),
(6,  'Fitri Handayani',  '086111223344', 'Jl. Merdeka No. 3, Batam',               'Perempuan',  2),
(7,  'Hendra Gunawan',   '087199887766', 'Jl. Gajah Mada No. 7, Batam',            'Laki-laki',  1),
(8,  'Dewi Kusuma',      '088122334455', 'Jl. Pemuda No. 22, Batam',               'Perempuan',  1),
(9,  'Reza Pratama',     '089155667788', 'Jl. Pahlawan No. 11, Palu',              'Laki-laki',  3),
(10, 'Lusi Anggraini',   '081211223344', 'Jl. Patimura No. 6, Palu',              'Perempuan',  3),
(11, 'Wahyu Santoso',    '081322334455', 'Jl. A. Yani No. 9, Batam',              'Laki-laki',  1),
(12, 'Maya Sari',        '081433445566', 'Jl. Diponegoro No. 4, Batam',           'Perempuan',  1),
(13, 'Eko Prasetyo',     '081544556677', 'Jl. Sudirman No. 30, Batam',            'Laki-laki',  2),
(14, 'Nita Cahyani',     '081655667788', 'Jl. Gatot Subroto No. 12, Batam',       'Perempuan',  2),
(15, 'Sigit Wibowo',     '081766778899', 'Jl. Veteran No. 19, Palu',              'Laki-laki',  3);

-- ── LAYANAN ───────────────────────────────────────────────────
INSERT INTO layanan (id, kode, name, kategori, harga, satuan, is_active) VALUES
(1,  'LYN-001', 'Cuci Komplit Express',   'Cuci',           15000.00, 'kg',     1),
(2,  'LYN-002', 'Cuci Setrika Reguler',   'Cuci & Setrika', 12000.00, 'kg',     1),
(3,  'LYN-003', 'Setrika Saja',           'Setrika',         8000.00, 'kg',     1),
(4,  'LYN-004', 'Cuci Sepatu',            'Spesial',        35000.00, 'pasang', 1),
(5,  'LYN-005', 'Cuci Tas',               'Spesial',        45000.00, 'pcs',    0),
(6,  'LYN-006', 'Dry Cleaning',           'Spesial',        60000.00, 'pcs',    1),
(7,  'LYN-007', 'Cuci Komplit Reguler',   'Cuci',           10000.00, 'kg',     1),
(8,  'LYN-008', 'Cuci Selimut',           'Cuci',           25000.00, 'pcs',    1),
(9,  'LYN-009', 'Cuci Boneka',            'Spesial',        30000.00, 'pcs',    1),
(10, 'LYN-010', 'Cuci Karpet',            'Spesial',        50000.00, 'pcs',    1);

-- ── PESANAN ───────────────────────────────────────────────────
INSERT INTO pesanan (id, kode, outlet_id, pelanggan_id, user_id, status, is_lunas, total, pickup_estimate, created_at) VALUES
(1,  'TR/9127/23', 3, 9,  4, 'Baru',         1, 1000000.00, '2025-07-10 10:25:00', '2025-07-09 08:00:00'),
(2,  'TR/9127/22', 3, 10, 4, 'Diproses',     0,  900000.00, '2025-07-05 09:41:00', '2025-07-04 09:00:00'),
(3,  'TR/9127/21', 3, 9,  4, 'Siap Diambil', 1,  650000.00, '2025-07-03 14:00:00', '2025-07-02 07:30:00'),
(4,  'ORD-1001',   1, 1,  2, 'Baru',         0,   45000.00, '2026-08-12 10:00:00', '2026-08-10 09:00:00'),
(5,  'ORD-1002',   1, 2,  2, 'Diproses',     0,   36000.00, '2026-08-11 14:00:00', '2026-08-09 10:00:00'),
(6,  'ORD-1003',   1, 3,  2, 'Selesai',      1,   35000.00, '2026-08-10 11:00:00', '2026-08-08 08:00:00'),
(7,  'ORD-1004',   1, 4,  2, 'Dibatalkan',   0,   24000.00, '2026-08-09 15:00:00', '2026-08-07 13:00:00'),
(8,  'ORD-1005',   1, 5,  2, 'Selesai',      1,   60000.00, '2026-08-08 10:00:00', '2026-08-06 09:00:00'),
(9,  'ORD-1006',   2, 6,  2, 'Baru',         0,   48000.00, '2026-08-14 11:00:00', '2026-08-12 10:00:00'),
(10, 'ORD-1007',   2, 7,  2, 'Diproses',     1,   90000.00, '2026-08-13 12:00:00', '2026-08-11 08:00:00'),
(11, 'ORD-1008',   1, 8,  2, 'Siap Diambil', 0,   32000.00, '2026-08-12 14:00:00', '2026-08-10 07:00:00'),
(12, 'ORD-1009',   1, 1,  2, 'Selesai',      1,  120000.00, '2026-08-11 09:00:00', '2026-08-09 08:30:00'),
(13, 'ORD-1010',   1, 2,  2, 'Baru',         0,   15000.00, '2026-08-15 10:00:00', '2026-08-13 09:00:00'),
(14, 'ORD-1011',   2, 3,  2, 'Diproses',     0,   70000.00, '2026-08-14 15:00:00', '2026-08-12 11:00:00'),
(15, 'ORD-1012',   1, 4,  2, 'Selesai',      1,   45000.00, '2026-08-10 13:00:00', '2026-08-08 10:00:00'),
(16, 'ORD-1013',   1, 5,  2, 'Siap Diambil', 1,   25000.00, '2026-08-11 11:00:00', '2026-08-09 09:00:00'),
(17, 'ORD-1014',   2, 6,  2, 'Selesai',      1,   84000.00, '2026-08-12 12:00:00', '2026-08-10 08:00:00'),
(18, 'ORD-1015',   1, 7,  2, 'Baru',         0,   30000.00, '2026-08-16 10:00:00', '2026-08-14 07:30:00'),
(19, 'ORD-1016',   1, 8,  2, 'Diproses',     0,   96000.00, '2026-08-15 14:00:00', '2026-08-13 10:00:00'),
(20, 'ORD-1017',   2, 1,  2, 'Selesai',      1,   60000.00, '2026-08-13 09:00:00', '2026-08-11 08:00:00');

-- ── PESANAN_ITEM ──────────────────────────────────────────────
INSERT INTO pesanan_item (pesanan_id, layanan_id, nama_layanan, harga, satuan, qty, subtotal) VALUES
(1,  1, 'Cuci Komplit Express', 15000.00, 'kg',     5.0, 75000.00),
(1,  6, 'Dry Cleaning',         60000.00, 'pcs',   15.0, 900000.00),
(2,  2, 'Cuci Setrika Reguler', 12000.00, 'kg',     4.0, 48000.00),
(2,  3, 'Setrika Saja',          8000.00, 'kg',     2.0, 16000.00),
(3,  4, 'Cuci Sepatu',          35000.00, 'pasang', 1.0, 35000.00),
(4,  1, 'Cuci Komplit Express', 15000.00, 'kg',     3.0, 45000.00),
(5,  2, 'Cuci Setrika Reguler', 12000.00, 'kg',     3.0, 36000.00),
(6,  4, 'Cuci Sepatu',          35000.00, 'pasang', 1.0, 35000.00),
(7,  2, 'Cuci Setrika Reguler', 12000.00, 'kg',     2.0, 24000.00),
(8,  6, 'Dry Cleaning',         60000.00, 'pcs',    1.0, 60000.00),
(9,  1, 'Cuci Komplit Express', 15000.00, 'kg',     2.0, 30000.00),
(9,  3, 'Setrika Saja',          8000.00, 'kg',     1.0, 8000.00),
(10, 7, 'Cuci Komplit Reguler', 10000.00, 'kg',     9.0, 90000.00),
(11, 2, 'Cuci Setrika Reguler', 12000.00, 'kg',     2.0, 24000.00),
(11, 3, 'Setrika Saja',          8000.00, 'kg',     1.0, 8000.00),
(12, 8, 'Cuci Selimut',         25000.00, 'pcs',    4.0, 100000.00),
(12, 1, 'Cuci Komplit Express', 15000.00, 'kg',     1.0, 15000.00),
(13, 1, 'Cuci Komplit Express', 15000.00, 'kg',     1.0, 15000.00),
(14, 9, 'Cuci Boneka',          30000.00, 'pcs',    1.0, 30000.00),
(14, 1, 'Cuci Komplit Express', 15000.00, 'kg',     2.0, 30000.00),
(15, 1, 'Cuci Komplit Express', 15000.00, 'kg',     3.0, 45000.00),
(16, 4, 'Cuci Sepatu',          35000.00, 'pasang', 1.0, 35000.00),
(17, 2, 'Cuci Setrika Reguler', 12000.00, 'kg',     7.0, 84000.00),
(18, 7, 'Cuci Komplit Reguler', 10000.00, 'kg',     3.0, 30000.00),
(19, 1, 'Cuci Komplit Express', 15000.00, 'kg',     4.0, 60000.00),
(19, 8, 'Cuci Selimut',         25000.00, 'pcs',    1.0, 25000.00),
(20, 6, 'Dry Cleaning',         60000.00, 'pcs',    1.0, 60000.00);
