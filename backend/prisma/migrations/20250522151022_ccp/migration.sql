/*
  Warnings:

  - You are about to alter the column `status` on the `langganan` table. The data in that column could be lost. The data in that column will be cast from `Enum(EnumId(0))` to `VarChar(191)`.
  - You are about to alter the column `status` on the `orderspecialcontent` table. The data in that column could be lost. The data in that column will be cast from `Enum(EnumId(1))` to `VarChar(191)`.

*/
-- DropForeignKey
ALTER TABLE `orderspecialcontent` DROP FOREIGN KEY `OrderSpecialContent_id_pendukung_fkey`;

-- DropIndex
DROP INDEX `kreator_email_unique` ON `kreator`;

-- DropIndex
DROP INDEX `judul_order_unik_per_pendukung` ON `orderspecialcontent`;

-- DropIndex
DROP INDEX `supporter_email_unique` ON `supporter`;

-- AlterTable
ALTER TABLE `langganan` MODIFY `status` VARCHAR(191) NOT NULL;

-- AlterTable
ALTER TABLE `orderspecialcontent` MODIFY `status` VARCHAR(191) NOT NULL;
