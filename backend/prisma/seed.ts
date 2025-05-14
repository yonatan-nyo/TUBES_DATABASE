import { PrismaClient } from "@prisma/client";
import { faker } from "@faker-js/faker";

const prisma = new PrismaClient();

async function main() {
  console.log("🌱 [SEED] Seeding database...");

  // Seed independent tables
  await prisma.kreator.createMany({
    data: Array.from({ length: 20 }, () => ({
      nama: faker.person.fullName(),
      email: faker.internet.email(),
      deskripsi: faker.lorem.paragraph(),
      bidang_kreasi: faker.word.noun(),
      tanggal_bergabung: faker.date.past(),
    })),
  });

  await prisma.supporter.createMany({
    data: Array.from({ length: 20 }, () => ({
      nama: faker.person.fullName(),
      email: faker.internet.email(),
      alamat: faker.location.streetAddress(),
      tanggal_bergabung: faker.date.past(),
    })),
  });

  //Fetch foreign key references
  const kreatorList = await prisma.kreator.findMany();
  const supporterList = await prisma.supporter.findMany();

  const getRandomKreator = () => kreatorList[Math.floor(Math.random() * kreatorList.length)];
  const getRandomSupporter = () => supporterList[Math.floor(Math.random() * supporterList.length)];

  for (let i = 0; i < 100; i++) {
    const kreator = getRandomKreator();

    await prisma.konten.create({
      data: {
        id_kreator: kreator.id_kreator,
        jenis: faker.helpers.arrayElement(["Video", "Audio", "Teks", "Gambar"]),
        judul: faker.lorem.sentence(),
        deskripsi: faker.lorem.paragraph(),
        tanggal_publikasi: faker.date.recent(),
      },
    });

    await prisma.membershipTier.create({
      data: {
        id_kreator: kreator.id_kreator,
        nama_membership: faker.word.adjective() + "-" + faker.word.noun(),
        deskripsi: faker.lorem.sentence(),
        harga_bulanan: parseFloat(faker.commerce.price()),
        daftar_manfaat: faker.lorem.sentences(2),
      },
    });
  }

  const kontenList = await prisma.konten.findMany();
  const membershipList = await prisma.membershipTier.findMany();

  for (let i = 0; i < 100; i++) {
    const konten = kontenList[Math.floor(Math.random() * kontenList.length)];
    const supporter = getRandomSupporter();

    await prisma.komentar.create({
      data: {
        id_konten: konten.id_konten,
        id_pendukung: supporter.id_pendukung,
        isi: faker.lorem.sentences(2),
        waktu: faker.date.recent(),
      },
    });

    const tier = membershipList[Math.floor(Math.random() * membershipList.length)];

    // ✅ Check for existing langganan first
    const existingLangganan = await prisma.langganan.findUnique({
      where: {
        id_kreator_nama_membership_id_pendukung: {
          id_kreator: tier.id_kreator,
          nama_membership: tier.nama_membership,
          id_pendukung: supporter.id_pendukung,
        },
      },
    });

    if (!existingLangganan) {
      await prisma.langganan.create({
        data: {
          id_kreator: tier.id_kreator,
          nama_membership: tier.nama_membership,
          id_pendukung: supporter.id_pendukung,
          tanggal_pembayaran_terakhir: faker.date.recent(),
          jumlah: tier.harga_bulanan,
          mode_pembayaran: faker.helpers.arrayElement(["Transfer", "E-Wallet"]),
          status: faker.helpers.arrayElement(["Aktif", "Nonaktif"]),
        },
      });
    }

    await prisma.orderSpecialContent.create({
      data: {
        id_kreator: konten.id_kreator,
        id_pendukung: supporter.id_pendukung,
        judul: faker.lorem.words(3),
        deskripsi: faker.lorem.paragraph(),
        harga_dasar: parseFloat(faker.commerce.price()),
        detail_kustom: faker.lorem.sentence(),
        tanggal_batas_revisi: faker.date.future(),
        estimasi_pengerjaan: faker.number.int({ min: 1, max: 10 }),
        status: "Dalam Proses",
        tanggal_penyelesaian: null,
        feedback: "",
      },
    });
  }

  console.log("✅ [SEED] Done seeding!");
}

main()
  .catch((e) => {
    console.error(e);
  })
  .finally(async () => {
    await prisma.$disconnect();
  });
