-- Data Kreator Populer
/*
Membuat view untuk menampilkan 10 kreator terpopuler berdasarkan jumlah pendukung aktif dan komentar. 
View ini menyertakan nama kreator, bidang kreasi, jumlah pendukung aktif jumlah komentar, serta skor popularitas.
*/

-- prettier-ignore-start
-- sql-formatter-disable
CREATE VIEW KreatorPopuler AS
SELECT
    k.nama AS nama_kreator,
    k.bidang_kreasi,
    COALESCE(pa.jumlah_pendukung_aktif, 0) AS jumlah_pendukung_aktif,
    COALESCE(kom.jumlah_komentar, 0) AS jumlah_komentar,
    COALESCE(pa.jumlah_pendukung_aktif, 0) * 3 + COALESCE(kom.jumlah_komentar, 0) AS skor_popularitas
FROM Kreator k
LEFT JOIN (
    SELECT
        l.id_kreator,
        COUNT(DISTINCT l.id_pendukung) AS jumlah_pendukung_aktif
    FROM Langganan l
    WHERE l.status = 'Aktif'
    GROUP BY l.id_kreator
) pa ON k.id_kreator = pa.id_kreator
LEFT JOIN (
    SELECT
        ko.id_kreator,
        COUNT(km.id_komentar) AS jumlah_komentar
    FROM Komentar km
    JOIN Konten ko ON km.id_konten = ko.id_konten
    GROUP BY ko.id_kreator
) kom ON k.id_kreator = kom.id_kreator
ORDER BY skor_popularitas DESC
LIMIT 10;

-- sql-formatter-enable
-- prettier-ignore-end