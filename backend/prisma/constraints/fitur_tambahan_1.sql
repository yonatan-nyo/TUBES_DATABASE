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
BEGIN 
    DECLARE v_harga DECIMAL(65, 30);
    
    SELECT harga INTO v_harga
    FROM merchandise
    WHERE id_merchandise = NEW.id_merchandise;
    
    SET NEW.total_harga = v_harga * NEW.jumlah;
END;

-- sql-formatter-enable
-- prettier-ignore-end