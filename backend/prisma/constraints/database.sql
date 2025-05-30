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

-- sql-formatter-enable
-- prettier-ignore-end