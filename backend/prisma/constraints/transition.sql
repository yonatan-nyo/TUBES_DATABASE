-- prettier-ignore-start
-- sql-formatter-disable
-- 1. Transisi status pesanan khusus (OrderSpecialContent) tidak boleh mundur
CREATE TRIGGER `valid_status_transition` BEFORE
UPDATE ON `OrderSpecialContent` FOR EACH ROW 
BEGIN 
    IF (
        OLD.`status` = 'Selesai'
        AND NEW.`status` IN ('Diproses', 'Menunggu')
    )
    OR (
        OLD.`status` = 'Diproses'
        AND NEW.`status` = 'Menunggu'
    ) THEN 
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Transisi status tidak valid. Urutan harus: Menunggu → Diproses → Selesai';
    END IF;
END;
-- sql-formatter-enable
-- prettier-ignore-end