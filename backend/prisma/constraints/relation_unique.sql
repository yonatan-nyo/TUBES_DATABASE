/* 
!!! 
unique constraints provided at schema.prisma thus doesnt need to copy this to migration file 
[AUTOMATICALLY GENERATED]
!!!
 */
-- on create
CREATE TABLE `Kreator` (
    -- other fields
    `email` VARCHAR(191) NOT NULL,
    -- other fields

    UNIQUE INDEX `Kreator_email_key`(`email`),
    -- other constraints
);
-- alter version assuming email exists in Kreator table
ALTER TABLE `Kreator` ADD CONSTRAINT `Kreator_email_key` UNIQUE (`email`);

-- on create
CREATE TABLE `Supporter` (
    -- other fields
    `email` VARCHAR(191) NOT NULL,
    -- other fields

    UNIQUE INDEX `Supporter_email_key`(`email`),
    -- other constraints
);
-- alter version assuming email exists in Supporter table
ALTER TABLE `Supporter` ADD CONSTRAINT `Supporter_email_key` UNIQUE (`email`);

-- on create
CREATE TABLE `OrderSpecialContent` (
    -- other fields
    `id_pendukung` INTEGER NOT NULL,
    `judul` VARCHAR(191) NOT NULL,
    -- other fields

    UNIQUE INDEX `OrderSpecialContent_id_pendukung_judul_key`(`id_pendukung`, `judul`),
    -- other constraints
);
-- alter version assuming id_pendukung and judul exist in OrderSpecialContent table
ALTER TABLE `OrderSpecialContent` ADD CONSTRAINT `OrderSpecialContent_id_pendukung_judul_key` UNIQUE (`id_pendukung`, `judul`);

-- on create
CREATE TABLE `KontenGambar` (
    -- other fields
    `id_order` INTEGER NULL,
    -- other fields

    UNIQUE INDEX `KontenGambar_id_order_key`(`id_order`),
    -- other constraints
);
-- alter version assuming id_order exists in KontenGambar table
ALTER TABLE `KontenGambar` ADD CONSTRAINT `KontenGambar_id_order_key` UNIQUE (`id_order`);

/* 
!!! 
unique constraints provided at schema.prisma thus doesnt need to copy this to migration file 
[AUTOMATICALLY GENERATED]
!!!
 */