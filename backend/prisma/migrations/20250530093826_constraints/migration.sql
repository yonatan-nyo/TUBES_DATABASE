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

-- Database Constraints
-- prettier-ignore-start
-- sql-formatter-disable

-- 1. Order dengan status 'Selesai' harus memiliki tanggal penyelesaian
CREATE TRIGGER `check_order_selesai` 
BEFORE INSERT ON `OrderSpecialContent` 
FOR EACH ROW 
BEGIN 
    IF NEW.`status` = 'Selesai' AND NEW.`tanggal_penyelesaian` IS NULL THEN 
        SIGNAL SQLSTATE '45000' 
        SET MESSAGE_TEXT = 'Order dengan status Selesai harus memiliki tanggal_penyelesaian';
    END IF;
END;

CREATE TRIGGER `check_order_selesai_update` 
BEFORE UPDATE ON `OrderSpecialContent` 
FOR EACH ROW 
BEGIN 
    IF NEW.`status` = 'Selesai' AND NEW.`tanggal_penyelesaian` IS NULL THEN 
        SIGNAL SQLSTATE '45000' 
        SET MESSAGE_TEXT = 'Order dengan status Selesai harus memiliki tanggal_penyelesaian';
    END IF;
END;

-- Check if membership tier exists and has at least one active subscription
CREATE TRIGGER `check_akses_konten_valid` 
BEFORE INSERT ON `AksesKonten` 
FOR EACH ROW 
BEGIN 
    DECLARE aktif_count INT;
    
    SELECT COUNT(*) INTO aktif_count 
    FROM `Langganan` 
    WHERE `id_kreator` = NEW.`id_kreator` 
      AND `nama_membership` = NEW.`nama_membership` 
      AND `status` = 'Aktif';
    
    IF aktif_count = 0 THEN 
        SIGNAL SQLSTATE '45000' 
        SET MESSAGE_TEXT = 'Tidak ada langganan aktif untuk membership tier ini';
    END IF;
END;

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

-- sql-formatter-enable
-- prettier-ignore-end

-- Fitur Tambahan
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