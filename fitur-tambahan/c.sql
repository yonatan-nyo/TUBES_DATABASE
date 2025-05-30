-- Aktivitas Pendukung
/*

Membuat tabel yang mencatat berbagai aktivitas pendukung untuk analisis engagement. Kolom-kolom dari tabel tersebut berisi idAktivitas, idPendukung, jenis_aktivitas, id_referensi, deskripsi, tanggal_aktivitas. 
Terdapat trigger yang akan mencatat aktivitas saat pendukung berlangganan tier, memberikan komentar pada konten, atau saat membeli merchandise.
*/

-- sql-formatter-disable
-- prettier-ignore-start

-- 1. Table to log supporter activities
CREATE TABLE `AktivitasPendukung` (
    `id_aktivitas` INTEGER NOT NULL AUTO_INCREMENT,
    `id_pendukung` INTEGER NOT NULL,
    `jenis_aktivitas` ENUM('Langganan', 'Komentar', 'Beli_Merchandise') NOT NULL,
    `id_referensi` INTEGER NOT NULL,
    `deskripsi` TEXT NOT NULL,
    `tanggal_aktivitas` DATETIME(3) NOT NULL DEFAULT CURRENT_TIMESTAMP(3),

    INDEX `AktivitasPendukung_id_pendukung_idx`(`id_pendukung`),
    PRIMARY KEY (`id_aktivitas`)
) DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

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

-- prettier-ignore-end
-- sql-formatter-enable
