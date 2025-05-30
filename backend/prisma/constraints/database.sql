-- prettier-ignore-start
-- sql-formatter-disable

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