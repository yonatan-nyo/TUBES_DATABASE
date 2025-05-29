-- 1. Order dengan status 'Selesai' harus memiliki tanggal penyelesaian
CREATE TRIGGER `check_order_selesai` BEFORE INSERT ON `OrderSpecialContent` FOR EACH ROW BEGIN IF NEW.`status` = 'Selesai'
AND NEW.`tanggal_penyelesaian` IS NULL THEN SIGNAL SQLSTATE '45000'
SET
  MESSAGE_TEXT = 'Order dengan status Selesai harus memiliki tanggal_penyelesaian';

END IF;

END;

CREATE TRIGGER `check_order_selesai_update` BEFORE
UPDATE ON `OrderSpecialContent` FOR EACH ROW BEGIN IF NEW.`status` = 'Selesai'
AND NEW.`tanggal_penyelesaian` IS NULL THEN SIGNAL SQLSTATE '45000'
SET
  MESSAGE_TEXT = 'Order dengan status Selesai harus memiliki tanggal_penyelesaian';

END IF;

END;

-- Supporter hanya boleh mengakses konten jika memiliki langganan aktif ke tier tersebut
CREATE TRIGGER `check_akses_konten_valid` BEFORE INSERT ON `AksesKonten` FOR EACH ROW BEGIN DECLARE aktif_count INT;

SELECT
  COUNT(*) INTO aktif_count
FROM
  `Langganan`
WHERE
  `id_kreator` = NEW.`id_kreator`
  AND `nama_membership` = NEW.`nama_membership`
  AND `id_pendukung` = (
    SELECT
      `id_pendukung`
    FROM
      `Langganan`
    WHERE
      `id_kreator` = NEW.`id_kreator`
      AND `nama_membership` = NEW.`nama_membership`
    LIMIT
      1
  )
  AND `status` = 'Aktif';

IF aktif_count = 0 THEN SIGNAL SQLSTATE '45000'
SET
  MESSAGE_TEXT = 'Supporter tidak memiliki langganan aktif untuk mengakses konten ini';

END IF;

END;

