
-- TYPE CONSTRAINTS
ALTER TABLE `MembershipTier`
  ADD CONSTRAINT `harga_bulanan_valid` CHECK (`harga_bulanan` > 0);

ALTER TABLE `Langganan`
  ADD CONSTRAINT `jumlah_valid` CHECK (`jumlah` > 0);

ALTER TABLE `Pembelian`
  ADD CONSTRAINT `pembelian_jumlah_valid` CHECK (`jumlah` > 0),
  ADD CONSTRAINT `pembelian_total_harga_valid` CHECK (`total_harga` > 0);

ALTER TABLE `Merchandise`
  ADD CONSTRAINT `harga_merch_valid` CHECK (`harga` > 0),
  ADD CONSTRAINT `stok_merch_valid` CHECK (`stok` >= 0);

ALTER TABLE `Komentar`
  ADD CONSTRAINT `isi_komentar_tidak_kosong` CHECK (CHAR_LENGTH(`isi`) > 0);

ALTER TABLE `KontenTeks`
  ADD CONSTRAINT `jumlah_kata_valid` CHECK (`jumlah_kata` >= 0);

ALTER TABLE `KontenVideo`
  ADD CONSTRAINT `durasi_video_valid` CHECK (`durasi` > 0);

ALTER TABLE `KontenAudio`
  ADD CONSTRAINT `durasi_audio_valid` CHECK (`durasi` > 0);

-- ATTRIBUTE CONSTRAINTS
ALTER TABLE `Supporter`
  ADD CONSTRAINT `supporter_email_unique` UNIQUE (`email`);

ALTER TABLE `Kreator`
  ADD CONSTRAINT `kreator_email_unique` UNIQUE (`email`);

ALTER TABLE `Langganan`
  MODIFY `status` ENUM('Aktif', 'Pending', 'Expired') NOT NULL;

ALTER TABLE `OrderSpecialContent`
  MODIFY `status` ENUM('Selesai', 'Diproses', 'Menunggu') NOT NULL;

-- RELATION CONSTRAINTS
ALTER TABLE `OrderSpecialContent`
  ADD CONSTRAINT `judul_order_unik_per_pendukung` UNIQUE (`id_pendukung`, `judul`);

-- DATABASE CONSTRAINTS (TRIGGERS)
DROP TRIGGER IF EXISTS `check_order_selesai`;
CREATE TRIGGER `check_order_selesai`
BEFORE INSERT ON `OrderSpecialContent`
FOR EACH ROW
BEGIN
  IF NEW.`status` = 'Selesai' AND NEW.`tanggal_penyelesaian` IS NULL THEN
    SIGNAL SQLSTATE '45000'
    SET MESSAGE_TEXT = 'Order dengan status Selesai harus memiliki tanggal_penyelesaian';
  END IF;
END;

DROP TRIGGER IF EXISTS `check_order_selesai_update`;
CREATE TRIGGER `check_order_selesai_update`
BEFORE UPDATE ON `OrderSpecialContent`
FOR EACH ROW
BEGIN
  IF NEW.`status` = 'Selesai' AND NEW.`tanggal_penyelesaian` IS NULL THEN
    SIGNAL SQLSTATE '45000'
    SET MESSAGE_TEXT = 'Order dengan status Selesai harus memiliki tanggal_penyelesaian';
  END IF;
END;

DROP TRIGGER IF EXISTS `check_akses_konten_valid`;
CREATE TRIGGER `check_akses_konten_valid`
BEFORE INSERT ON `AksesKonten`
FOR EACH ROW
BEGIN
  DECLARE aktif_count INT;
  SELECT COUNT(*) INTO aktif_count
  FROM `Langganan`
  WHERE 
    `id_kreator` = NEW.`id_kreator` AND
    `nama_membership` = NEW.`nama_membership` AND
    `id_pendukung` = (
      SELECT `id_pendukung`
      FROM `Langganan`
      WHERE 
        `id_kreator` = NEW.`id_kreator` AND 
        `nama_membership` = NEW.`nama_membership`
      LIMIT 1
    ) AND
    `status` = 'Aktif';

  IF aktif_count = 0 THEN
    SIGNAL SQLSTATE '45000'
    SET MESSAGE_TEXT = 'Supporter tidak memiliki langganan aktif untuk mengakses konten ini';
  END IF;
END;

-- TRANSITION CONSTRAINTS
DROP TRIGGER IF EXISTS `valid_status_transition`;
CREATE TRIGGER `valid_status_transition`
BEFORE UPDATE ON `OrderSpecialContent`
FOR EACH ROW
BEGIN
  IF (OLD.`status` = 'Selesai' AND NEW.`status` IN ('Diproses', 'Menunggu')) OR
     (OLD.`status` = 'Diproses' AND NEW.`status` = 'Menunggu') THEN
    SIGNAL SQLSTATE '45000'
    SET MESSAGE_TEXT = 'Transisi status tidak valid. Urutan harus: Menunggu → Diproses → Selesai';
  END IF;
END;
