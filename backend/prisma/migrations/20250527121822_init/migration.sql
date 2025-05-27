CREATE PROCEDURE hitung_total_harga_merchandise (
    IN input_id_merchandise INT,
    IN input_id_pendukung INT
)
BEGIN
    DECLARE temp TEXT;

    IF input_id_merchandise IS NULL OR input_id_pendukung IS NULL THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Parameter input tidak boleh null.';
    END IF;

    SET temp = CONCAT(
        'UPDATE pembelian p 
         JOIN merchandise m 
         ON p.id_merchandise = m.id_merchandise 
         SET p.total_harga = m.harga * p.jumlah 
         WHERE p.id_merchandise = ', input_id_merchandise,
        ' AND p.id_pendukung = ', input_id_pendukung
    );

    PREPARE stmt FROM temp;
    EXECUTE stmt;
    DEALLOCATE PREPARE stmt;
END;

