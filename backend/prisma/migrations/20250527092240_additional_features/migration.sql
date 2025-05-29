
-- 3. AKTIVITAS PENDUKUNG

-- Trigger saat ada langganan baru
CREATE TRIGGER after_langganan_insert
AFTER INSERT ON Langganan
FOR EACH ROW
BEGIN
    INSERT INTO AktivitasPendukung (id_pendukung, jenis_aktivitas, id_referensi, deskripsi, tanggal_aktivitas)
    VALUES (
        NEW.id_pendukung,
        'Langganan',
        NEW.id_kreator,                         -- Menggunakan id_kreator sebagai referensi
        CONCAT('Berlangganan dengan tier "', NEW.nama_membership, '" ke kreator dengan ID: ', NEW.id_kreator),
        NEW.tanggal_pembayaran_terakhir
    );
END;

-- Trigger saat ada komentar baru
CREATE TRIGGER after_komentar_insert
AFTER INSERT ON Komentar
FOR EACH ROW
BEGIN
    INSERT INTO AktivitasPendukung (id_pendukung, jenis_aktivitas, id_referensi, deskripsi, tanggal_aktivitas)
    VALUES (
        NEW.id_pendukung,
        'Komentar',
        NEW.id_konten,                          -- Menggunakan id_konten sebagai referensi
        CONCAT('Memberi komentar pada konten dengan ID: ', NEW.id_konten),
        NEW.waktu
    );
END;

-- Trigger saat ada pembelian baru
CREATE TRIGGER after_pembelian_insert
AFTER INSERT ON Pembelian
FOR EACH ROW
BEGIN
    INSERT INTO AktivitasPendukung (id_pendukung, jenis_aktivitas, id_referensi, deskripsi, tanggal_aktivitas)
    VALUES (
        NEW.id_pendukung,
        'Beli_Merchandise',
        NEW.id_merchandise,                     -- Menggunakan id_merchandise sebagai referensi
        CONCAT('Membeli merchandise dengan ID: ', NEW.id_merchandise, ' sejumlah ', NEW.jumlah),
        NEW.tanggal_pembelian
    );
END;


-- 4. VALIDASI FORMAT EMAIL UNTUK KREATOR DAN SUPPORTER

-- Insert trigger untuk Kreator
DROP TRIGGER IF EXISTS `email_kreator_insert`;
CREATE TRIGGER `email_kreator_insert`
BEFORE INSERT ON Kreator
FOR EACH ROW
BEGIN
    IF New.Email NOT LIKE '_%@%.com' OR NEW.Email LIKE '%@%@%.com' THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Format email untuk Kreator tidak valid. Pastikan formatnya <...>@<...>.com';
    END IF;
END;

-- Update trigger untuk Kreator
DROP TRIGGER IF EXISTS `email_kreator_update`;
CREATE TRIGGER `email_kreator_update`
BEFORE UPDATE ON Kreator
FOR EACH ROW
BEGIN
    IF New.Email NOT LIKE '_%@%.com' OR NEW.Email LIKE '%@%@%.com' THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Format email untuk Kreator tidak valid. Pastikan formatnya <...>@<...>.com';
    END IF;
END;

-- Insert trigger untuk Supporter
DROP TRIGGER IF EXISTS `email_supporter_insert`;
CREATE TRIGGER `email_supporter_insert`
BEFORE INSERT ON Supporter
FOR EACH ROW
BEGIN
    IF New.Email NOT LIKE '_%@%.com' OR NEW.Email LIKE '%@%@%.com' THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Format email untuk Supporter tidak valid. Pastikan formatnya <...>@<...>.com';
    END IF;
END;

-- Update trigger untuk Supporter
DROP TRIGGER IF EXISTS `email_supporter_update`;
CREATE TRIGGER `email_supporter_update`
BEFORE UPDATE ON Supporter
FOR EACH ROW
BEGIN
    IF New.Email NOT LIKE '_%@%.com' OR New.Email LIKE '%@%@%.com' THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Format email untuk Supporter tidak valid. Pastikan formatnya <...>@<...>.com';
    END IF;
END;