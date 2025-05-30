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