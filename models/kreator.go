package models

type Kreator struct {
	IDKreator        int    `gorm:"primaryKey"`
	Nama             string `gorm:"type:varchar(100)"`
	Email            string `gorm:"type:varchar(100)"`
	Deskripsi        string `gorm:"type:text"`
	BidangKreasi     string `gorm:"type:varchar(100)"`
	TanggalBergabung string `gorm:"type:date"`
}

type Supporter struct {
	IDPendukung      int    `gorm:"primaryKey"`
	Nama             string `gorm:"type:varchar(100)"`
	Email            string `gorm:"type:varchar(100)"`
	Alamat           string `gorm:"type:text"`
	TanggalBergabung string `gorm:"type:date"`
}

type Konten struct {
	IDKonten         int     `gorm:"primaryKey"`
	IDKreator        int     `gorm:"index"`
	Kreator          Kreator `gorm:"foreignKey:IDKreator;references:IDKreator"`
	Jenis            string  `gorm:"type:varchar(50)"`
	Judul            string  `gorm:"type:varchar(100)"`
	Deskripsi        string  `gorm:"type:text"`
	TanggalPublikasi string  `gorm:"type:date"`
}

type MembershipTier struct {
	IDKreator      int     `gorm:"primaryKey"`
	Kreator        Kreator `gorm:"foreignKey:IDKreator;references:IDKreator"`
	NamaMembership string  `gorm:"primaryKey;type:varchar(100)"`
	Deskripsi      string  `gorm:"type:text"`
	HargaBulanan   float64 `gorm:"type:decimal(10,2)"`
	DaftarManfaat  string  `gorm:"type:text"`
}

type Komentar struct {
	IDKomentar  int       `gorm:"primaryKey"`
	IDKonten    int       `gorm:"index"`
	Konten      Konten    `gorm:"foreignKey:IDKonten;references:IDKonten"`
	IDPendukung int       `gorm:"index"`
	Supporter   Supporter `gorm:"foreignKey:IDPendukung;references:IDPendukung"`
	Isi         string    `gorm:"type:text"`
	Waktu       string    `gorm:"type:datetime"`
}

type Langganan struct {
	IDKreator                 int            `gorm:"primaryKey"`
	Kreator                   Kreator        `gorm:"foreignKey:IDKreator;references:IDKreator"`
	NamaMembership            string         `gorm:"primaryKey;type:varchar(100)"`
	IDPendukung               int            `gorm:"primaryKey"`
	Supporter                 Supporter      `gorm:"foreignKey:IDPendukung;references:IDPendukung"`
	MembershipTier            MembershipTier `gorm:"foreignKey:IDKreator,NamaMembership;references:IDKreator,NamaMembership"`
	TanggalPembayaranTerakhir string         `gorm:"type:date"`
	Jumlah                    float64        `gorm:"type:decimal(10,2)"`
	ModePembayaran            string         `gorm:"type:varchar(50)"`
	Status                    string         `gorm:"type:varchar(50)"`
}

type OrderSpecialContent struct {
	IDOrder             int       `gorm:"primaryKey"`
	IDKreator           int       `gorm:"index"`
	Kreator             Kreator   `gorm:"foreignKey:IDKreator;references:IDKreator"`
	IDPendukung         int       `gorm:"index"`
	Supporter           Supporter `gorm:"foreignKey:IDPendukung;references:IDPendukung"`
	Judul               string    `gorm:"type:varchar(100)"`
	Deskripsi           string    `gorm:"type:text"`
	HargaDasar          float64   `gorm:"type:decimal(10,2)"`
	DetailKustom        string    `gorm:"type:text"`
	TanggalBatasRevisi  string    `gorm:"type:date"`
	EstimasiPengerjaan  int       `gorm:"type:int"`
	Status              string    `gorm:"type:varchar(50)"`
	TanggalPenyelesaian string    `gorm:"type:date"`
	Feedback            string    `gorm:"type:text"`
}

type KontenGambar struct {
	IDKonten    int                 `gorm:"primaryKey"`
	Konten      Konten              `gorm:"foreignKey:IDKonten;references:IDKonten"`
	IDOrder     int                 `gorm:"index"`
	Order       OrderSpecialContent `gorm:"foreignKey:IDOrder;references:IDOrder"`
	ImageSource string              `gorm:"type:text"`
	Resolusi    string              `gorm:"type:varchar(50)"`
	Format      string              `gorm:"type:varchar(50)"`
}

type KontenTeks struct {
	IDKonten   int    `gorm:"primaryKey"`
	Konten     Konten `gorm:"foreignKey:IDKonten;references:IDKonten"`
	TextSource string `gorm:"type:text"`
	JumlahKata int    `gorm:"type:int"`
	Format     string `gorm:"type:varchar(50)"`
}

type KontenVideo struct {
	IDKonten    int    `gorm:"primaryKey"`
	Konten      Konten `gorm:"foreignKey:IDKonten;references:IDKonten"`
	VideoSource string `gorm:"type:text"`
	Durasi      int    `gorm:"type:int"`
	Resolusi    string `gorm:"type:varchar(50)"`
}

type KontenAudio struct {
	IDKonten    int    `gorm:"primaryKey"`
	Konten      Konten `gorm:"foreignKey:IDKonten;references:IDKonten"`
	AudioSource string `gorm:"type:text"`
	Durasi      int    `gorm:"type:int"`
	Kualitas    string `gorm:"type:varchar(50)"`
}

type Merchandise struct {
	IDMerchandise int     `gorm:"primaryKey"`
	Nama          string  `gorm:"type:varchar(100)"`
	IDKonten      int     `gorm:"index"`
	Konten        Konten  `gorm:"foreignKey:IDKonten;references:IDKonten"`
	Harga         float64 `gorm:"type:decimal(10,2)"`
	Stok          int     `gorm:"type:int"`
	Deskripsi     string  `gorm:"type:text"`
}

type Pembelian struct {
	IDMerchandise    int         `gorm:"primaryKey"`
	Merchandise      Merchandise `gorm:"foreignKey:IDMerchandise;references:IDMerchandise"`
	IDPendukung      int         `gorm:"primaryKey"`
	Supporter        Supporter   `gorm:"foreignKey:IDPendukung;references:IDPendukung"`
	Jumlah           int         `gorm:"type:int"`
	TanggalPembelian string      `gorm:"type:date"`
	MetodePembayaran string      `gorm:"type:varchar(50)"`
	TotalHarga       float64     `gorm:"type:decimal(10,2)"`
}

type AksesKonten struct {
	IDKonten       int            `gorm:"primaryKey"`
	Konten         Konten         `gorm:"foreignKey:IDKonten;references:IDKonten"`
	IDKreator      int            `gorm:"primaryKey"`
	Kreator        Kreator        `gorm:"foreignKey:IDKreator;references:IDKreator"`
	NamaMembership string         `gorm:"primaryKey;type:varchar(100)"`
	MembershipTier MembershipTier `gorm:"foreignKey:IDKreator,NamaMembership;references:IDKreator,NamaMembership"`
}
