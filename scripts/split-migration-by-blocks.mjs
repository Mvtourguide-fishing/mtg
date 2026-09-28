#!/usr/bin/env node
// Most general of the three split-migration-*.mjs helpers: splits on
// blank-line boundaries between statement groups (every generator script
// in this codebase separates its statements/blocks with a blank
// `lines.push("")`), rather than relying on a specific comment-marker
// convention — works for any generated migration file regardless of its
// internal comment style, unlike split-migration-file.mjs ("-- Article:
// ..." blocks) or split-simple-migration.mjs ("-- <slug>\n<statement>;"
// blocks). Same fix, same reason: the Supabase Studio SQL Editor refuses
// to run very large files as a single paste.
//
// Never splits inside a statement — only at a blank line, so a chunk
// boundary can never land mid-INSERT.
//
// Usage:
//   node scripts/split-migration-by-blocks.mjs <input.sql> <outputDir> [maxBytesPerChunk]

import { mkdirSync, readFileSync, writeFileSync } from "node:fs";
import path from "node:path";

const [, , inputPath, outputDir, maxBytesArg] = process.argv;
const MAX_BYTES = Number(maxBytesArg ?? 150_000);

if (!inputPath || !outputDir) {
  console.error("Usage: node scripts/split-migration-by-blocks.mjs <input.sql> <outputDir> [maxBytesPerChunk]");
  process.exit(1);
}

const text = readFileSync(inputPath, "utf8");
const lines = text.split("\n");

// Preamble = every leading line that's blank or a "--" comment, up to
// (not including) the first real SQL line.
let preambleEnd = 0;
while (preambleEnd < lines.length) {
  const line = lines[preambleEnd];
  if (line.trim() === "" || line.trimStart().startsWith("--")) {
    preambleEnd += 1;
  } else {
    break;
  }
}
const preamble = lines.slice(0, preambleEnd).join("\n") + (preambleEnd > 0 ? "\n\n" : "");
const body = lines.slice(preambleEnd).join("\n");

// Blocks = groups of consecutive non-blank lines (one or more
// blank lines between them is the split point).
const blocks = body.split(/\n{2,}/).map((b) => b.trim()).filter((b) => b.length > 0);

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
  currentSize += block.length + 2;
}
if (current.length > 0) chunks.push(current);

const digits = String(chunks.length).length;
chunks.forEach((chunkBlocks, i) => {
  const partNum = String(i + 1).padStart(digits, "0");
  const outPath = path.join(outputDir, `part-${partNum}-of-${chunks.length}.sql`);
  const content =
    `-- Part ${i + 1} of ${chunks.length} - run this in the Supabase SQL Editor AFTER the previous parts.\n` +
    `-- Safe to re-run: every statement in the source file is idempotent (on\n` +
    `-- conflict do nothing / coalesce jsonb merge).\n\n` +
    preamble +
    chunkBlocks.join("\n\n");
  writeFileSync(outPath, content + "\n");
  console.log(`Wrote ${outPath} (${(content.length / 1024).toFixed(1)} KB, ${chunkBlocks.length} blocks)`);
});

console.log(`\nSplit ${blocks.length} blocks into ${chunks.length} parts.`);
