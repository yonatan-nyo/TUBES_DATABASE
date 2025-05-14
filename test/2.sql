-- Kreator yang memiliki merchandise
SELECT
    k.id_kreator,
    k.nama AS nama_kreator,
    k.bidang_kreasi,
    'Memiliki Merchandise' AS kategori
FROM
    Kreator k
    JOIN Konten ko ON k.id_kreator = ko.id_kreator
    JOIN Merchandise m ON ko.id_konten = m.id_konten
GROUP BY
    k.id_kreator,
    k.nama,
    k.bidang_kreasi
UNION
-- Kreator yang memiliki membership tier premium
SELECT
    k.id_kreator,
    k.nama AS nama_kreator,
    k.bidang_kreasi,
    'Memiliki Tier Premium' AS kategori
FROM
    Kreator k
    JOIN MembershipTier mt ON k.id_kreator = mt.id_kreator
    JOIN Langganan l ON mt.id_kreator = l.id_kreator
    AND mt.nama_membership = l.nama_membership
    JOIN Supporter s ON l.id_pendukung = s.id_pendukung
WHERE
    mt.harga_bulanan > 100000
GROUP BY
    k.id_kreator,
    k.nama,
    k.bidang_kreasi
ORDER BY
    id_kreator,
    kategori;