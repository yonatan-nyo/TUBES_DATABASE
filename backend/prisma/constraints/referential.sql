/* 
!!! 
referential constraints provided at schema.prisma thus doesnt need to copy this to migration file 
[AUTOMATICALLY GENERATED]
!!!
 */
-- AddForeignKey
ALTER TABLE `Konten` ADD CONSTRAINT `Konten_id_kreator_fkey` FOREIGN KEY (`id_kreator`) REFERENCES `Kreator` (`id_kreator`) ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE `MembershipTier` ADD CONSTRAINT `MembershipTier_id_kreator_fkey` FOREIGN KEY (`id_kreator`) REFERENCES `Kreator` (`id_kreator`) ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE `Komentar` ADD CONSTRAINT `Komentar_id_konten_fkey` FOREIGN KEY (`id_konten`) REFERENCES `Konten` (`id_konten`) ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE `Komentar` ADD CONSTRAINT `Komentar_id_pendukung_fkey` FOREIGN KEY (`id_pendukung`) REFERENCES `Supporter` (`id_pendukung`) ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE `Langganan` ADD CONSTRAINT `Langganan_id_pendukung_fkey` FOREIGN KEY (`id_pendukung`) REFERENCES `Supporter` (`id_pendukung`) ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE `Langganan` ADD CONSTRAINT `Langganan_id_kreator_nama_membership_fkey` FOREIGN KEY (`id_kreator`, `nama_membership`) REFERENCES `MembershipTier` (`id_kreator`, `nama_membership`) ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE `OrderSpecialContent` ADD CONSTRAINT `OrderSpecialContent_id_kreator_fkey` FOREIGN KEY (`id_kreator`) REFERENCES `Kreator` (`id_kreator`) ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE `OrderSpecialContent` ADD CONSTRAINT `OrderSpecialContent_id_pendukung_fkey` FOREIGN KEY (`id_pendukung`) REFERENCES `Supporter` (`id_pendukung`) ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE `KontenGambar` ADD CONSTRAINT `KontenGambar_id_konten_fkey` FOREIGN KEY (`id_konten`) REFERENCES `Konten` (`id_konten`) ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE `KontenGambar` ADD CONSTRAINT `KontenGambar_id_order_fkey` FOREIGN KEY (`id_order`) REFERENCES `OrderSpecialContent` (`id_order`) ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE `KontenTeks` ADD CONSTRAINT `KontenTeks_id_konten_fkey` FOREIGN KEY (`id_konten`) REFERENCES `Konten` (`id_konten`) ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE `KontenVideo` ADD CONSTRAINT `KontenVideo_id_konten_fkey` FOREIGN KEY (`id_konten`) REFERENCES `Konten` (`id_konten`) ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE `KontenAudio` ADD CONSTRAINT `KontenAudio_id_konten_fkey` FOREIGN KEY (`id_konten`) REFERENCES `Konten` (`id_konten`) ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE `Merchandise` ADD CONSTRAINT `Merchandise_id_konten_fkey` FOREIGN KEY (`id_konten`) REFERENCES `Konten` (`id_konten`) ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE `Pembelian` ADD CONSTRAINT `Pembelian_id_merchandise_fkey` FOREIGN KEY (`id_merchandise`) REFERENCES `Merchandise` (`id_merchandise`) ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE `Pembelian` ADD CONSTRAINT `Pembelian_id_pendukung_fkey` FOREIGN KEY (`id_pendukung`) REFERENCES `Supporter` (`id_pendukung`) ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE `AksesKonten` ADD CONSTRAINT `AksesKonten_id_konten_fkey` FOREIGN KEY (`id_konten`) REFERENCES `Konten` (`id_konten`) ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE `AksesKonten` ADD CONSTRAINT `AksesKonten_id_kreator_nama_membership_fkey` FOREIGN KEY (`id_kreator`, `nama_membership`) REFERENCES `MembershipTier` (`id_kreator`, `nama_membership`) ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE `AktivitasPendukung` ADD CONSTRAINT `AktivitasPendukung_id_pendukung_fkey` FOREIGN KEY (`id_pendukung`) REFERENCES `Supporter` (`id_pendukung`) ON DELETE RESTRICT ON UPDATE CASCADE;

/* 
!!! 
referential constraints provided at schema.prisma thus doesnt need to copy this to migration file 
[AUTOMATICALLY GENERATED]
!!!
 */