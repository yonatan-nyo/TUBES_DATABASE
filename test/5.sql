SELECT
    hasil_akhir.bidang_kreasi,
    COUNT(DISTINCT hasil_akhir.id_kreator) AS jumlah_kreator,
    SUM(hasil_akhir.jumlah_konten) AS total_konten,
    ROUND(AVG(hasil_akhir.rata_rata_komentar), 2) AS rata_rata_komentar_per_konten,
    ROUND(SUM(hasil_akhir.total_pendapatan_merchandise), 2) AS total_pendapatan_merchandise,
    ROUND(SUM(hasil_akhir.total_pendapatan_membership), 2) AS total_pendapatan_membership,
    ROUND(SUM(hasil_akhir.total_pendapatan), 2) AS total_pendapatan_keseluruhan,
    ROUND(AVG(hasil_akhir.total_pendapatan), 2) AS rata_rata_pendapatan_per_kreator
FROM
    (
        SELECT
            k.id_kreator,
            k.nama AS nama_kreator,
            k.bidang_kreasi,
            COUNT(DISTINCT ko.id_konten) AS jumlah_konten,
            CASE
                WHEN COUNT(DISTINCT ko.id_konten) = 0 THEN 0
                ELSE COUNT(km.id_komentar) / COUNT(DISTINCT ko.id_konten)
            END AS rata_rata_komentar,
            COALESCE(merch_sales.total_pendapatan_merchandise, 0) AS total_pendapatan_merchandise,
            COALESCE(membership_revenue.total_pendapatan_membership, 0) AS total_pendapatan_membership,
            COALESCE(merch_sales.total_pendapatan_merchandise, 0) + COALESCE(membership_revenue.total_pendapatan_membership, 0) AS total_pendapatan
        FROM
            Kreator k
            LEFT JOIN Konten ko ON k.id_kreator = ko.id_kreator
            LEFT JOIN Komentar km ON ko.id_konten = km.id_konten
            LEFT JOIN (
                -- Subquery untuk total pendapatan dari merchandise per kreator
                SELECT
                    ko.id_kreator,
                    SUM(p.total_harga) AS total_pendapatan_merchandise
                FROM
                    Konten ko
                    JOIN Merchandise m ON ko.id_konten = m.id_konten
                    JOIN Pembelian p ON m.id_merchandise = p.id_merchandise
                GROUP BY
                    ko.id_kreator
            ) AS merch_sales ON k.id_kreator = merch_sales.id_kreator
            LEFT JOIN (
                -- Subquery untuk total pendapatan dari membership per kreator
                SELECT
                    mt.id_kreator,
                    SUM(l.jumlah) AS total_pendapatan_membership
                FROM
                    MembershipTier mt
                    JOIN Langganan l ON mt.id_kreator = l.id_kreator
                    AND mt.nama_membership = l.nama_membership
                WHERE
                    l.status = 'Aktif'
                GROUP BY
                    mt.id_kreator
            ) AS membership_revenue ON k.id_kreator = membership_revenue.id_kreator
        GROUP BY
            k.id_kreator,
            k.nama,
            k.bidang_kreasi,
            merch_sales.total_pendapatan_merchandise,
            membership_revenue.total_pendapatan_membership
    ) AS hasil_akhir
GROUP BY
    hasil_akhir.bidang_kreasi
HAVING
    SUM(hasil_akhir.total_pendapatan) > 500000
ORDER BY
    total_pendapatan_keseluruhan DESC;