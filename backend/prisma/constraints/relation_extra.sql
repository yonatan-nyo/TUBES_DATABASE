ALTER TABLE `OrderSpecialContent`
ADD CONSTRAINT `chk_status_selesai_tanggal`
CHECK (
  NOT (`status` = 'Selesai' AND `tanggal_penyelesaian` IS NULL)
);
