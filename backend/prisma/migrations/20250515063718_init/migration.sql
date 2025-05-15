/*
  Warnings:

  - The primary key for the `akseskonten` table will be changed. If it partially fails, the table could be left without primary key constraint.
  - A unique constraint covering the columns `[id_order]` on the table `KontenGambar` will be added. If there are existing duplicate values, this will fail.

*/
-- DropForeignKey
ALTER TABLE `kontengambar` DROP FOREIGN KEY `KontenGambar_id_order_fkey`;

-- DropIndex
DROP INDEX `KontenGambar_id_order_fkey` ON `kontengambar`;

-- AlterTable
ALTER TABLE `akseskonten` DROP PRIMARY KEY,
    ADD PRIMARY KEY (`id_konten`, `id_kreator`, `nama_membership`);

-- AlterTable
ALTER TABLE `komentar` MODIFY `isi` TEXT NOT NULL;

-- AlterTable
ALTER TABLE `konten` MODIFY `deskripsi` TEXT NULL;

-- AlterTable
ALTER TABLE `kontengambar` MODIFY `id_order` INTEGER NULL;

-- AlterTable
ALTER TABLE `kontenteks` MODIFY `textSource` TEXT NOT NULL;

-- AlterTable
ALTER TABLE `kreator` MODIFY `deskripsi` TEXT NULL;

-- AlterTable
ALTER TABLE `membershiptier` MODIFY `deskripsi` TEXT NULL,
    MODIFY `daftar_manfaat` TEXT NULL;

-- AlterTable
ALTER TABLE `merchandise` MODIFY `deskripsi` TEXT NULL;

-- AlterTable
ALTER TABLE `orderspecialcontent` MODIFY `deskripsi` TEXT NULL,
    MODIFY `detail_kustom` TEXT NULL,
    MODIFY `feedback` TEXT NULL;

-- AlterTable
ALTER TABLE `supporter` MODIFY `alamat` TEXT NULL;

-- CreateIndex
CREATE UNIQUE INDEX `KontenGambar_id_order_key` ON `KontenGambar`(`id_order`);

-- AddForeignKey
ALTER TABLE `KontenGambar` ADD CONSTRAINT `KontenGambar_id_order_fkey` FOREIGN KEY (`id_order`) REFERENCES `OrderSpecialContent`(`id_order`) ON DELETE SET NULL ON UPDATE CASCADE;
