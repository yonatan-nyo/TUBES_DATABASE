CREATE TRIGGER hitung_total_harga_insert
AFTER INSERT ON pembelian
FOR EACH ROW
BEGIN
  DECLARE v_harga DECIMAL(65,30);

  SELECT harga INTO v_harga
  FROM merchandise
  WHERE id_merchandise = NEW.id_merchandise;

  UPDATE pembelian
  SET total_harga = v_harga * NEW.jumlah
  WHERE id_merchandise = NEW.id_merchandise
    AND id_pendukung = NEW.id_pendukung;
END;

CREATE TRIGGER hitung_total_harga_update
AFTER UPDATE ON pembelian
FOR EACH ROW
BEGIN
  DECLARE v_harga DECIMAL(65,30);

  SELECT harga INTO v_harga
  FROM merchandise
  WHERE id_merchandise = NEW.id_merchandise;

  UPDATE pembelian
  SET total_harga = v_harga * NEW.jumlah
  WHERE id_merchandise = NEW.id_merchandise
    AND id_pendukung = NEW.id_pendukung;
END;