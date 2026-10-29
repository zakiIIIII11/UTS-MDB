-- ============================================================
-- UTS MANAJEMEN BASIS DATA
-- Nama File : script.sql
-- ============================================================

-- ------------------------------------------------------------
-- 1. PEMBUATAN SKEMA DAN TABEL (Soal No. 3)[cite: 1]
-- ------------------------------------------------------------

-- Membuat Skema SALAM
CREATE SCHEMA IF NOT EXISTS SALAM;

-- Hapus tabel jika sudah ada (opsional untuk reset)
DROP TABLE IF EXISTS SALAM.mahasiswas;

-- Membuat Tabel mahasiswas beserta Constraint
CREATE TABLE SALAM.mahasiswas (
    nim VARCHAR(15) PRIMARY KEY,
    nama VARCHAR(100) NOT NULL,
    email VARCHAR(100) UNIQUE,
    ipk DECIMAL(3,2) CHECK (ipk >= 0.00 AND ipk <= 4.00),
    -- Kolom pembeda/kustomisasi
    buku_favorit VARCHAR(100), 
    pullup_max_rep INT CHECK (pullup_max_rep >= 0)
);

-- ------------------------------------------------------------
-- 2. PEMBUKTIAN CONSTRAINT (Soal No. 3)[cite: 1]
-- ------------------------------------------------------------

-- A. Insert Data Valid (Sukses)
INSERT INTO SALAM.mahasiswas (nim, nama, email, ipk, buku_favorit, pullup_max_rep)
VALUES ('123456789', 'Hilmi', 'hilmi@email.com', 3.85, 'Laut Bercerita', 10);

-- B. Pengujian Primary Key / Unique Constraint Violation (Gagal/Error)
-- Jalankan query di bawah ini secara terpisah untuk mengambil screenshot error:
-- INSERT INTO SALAM.mahasiswas (nim, nama, email, ipk) VALUES ('123456789', 'Zaki', 'hilmi@email.com', 3.50);

-- C. Pengujian Check Constraint Violation (Gagal/Error)
-- Jalankan query di bawah ini secara terpisah untuk mengambil screenshot error:
-- INSERT INTO SALAM.mahasiswas (nim, nama, email, ipk) VALUES ('123456790', 'Fajar', 'fajar@email.com', 4.50);

-- ------------------------------------------------------------
-- 3. MANAJEMEN USER DAN ROLE (Soal No. 4)[cite: 1]
-- ------------------------------------------------------------

-- Hapus user lama jika ada
DROP USER IF EXISTS backend_dev;
DROP USER IF EXISTS bi_dev;
DROP USER IF EXISTS data_engineer;

-- Membuat User Baru
CREATE USER backend_dev WITH PASSWORD 'backend123';
CREATE USER bi_dev WITH PASSWORD 'bi123';
CREATE USER data_engineer WITH PASSWORD 'dataeng123';

-- Hak Akses USAGE ke Skema SALAM
GRANT USAGE ON SCHEMA SALAM TO backend_dev, bi_dev, data_engineer;

-- A. Role backend_dev: CRUD semua tabel[cite: 1]
GRANT SELECT, INSERT, UPDATE, DELETE ON ALL TABLES IN SCHEMA SALAM TO backend_dev;
ALTER DEFAULT PRIVILEGES IN SCHEMA SALAM GRANT SELECT, INSERT, UPDATE, DELETE ON TABLES TO backend_dev;

-- B. Role bi_dev: Hanya Read/SELECT semua tabel/view[cite: 1]
GRANT SELECT ON ALL TABLES IN SCHEMA SALAM TO bi_dev;
ALTER DEFAULT PRIVILEGES IN SCHEMA SALAM GRANT SELECT ON TABLES TO bi_dev;

-- C. Role data_engineer: CREATE, MODIFY, DROP objects & CRUD semua tabel[cite: 1]
GRANT ALL PRIVILEGES ON SCHEMA SALAM TO data_engineer;
GRANT ALL PRIVILEGES ON ALL TABLES IN SCHEMA SALAM TO data_engineer;
ALTER DEFAULT PRIVILEGES IN SCHEMA SALAM GRANT ALL PRIVILEGES ON TABLES TO data_engineer;

-- ------------------------------------------------------------
-- 4. PEMBUKTIAN USER ROLE (Dites pada Koneksi Masing-Masing)[cite: 1]
-- ------------------------------------------------------------

-- A. Tes Koneksi User: bi_dev
-- SELECT * FROM SALAM.mahasiswas;                -- (Berhasil)
-- DELETE FROM SALAM.mahasiswas;                  -- (Gagal: Permission Denied)

-- B. Tes Koneksi User: backend_dev
-- UPDATE SALAM.mahasiswas SET ipk = 3.90 WHERE nim = '123456789'; -- (Berhasil)
-- DROP TABLE SALAM.mahasiswas;                   -- (Gagal: Permission Denied)

-- C. Tes Koneksi User: data_engineer
-- CREATE TABLE SALAM.tes_log (id INT);           -- (Berhasil)
-- DROP TABLE SALAM.tes_log;                      -- (Berhasil)