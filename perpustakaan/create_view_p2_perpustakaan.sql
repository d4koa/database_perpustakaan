-- Nama database : PERPUSTAKAAN
-- Software DBMS : ORACLE APEX
-- Bagian        : CREATE VIEW PART_2

-- Membuat beberapa view dengan beberapa kondisi part_2
-- PENERAPAN JOIN part-2
-- Membuat view V_PENGEMBALIAN_BUKU  -> pengembalian buku  
CREATE VIEW V_PENGEMBALIAN_BUKU  AS
SELECT A.ID_KEMBALI KODE_KEMBALI, 
    B.BUKU, 
    B.KODE_BUKU,
    C.NAMA_LENGKAP PEMINJAM, 
    C.ID_MEMBER KODE_PEMINJAM,
    D.NAMA_LENGKAP PENERIMA, 
    D.ID_STAFF KODE_PENERIMA,
    A.TGL_PENGEMBALIAN, 
    A.DENDA
FROM PENGEMBALIAN A
JOIN V_PEMINJAMAN_BUKU  B ON B.KODE_PINJAM = A.ID_PINJAM
JOIN MEMBER C ON C.ID_MEMBER = A.ID_MEMBER
JOIN STAFF D ON D.ID_STAFF = A.ID_STAFF
ORDER BY KODE_KEMBALI ASC;

-- PENERAPAN FUNGSI ARITMATIKA
-- Misalkan telat mengembalikan buku dan telah
-- lewat selama 5 hari. Jika telat mengembalikan
-- maka akan diberikan denda sebesar Rp. 5000.
-- Kemudian jika melewati tanggal pengembalian
-- maka akan ditambahkan Rp. 1.0000 pada denda
-- peminjam buku yang bersangkutan setiap 
-- terlewat perharinya.

-- Misalkan MEMBER dengan ID_MEMBER 'MBR0011' telat
-- mengembalikan buku dan telah lewat selama 5 hari

CREATE VIEW V_TELAT_MENGEMBALIKAN_5_HARI AS
SELECT A.ID_KEMBALI KODE_KEMBALI,
    B.BUKU,
    B.KODE_BUKU,
    C.NAMA_LENGKAP PEMINJAM,
    C.ID_MEMBER KODE_PEMINJAM,
    D.NAMA_LENGKAP PENERIMA,
    D.ID_STAFF KODE_PENERIMA,
    B.TGL_KEMBALI+5 TGL_PENGEMBALIAN,
    A.DENDA+5000+(5*1000) DENDA
FROM PENGEMBALIAN A
JOIN V_PEMINJAMAN_BUKU B ON B.KODE_PINJAM = A.ID_PINJAM
JOIN MEMBER C ON C.ID_MEMBER = A.ID_MEMBER
JOIN STAFF D ON D.ID_STAFF = A.ID_STAFF
WHERE C.ID_MEMBER LIKE 'MBR0011';

-- QUERY DENGAN PENERAPAN FUNGSI TEKS
-- Mengambil data pada tabel MEMBER dan PENGUNJUNG kemudian
-- menambahkan teks 'mengunjungi perpustakaan pada tanggal'.

CREATE VIEW V_PERNYATAAN AS
SELECT B.NAMA_LENGKAP ||  ' mengunjungi perpustakaan pada tanggal ' || TGL_KUNJUNGAN AS PERNYATAAN
FROM PENGUNJUNG A
JOIN MEMBER B ON B.ID_MEMBER = A.ID_MEMBER
ORDER BY ID_PENGUNJUNG;

-- QUERY DENGAN KONDISI WHERE DAN LIKE
-- Mencari pengunjung dan kapan melakukan kunjungan yang
-- memiliki alamat di daerah'Nanggeleng' atau 'Baros'.

CREATE VIEW V_PENGUNJUNG_NANGGELENG_DAN_BAROS AS
SELECT A.ID_PENGUNJUNG AS KODE_PENGUNJUNG,
    B.NAMA_LENGKAP AS MEMBER,
    CASE
        WHEN B.GENDER = '0' THEN 'PEREMPUAN'
        WHEN B.GENDER = '1' THEN 'LAKI-LAKI'
        ELSE 'TIDAK KETAHUI'
    END AS GENDER,
    B.ID_MEMBER AS KODE_MEMBER,
    B.ALAMAT,
    A.TGL_KUNJUNGAN
FROM PENGUNJUNG A
JOIN MEMBER B ON B.ID_MEMBER = A.ID_MEMBER
WHERE B.ALAMAT = 'Nanggeleng' OR B.ALAMAT = 'Baros'
ORDER BY TGL_KUNJUNGAN ASC;

-- PENERAPAN GROUP BY
-- Mengambil data berapa banyak pengunjung
-- yang berkunjung sesuai dengan tanggalnya.

CREATE VIEW V_BANYAK_PENGUNJUNG AS
SELECT TGL_KUNJUNGAN,
    COUNT(ID_PENGUNJUNG) || ' orang' AS BANYAK_PENGUNJUNG
FROM PENGUNJUNG
GROUP BY TGL_KUNJUNGAN
ORDER BY TGL_KUNJUNGAN ASC;