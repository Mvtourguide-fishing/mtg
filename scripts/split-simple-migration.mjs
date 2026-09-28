#!/usr/bin/env node
// Generic sibling to scripts/split-migration-file.mjs, for a migration
// file made of repeated "-- <slug>\n<one statement>;" blocks (rather than
// that script's multi-statement "-- Article: ..." blocks) — e.g.
// 20250122000100_island_content_attributes.sql, whose 1MB size the
// Supabase Studio SQL Editor refuses outright ("Query is too large to be
// run via the SQL Editor"). Same fix: split into several independently
// pasteable chunks, each safe to re-run (every source block here is a
// `coalesce(...) || jsonb` merge, so applying the same chunk twice is a
// no-op the second time).
//
// Splits on lines matching /^-- \S+$/ (a bare "-- slug" comment, not a
// prose comment line or a "-- Article: ..." style marker) — the file's
// own preamble (everything before the first such marker) is repeated at
// the top of every chunk.
//
// Usage:
//   node scripts/split-simple-migration.mjs <input.sql> <outputDir> [maxBytesPerChunk]

import { mkdirSync, readFileSync, writeFileSync } from "node:fs";
import path from "node:path";

const [, , inputPath, outputDir, maxBytesArg] = process.argv;
const MAX_BYTES = Number(maxBytesArg ?? 150_000);

if (!inputPath || !outputDir) {
  console.error("Usage: node scripts/split-simple-migration.mjs <input.sql> <outputDir> [maxBytesPerChunk]");
  process.exit(1);
}

const text = readFileSync(inputPath, "utf8");
const markerRe = /^-- \S+$/m;
const firstMarkerIndex = text.search(markerRe);
if (firstMarkerIndex === -1) {
  console.error("No bare '-- <slug>' markers found — is this the right file?");
  process.exit(1);
}

const preamble = text.slice(0, firstMarkerIndex);
const body = text.slice(firstMarkerIndex);

const blocks = body.split(/(?=^-- \S+$)/m).filter((b) => b.trim().length > 0);

mkdirSync(outputDir, { recursive: true });

const chunks = [];
let current = [];
let currentSize = preamble.length;

for (const block of blocks) {
  if (currentSize + block.length > MAX_BYTES && current.length > 0) {
    chunks.push(current);
    current = [];
    currentSize = preamble.length;
  }
  current.push(block);
  currentSize += block.length;
}
if (current.length > 0) chunks.push(current);

const digits = String(chunks.length).length;
chunks.forEach((chunkBlocks, i) => {
  const partNum = String(i + 1).padStart(digits, "0");
  const outPath = path.join(outputDir, `part-${partNum}-of-${chunks.length}.sql`);
  const content =
    `-- Part ${i + 1} of ${chunks.length} - run this in the Supabase SQL Editor AFTER the previous parts.\n` +
    `-- Safe to re-run: every statement is a jsonb merge (coalesce(...) || ...).\n\n` +
    preamble +
    chunkBlocks.join("\n");
  writeFileSync(outPath, content);
  console.log(`Wrote ${outPath} (${(content.length / 1024).toFixed(1)} KB, ${chunkBlocks.length} blocks)`);
});

console.log(`\nSplit ${blocks.length} blocks into ${chunks.length} parts.`);
