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
-- sql-formatter-enable
-- prettier-ignore-end