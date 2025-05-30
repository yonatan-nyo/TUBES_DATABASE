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