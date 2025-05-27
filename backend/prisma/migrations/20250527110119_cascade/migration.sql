-- DropForeignKey
ALTER TABLE `akseskonten` DROP FOREIGN KEY `AksesKonten_id_konten_fkey`;

-- DropForeignKey
ALTER TABLE `akseskonten` DROP FOREIGN KEY `AksesKonten_id_kreator_nama_membership_fkey`;

-- DropForeignKey
ALTER TABLE `komentar` DROP FOREIGN KEY `Komentar_id_konten_fkey`;

-- DropForeignKey
ALTER TABLE `langganan` DROP FOREIGN KEY `Langganan_id_kreator_nama_membership_fkey`;

-- DropForeignKey
ALTER TABLE `langganan` DROP FOREIGN KEY `Langganan_id_pendukung_fkey`;

-- DropForeignKey
ALTER TABLE `pembelian` DROP FOREIGN KEY `Pembelian_id_merchandise_fkey`;

-- DropForeignKey
ALTER TABLE `pembelian` DROP FOREIGN KEY `Pembelian_id_pendukung_fkey`;

-- DropIndex
DROP INDEX `AksesKonten_id_kreator_nama_membership_fkey` ON `akseskonten`;

-- DropIndex
DROP INDEX `Komentar_id_konten_fkey` ON `komentar`;

-- DropIndex
DROP INDEX `Langganan_id_pendukung_fkey` ON `langganan`;

-- DropIndex
DROP INDEX `Pembelian_id_pendukung_fkey` ON `pembelian`;

-- AddForeignKey
ALTER TABLE `Komentar` ADD CONSTRAINT `Komentar_id_konten_fkey` FOREIGN KEY (`id_konten`) REFERENCES `Konten`(`id_konten`) ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE `Langganan` ADD CONSTRAINT `Langganan_id_pendukung_fkey` FOREIGN KEY (`id_pendukung`) REFERENCES `Supporter`(`id_pendukung`) ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE `Langganan` ADD CONSTRAINT `Langganan_id_kreator_nama_membership_fkey` FOREIGN KEY (`id_kreator`, `nama_membership`) REFERENCES `MembershipTier`(`id_kreator`, `nama_membership`) ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE `OrderSpecialContent` ADD CONSTRAINT `OrderSpecialContent_id_pendukung_fkey` FOREIGN KEY (`id_pendukung`) REFERENCES `Supporter`(`id_pendukung`) ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE `Pembelian` ADD CONSTRAINT `Pembelian_id_merchandise_fkey` FOREIGN KEY (`id_merchandise`) REFERENCES `Merchandise`(`id_merchandise`) ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE `Pembelian` ADD CONSTRAINT `Pembelian_id_pendukung_fkey` FOREIGN KEY (`id_pendukung`) REFERENCES `Supporter`(`id_pendukung`) ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE `AksesKonten` ADD CONSTRAINT `AksesKonten_id_konten_fkey` FOREIGN KEY (`id_konten`) REFERENCES `Konten`(`id_konten`) ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE `AksesKonten` ADD CONSTRAINT `AksesKonten_id_kreator_nama_membership_fkey` FOREIGN KEY (`id_kreator`, `nama_membership`) REFERENCES `MembershipTier`(`id_kreator`, `nama_membership`) ON DELETE CASCADE ON UPDATE CASCADE;
