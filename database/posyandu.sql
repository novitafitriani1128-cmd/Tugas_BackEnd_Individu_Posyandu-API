
-- ==================================================
-- SISTEM INFORMASI POSYANDU DESA
-- DATABASE: posyandu_db
-- DBMS: PostgreSQL
-- ==================================================


-- 1. TABEL ORANG TUA
CREATE TABLE orang_tua (
    id_orang_tua SERIAL PRIMARY KEY,
    nama_orang_tua VARCHAR(100) NOT NULL,
    nik VARCHAR(20) UNIQUE NOT NULL,
    no_telepon VARCHAR(20),
    alamat TEXT
);


-- 2. TABEL BALITA
CREATE TABLE balita (
    id_balita SERIAL PRIMARY KEY,
    id_orang_tua INT NOT NULL,
    nama_balita VARCHAR(100) NOT NULL,
    jenis_kelamin VARCHAR(10) NOT NULL
        CHECK (jenis_kelamin IN ('Laki-laki', 'Perempuan')),
    tanggal_lahir DATE NOT NULL,
    tempat_lahir VARCHAR(100),

    CONSTRAINT fk_balita_orang_tua
        FOREIGN KEY (id_orang_tua)
        REFERENCES orang_tua(id_orang_tua)
);


-- 3. TABEL BUKU KIA
CREATE TABLE buku_kia (
    id_buku_kia SERIAL PRIMARY KEY,
    id_balita INT UNIQUE NOT NULL,
    nomor_buku VARCHAR(30) UNIQUE NOT NULL,
    tanggal_penerbitan DATE,
    keterangan TEXT,

    CONSTRAINT fk_buku_kia_balita
        FOREIGN KEY (id_balita)
        REFERENCES balita(id_balita)
        ON DELETE CASCADE
);


-- 4. TABEL POSYANDU
CREATE TABLE posyandu (
    id_posyandu SERIAL PRIMARY KEY,
    nama_posyandu VARCHAR(100) NOT NULL,
    alamat TEXT NOT NULL,
    nama_desa VARCHAR(100) NOT NULL,
    nomor_telepon VARCHAR(20)
);


-- 5. TABEL KADER
CREATE TABLE kader (
    id_kader SERIAL PRIMARY KEY,
    id_posyandu INT NOT NULL,
    nama_kader VARCHAR(100) NOT NULL,
    no_telepon VARCHAR(20),
    jabatan VARCHAR(50),

    CONSTRAINT fk_kader_posyandu
        FOREIGN KEY (id_posyandu)
        REFERENCES posyandu(id_posyandu)
);


-- 6. TABEL KEGIATAN POSYANDU
CREATE TABLE kegiatan_posyandu (
    id_kegiatan SERIAL PRIMARY KEY,
    id_posyandu INT NOT NULL,
    nama_kegiatan VARCHAR(100) NOT NULL,
    tanggal_kegiatan DATE NOT NULL,
    lokasi VARCHAR(150),
    deskripsi TEXT,
    status_kegiatan VARCHAR(20) DEFAULT 'Terjadwal'
        CHECK (status_kegiatan IN
        ('Terjadwal', 'Berlangsung', 'Selesai', 'Dibatalkan')),

    CONSTRAINT fk_kegiatan_posyandu
        FOREIGN KEY (id_posyandu)
        REFERENCES posyandu(id_posyandu)
);


-- 7. TABEL PEMERIKSAAN
CREATE TABLE pemeriksaan (
    id_pemeriksaan SERIAL PRIMARY KEY,
    id_balita INT NOT NULL,
    id_kader INT NOT NULL,
    id_kegiatan INT NOT NULL,
    tanggal_pemeriksaan DATE DEFAULT CURRENT_DATE,
    berat_badan NUMERIC(5,2)
        CHECK (berat_badan > 0),
    tinggi_badan NUMERIC(5,2)
        CHECK (tinggi_badan > 0),
    lingkar_kepala NUMERIC(5,2)
        CHECK (lingkar_kepala > 0),
    catatan TEXT,

    CONSTRAINT fk_pemeriksaan_balita
        FOREIGN KEY (id_balita)
        REFERENCES balita(id_balita),

    CONSTRAINT fk_pemeriksaan_kader
        FOREIGN KEY (id_kader)
        REFERENCES kader(id_kader),

    CONSTRAINT fk_pemeriksaan_kegiatan
        FOREIGN KEY (id_kegiatan)
        REFERENCES kegiatan_posyandu(id_kegiatan)
);


-- 8. TABEL JENIS LAYANAN
CREATE TABLE jenis_layanan (
    id_layanan SERIAL PRIMARY KEY,
    nama_layanan VARCHAR(100) UNIQUE NOT NULL,
    deskripsi TEXT,
    satuan VARCHAR(30)
);


-- 9. TABEL DETAIL PEMERIKSAAN
CREATE TABLE detail_pemeriksaan (
    id_pemeriksaan INT NOT NULL,
    id_layanan INT NOT NULL,
    hasil_layanan VARCHAR(150),
    keterangan TEXT,

    PRIMARY KEY (id_pemeriksaan, id_layanan),

    CONSTRAINT fk_detail_pemeriksaan
        FOREIGN KEY (id_pemeriksaan)
        REFERENCES pemeriksaan(id_pemeriksaan)
        ON DELETE CASCADE,

    CONSTRAINT fk_detail_layanan
        FOREIGN KEY (id_layanan)
        REFERENCES jenis_layanan(id_layanan)
);


-- ==================================================
-- CONTOH DATA (DUMMY DATA)
-- ==================================================


-- DATA ORANG TUA
INSERT INTO orang_tua
(nama_orang_tua, nik, no_telepon, alamat)
VALUES
('Siti Aminah', '3515010101900001',
 '081234567890', 'Desa Sukamaju'),
('Dewi Lestari', '3515010201900002',
 '081234567891', 'Desa Sukamaju');


-- DATA BALITA
INSERT INTO balita
(id_orang_tua, nama_balita, jenis_kelamin,
 tanggal_lahir, tempat_lahir)
VALUES
(1, 'Alya Putri', 'Perempuan',
 '2023-05-10', 'Sidoarjo'),
(2, 'Rizky Pratama', 'Laki-laki',
 '2022-08-15', 'Sidoarjo');


-- DATA BUKU KIA
INSERT INTO buku_kia
(id_balita, nomor_buku, tanggal_penerbitan, keterangan)
VALUES
(1, 'KIA-001', '2023-05-10', 'Buku KIA Alya Putri'),
(2, 'KIA-002', '2022-08-15', 'Buku KIA Rizky Pratama');


-- DATA POSYANDU
INSERT INTO posyandu
(nama_posyandu, alamat, nama_desa, nomor_telepon)
VALUES
('Posyandu Melati', 'Balai RW 01',
 'Sukamaju', '081234567892');


-- DATA KADER
INSERT INTO kader
(id_posyandu, nama_kader, no_telepon, jabatan)
VALUES
(1, 'Rina Kartika', '081234567893', 'Ketua Kader'),
(1, 'Sari Wulandari', '081234567894', 'Anggota');


-- DATA KEGIATAN
INSERT INTO kegiatan_posyandu
(id_posyandu, nama_kegiatan, tanggal_kegiatan,
 lokasi, deskripsi, status_kegiatan)
VALUES
(1, 'Posyandu Balita Bulanan',
 '2026-11-10', 'Balai RW 01',
 'Kegiatan penimbangan dan pemeriksaan balita',
 'Terjadwal');


-- DATA PEMERIKSAAN
INSERT INTO pemeriksaan
(id_balita, id_kader, id_kegiatan, tanggal_pemeriksaan,
 berat_badan, tinggi_badan, lingkar_kepala, catatan)
VALUES
(1, 1, 1, '2026-11-10',
 12.50, 88.00, 47.00, 'Kondisi balita baik');


-- DATA JENIS LAYANAN
INSERT INTO jenis_layanan
(nama_layanan, deskripsi, satuan)
VALUES
('Penimbangan Berat Badan',
 'Pengukuran berat badan balita', 'Kg'),
('Pengukuran Tinggi Badan',
 'Pengukuran tinggi badan balita', 'Cm'),
('Imunisasi',
 'Pemberian imunisasi sesuai jadwal', 'Dosis'),
('Pemberian Vitamin',
 'Pemberian vitamin kepada balita', 'Dosis');


-- DATA DETAIL PEMERIKSAAN
INSERT INTO detail_pemeriksaan
(id_pemeriksaan, id_layanan, hasil_layanan, keterangan)
VALUES
(1, 1, '12.50 Kg', 'Berat badan tercatat'),
(1, 2, '88.00 Cm', 'Tinggi badan tercatat'),
(1, 4, 'Vitamin A', 'Vitamin telah diberikan');


-- ==================================================
-- QUERY UNTUK MEMERIKSA DATA
-- ==================================================

-- Melihat seluruh tabel
SELECT table_name
FROM information_schema.tables
WHERE table_schema = 'public'
ORDER BY table_name;

-- Melihat data balita beserta orang tua
SELECT
    b.id_balita,
    b.nama_balita,
    b.jenis_kelamin,
    b.tanggal_lahir,
    o.nama_orang_tua,
    o.no_telepon
FROM balita b
JOIN orang_tua o
ON b.id_orang_tua = o.id_orang_tua;

-- Melihat data pemeriksaan beserta layanan
SELECT
    p.id_pemeriksaan,
    b.nama_balita,
    jl.nama_layanan,
    dp.hasil_layanan,
    p.tanggal_pemeriksaan
FROM pemeriksaan p
JOIN balita b
ON p.id_balita = b.id_balita
JOIN detail_pemeriksaan dp
ON p.id_pemeriksaan = dp.id_pemeriksaan
JOIN jenis_layanan jl
ON dp.id_layanan = jl.id_layanan;
