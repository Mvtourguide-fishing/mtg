#!/usr/bin/env node
// One-off helper: runs one or more .sql files directly against a Postgres
// database over a real wire-protocol connection (node-postgres/pg),
// completely bypassing any browser-based SQL editor.
//
// Built because pasting the generated Task 14 migration files into the
// Supabase Studio SQL Editor was producing errors that cited SQL not
// present anywhere in the pasted content (e.g. a line number and an
// ALTER TABLE statement that don't exist in the file at all) — this
// script removes the browser/clipboard/editor entirely from the picture,
// so whatever Postgres receives is provably byte-for-byte the file on
// disk.
//
// Usage:
//   npm install pg
//   DATABASE_URL="postgresql://postgres:PASSWORD@HOST:5432/postgres" \
//     node scripts/run-sql-file.mjs supabase/migrations/20250110000200_legacy_media_attachments.sql
//
// Get the connection string from: Supabase Dashboard -> Project Settings
// -> Database -> Connection string (URI, "Session pooler" or "Direct
// connection" both work). NEVER paste that connection string into a chat
// message or commit it anywhere — it contains your database password.
//
// You can pass several files in one run, applied in order:
//   node scripts/run-sql-file.mjs file1.sql file2.sql file3.sql

import { readFileSync } from "node:fs";
import path from "node:path";

const files = process.argv.slice(2);
const connectionString = process.env.DATABASE_URL;

if (!connectionString) {
  console.error("Set DATABASE_URL first (see this file's header comment for where to find it). Example:");
  console.error('  DATABASE_URL="postgresql://postgres:PASSWORD@HOST:5432/postgres" node scripts/run-sql-file.mjs <file.sql>');
  process.exit(1);
}
if (files.length === 0) {
  console.error("Usage: node scripts/run-sql-file.mjs <file1.sql> [file2.sql ...]");
  process.exit(1);
}

const { Client } = await import("pg");

async function runFile(client, filePath) {
  const sql = readFileSync(filePath, "utf8");
  console.log(`\nRunning ${filePath} (${sql.length} bytes, ${sql.split("\n").length} lines)...`);
  await client.query(sql);
  console.log(`OK: ${filePath}`);
}

async function main() {
  // Supabase requires SSL. rejectUnauthorized: false skips CA-chain
  // verification (acceptable for this one-off local troubleshooting
  // script — the connection is still encrypted, just not certificate-
  // pinned) rather than requiring you to source Supabase's CA bundle.
  const client = new Client({ connectionString, ssl: { rejectUnauthorized: false } });
  await client.connect();
  try {
    for (const file of files) {
      await runFile(client, path.resolve(file));
    }
    console.log("\nAll files ran successfully.");
  } finally {
    await client.end();
  }
}

main().catch((err) => {
  console.error("\nFAILED:", err.message);
  if (err.position) {
    console.error(`(Postgres error position: character ${err.position} in the submitted SQL)`);
  }
  process.exit(1);
});
