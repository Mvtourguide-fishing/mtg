#!/usr/bin/env node
// One-off helper: splits a large generated migration SQL file into several
// smaller, independently-runnable files — for when pasting one huge file
// into a web-based SQL editor is unreliable (see Task 14's article
// migration: a single 899KB paste produced inexplicable errors in the
// Supabase Studio SQL Editor that repeated troubleshooting couldn't
// resolve; smaller pastes are a pragmatic workaround).
//
// Splits on the "-- Article: ..." comment markers
// scripts/import-legacy-articles.mjs emits before each article's block of
// statements, grouping consecutive articles into chunks up to a target
// byte size. The shared preamble (header comments + category-creation
// statements) is repeated at the top of EVERY chunk — safe, since every
// statement in it is `on conflict ... do nothing`, so running it more
// than once is a no-op.
//
// Usage:
//   node scripts/split-migration-file.mjs <input.sql> <outputDir> [maxBytesPerChunk]

import { mkdirSync, readFileSync, writeFileSync } from "node:fs";
import path from "node:path";

const [, , inputPath, outputDir, maxBytesArg] = process.argv;
const MAX_BYTES = Number(maxBytesArg ?? 150_000);

if (!inputPath || !outputDir) {
  console.error("Usage: node scripts/split-migration-file.mjs <input.sql> <outputDir> [maxBytesPerChunk]");
  process.exit(1);
}

const text = readFileSync(inputPath, "utf8");
const markerRe = /^-- Article: .*$/m;
const firstMarkerIndex = text.search(markerRe);
if (firstMarkerIndex === -1) {
  console.error("No '-- Article: ...' markers found — is this the right file?");
  process.exit(1);
}

const preamble = text.slice(0, firstMarkerIndex);
const body = text.slice(firstMarkerIndex);

// Split into per-article blocks: each starts at a "-- Article:" line and
// runs until the next one (or end of file).
const blocks = body.split(/(?=^-- Article: )/m).filter((b) => b.trim().length > 0);

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
    `-- Safe to re-run: every statement uses "on conflict ... do nothing".\n\n` +
    preamble +
    chunkBlocks.join("\n");
  writeFileSync(outPath, content);
  console.log(`Wrote ${outPath} (${(content.length / 1024).toFixed(1)} KB, ${chunkBlocks.length} articles)`);
});

console.log(`\nSplit ${blocks.length} articles into ${chunks.length} parts.`);
