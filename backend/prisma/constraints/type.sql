/*
Karena MariaDB tidak mendukung create TYPE, kita akan menggunakan
CHECK CONSTRAINT untuk memastikan nilai kolom sesuai dengan tipe yang diinginkan.
 */
-- 1. Harga harus > 0
ALTER TABLE `MembershipTier` ADD CONSTRAINT `harga_bulanan_valid` CHECK (`harga_bulanan` > 0);

ALTER TABLE `Pembelian` ADD CONSTRAINT `pembelian_total_harga_valid` CHECK (`total_harga` > 0);

ALTER TABLE `Merchandise` ADD CONSTRAINT `harga_merch_valid` CHECK (`harga` > 0);

-- 2. Jumlah harus > 0
ALTER TABLE `Langganan` ADD CONSTRAINT `jumlah_valid` CHECK (`jumlah` > 0);

ALTER TABLE `Pembelian` ADD CONSTRAINT `pembelian_jumlah_valid` CHECK (`jumlah` > 0);

ALTER TABLE `Merchandise` ADD CONSTRAINT `stok_merch_valid` CHECK (`stok` >= 0);

-- 3. Isi komentar tidak boleh kosong
ALTER TABLE `Komentar` ADD CONSTRAINT `isi_komentar_tidak_kosong` CHECK (CHAR_LENGTH(`isi`) > 0);

-- 4. Jumlah kata dalam KontenTeks harus > 0
ALTER TABLE `KontenTeks` ADD CONSTRAINT `jumlah_kata_valid` CHECK (`jumlah_kata` > 0);

-- 5. Durasi konten harus > 0
ALTER TABLE `KontenVideo` ADD CONSTRAINT `durasi_video_valid` CHECK (`durasi` > 0);

ALTER TABLE `KontenAudio` ADD CONSTRAINT `durasi_audio_valid` CHECK (`durasi` > 0);