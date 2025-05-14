SELECT
    k.id_kreator,
    k.nama AS nama_kreator,
    k.bidang_kreasi,
    ko.id_konten,
    ko.judul AS judul_konten,
    ko.jenis AS jenis_konten,
    m.id_merchandise,
    m.nama AS nama_merchandise,
    m.harga
FROM
    Kreator k
    JOIN Konten ko ON k.id_kreator = ko.id_kreator
    JOIN Merchandise m ON ko.id_konten = m.id_konten
ORDER BY
    k.id_kreator,
    ko.id_konten;