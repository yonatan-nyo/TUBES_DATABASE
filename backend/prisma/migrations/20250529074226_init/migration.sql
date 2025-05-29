-- CreateTable
CREATE TABLE `Kreator` (
    `id_kreator` INTEGER NOT NULL AUTO_INCREMENT,
    `nama` VARCHAR(191) NOT NULL,
    `email` VARCHAR(191) NOT NULL,
    `deskripsi` TEXT NULL,
    `bidang_kreasi` VARCHAR(191) NOT NULL,
    `tanggal_bergabung` DATETIME(3) NOT NULL,

    UNIQUE INDEX `Kreator_email_key`(`email`),
    PRIMARY KEY (`id_kreator`)
) DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

-- CreateTable
CREATE TABLE `Supporter` (
    `id_pendukung` INTEGER NOT NULL AUTO_INCREMENT,
    `nama` VARCHAR(191) NOT NULL,
    `email` VARCHAR(191) NOT NULL,
    `alamat` TEXT NULL,
    `tanggal_bergabung` DATETIME(3) NOT NULL,

    UNIQUE INDEX `Supporter_email_key`(`email`),
    PRIMARY KEY (`id_pendukung`)
) DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

-- CreateTable
CREATE TABLE `Konten` (
    `id_konten` INTEGER NOT NULL AUTO_INCREMENT,
    `id_kreator` INTEGER NOT NULL,
    `jenis` VARCHAR(191) NOT NULL,
    `judul` VARCHAR(191) NOT NULL,
    `deskripsi` TEXT NULL,
    `tanggal_publikasi` DATETIME(3) NOT NULL,

    PRIMARY KEY (`id_konten`)
) DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

-- CreateTable
CREATE TABLE `MembershipTier` (
    `id_kreator` INTEGER NOT NULL,
    `nama_membership` VARCHAR(191) NOT NULL,
    `deskripsi` TEXT NULL,
    `harga_bulanan` DECIMAL(65, 30) NOT NULL,
    `daftar_manfaat` TEXT NULL,

    PRIMARY KEY (`id_kreator`, `nama_membership`)
) DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

-- CreateTable
CREATE TABLE `Komentar` (
    `id_komentar` INTEGER NOT NULL AUTO_INCREMENT,
    `id_konten` INTEGER NOT NULL,
    `id_pendukung` INTEGER NOT NULL,
    `isi` TEXT NOT NULL,
    `waktu` DATETIME(3) NOT NULL,

    PRIMARY KEY (`id_komentar`)
) DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

-- CreateTable
CREATE TABLE `Langganan` (
    `id_kreator` INTEGER NOT NULL,
    `nama_membership` VARCHAR(191) NOT NULL,
    `id_pendukung` INTEGER NOT NULL,
    `tanggal_pembayaran_terakhir` DATETIME(3) NOT NULL,
    `jumlah` DECIMAL(65, 30) NOT NULL,
    `mode_pembayaran` VARCHAR(191) NOT NULL,
    `status` ENUM('Aktif', 'Pending', 'Expired') NOT NULL,

    PRIMARY KEY (`id_kreator`, `nama_membership`, `id_pendukung`)
) DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

-- CreateTable
CREATE TABLE `OrderSpecialContent` (
    `id_order` INTEGER NOT NULL AUTO_INCREMENT,
    `id_kreator` INTEGER NOT NULL,
    `id_pendukung` INTEGER NOT NULL,
    `judul` VARCHAR(191) NOT NULL,
    `deskripsi` TEXT NULL,
    `harga_dasar` DECIMAL(65, 30) NOT NULL,
    `detail_kustom` TEXT NULL,
    `tanggal_batas_revisi` DATETIME(3) NOT NULL,
    `estimasi_pengerjaan` INTEGER NOT NULL,
    `status` ENUM('Selesai', 'Diproses', 'Menunggu') NOT NULL,
    `tanggal_penyelesaian` DATETIME(3) NULL,
    `feedback` TEXT NULL,

    UNIQUE INDEX `OrderSpecialContent_id_pendukung_judul_key`(`id_pendukung`, `judul`),
    PRIMARY KEY (`id_order`)
) DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

-- CreateTable
CREATE TABLE `KontenGambar` (
    `id_konten` INTEGER NOT NULL,
    `id_order` INTEGER NULL,
    `imageSource` VARCHAR(191) NOT NULL,
    `resolusi` VARCHAR(191) NOT NULL,
    `format` VARCHAR(191) NOT NULL,

    UNIQUE INDEX `KontenGambar_id_order_key`(`id_order`),
    PRIMARY KEY (`id_konten`)
) DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

-- CreateTable
CREATE TABLE `KontenTeks` (
    `id_konten` INTEGER NOT NULL,
    `textSource` TEXT NOT NULL,
    `jumlah_kata` INTEGER NOT NULL,
    `format` VARCHAR(191) NOT NULL,

    PRIMARY KEY (`id_konten`)
) DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

-- CreateTable
CREATE TABLE `KontenVideo` (
    `id_konten` INTEGER NOT NULL,
    `videoSource` VARCHAR(191) NOT NULL,
    `durasi` INTEGER NOT NULL,
    `resolusi` VARCHAR(191) NOT NULL,

    PRIMARY KEY (`id_konten`)
) DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

-- CreateTable
CREATE TABLE `KontenAudio` (
    `id_konten` INTEGER NOT NULL,
    `audioSource` VARCHAR(191) NOT NULL,
    `durasi` INTEGER NOT NULL,
    `kualitas` VARCHAR(191) NOT NULL,

    PRIMARY KEY (`id_konten`)
) DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

-- CreateTable
CREATE TABLE `Merchandise` (
    `id_merchandise` INTEGER NOT NULL AUTO_INCREMENT,
    `nama` VARCHAR(191) NOT NULL,
    `id_konten` INTEGER NOT NULL,
    `harga` DECIMAL(65, 30) NOT NULL,
    `stok` INTEGER NOT NULL,
    `deskripsi` TEXT NULL,

    PRIMARY KEY (`id_merchandise`)
) DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

-- CreateTable
CREATE TABLE `Pembelian` (
    `id_merchandise` INTEGER NOT NULL,
    `id_pendukung` INTEGER NOT NULL,
    `jumlah` INTEGER NOT NULL,
    `tanggal_pembelian` DATETIME(3) NOT NULL,
    `metode_pembayaran` VARCHAR(191) NOT NULL,
    `total_harga` DECIMAL(65, 30) NOT NULL,

    PRIMARY KEY (`id_merchandise`, `id_pendukung`)
) DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

-- CreateTable
CREATE TABLE `AksesKonten` (
    `id_konten` INTEGER NOT NULL,
    `id_kreator` INTEGER NOT NULL,
    `nama_membership` VARCHAR(191) NOT NULL,

    PRIMARY KEY (`id_konten`, `id_kreator`, `nama_membership`)
) DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

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
ALTER TABLE `Konten` ADD CONSTRAINT `Konten_id_kreator_fkey` FOREIGN KEY (`id_kreator`) REFERENCES `Kreator`(`id_kreator`) ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE `MembershipTier` ADD CONSTRAINT `MembershipTier_id_kreator_fkey` FOREIGN KEY (`id_kreator`) REFERENCES `Kreator`(`id_kreator`) ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE `Komentar` ADD CONSTRAINT `Komentar_id_konten_fkey` FOREIGN KEY (`id_konten`) REFERENCES `Konten`(`id_konten`) ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE `Komentar` ADD CONSTRAINT `Komentar_id_pendukung_fkey` FOREIGN KEY (`id_pendukung`) REFERENCES `Supporter`(`id_pendukung`) ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE `Langganan` ADD CONSTRAINT `Langganan_id_pendukung_fkey` FOREIGN KEY (`id_pendukung`) REFERENCES `Supporter`(`id_pendukung`) ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE `Langganan` ADD CONSTRAINT `Langganan_id_kreator_nama_membership_fkey` FOREIGN KEY (`id_kreator`, `nama_membership`) REFERENCES `MembershipTier`(`id_kreator`, `nama_membership`) ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE `OrderSpecialContent` ADD CONSTRAINT `OrderSpecialContent_id_kreator_fkey` FOREIGN KEY (`id_kreator`) REFERENCES `Kreator`(`id_kreator`) ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE `OrderSpecialContent` ADD CONSTRAINT `OrderSpecialContent_id_pendukung_fkey` FOREIGN KEY (`id_pendukung`) REFERENCES `Supporter`(`id_pendukung`) ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE `KontenGambar` ADD CONSTRAINT `KontenGambar_id_konten_fkey` FOREIGN KEY (`id_konten`) REFERENCES `Konten`(`id_konten`) ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE `KontenGambar` ADD CONSTRAINT `KontenGambar_id_order_fkey` FOREIGN KEY (`id_order`) REFERENCES `OrderSpecialContent`(`id_order`) ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE `KontenTeks` ADD CONSTRAINT `KontenTeks_id_konten_fkey` FOREIGN KEY (`id_konten`) REFERENCES `Konten`(`id_konten`) ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE `KontenVideo` ADD CONSTRAINT `KontenVideo_id_konten_fkey` FOREIGN KEY (`id_konten`) REFERENCES `Konten`(`id_konten`) ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE `KontenAudio` ADD CONSTRAINT `KontenAudio_id_konten_fkey` FOREIGN KEY (`id_konten`) REFERENCES `Konten`(`id_konten`) ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE `Merchandise` ADD CONSTRAINT `Merchandise_id_konten_fkey` FOREIGN KEY (`id_konten`) REFERENCES `Konten`(`id_konten`) ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE `Pembelian` ADD CONSTRAINT `Pembelian_id_merchandise_fkey` FOREIGN KEY (`id_merchandise`) REFERENCES `Merchandise`(`id_merchandise`) ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE `Pembelian` ADD CONSTRAINT `Pembelian_id_pendukung_fkey` FOREIGN KEY (`id_pendukung`) REFERENCES `Supporter`(`id_pendukung`) ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE `AksesKonten` ADD CONSTRAINT `AksesKonten_id_konten_fkey` FOREIGN KEY (`id_konten`) REFERENCES `Konten`(`id_konten`) ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE `AksesKonten` ADD CONSTRAINT `AksesKonten_id_kreator_nama_membership_fkey` FOREIGN KEY (`id_kreator`, `nama_membership`) REFERENCES `MembershipTier`(`id_kreator`, `nama_membership`) ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE `AktivitasPendukung` ADD CONSTRAINT `AktivitasPendukung_id_pendukung_fkey` FOREIGN KEY (`id_pendukung`) REFERENCES `Supporter`(`id_pendukung`) ON DELETE RESTRICT ON UPDATE CASCADE;
