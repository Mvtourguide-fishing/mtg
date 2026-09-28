#!/usr/bin/env node
// Stays/Resorts/Guesthouses/Hotels ecosystem, Phase 1-2: legacy
// resort/hotel/guesthouse page extraction.
//
// The legacy site (release/public_html/resorts/<folder>/, release/public_html/
// hotels/<folder>/) has one primary overview page per property (plus
// non-content *-booking.html sub-pages, already confirmed by the Phase 1
// audit + the existing retired-urls.json migration report to be booking
// widgets, not real content — skipped entirely here) at a consistent
// Bootstrap-era template:
//   - <meta name="description"> repeats the property name + atoll.
//   - Free-text marketing paragraphs (genuinely unique per property).
//   - A "Property Facilities and Services" icon grid — confirmed by the
//     Phase 1 audit to be IDENTICAL boilerplate on every property
//     regardless of tier — NOT extracted as real per-property data.
//   - One <h3> block per room/villa type: name, fixed 2-person price +
//     tax-inclusive price, bed type, max occupancy, a small image
//     carousel, and another boilerplate "Room Facilities" list (also not
//     extracted — same reason).
//   - A YouTube iframe embed (resorts: 109/110; hotels: 1/12).
//
// This script extracts ONLY the real, per-property fields: name, atoll
// mentions (both from <meta description> and body text, kept separate so
// a later verification pass can catch legacy authoring errors — e.g. a
// property whose own text disagrees with itself), an explicit island-name
// mention where the page states one distinct from the resort's own brand
// name, description paragraphs, room/villa entries (name/price/bed/
// occupancy/first two photos), video id, and the images/ directory
// listing. No island/atoll is resolved to a final answer here, and no
// island name is ever inferred from the brand name — that's a deliberate
// separate verification step (this session's established policy: never
// let text-extraction confidence substitute for a checked fact, since the
// Milaidhoo legacy page was independently found here to claim "Male
// Atoll" when it is a real, well-documented Baa Atoll resort).
//
// Read-only against the legacy export. Writes only to
// data/maldives/accommodations-v2/.
//
// Usage: node scripts/extract-legacy-accommodations.mjs

import { load as loadHtml } from "cheerio";
import { existsSync, mkdirSync, readdirSync, readFileSync, rmSync, statSync, writeFileSync } from "node:fs";
import path from "node:path";
import { fileURLToPath } from "node:url";

const __dirname = path.dirname(fileURLToPath(import.meta.url));
const ROOT = path.resolve(__dirname, "..");
const RELEASE_DIR = path.join(ROOT, "release", "public_html");
const RESORTS_DIR = path.join(RELEASE_DIR, "resorts");
const HOTELS_DIR = path.join(RELEASE_DIR, "hotels");
const OUT_DIR = path.join(ROOT, "data", "maldives", "accommodations-v2");
const PROFILES_DIR = path.join(OUT_DIR, "legacy-profiles");
const REPORT_PATH = path.join(OUT_DIR, "legacy-extraction-report.json");

const EXCLUDED_FOLDERS = new Set(["images", "sample", "bookingphp"]);

// Natural/administrative atoll-name aliases as they actually appear in
// legacy prose, mapped to the real administrative code from
// data/maldives/locations/atolls.json. `null` = a genuinely ambiguous
// natural name (spans two administrative atolls) that needs a more
// specific same-page mention to resolve, never guessed.
const ATOLL_ALIASES = {
  "haa alif": "HA", "haa alifu": "HA", "ha alif": "HA", "ha alifu": "HA",
  "haa dhaalu": "HDh", "ha dhaalu": "HDh",
  shaviyani: "Sh",
  noonu: "N",
  raa: "R",
  baa: "B",
  lhaviyani: "Lh",
  kaafu: "K", male: "K", "north male": "K", "south male": "K", "north male'": "K", "south male'": "K",
  "alif alif": "AA", "alifu alifu": "AA", "north ari": "AA", "north ari atoll": "AA",
  "alif dhaalu": "ADh", "alifu dhaalu": "ADh", "south ari": "ADh", "south ari atoll": "ADh",
  ari: null,
  vaavu: "V",
  meemu: "M",
  faafu: "F",
  dhaalu: "Dh",
  thaa: "Th",
  laamu: "L",
  "gaafu alif": "GA", "gaafu alifu": "GA",
  "gaafu dhaalu": "GDh",
  huvadhoo: null,
  gnaviyani: "Gn", fuvahmulah: "Gn",
  seenu: "S", addu: "S",
};

function normalizeAtollPhrase(raw) {
  return raw.toLowerCase().replace(/['’]/g, "").replace(/\s+/g, " ").trim();
}

/** Every distinct real administrative atoll code mentioned in `text`
 * (deduped), plus the raw phrases that didn't resolve (ambiguous natural
 * names or unrecognized text) for the report to surface rather than drop
 * silently. */
function findAtollMentions(text) {
  const codes = new Set();
  const ambiguous = new Set();
  const unresolved = new Set();
  const re = /([A-Z][a-z'’]+(?:\s+[A-Z][a-z'’]+){0,2})\s+[Aa]tolls?\b/g;
  let m;
  while ((m = re.exec(text))) {
    const phrase = normalizeAtollPhrase(m[1]);
    if (!(phrase in ATOLL_ALIASES)) {
      unresolved.add(phrase);
      continue;
    }
    const code = ATOLL_ALIASES[phrase];
    if (code === null) ambiguous.add(phrase);
    else codes.add(code);
  }
  return { codes: Array.from(codes), ambiguous: Array.from(ambiguous), unresolved: Array.from(unresolved) };
}

/** An explicit "situated/located on the island of X" / "on X Island"
 * mention naming a real island distinct from generic phrasing — never a
 * fallback to the brand name. */
function findExplicitIslandName($, bodyText) {
  const patterns = [
    /(?:situated|located)\s+(?:\w+\s+){0,4}?island\s+of\s+([A-Z][A-Za-z'’-]+)/,
    /island\s+(?:of|named|called)\s+([A-Z][A-Za-z'’-]+)/,
  ];
  for (const re of patterns) {
    const match = bodyText.match(re);
    if (match) return match[1].trim();
  }
  return null;
}

function findVideoId(html) {
  const m = html.match(/youtube\.com\/embed\/([A-Za-z0-9_-]{6,})/);
  return m ? m[1] : null;
}

function findStarRating(text) {
  const m = text.match(/\b(one|two|three|four|five|1|2|3|4|5)[\s-]star\b/i);
  if (!m) return null;
  const word = m[1].toLowerCase();
  const map = { one: 1, two: 2, three: 3, four: 4, five: 5 };
  return map[word] ?? Number(word);
}

// #myMenu is a sitewide "Other Resorts"/"Other Hotels" link list appended
// to every property page (confirmed identical structure on Ayada and
// Amra Palace) — it names dozens of OTHER properties' atolls and would
// otherwise swamp this page's own atoll-mention detection with noise.
const NOISE_SELECTORS = ["script", "style", "nav", "header", "header2", "footer", "footer2", ".top-header", "#top-nav", "#myMenu", "#mySearch"];

function extractRooms($) {
  const rooms = [];
  $("h3").each((_, el) => {
    const $h3 = $(el);
    const priceSpan = $h3.find("span.red-text, span").first();
    const priceText = priceSpan.text();
    const priceMatch = priceText.match(/(\d[\d,]*)\s*\$/);
    if (!priceMatch) return; // not a room-pricing h3 (transfer/meal-plan/etc h3s don't match)

    // Room name = the h3's own text with the price span's text removed.
    const fullText = $h3.clone().children("span, p").remove().end().text().trim();
    const name = fullText.replace(/\s+/g, " ").trim();
    if (!name) return;

    const price = Number(priceMatch[1].replace(/,/g, ""));
    const taxText = $h3.find(".text-danger").first().text();
    const taxMatch = taxText.match(/(\d[\d,]*)\s*\$/);
    const priceInclTax = taxMatch ? Number(taxMatch[1].replace(/,/g, "")) : null;

    // Bed type / occupancy: the very next <p> sibling after the h3's
    // containing block, matching the "King - ... Max 3" pattern.
    const $occP = $h3.nextAll("p").first();
    const occText = $occP.text();
    const bedMatch = occText.match(/fa-bed[^>]*>\s*([A-Za-z /]+?)\s*-/) ?? occText.match(/^\s*([A-Za-z /]+?)\s*-/);
    const bedType = bedMatch ? bedMatch[1].trim() : null;
    const maxMatch = occText.match(/Max\s*(\d+)/i);
    const maxOccupancy = maxMatch ? Number(maxMatch[1]) : null;

    // First 1-2 room-specific images: the carousel immediately following
    // this h3, before the next h3.
    const images = [];
    let node = $h3.next();
    let guard = 0;
    while (node.length && node.get(0).tagName?.toLowerCase() !== "h3" && guard < 40) {
      node.find("img").each((_, img) => {
        const src = $(img).attr("src");
        if (src && images.length < 2) images.push(src);
      });
      node = node.next();
      guard += 1;
    }

    rooms.push({ name, price, priceInclTax, currency: "USD", bedType, maxOccupancy, images });
  });
  return rooms;
}

function extractProfile(filePath, meta) {
  const html = readFileSync(filePath, "utf8");
  const $ = loadHtml(html);
  $(NOISE_SELECTORS.join(", ")).remove();

  const metaDescription = $('meta[name="description"]').attr("content")?.trim() ?? null;
  const title = $("title").first().text().trim() || null;
  const h1 = $("main h1").first().text().trim() || $("h1").first().text().trim() || null;

  const bodyText = $("body").text().replace(/\s+/g, " ").trim();

  const metaAtoll = metaDescription ? findAtollMentions(metaDescription) : { codes: [], ambiguous: [], unresolved: [] };
  const bodyAtoll = findAtollMentions(bodyText);
  const explicitIslandName = findExplicitIslandName($, bodyText);
  const videoId = findVideoId(html);
  const starRating = findStarRating(metaDescription ?? "") ?? findStarRating(bodyText);
  const isGuesthouseMention = /guest\s*house/i.test(bodyText);

  // Free-text marketing paragraphs: <p> tags before the first "Property
  // Facilities and Services" boilerplate block, with boilerplate/utility
  // text (nav breadcrumbs, transfer info already captured elsewhere,
  // single-word fragments) filtered out by a minimum length.
  const descriptionParagraphs = [];
  $("main p, body > div p").each((_, el) => {
    if (descriptionParagraphs.length >= 6) return;
    const text = $(el).text().replace(/\s+/g, " ").trim();
    if (text.length < 60) return;
    if (/Including All taxes|Property Facilities|Cancellation Policy|Meal Plans/i.test(text)) return;
    if (!descriptionParagraphs.includes(text)) descriptionParagraphs.push(text);
  });

  const rooms = extractRooms($);

  // Directory listing of this property's own images/ folder (relative to
  // release/public_html), for a later, separate image-attachment script —
  // not matched to entities here.
  const propertyDir = path.dirname(filePath);
  const imagesDir = path.join(propertyDir, "images");
  let imageFiles = [];
  if (existsSync(imagesDir) && statSync(imagesDir).isDirectory()) {
    imageFiles = readdirSync(imagesDir).filter((f) => /\.(webp|jpg|jpeg|png)$/i.test(f));
  }

  return {
    ...meta,
    sourceFile: path.relative(RELEASE_DIR, filePath).split(path.sep).join("/"),
    legacyTitle: title,
    legacyH1: h1,
    metaDescription,
    metaAtollCodes: metaAtoll.codes,
    metaAtollAmbiguous: metaAtoll.ambiguous,
    bodyAtollCodes: bodyAtoll.codes,
    bodyAtollAmbiguous: bodyAtoll.ambiguous,
    bodyAtollUnresolved: bodyAtoll.unresolved,
    explicitIslandName,
    starRating,
    isGuesthouseMention,
    videoId,
    descriptionParagraphs,
    rooms,
    imageDirRelative: path.relative(RELEASE_DIR, imagesDir).split(path.sep).join("/"),
    imageCount: imageFiles.length,
    imageFiles,
  };
}

/** Picks the primary overview page for a property folder — the file
 * whose own name doesn't contain "booking" (case-insensitive), preferring
 * one matching *-Maldives.html (the dominant naming convention confirmed
 * by the Phase 1 audit for 110/138 resorts) if more than one candidate
 * remains. */
function pickPrimaryFile(folderPath) {
  const files = readdirSync(folderPath).filter((f) => f.endsWith(".html") && !/booking/i.test(f));
  if (files.length === 0) return null;
  if (files.length === 1) return files[0];
  const maldivesPattern = files.find((f) => /-maldives\.html$/i.test(f));
  if (maldivesPattern) return maldivesPattern;
  // Fall back to the shortest filename (usually the overview page; longer
  // ones tend to be sub-pages like "...surfandSpa.html").
  return files.sort((a, b) => a.length - b.length)[0];
}

function walkPropertyFolders(baseDir, propertyKind) {
  const results = [];
  const multiFileFolders = [];
  if (!existsSync(baseDir)) return { results, multiFileFolders };
  for (const folder of readdirSync(baseDir)) {
    if (EXCLUDED_FOLDERS.has(folder)) continue;
    const folderPath = path.join(baseDir, folder);
    if (!statSync(folderPath).isDirectory()) continue;

    const allHtml = readdirSync(folderPath).filter((f) => f.endsWith(".html"));
    const nonBooking = allHtml.filter((f) => !/booking/i.test(f));
    if (nonBooking.length > 1) multiFileFolders.push({ folder, files: nonBooking });

    const primary = pickPrimaryFile(folderPath);
    if (!primary) {
      results.push({ folder, propertyKind, status: "no_primary_page_found" });
      continue;
    }
    results.push({ folder, propertyKind, status: "found", filePath: path.join(folderPath, primary) });
  }
  return { results, multiFileFolders };
}

function main() {
  if (existsSync(PROFILES_DIR)) rmSync(PROFILES_DIR, { recursive: true, force: true });
  mkdirSync(PROFILES_DIR, { recursive: true });

  const { results: resortResults, multiFileFolders: resortMultiFile } = walkPropertyFolders(RESORTS_DIR, "resort");
  const { results: hotelResults, multiFileFolders: hotelMultiFile } = walkPropertyFolders(HOTELS_DIR, "hotel_or_guesthouse");

  const allResults = [...resortResults, ...hotelResults];
  const extracted = [];
  const failures = [];
  const noPrimaryPage = [];

  for (const entry of allResults) {
    if (entry.status === "no_primary_page_found") {
      noPrimaryPage.push({ folder: entry.folder, propertyKind: entry.propertyKind });
      continue;
    }
    try {
      const profile = extractProfile(entry.filePath, { folder: entry.folder, propertyKind: entry.propertyKind });
      extracted.push(profile);
      writeFileSync(path.join(PROFILES_DIR, `${entry.propertyKind}--${entry.folder}.json`), JSON.stringify(profile, null, 2) + "\n");
    } catch (err) {
      failures.push({ folder: entry.folder, propertyKind: entry.propertyKind, error: String(err?.message ?? err) });
    }
  }

  // Confidence classification for the atoll, per property: agreement
  // between meta-description and body-text mentions is the strongest
  // signal; anything else needs a human/verification pass before seeding
  // — see the script's header comment on the Milaidhoo self-contradiction
  // this exact check exists to catch.
  const atollConfidence = { agree: 0, metaOnly: 0, bodyOnly: 0, conflict: 0, none: 0, ambiguousOnly: 0 };
  for (const p of extracted) {
    const meta = new Set(p.metaAtollCodes);
    const body = new Set(p.bodyAtollCodes);
    const union = new Set([...meta, ...body]);
    if (union.size === 0) {
      p.atollConfidence = p.metaAtollAmbiguous.length > 0 || p.bodyAtollAmbiguous.length > 0 ? "ambiguousOnly" : "none";
    } else if (union.size > 1) {
      p.atollConfidence = "conflict";
    } else if (meta.size > 0 && body.size > 0) {
      p.atollConfidence = "agree";
    } else if (meta.size > 0) {
      p.atollConfidence = "metaOnly";
    } else {
      p.atollConfidence = "bodyOnly";
    }
    p.resolvedAtollCode = union.size === 1 ? Array.from(union)[0] : null;
    atollConfidence[p.atollConfidence] += 1;
  }
  // Re-write profiles now that atollConfidence/resolvedAtollCode are set.
  for (const p of extracted) {
    writeFileSync(path.join(PROFILES_DIR, `${p.propertyKind}--${p.folder}.json`), JSON.stringify(p, null, 2) + "\n");
  }

  const withExplicitIsland = extracted.filter((p) => p.explicitIslandName).length;
  const guesthouseMentions = extracted.filter((p) => p.isGuesthouseMention && p.propertyKind === "hotel_or_guesthouse").length;
  const withVideo = extracted.filter((p) => p.videoId).length;
  const withRooms = extracted.filter((p) => p.rooms.length > 0).length;
  const totalRooms = extracted.reduce((sum, p) => sum + p.rooms.length, 0);
  const totalImages = extracted.reduce((sum, p) => sum + p.imageCount, 0);

  const report = {
    generatedAt: new Date().toISOString(),
    summary: {
      resortFoldersFound: resortResults.length,
      hotelFoldersFound: hotelResults.length,
      extracted: extracted.length,
      failures: failures.length,
      noPrimaryPage: noPrimaryPage.length,
      multiFileFoldersFlagged: resortMultiFile.length + hotelMultiFile.length,
      atollConfidence,
      withExplicitIslandName: withExplicitIsland,
      withoutExplicitIslandName: extracted.length - withExplicitIsland,
      guesthouseMentionsAmongHotelFolder: guesthouseMentions,
      withVideo,
      withoutVideo: extracted.length - withVideo,
      propertiesWithAtLeastOneRoom: withRooms,
      totalRoomsExtracted: totalRooms,
      totalImagesFound: totalImages,
    },
    noPrimaryPage,
    failures,
    multiFileFolders: { resorts: resortMultiFile, hotels: hotelMultiFile },
    properties: extracted.map((p) => ({
      folder: p.folder,
      propertyKind: p.propertyKind,
      legacyH1: p.legacyH1,
      sourceFile: p.sourceFile,
      atollConfidence: p.atollConfidence,
      resolvedAtollCode: p.resolvedAtollCode,
      metaAtollCodes: p.metaAtollCodes,
      bodyAtollCodes: p.bodyAtollCodes,
      metaAtollAmbiguous: p.metaAtollAmbiguous,
      bodyAtollAmbiguous: p.bodyAtollAmbiguous,
      explicitIslandName: p.explicitIslandName,
      starRating: p.starRating,
      isGuesthouseMention: p.isGuesthouseMention,
      videoId: p.videoId,
      roomCount: p.rooms.length,
      imageCount: p.imageCount,
    })),
  };

  writeFileSync(REPORT_PATH, JSON.stringify(report, null, 2) + "\n");

  console.log(`Resort folders: ${resortResults.length}, Hotel/guesthouse folders: ${hotelResults.length}`);
  console.log(`Extracted: ${extracted.length}, Failures: ${failures.length}, No primary page: ${noPrimaryPage.length}`);
  console.log(`Atoll confidence:`, atollConfidence);
  console.log(`Explicit island name found: ${withExplicitIsland} / ${extracted.length}`);
  console.log(`Guesthouse mentions (of hotel-folder properties): ${guesthouseMentions}`);
  console.log(`With video: ${withVideo} / ${extracted.length}`);
  console.log(`Properties with >=1 room extracted: ${withRooms} / ${extracted.length} (${totalRooms} rooms total)`);
  console.log(`Total images found: ${totalImages}`);
  console.log(`Multi-file folders flagged for review: ${resortMultiFile.length + hotelMultiFile.length}`);
  console.log(`\nWrote ${REPORT_PATH}`);
  console.log(`Wrote ${extracted.length} profiles to ${PROFILES_DIR}/`);
}

main();
