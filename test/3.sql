SELECT
  k.bidang_kreasi,
  COUNT(DISTINCT k.id_kreator) AS jumlah_kreator,
  ROUND(SUM(p.total_harga), 2) AS total_income_merch,
  ROUND(SUM(l.jumlah), 2) AS total_income_member,
  ROUND(SUM(p.total_harga) + SUM(l.jumlah), 2) AS total_pendapatan,
  ROUND(AVG(p.total_harga), 2) AS rata_rata_pembelian_merchandise,
  ROUND(AVG(l.jumlah), 2) AS rata_rata_biaya_membership
FROM
  Kreator k
  JOIN Konten ko ON k.id_kreator = ko.id_kreator
  JOIN Merchandise m ON ko.id_konten = m.id_konten
  JOIN Pembelian p ON m.id_merchandise = p.id_merchandise
  JOIN MembershipTier mt ON k.id_kreator = mt.id_kreator
  JOIN Langganan l ON mt.id_kreator = l.id_kreator
  AND mt.nama_membership = l.nama_membership
GROUP BY
  k.bidang_kreasi
HAVING
  total_pendapatan > 10000000
ORDER BY
  total_pendapatan DESC;