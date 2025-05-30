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

  const getRandomKreator = () =>
    kreatorList[Math.floor(Math.random() * kreatorList.length)];
  const getRandomSupporter = () =>
    supporterList[Math.floor(Math.random() * supporterList.length)];

  for (let i = 0; i < 50; i++) {
    const kreator = getRandomKreator();
    const typeContent = faker.helpers.arrayElement([
      "Video",
      "Audio",
      "Teks",
      "Gambar",
    ]);
    const status = faker.helpers.arrayElement([
      "Selesai",
      "Diproses",
      "Menunggu",
    ]);

    const orderSpecialContent = await prisma.orderSpecialContent.create({
      data: {
        id_kreator: getRandomKreator().id_kreator,
        id_pendukung: getRandomSupporter().id_pendukung,
        judul: faker.lorem.words(3),
        deskripsi: faker.lorem.paragraph(),
        harga_dasar: parseFloat(faker.commerce.price()),
        detail_kustom: faker.lorem.sentence(),
        tanggal_batas_revisi: faker.date.future(),
        estimasi_pengerjaan: faker.number.int({ min: 1, max: 10 }),
        status,
        tanggal_penyelesaian: status === "Selesai" ? faker.date.recent() : null,
        feedback: "",
      },
    });
    const createdKonten = await prisma.konten.create({
      data: {
        id_kreator: kreator.id_kreator,
        jenis: typeContent,
        judul: faker.lorem.sentence(),
        deskripsi: faker.lorem.paragraph(),
        tanggal_publikasi: faker.date.recent(),
      },
    });

    if (typeContent === "Gambar") {
      const isFromOrder = Math.random() < 0.5;

      if (isFromOrder) {
        await prisma.kontenGambar.create({
          data: {
            id_konten: createdKonten.id_konten,
            imageSource: faker.image.url(),
            resolusi: `${faker.number.int({ min: 720, max: 2160 })}p`,
            format: faker.helpers.arrayElement(["jpg", "png", "webp"]),
            id_order: orderSpecialContent.id_order,
          },
        });
      } else {
        await prisma.kontenGambar.create({
          data: {
            id_konten: createdKonten.id_konten,
            id_order: undefined,
            imageSource: faker.image.url(),
            resolusi: `${faker.number.int({ min: 720, max: 2160 })}p`,
            format: faker.helpers.arrayElement(["jpg", "png", "webp"]),
          },
        });
      }
    } else if (typeContent === "Teks") {
      await prisma.kontenTeks.create({
        data: {
          id_konten: createdKonten.id_konten,
          textSource: faker.lorem.paragraphs(3),
          jumlah_kata: faker.number.int({ min: 100, max: 2000 }),
          format: faker.helpers.arrayElement(["markdown", "txt", "html"]),
        },
      });
    } else if (typeContent === "Audio") {
      await prisma.kontenAudio.create({
        data: {
          id_konten: createdKonten.id_konten,
          audioSource: faker.internet.url(),
          durasi: faker.number.int({ min: 30, max: 600 }), // seconds
          kualitas: faker.helpers.arrayElement([
            "128kbps",
            "256kbps",
            "320kbps",
          ]),
        },
      });
    } else if (typeContent === "Video") {
      await prisma.kontenVideo.create({
        data: {
          id_konten: createdKonten.id_konten,
          videoSource: faker.internet.url(),
          durasi: faker.number.int({ min: 60, max: 3600 }),
          resolusi: faker.helpers.arrayElement(["720p", "1080p", "4K"]),
        },
      });
    }
  }

  const kreatorIds = (
    await prisma.kreator.findMany({
      select: { id_kreator: true },
    })
  ).map((k) => k.id_kreator);

  // Salin array kreator
  const kreatorPool = [...kreatorIds];

  while (kreatorPool.length > 0) {
    // Pilih salah satu kreator secara acak
    const randomIndex = Math.floor(Math.random() * kreatorPool.length);
    const selectedKreatorId = kreatorPool[randomIndex];

    // Hitung jumlah tier yang sudah dibuat
    const tierCount = await prisma.membershipTier.count({
      where: { id_kreator: selectedKreatorId },
    });

    if (tierCount >= 5) {
      // Jika sudah penuh, hapus dari pool
      kreatorPool.splice(randomIndex, 1);
      continue;
    }

    // Tambahkan satu tier
    await prisma.membershipTier.create({
      data: {
        id_kreator: selectedKreatorId,
        nama_membership: faker.word.adjective() + "-" + faker.word.noun(),
        deskripsi: faker.lorem.sentence(),
        harga_bulanan: parseFloat(
          faker.commerce.price({ min: 10000, max: 1000000 })
        ),
        daftar_manfaat: faker.lorem.sentences(2),
      },
    });
  }

  const kontenList = await prisma.konten.findMany();
  const membershipList = await prisma.membershipTier.findMany();

  for (let i = 0; i < 50; i++) {
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

    const tier =
      membershipList[Math.floor(Math.random() * membershipList.length)];

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
          jumlah: faker.number.int({ min: 1, max: 10 }),
          mode_pembayaran: faker.helpers.arrayElement(["Transfer", "E-Wallet"]),
          status: faker.helpers.arrayElement(["Aktif", "Pending", "Expired"]),
        },
      });
    }
  }

  const kontenIds = kontenList.map((konten) => konten.id_konten);

  for (let i = 0; i < 30; i++) {
    const randomKontenId =
      kontenIds[Math.floor(Math.random() * kontenIds.length)];
    await prisma.merchandise.create({
      data: {
        nama: faker.commerce.productName(),
        id_konten: randomKontenId,
        harga: parseFloat(faker.commerce.price({ min: 10000, max: 1500000 })),
        stok: faker.number.int({ min: 10, max: 100 }),
        deskripsi: faker.commerce.productDescription(),
      },
    });
  }

  const merchandiseList = await prisma.merchandise.findMany();

  // Try to create 50 unique pembelian records
  const usedPairs = new Set();
  let successfulCreations = 0;
  let attempts = 0;
  const maxAttempts = 1000;
  while (successfulCreations < 50 && attempts < maxAttempts) {
    attempts++;
    const merchandise =
      merchandiseList[Math.floor(Math.random() * merchandiseList.length)];
    const supporter = getRandomSupporter();

    // Create a unique key for this combination
    const pairKey = `${merchandise.id_merchandise}-${supporter.id_pendukung}`;

    // Skip if we've already used this combination
    if (usedPairs.has(pairKey)) {
      continue;
    }

    usedPairs.add(pairKey);

    try {
      const quantity = faker.number.int({ min: 1, max: 5 });
      const totalPrice = Number(merchandise.harga) * quantity;

      await prisma.pembelian.create({
        data: {
          id_merchandise: merchandise.id_merchandise,
          id_pendukung: supporter.id_pendukung,
          jumlah: quantity,
          tanggal_pembelian: faker.date.recent(),
          metode_pembayaran: faker.helpers.arrayElement([
            "Transfer Bank",
            "E-Wallet",
            "Kartu Kredit",
            "QRIS",
          ]),
          total_harga: totalPrice,
        },
      });

      successfulCreations++;
    } catch (error) {
      // @ts-ignore
      if (!error.message.includes("Unique constraint")) {
        throw error;
      }
      console.warn(`⚠️ [SEED] Duplicate pembelian detected: ${pairKey}`);
    }
  }

  console.log(
    `✅ [SEED] Created ${successfulCreations} pembelian records after ${attempts} attempts`
  );

  for (let i = 0; i < 40; i++) {
    const konten = kontenList[Math.floor(Math.random() * kontenList.length)];

    try {
      // Find all existing active subscriptions
      const activeLangganans = await prisma.langganan.findMany({
        where: {
          status: "Aktif",
        },
        include: {
          membershipTier: true,
        },
      });

      if (activeLangganans.length > 0) {
        // Use a random active subscription
        const randomActiveLangganan =
          activeLangganans[Math.floor(Math.random() * activeLangganans.length)];

        await prisma.aksesKonten.create({
          data: {
            id_konten: konten.id_konten,
            id_kreator: randomActiveLangganan.id_kreator,
            nama_membership: randomActiveLangganan.nama_membership,
          },
        });
      } else {
        // Create a new active subscription and then create access
        const supporter = getRandomSupporter();
        const tier =
          membershipList[Math.floor(Math.random() * membershipList.length)];

        // Check if this combination already exists
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
          // Create active subscription
          await prisma.langganan.create({
            data: {
              id_kreator: tier.id_kreator,
              nama_membership: tier.nama_membership,
              id_pendukung: supporter.id_pendukung,
              tanggal_pembayaran_terakhir: faker.date.recent(),
              jumlah: faker.number.int({ min: 1, max: 10 }),
              mode_pembayaran: faker.helpers.arrayElement([
                "Transfer",
                "E-Wallet",
              ]),
              status: "Aktif",
            },
          });

          // Now create the access
          await prisma.aksesKonten.create({
            data: {
              id_konten: konten.id_konten,
              id_kreator: tier.id_kreator,
              nama_membership: tier.nama_membership,
            },
          });
        }
      }
    } catch (error) {
      // @ts-ignore
      if (!error.message.includes("Unique constraint")) {
        console.warn(
          // @ts-ignore
          `⚠️ [SEED] Failed to create AksesKonten: ${error.message}`
        );
      }
    }
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
