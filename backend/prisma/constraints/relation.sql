/* 
!!! 
unique constraints provided at schema.prisma thus doesnt need to copy this to migration file 
[AUTOMATICALLY GENERATED]
!!!
 */
--  1. Atribut email harus unik
ALTER TABLE `Supporter` ADD CONSTRAINT `supporter_email_unique` UNIQUE (`email`);

ALTER TABLE `Kreator` ADD CONSTRAINT `kreator_email_unique` UNIQUE (`email`);

--  2. Setiap pendukung hanya boleh memiliki satu order dengan judul tertentu (judul order unik terhadap dirinya sendiri)
ALTER TABLE `OrderSpecialContent` ADD CONSTRAINT `judul_order_unik_per_pendukung` UNIQUE (`id_pendukung`, `judul`);

/* 
!!! 
unique constraints provided at schema.prisma thus doesnt need to copy this to migration file 
[AUTOMATICALLY GENERATED]
!!!
 */