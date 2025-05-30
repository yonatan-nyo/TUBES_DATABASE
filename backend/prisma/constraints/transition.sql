-- prettier-ignore-start
-- sql-formatter-disable
-- 1. Transisi status pesanan khusus (OrderSpecialContent) harus mengikuti alur yang sah
CREATE TRIGGER `valid_status_transition` BEFORE
UPDATE ON `OrderSpecialContent` FOR EACH ROW 
BEGIN 
    IF (
        -- 'menunggu_persetujuan' hanya boleh ke 'disetujui' atau 'ditolak'
        OLD.`status` = 'menunggu_persetujuan' AND NEW.`status` NOT IN ('disetujui', 'ditolak')
    )
    OR (
        -- 'disetujui' hanya boleh ke 'dalam_pengerjaan'
        OLD.`status` = 'disetujui' AND NEW.`status` <> 'dalam_pengerjaan'
    )
    OR (
        -- 'dalam_pengerjaan' hanya boleh ke 'selesai'
        OLD.`status` = 'dalam_pengerjaan' AND NEW.`status` <> 'selesai'
    )
    OR (
        -- 'selesai' tidak boleh berubah
        OLD.`status` = 'selesai' AND NEW.`status` <> 'selesai'
    )
    OR (
        -- 'ditolak' tidak boleh berubah
        OLD.`status` = 'ditolak' AND NEW.`status` <> 'ditolak'
    ) THEN 
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Transisi status tidak valid. Ikuti alur status yang benar: menunggu_persetujuan → disetujui/ditolak → dalam_pengerjaan → selesai';
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