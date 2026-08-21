# Piposmart — API Documentation

Base URL (local): `http://localhost:8080`

Format response sukses:

```json
{
  "success": true,
  "data": {},
  "meta": {
    "page": 1,
    "limit": 20,
    "total": 100,
    "total_pages": 5
  }
}
```

Format error:

```json
{
  "success": false,
  "error": "pesan error",
  "details": { "Email": "wajib diisi" }
}
```

Autentikasi (endpoint terlindungi):

```http
Authorization: Bearer <jwt_token>
```

Pagination query umum: `page` (default 1), `limit` (default 20, max 100).

---

## Health

| Method | Path | Auth | Deskripsi |
| --- | --- | --- | --- |
| GET | `/health` | Tidak | Status server + koneksi DB |

---

## Auth

| Method | Path | Auth | Deskripsi |
| --- | --- | --- | --- |
| POST | `/auth/register` | Tidak | Registrasi user |
| POST | `/auth/login` | Tidak | Login → JWT |
| GET | `/auth/me` | Ya | Profil user saat ini |
| DELETE | `/auth/session` | Ya | Logout (client hapus token) |

### POST `/auth/login`

```json
{
  "email": "reynold@gmail.com",
  "password": "password123"
}
```

Response `data`:

```json
{
  "token": "<jwt>",
  "user": {
    "id": 1,
    "name": "reynold",
    "email": "reynold@gmail.com",
    "role": "owner",
    "phone": "081234567890"
  }
}
```

### POST `/auth/register`

```json
{
  "name": "Nama User",
  "email": "user@example.com",
  "password": "password123",
  "phone": "08123456789",
  "role": "owner"
}
```

`role` opsional: `owner` | `kasir` | `produksi` (default `owner`).

---

## Layanan (master data / setara `/items`)

| Method | Path | Auth | Deskripsi |
| --- | --- | --- | --- |
| GET | `/layanan` | Ya | List + search/filter/pagination |
| GET | `/layanan/:id` | Ya | Detail |
| POST | `/layanan` | Ya | Tambah |
| PUT | `/layanan/:id` | Ya | Update |
| DELETE | `/layanan/:id` | Ya | Hapus |

Query list: `q`, `kategori`, `is_active` (`true`/`false`), `page`, `limit`.

Body create/update:

```json
{
  "name": "Cuci Komplit Express",
  "kategori": "Cuci",
  "harga": 15000,
  "satuan": "kg",
  "is_active": true
}
```

---

## Outlets

| Method | Path | Auth |
| --- | --- | --- |
| GET | `/outlets` | Ya |
| GET | `/outlets/:id` | Ya |
| POST | `/outlets` | Ya |
| PUT | `/outlets/:id` | Ya |
| DELETE | `/outlets/:id` | Ya |

Query: `q`, `page`, `limit`.

```json
{
  "name": "Mewing Laundry · Nagoya",
  "address": "Jl. Nagoya Hill No. 12",
  "provinsi": "Kepulauan Riau",
  "kota": "Batam",
  "kecamatan": "Lubuk Baja"
}
```

---

## Pelanggan

| Method | Path | Auth |
| --- | --- | --- |
| GET | `/pelanggan` | Ya |
| GET | `/pelanggan/:id` | Ya |
| POST | `/pelanggan` | Ya |
| PUT | `/pelanggan/:id` | Ya |
| DELETE | `/pelanggan/:id` | Ya |

Query: `q`, `outlet_id`, `page`, `limit`.

```json
{
  "name": "Andi Susanto",
  "phone": "081234567890",
  "address": "Jl. Sudirman No. 10",
  "gender": "Laki-laki",
  "outlet_id": 1
}
```

---

## Karyawan (RBAC: role `owner` saja)

| Method | Path | Auth + Role |
| --- | --- | --- |
| GET | `/karyawan` | Ya + owner |
| GET | `/karyawan/:id` | Ya + owner |
| POST | `/karyawan` | Ya + owner |
| PUT | `/karyawan/:id` | Ya + owner |
| DELETE | `/karyawan/:id` | Ya + owner |

Query: `q`, `role`, `page`, `limit`.

Create:

```json
{
  "name": "Kasir Baru",
  "email": "kasir@example.com",
  "password": "password123",
  "phone": "08111111111",
  "role": "kasir",
  "outlet_ids": [1],
  "join_date": "2026-01-15"
}
```

Update: field `password` opsional (kosong = tidak diganti).

---

## Pesanan

| Method | Path | Auth |
| --- | --- | --- |
| GET | `/pesanan` | Ya |
| GET | `/pesanan/:id` | Ya |
| POST | `/pesanan` | Ya |
| PUT | `/pesanan/:id` | Ya |
| DELETE | `/pesanan/:id` | Ya |

Query list: `q`, `status`, `outlet_id`, `page`, `limit`.

Status: `Baru` | `Diproses` | `Siap Diambil` | `Selesai` | `Dibatalkan`.

Create:

```json
{
  "outlet_id": 1,
  "pelanggan_id": 1,
  "items": [
    { "layanan_id": 1, "qty": 2 },
    { "layanan_id": 3, "qty": 1 }
  ],
  "pickup_estimate": "2026-08-22 10:00:00",
  "notes": "Jangan pakai pewangi"
}
```

Update (partial):

```json
{
  "status": "Diproses",
  "is_lunas": true,
  "notes": "Sudah dicuci"
}
```

---

## Transaksi & Dashboard

| Method | Path | Auth | Query |
| --- | --- | --- | --- |
| GET | `/transactions` | Ya | `q`, `status`, `outlet_id`, `page`, `limit` |
| GET | `/dashboard/summary` | Ya | `outlet_id` (opsional) |
| GET | `/orders/status-summary` | Ya | `outlet_id` (opsional) |

Contoh `dashboard/summary` → `data`:

```json
{
  "pesanan_aktif": 12,
  "laba_hari_ini": 450000,
  "penjualan_hari_ini": 8,
  "pengeluaran_hari_ini": 0,
  "total_selesai": 40
}
```

---

## HTTP status code

| Code | Arti |
| --- | --- |
| 200 | OK |
| 201 | Created |
| 400 | Validasi / bad request |
| 401 | Belum login / token invalid |
| 403 | Role tidak diizinkan (RBAC) |
| 404 | Data tidak ditemukan |
| 409 | Konflik (mis. email sudah dipakai) |
| 500 | Error server |
| 503 | Database unavailable (`/health`) |

---

## File terkait

- OpenAPI: [`openapi.yaml`](openapi.yaml)
- Postman: [`postman/Piposmart.postman_collection.json`](postman/Piposmart.postman_collection.json)
- Schema SQL: [`../database/01_schema_migration.sql`](../database/01_schema_migration.sql)
