-- Otomatisasi Perhitungan Harga Merchandise
/*
Menghitung total_harga secara otomatis, sehingga tidak diperlukan pengisian manual 
saat record baru ditambahkan ke tabel pembelian, dan memperbarui total_harga jika 
terjadi update dan penghapusan pembelian.
*/

-- prettier-ignore-start
-- sql-formatter-disable
CREATE TRIGGER hitung_total_harga_insert
BEFORE INSERT ON pembelian
FOR EACH ROW
BEGIN
   DECLARE v_harga DECIMAL(65, 30) DEFAULT 0.0;
 
   SELECT harga INTO v_harga
   FROM merchandise
   WHERE id_merchandise = NEW.id_merchandise;
 
   SET NEW.total_harga = v_harga * NEW.jumlah;
END;
CREATE TRIGGER hitung_total_harga_update
BEFORE UPDATE ON pembelian
FOR EACH ROW
BEGI
   DECLARE v_harga DECIMAL(65, 30);
 
   SELECT harga INTO v_harga
   FROM merchandise
   WHERE id_merchandise = NEW.id_merchandise;
 
   SET NEW.total_harga = v_harga * NEW.jumlah;
END;
-- sql-formatter-enable
-- prettier-ignore-end