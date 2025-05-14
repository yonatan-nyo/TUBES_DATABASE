-- Query dengan subquery yang memenuhi syarat minimal 3 relasi per subquery
SELECT
    k.id_kreator,
    k.nama AS nama_kreator,
    k.bidang_kreasi,
    konten_info.judul AS judul_konten,
    konten_info.jumlah_komentar,
    merch_info.nama AS nama_merchandise,
    merch_info.total_penjualan
FROM
    Kreator k
    LEFT JOIN (
        -- Subquery konten dengan minimal 3 relasi
        SELECT
            ko.id_kreator,
            ko.id_konten,
            ko.judul,
            COUNT(km.id_komentar) AS jumlah_komentar,
            s.nama AS nama_supporter_terakhir,
            ROW_NUMBER() OVER (
                PARTITION BY
                    ko.id_kreator
                ORDER BY
                    COUNT(km.id_komentar) DESC
            ) AS ranking
        FROM
            Konten ko
            LEFT JOIN Komentar km ON ko.id_konten = km.id_konten
            LEFT JOIN Supporter s ON km.id_pendukung = s.id_pendukung
            LEFT JOIN AksesKonten ak ON ko.id_konten = ak.id_konten
        GROUP BY
            ko.id_kreator,
            ko.id_konten,
            ko.judul,
            s.nama
    ) AS konten_info ON k.id_kreator = konten_info.id_kreator
    AND konten_info.ranking = 1
    LEFT JOIN (
        -- Subquery merchandise dengan minimal 3 relasi
        SELECT
            ko.id_kreator,
            m.id_merchandise,
            m.nama,
            SUM(p.jumlah) AS total_penjualan,
            s.nama AS nama_pembeli_terbesar,
            ROW_NUMBER() OVER (
                PARTITION BY
                    ko.id_kreator
                ORDER BY
                    SUM(p.jumlah) DESC
            ) AS ranking
        FROM
            Merchandise m
            JOIN Konten ko ON m.id_konten = ko.id_konten
            LEFT JOIN Pembelian p ON m.id_merchandise = p.id_merchandise
            LEFT JOIN Supporter s ON p.id_pendukung = s.id_pendukung
        GROUP BY
            ko.id_kreator,
            m.id_merchandise,
            m.nama,
            s.nama
    ) AS merch_info ON k.id_kreator = merch_info.id_kreator
    AND merch_info.ranking = 1
ORDER BY
    k.id_kreator;