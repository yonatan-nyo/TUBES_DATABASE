-- CreateTable
CREATE TABLE `AktivitasPendukung` (
    `id_aktivitas` INTEGER NOT NULL AUTO_INCREMENT,
    `id_pendukung` INTEGER NOT NULL,
    `jenis_aktivitas` ENUM('Langganan', 'Komentar', 'Beli_Merchandise') NOT NULL,
    `id_referensi` INTEGER NOT NULL,
    `deskripsi` TEXT NOT NULL,
    `tanggal_aktivitas` DATETIME(3) NOT NULL DEFAULT CURRENT_TIMESTAMP(3),

    INDEX `AktivitasPendukung_id_pendukung_idx`(`id_pendukung`),
    PRIMARY KEY (`id_aktivitas`)
) DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

-- AddForeignKey
ALTER TABLE `AktivitasPendukung` ADD CONSTRAINT `AktivitasPendukung_id_pendukung_fkey` FOREIGN KEY (`id_pendukung`) REFERENCES `Supporter`(`id_pendukung`) ON DELETE RESTRICT ON UPDATE CASCADE;
