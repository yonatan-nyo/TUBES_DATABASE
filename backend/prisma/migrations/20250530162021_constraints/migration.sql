-- Type Constraints
/*
Karena MariaDB tidak mendukung create TYPE, kita akan menggunakan
CHECK CONSTRAINT untuk memastikan nilai kolom sesuai dengan tipe yang diinginkan.
 */
ALTER TABLE `Pembelian`
 ADD CONSTRAINT `pembelian_total_harga_valid` CHECK (`total_harga` >= 0.0);

ALTER TABLE `Langganan`
 ADD CONSTRAINT `jumlah_valid` CHECK (`jumlah` > 0);

ALTER TABLE `Pembelian`
 ADD CONSTRAINT `pembelian_jumlah_valid` CHECK (`jumlah` >= 0);

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

-- Relation Extra Sql
ALTER TABLE `OrderSpecialContent`
ADD CONSTRAINT `chk_status_selesai_tanggal`
CHECK (
  NOT (`status` = 'Selesai' AND `tanggal_penyelesaian` IS NULL)
);

-- Trigger untuk validasi jumlah tier maksimal saat INSERT
CREATE TRIGGER check_max_tier_per_kreator_insert
BEFORE INSERT ON MembershipTier
FOR EACH ROW
BEGIN
    DECLARE tier_count INT;

    SELECT COUNT(*) INTO tier_count
    FROM MembershipTier
    WHERE id_kreator = NEW.id_kreator;

    IF tier_count >= 5 THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Maksimal tier untuk satu kreator adalah 5.';
    END IF;
END;

-- Trigger untuk validasi jumlah tier maksimal saat UPDATE
CREATE TRIGGER check_max_tier_per_kreator_update
BEFORE UPDATE ON MembershipTier
FOR EACH ROW
BEGIN
    DECLARE tier_count INT;

    -- Jika id_kreator tidak berubah, jumlah tetap dihitung berdasarkan id_kreator yang sama
    -- Jika id_kreator berubah, validasi pada NEW.id_kreator
    IF NEW.id_kreator <> OLD.id_kreator THEN
        SELECT COUNT(*) INTO tier_count
        FROM MembershipTier
        WHERE id_kreator = NEW.id_kreator;
    ELSE
        SELECT COUNT(*) INTO tier_count
        FROM MembershipTier
        WHERE id_kreator = NEW.id_kreator AND nama_membership <> OLD.nama_membership;
    END IF;

    IF tier_count >= 5 THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Maksimal tier untuk satu kreator adalah 5.';
    END IF;
END;

-- Database Constraints
-- prettier-ignore-start
-- sql-formatter-disable

-- 1. waktu komentar harus > tanggal publikasi konten
CREATE TRIGGER check_komentar_waktu_valid
BEFORE INSERT ON Komentar
FOR EACH ROW
BEGIN
    DECLARE tanggal_publikasi DATETIME;

    SELECT tanggal_publikasi INTO tanggal_publikasi
    FROM Konten
    WHERE id_konten = NEW.id_konten;

    IF NEW.waktu <= tanggal_publikasi THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Komentar hanya dapat ditulis setelah konten dipublikasikan.';
    END IF;
END;

CREATE TRIGGER check_komentar_update_valid
BEFORE UPDATE ON Komentar
FOR EACH ROW
BEGIN
    DECLARE tanggal DATETIME;

    SELECT tanggal_publikasi INTO tanggal
    FROM Konten
    WHERE id_konten = NEW.id_konten;

    IF NEW.waktu <= tanggal THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Komentar hanya dapat ditulis setelah konten dipublikasikan.';
    END IF;
END;

CREATE TRIGGER check_konten_update_komentar_valid
BEFORE UPDATE ON Konten
FOR EACH ROW
BEGIN
    DECLARE conflict_count INT;

    SELECT COUNT(*) INTO conflict_count
    FROM Komentar
    WHERE id_konten = OLD.id_konten
        AND waktu <= NEW.tanggal_publikasi;

    IF conflict_count > 0 THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Tanggal publikasi tidak boleh lebih besar dari waktu komentar yang sudah ada.';
    END IF;
END;

-- 2. tanggal pembeliannya merhcandise hasil konten harus > release date konten
CREATE TRIGGER check_pembelian_setelah_publikasi
BEFORE INSERT ON Pembelian
FOR EACH ROW
BEGIN
    DECLARE publikasi DATETIME;

    SELECT k.tanggal_publikasi INTO publikasi
    FROM Merchandise m
    JOIN Konten k ON m.id_konten = k.id_konten
    WHERE m.id_merchandise = NEW.id_merchandise;

    IF NEW.tanggal_pembelian <= publikasi THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Pembelian merchandise tidak boleh dilakukan sebelum kontennya dirilis.';
    END IF;
END;

CREATE TRIGGER check_pembelian_update
BEFORE UPDATE ON Pembelian
FOR EACH ROW
BEGIN
    DECLARE tanggal DATETIME;

    SELECT k.tanggal_publikasi INTO tanggal
    FROM Merchandise m
    JOIN Konten k ON m.id_konten = k.id_konten
    WHERE m.id_merchandise = NEW.id_merchandise;

    IF NEW.tanggal_pembelian <= tanggal THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Pembelian tidak boleh dilakukan sebelum kontennya dirilis.';
    END IF;
END;

CREATE TRIGGER check_konten_update_pembelian_valid
BEFORE UPDATE ON Konten
FOR EACH ROW
BEGIN
    DECLARE conflict_count INT;

    SELECT COUNT(*) INTO conflict_count
    FROM Pembelian p
    JOIN Merchandise m ON p.id_merchandise = m.id_merchandise
    WHERE m.id_konten = OLD.id_konten
        AND p.tanggal_pembelian <= NEW.tanggal_publikasi;

    IF conflict_count > 0 THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Tanggal publikasi konten tidak boleh setelah ada pembelian merchandise.';
    END IF;
END;

-- sql-formatter-enable
-- prettier-ignore-end

-- Transition Constraints
-- prettier-ignore-start
-- sql-formatter-disable
-- 1. Transisi status pesanan khusus (OrderSpecialContent) harus mengikuti alur yang sah
CREATE TRIGGER `valid_status_transition` BEFORE
UPDATE ON `OrderSpecialContent` FOR EACH ROW 
BEGIN 
    IF (
        -- 'Menunggu_persetujuan' hanya boleh ke 'Disetujui' atau 'Ditolak'
        OLD.`status` = 'Menunggu_persetujuan' AND NEW.`status` NOT IN ('Disetujui', 'Ditolak')
    )
    OR (
        -- 'Disetujui' hanya boleh ke 'Dalam_pengerjaan'
        OLD.`status` = 'Disetujui' AND NEW.`status` <> 'Dalam_pengerjaan'
    )
    OR (
        -- 'Dalam_pengerjaan' hanya boleh ke 'Selesai'
        OLD.`status` = 'Dalam_pengerjaan' AND NEW.`status` <> 'Selesai'
    )
    OR (
        -- 'Selesai' tidak boleh berubah
        OLD.`status` = 'Selesai' AND NEW.`status` <> 'Selesai'
    )
    OR (
        -- 'Ditolak' tidak boleh berubah
        OLD.`status` = 'Ditolak' AND NEW.`status` <> 'Ditolak'
    ) THEN 
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Transisi status tidak valid. Ikuti alur status yang benar: Menunggu_persetujuan → Disetujui/Ditolak → Dalam_pengerjaan → Selesai';
    END IF;
END;

CREATE TRIGGER check_status_langganan_transition
BEFORE UPDATE ON Langganan
FOR EACH ROW
BEGIN
    IF (
        -- Tidak boleh dari Aktif ke Pending
        OLD.status = 'Aktif' AND NEW.status = 'Pending'
    )
    OR (
        -- Tidak boleh dari Expired langsung ke Aktif
        OLD.status = 'Expired' AND NEW.status = 'Aktif'
    ) THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Transisi status tidak valid. Gunakan urutan: Pending → Aktif → Expired → Pending (tidak langsung ke Aktif).';
    END IF;
END;

-- sql-formatter-enable
-- prettier-ignore-end

-- Fitur Tambahan 1
-- prettier-ignore-start
-- sql-formatter-disable
CREATE TRIGGER hitung_total_harga_insert 
BEFORE INSERT ON pembelian 
FOR EACH ROW 
BEGIN 
    DECLARE v_harga DECIMAL(65, 30) DEFAULT 0.0;
    
    SELECT harga INTO v_harga
    FROM merchandise
    WHERE id_merchandise = NEW.id_merchandise;
    
    SET NEW.total_harga = v_harga * NEW.jumlah;
END;

CREATE TRIGGER hitung_total_harga_update 
BEFORE UPDATE ON pembelian 
FOR EACH ROW 
BEGIN 
    DECLARE v_harga DECIMAL(65, 30);
    
    SELECT harga INTO v_harga
    FROM merchandise
    WHERE id_merchandise = NEW.id_merchandise;
    
    SET NEW.total_harga = v_harga * NEW.jumlah;
END;

-- sql-formatter-enable
-- prettier-ignore-end

-- Fitur Tambahan 2
-- Data Kreator Populer
/*
Membuat view untuk menampilkan 10 kreator terpopuler berdasarkan jumlah pendukung aktif dan komentar. 
View ini menyertakan nama kreator, bidang kreasi, jumlah pendukung aktif jumlah komentar, serta skor popularitas.
*/

-- prettier-ignore-start
-- sql-formatter-disable
CREATE VIEW KreatorPopuler AS
SELECT
    k.nama AS nama_kreator,
    k.bidang_kreasi,
    COALESCE(pa.jumlah_pendukung_aktif, 0) AS jumlah_pendukung_aktif,
    COALESCE(kom.jumlah_komentar, 0) AS jumlah_komentar,
    COALESCE(pa.jumlah_pendukung_aktif, 0) * 3 + COALESCE(kom.jumlah_komentar, 0) AS skor_popularitas
FROM Kreator k
LEFT JOIN (
    SELECT
        l.id_kreator,
        COUNT(DISTINCT l.id_pendukung) AS jumlah_pendukung_aktif
    FROM Langganan l
    WHERE l.status = 'Aktif'
    GROUP BY l.id_kreator
) pa ON k.id_kreator = pa.id_kreator
LEFT JOIN (
    SELECT
        ko.id_kreator,
        COUNT(km.id_komentar) AS jumlah_komentar
    FROM Komentar km
    JOIN Konten ko ON km.id_konten = ko.id_konten
    GROUP BY ko.id_kreator
) kom ON k.id_kreator = kom.id_kreator
ORDER BY skor_popularitas DESC
LIMIT 10;

-- sql-formatter-enable
-- prettier-ignore-end

-- Fitur Tambahan 3
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

-- Fitur Tambahan 4

-- Trigger: BEFORE INSERT on Kreator
CREATE TRIGGER `email_kreator_insert`
BEFORE INSERT ON `Kreator`
FOR EACH ROW
BEGIN
   IF NEW.email NOT LIKE '_%@%.com' OR NEW.email LIKE '%@%@%.com' THEN
       SIGNAL SQLSTATE '45000'
       SET MESSAGE_TEXT = 'Format email untuk Kreator tidak valid. Pastikan formatnya <...>@<...>.com';
   END IF;
END;

-- Trigger: BEFORE UPDATE on Kreator
CREATE TRIGGER `email_kreator_update`
BEFORE UPDATE ON `Kreator`
FOR EACH ROW
BEGIN
   IF NEW.email NOT LIKE '_%@%.com' OR NEW.email LIKE '%@%@%.com' THEN
       SIGNAL SQLSTATE '45000'
       SET MESSAGE_TEXT = 'Format email untuk Kreator tidak valid. Pastikan formatnya <...>@<...>.com';
   END IF;
END;

-- Trigger: BEFORE INSERT on Supporter
CREATE TRIGGER `email_supporter_insert`
BEFORE INSERT ON `Supporter`
FOR EACH ROW
BEGIN
   IF NEW.email NOT LIKE '_%@%.com' OR NEW.email LIKE '%@%@%.com' THEN
       SIGNAL SQLSTATE '45000'
       SET MESSAGE_TEXT = 'Format email untuk Supporter tidak valid. Pastikan formatnya <...>@<...>.com';
   END IF;
END;

-- Trigger: BEFORE UPDATE on Supporter
CREATE TRIGGER `email_supporter_update`
BEFORE UPDATE ON `Supporter`
FOR EACH ROW
BEGIN
   IF NEW.email NOT LIKE '_%@%.com' OR NEW.email LIKE '%@%@%.com' THEN
       SIGNAL SQLSTATE '45000'
       SET MESSAGE_TEXT = 'Format email untuk Supporter tidak valid. Pastikan formatnya <...>@<...>.com';
   END IF;
END;