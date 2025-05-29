// combine type.sql, database.sql, transition.sql to one file

import { readFileSync, writeFileSync } from "fs";
import { join } from "path";
import { fileURLToPath } from "url";

const __dirname = fileURLToPath(new URL(".", import.meta.url));

const typeSqlPath = join(__dirname, "type.sql");
const databaseSqlPath = join(__dirname, "database.sql");
const transitionSqlPath = join(__dirname, "transition.sql");
const outputSqlPath = join(__dirname, "../0_combined.sql");
const fiturTambahan1SqlPath = join (__dirname, "fitur_tambahan_1.sql");

function combineSqlFiles() {
  const typeSql = readFileSync(typeSqlPath, "utf8");
  const databaseSql = readFileSync(databaseSqlPath, "utf8");
  const transitionSql = readFileSync(transitionSqlPath, "utf8");
  const fiturTambahan1Sql = readFileSync(fiturTambahan1SqlPath, "utf8");

  const combinedSql = `-- Type Constraints\n${typeSql}\n\n-- Database Constraints\n${databaseSql}\n\n-- Transition Constraints\n${transitionSql}\n\n-- Fitur Tambahan\n${fiturTambahan1Sql}`;

  writeFileSync(outputSqlPath, combinedSql, "utf8");
  console.log("SQL files combined successfully into combined.sql");
}

combineSqlFiles();
