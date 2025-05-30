// combine type.sql, database.sql, transition.sql to one file

import { readFileSync, writeFileSync, readdirSync, statSync } from "fs";
import { join } from "path";
import { fileURLToPath } from "url";

const __dirname = fileURLToPath(new URL(".", import.meta.url));

const typeSqlPath = join(__dirname, "type.sql");
const databaseSqlPath = join(__dirname, "database.sql");
const transitionSqlPath = join(__dirname, "transition.sql");
const fiturTambahan1SqlPath = join(__dirname, "fitur_tambahan_1.sql");

function findLatestConstraintsMigration(): string | null {
  const migrationsPath = join(__dirname, "../migrations");

  try {
    const migrationFolders = readdirSync(migrationsPath)
      .filter((folder) => {
        const folderPath = join(migrationsPath, folder);
        return statSync(folderPath).isDirectory() && folder.includes("_constraints");
      })
      .sort()
      .reverse(); // Get the latest one first

    if (migrationFolders.length === 0) {
      console.error("❌ No constraints migration folder found");
      return null;
    }

    return join(migrationsPath, migrationFolders[0]);
  } catch (error) {
    console.error("❌ Error reading migrations folder:", error);
    return null;
  }
}

function combineSqlFiles() {
  const typeSql = readFileSync(typeSqlPath, "utf8");
  const databaseSql = readFileSync(databaseSqlPath, "utf8");
  const transitionSql = readFileSync(transitionSqlPath, "utf8");
  const fiturTambahan1Sql = readFileSync(fiturTambahan1SqlPath, "utf8");

  const combinedSql = `-- Type Constraints\n${typeSql}\n\n-- Database Constraints\n${databaseSql}\n\n-- Transition Constraints\n${transitionSql}\n\n-- Fitur Tambahan\n${fiturTambahan1Sql}`;

  // Find the latest constraints migration folder
  const constraintsMigrationPath = findLatestConstraintsMigration();
  if (!constraintsMigrationPath) {
    return;
  }

  const migrationSqlPath = join(constraintsMigrationPath, "migration.sql");

  try {
    writeFileSync(migrationSqlPath, combinedSql, "utf8");

    const folderName = constraintsMigrationPath.split(/[\\\/]/).pop();
    console.log(`✅ SQL files combined successfully into ${folderName}/migration.sql`);
    console.log(`📁 Migration file path: ${migrationSqlPath}`);
  } catch (error) {
    console.error("❌ Error writing to migration file:", error);
  }
}

combineSqlFiles();
