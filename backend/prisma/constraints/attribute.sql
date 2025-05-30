/* 
!!! 
enums provided at schema.prisma thus doesnt need to copy this to migration file 
[AUTOMATICALLY GENERATED]
!!!
*/
--  on create
CREATE TABLE `Konten` (
    -- other attributes
    `jenis` ENUM('Teks', 'Gambar', 'Audio', 'Video') NOT NULL,
    -- other attributes & constraints
);
-- alter version assuming jenis exists in Konten table
ALTER TABLE `Konten`
MODIFY COLUMN `jenis` ENUM('Teks', 'Gambar', 'Audio', 'Video') NOT NULL;

--  on create
CREATE TABLE `Langganan` (
    -- other attributes
    `status` ENUM('Aktif', 'Pending', 'Expired') NOT NULL,
    -- other attributes & constraints
);
-- alter version assuming status exists in Langganan table
ALTER TABLE `Langganan`
MODIFY COLUMN `status` ENUM('Aktif', 'Pending', 'Expired') NOT NULL;

--  on create
CREATE TABLE `OrderSpecialContent` (
    -- other attributes
    `status` ENUM('Menunggu_persetujuan', 'Disetujui', 'Ditolak', 'Dalam_pengerjaan', 'Selesai') NOT NULL,
    -- other attributes & constraints
);
-- alter version assuming status exists in OrderSpecialContent table
ALTER TABLE `OrderSpecialContent`
MODIFY COLUMN `status` ENUM('Menunggu_persetujuan', 'Disetujui', 'Ditolak', 'Dalam_pengerjaan', 'Selesai') NOT NULL;

--  on create
CREATE TABLE `AktivitasPendukung` (
    -- other attributes
    `jenis_aktivitas` ENUM('Langganan', 'Komentar', 'Beli_Merchandise') NOT NULL,
    -- other attributes & constraints
);
-- alter version assuming jenis_aktivitas exists in AktivitasPendukung table
ALTER TABLE `AktivitasPendukung`
MODIFY COLUMN `jenis_aktivitas` ENUM('Langganan', 'Komentar', 'Beli_Merchandise') NOT NULL;

/* 
!!! 
enums provided at schema.prisma thus doesnt need to copy this to migration file 
[AUTOMATICALLY GENERATED]
!!!
*/
