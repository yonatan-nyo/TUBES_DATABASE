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
        -- Expired tidak boleh berubah
        OLD.status = 'Expired' AND NEW.status <> 'Expired'
    )
    OR (
        -- Tidak boleh dari Aktif kembali ke Pending
        OLD.status = 'Aktif' AND NEW.status = 'Pending'
    )
    OR (
        -- Tidak boleh dari Pending langsung ke Aktif jika tidak sah
        OLD.status = 'Pending' AND NEW.status NOT IN ('Aktif', 'Expired')
    ) THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Transisi status langganan tidak valid: ikuti urutan Pending → Aktif → Expired';
    END IF;
END;

-- sql-formatter-enable
-- prettier-ignore-end