-- 2. Trigger: Log after Langganan inserted
CREATE TRIGGER after_langganan_insert
AFTER INSERT ON Langganan
FOR EACH ROW
BEGIN
   INSERT INTO AktivitasPendukung (id_pendukung, jenis_aktivitas, id_referensi, deskripsi, tanggal_aktivitas)
   VALUES (
       NEW.id_pendukung,
       'Langganan',
       NEW.id_kreator,
       CONCAT('Berlangganan membership tier "', NEW.nama_membership, '" dari kreator dengan ID: ', NEW.id_kreator),
       NOW(3)
   );
END;
-- 3. Trigger: Log after Komentar inserted
CREATE TRIGGER after_komentar_insert
AFTER INSERT ON Komentar
FOR EACH ROW
BEGIN
   INSERT INTO AktivitasPendukung (id_pendukung, jenis_aktivitas, id_referensi, deskripsi, tanggal_aktivitas)
   VALUES (
       NEW.id_pendukung,
       'Komentar',
       NEW.id_konten,
       CONCAT('Memberi komentar pada konten dengan ID: ', NEW.id_konten),
       NEW.waktu
   );
END;
-- 4. Trigger: Log after PembelianMerchandise inserted
CREATE TRIGGER after_pembelian_insert
AFTER INSERT ON Pembelian
FOR EACH ROW
BEGIN
   INSERT INTO AktivitasPendukung (id_pendukung, jenis_aktivitas, id_referensi, deskripsi, tanggal_aktivitas)
   VALUES (
       NEW.id_pendukung,
       'Beli_Merchandise',
       NEW.id_merchandise,
       CONCAT('Membeli merchandise dengan ID: ', NEW.id_merchandise),
       NEW.tanggal_pembelian
   );
END;