-- 1. Atribut status harus bernilai terbatas (terdefinisi)
ALTER TABLE `Langganan` MODIFY `status` ENUM ('Aktif', 'Pending', 'Expired') NOT NULL;

ALTER TABLE `OrderSpecialContent` MODIFY `status` ENUM ('Selesai', 'Diproses', 'Menunggu') NOT NULL;