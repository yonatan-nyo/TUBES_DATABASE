/*
Karena MariaDB tidak mendukung create TYPE, kita akan menggunakan
CHECK CONSTRAINT untuk memastikan nilai kolom sesuai dengan tipe yang diinginkan.
 */
ALTER TABLE `Pembelian`
 ADD CONSTRAINT `pembelian_total_harga_valid` CHECK (`total_harga` > 0.0);

ALTER TABLE `Langganan`
 ADD CONSTRAINT `jumlah_valid` CHECK (`jumlah` > 0);

ALTER TABLE `Pembelian`
 ADD CONSTRAINT `pembelian_jumlah_valid` CHECK (`jumlah` > 0);

ALTER TABLE `KontenTeks`
 ADD CONSTRAINT `jumlah_kata_valid` CHECK (`jumlah_kata` > 0);

ALTER TABLE `KontenVideo`
 ADD CONSTRAINT `durasi_video_valid` CHECK (`durasi` > 0);

ALTER TABLE `KontenAudio`
 ADD CONSTRAINT `durasi_audio_valid` CHECK (`durasi` > 0);

ALTER TABLE `Merchandise`
 ADD CONSTRAINT `stok_merch_valid` CHECK (`stok` >= 0);

ALTER TABLE `Komentar`
 ADD CONSTRAINT `isi_komentar_tidak_kosong` CHECK (CHAR_LENGTH(`isi`) > 0);

--  !!!
--  PAKAI ENUM LANGSUNG DARI SCHEMA PRISMA JADI TIDAK PERLU DITAMBAHKAN DI SINI
--  PAKAI ENUM LANGSUNG DARI SCHEMA PRISMA JADI TIDAK PERLU DITAMBAHKAN DI SINI
--  PAKAI ENUM LANGSUNG DARI SCHEMA PRISMA JADI TIDAK PERLU DITAMBAHKAN DI SINI
-- Dengan Attribute Constraints
-- CREATE TABLE `Konten` (
--    -- other attributes
--    `jenis` ENUM('Teks', 'Gambar', 'Audio', 'Video') NOT NULL,
--    -- other attributes
-- )
-- ALTER TABLE `Konten`
-- MODIFY COLUMN `jenis` ENUM('Teks', 'Gambar', 'Audio', 'Video') NOT NULL;
-- Dengan Check (asumsi jenis dalam bentuk VARCHAR)
-- ALTER TABLE `Konten`
-- ADD CONSTRAINT chk_jenis_konten CHECK (`jenis` IN ('Teks', 'Gambar', 'Audio', 'Video'));

--  PAKAI ENUM LANGSUNG DARI SCHEMA PRISMA JADI TIDAK PERLU DITAMBAHKAN DI SINI
--  PAKAI ENUM LANGSUNG DARI SCHEMA PRISMA JADI TIDAK PERLU DITAMBAHKAN DI SINI
--  PAKAI ENUM LANGSUNG DARI SCHEMA PRISMA JADI TIDAK PERLU DITAMBAHKAN DI SINI

ALTER TABLE `Merchandise`
ADD CONSTRAINT `harga_merch_valid`
CHECK (`harga` > 0.0 AND `harga` <= 1500000.0);

ALTER TABLE `MembershipTier`
ADD CONSTRAINT `harga_bulanan_valid`
CHECK (`harga_bulanan` > 0.0 AND `harga_bulanan` <= 1000000.0);