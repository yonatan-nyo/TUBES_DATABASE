-- Validasi Email
/*

Memastikan alamat email yang terdapat pada database  (relasi kreator/pendukung) valid sesuai format standar. Asumsi alamat valid sebagai berikut : "<...>@<...>.com".
*/

-- sql-formatter-disable
-- prettier-ignore-start

-- Trigger: BEFORE INSERT on Kreator
CREATE TRIGGER `email_kreator_insert`
BEFORE INSERT ON `Kreator`
FOR EACH ROW
BEGIN
   IF NEW.email NOT LIKE '_%@%.com' OR NEW.email LIKE '%@%@%.com' THEN
       SIGNAL SQLSTATE '45000'
       SET MESSAGE_TEXT = 'Format email untuk Kreator tidak valid. Pastikan formatnya <...>@<...>.com';
   END IF;
END;

-- Trigger: BEFORE UPDATE on Kreator
CREATE TRIGGER `email_kreator_update`
BEFORE UPDATE ON `Kreator`
FOR EACH ROW
BEGIN
   IF NEW.email NOT LIKE '_%@%.com' OR NEW.email LIKE '%@%@%.com' THEN
       SIGNAL SQLSTATE '45000'
       SET MESSAGE_TEXT = 'Format email untuk Kreator tidak valid. Pastikan formatnya <...>@<...>.com';
   END IF;
END;

-- Trigger: BEFORE INSERT on Supporter
CREATE TRIGGER `email_supporter_insert`
BEFORE INSERT ON `Supporter`
FOR EACH ROW
BEGIN
   IF NEW.email NOT LIKE '_%@%.com' OR NEW.email LIKE '%@%@%.com' THEN
       SIGNAL SQLSTATE '45000'
       SET MESSAGE_TEXT = 'Format email untuk Supporter tidak valid. Pastikan formatnya <...>@<...>.com';
   END IF;
END;

-- Trigger: BEFORE UPDATE on Supporter
CREATE TRIGGER `email_supporter_update`
BEFORE UPDATE ON `Supporter`
FOR EACH ROW
BEGIN
   IF NEW.email NOT LIKE '_%@%.com' OR NEW.email LIKE '%@%@%.com' THEN
       SIGNAL SQLSTATE '45000'
       SET MESSAGE_TEXT = 'Format email untuk Supporter tidak valid. Pastikan formatnya <...>@<...>.com';
   END IF;
END;
-- prettier-ignore-end
-- sql-formatter-enable
