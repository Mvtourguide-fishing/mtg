// Shared helpers for the Task 14 legacy-migration scripts
// (import-legacy-media.mjs, import-legacy-articles.mjs). Not part of the
// application — dev/migration tooling only, never imported from src/.

import { createHash } from "node:crypto";
import { existsSync, readFileSync } from "node:fs";
import path from "node:path";
import { fileURLToPath } from "node:url";

export const __dirname = path.dirname(fileURLToPath(import.meta.url));
export const ROOT = path.resolve(__dirname, "..", "..");
export const RELEASE_DIR = path.join(ROOT, "release", "public_html");
export const DATA_DIR = path.join(ROOT, "data", "maldives");

// Identical to every generate-*-seed.mjs script's own copy (Tasks 4-11) —
// duplicated here rather than imported, since those scripts intentionally
// have no shared module of their own yet and this stays a read-only
// migration-tooling concern.
export function slugify(input) {
  return String(input)
    .normalize("NFD")
    .replace(/[̀-ͯ]/g, "")
    .replace(/['’]/g, "")
    .toLowerCase()
    .replace(/[^a-z0-9]+/g, "-")
    .replace(/^-+|-+$/g, "");
}

// Accented/"smart"-typography characters (Malé, curly quotes, em dashes,
// ellipses — all genuinely present in the legacy content) were traced to
// real, reproducible failures when a generated migration SQL file was
// copy-pasted into the Supabase Studio SQL Editor: some Windows/browser
// clipboard path was corrupting or dropping specific non-ASCII bytes,
// silently truncating statements or scrambling nearby text (surfaced as,
// e.g., "relation \"crystal\" does not exist" — a word from unrelated
// prose ending up mid-statement). Transliterating to plain ASCII before
// this text ever reaches a SQL string literal makes that whole class of
// corruption structurally impossible, at the cost of e.g. "Malé"
// rendering as "Male" in generated SQL values (titles/slugs elsewhere in
// the app are unaffected — this only touches text embedded in migration
// SQL). Used by both import scripts' sqlString().
const SMART_CHAR_MAP = {
  "‘": "'",
  "’": "'",
  "“": '"',
  "”": '"',
  "–": "-",
  "—": "-",
  "…": "...",
  " ": " ",
};

export function toAsciiSafe(input) {
  if (input === null || input === undefined) return input;
  let text = String(input);
  for (const [char, replacement] of Object.entries(SMART_CHAR_MAP)) {
    text = text.split(char).join(replacement);
  }
  text = text.normalize("NFD").replace(/[̀-ͯ]/g, "");
  text = text.replace(/[^\x00-\x7F]/g, "");
  return text;
}

export function assignUniqueSlug(name, existingSlugs, disambiguator) {
  let slug = slugify(name);
  if (!existingSlugs.has(slug)) {
    existingSlugs.add(slug);
    return slug;
  }
  const withDisambiguator = `${slug}-${slugify(disambiguator ?? "")}`;
  if (!existingSlugs.has(withDisambiguator)) {
    existingSlugs.add(withDisambiguator);
    return withDisambiguator;
  }
  let n = 2;
  let candidate = `${withDisambiguator}-${n}`;
  while (existingSlugs.has(candidate)) {
    n += 1;
    candidate = `${withDisambiguator}-${n}`;
  }
  existingSlugs.add(candidate);
  return candidate;
}

const TOKEN_STOPWORDS = new Set([
  "the", "and", "for", "with", "from", "maldives", "island", "islands",
  "atoll", "atolls", "resort", "resorts", "hotel", "hotels", "guesthouse",
  "guesthouses", "villa", "villas", "images", "image", "photo", "photos",
  "pic", "pics", "img", "booking", "package", "packages", "of", "in", "at",
  "to", "a", "an", "new", "best", "top", "info", "information", "page",
  "view", "gallery", "index", "html",
]);

/** lowercase, accent-stripped, hyphen-split tokens — same folding as
 * slugify() but returned as an array instead of a joined string. */
export function tokenize(input) {
  return slugify(input).split("-").filter(Boolean);
}

/** tokenize() with generic/noise words removed — used for match scoring
 * so "maldives-resort-photo.jpg" doesn't score every resort in the
 * dataset a "match" purely on boilerplate words. */
export function distinctiveTokens(input) {
  return tokenize(input).filter((t) => !TOKEN_STOPWORDS.has(t) && t.length > 2 && !/^\d+$/.test(t));
}

/** Same deterministic-uuid trick used throughout Tasks 10-11 for tables
 * without a natural unique key (transfer_services, package_itinerary_items)
 * — re-running a migration generator against unchanged input always
 * produces the same id, so ON CONFLICT (id) DO NOTHING is genuinely
 * idempotent. Shared here so the media-import and article-import scripts
 * derive identical media_assets ids for the same source file. */
export function deterministicUuid(key) {
  const hex = createHash("sha1").update(key).digest("hex").slice(0, 32);
  return `${hex.slice(0, 8)}-${hex.slice(8, 12)}-${hex.slice(12, 16)}-${hex.slice(16, 20)}-${hex.slice(20, 32)}`;
}

/**
 * The single canonical Supabase Storage path for a legacy media file,
 * derived only from its relativePath (never from which entity or article
 * happens to reference it). Both import-legacy-media.mjs and
 * import-legacy-articles.mjs must use this — a physical file has exactly
 * one storage location, and its media_assets row (keyed by the same
 * deterministicUuid("legacy-media::" + relativePath)) must have exactly
 * one storage_path. Two scripts computing different paths for the same
 * file would mean whichever migration happens to run first silently wins
 * (ON CONFLICT DO NOTHING on the shared id) and the loser's own path is
 * simply wrong — a real bug caught by comparing both generated migrations.
 */
export function storagePathForRelativePath(relativePath) {
  // relativePath is always forward-slash-joined (Task 14 convention —
  // see buildEntityIndex/media-inventory) regardless of host OS, so this
  // splits on "/" directly rather than going through node:path, which
  // would use backslashes on Windows.
  const segments = relativePath.split("/");
  const filename = segments.pop();
  const extMatch = filename.match(/\.[a-zA-Z0-9]+$/);
  const ext = extMatch ? extMatch[0].toLowerCase() : "";
  const base = slugify(ext ? filename.slice(0, -ext.length) : filename);
  const dir = segments.map((segment) => slugify(segment)).join("/");
  return `legacy/${dir ? `${dir}/` : ""}${base}${ext}`;
}

export function loadJson(...segments) {
  const full = path.join(DATA_DIR, ...segments);
  if (!existsSync(full)) throw new Error(`Missing required data file: ${full}`);
  return JSON.parse(readFileSync(full, "utf8"));
}

/**
 * Reconstructs (best-effort — for matching/review, not a guaranteed exact
 * mirror of the live database) the real MTG entity catalogue this
 * migration must match legacy media/content against: every atoll, island
 * (inhabited + the uninhabited resort islands Task 5 added), accommodation,
 * activity (general/diving/fishing/surfing all share one table), dive
 * site, surf break, package, and transfer route, each with its
 * reconstructed slug, title, canonical href, and a distinctive-token set
 * for matching.
 */
export function buildEntityIndex() {
  const entities = [];
  const usedLocationSlugs = new Set();
  const atollSlugByCode = new Map();
  const atollNameByCode = new Map();

  const atolls = loadJson("locations", "atolls.json");
  const islands = loadJson("locations", "islands.json");

  usedLocationSlugs.add("maldives");
  entities.push({
    type: "country",
    slug: "maldives",
    title: "Maldives",
    href: "/maldives/",
    tokens: new Set(["maldives"]),
  });

  for (const atoll of atolls) {
    if (!atoll.administrative_code || !atoll.name) continue;
    const slugBaseName = atoll.name.replace(/\s+Atoll$/i, "");
    const slug = assignUniqueSlug(slugBaseName, usedLocationSlugs, atoll.administrative_code);
    atollSlugByCode.set(atoll.administrative_code, slug);
    atollNameByCode.set(atoll.administrative_code, atoll.name);
    entities.push({
      type: "atoll",
      slug,
      title: atoll.name,
      administrativeCode: atoll.administrative_code,
      href: `/maldives/atolls/${slug}/`,
      tokens: new Set([...distinctiveTokens(atoll.name), atoll.administrative_code.toLowerCase()]),
    });
  }

  const islandSlugByKey = new Map(); // `${name}::${atollCode}` -> slug
  for (const island of islands) {
    if (!island.name || !island.atoll_administrative_code) continue;
    const atollSlug = atollSlugByCode.get(island.atoll_administrative_code);
    if (!atollSlug) continue;
    const slug = assignUniqueSlug(island.name, usedLocationSlugs, atollSlug);
    islandSlugByKey.set(`${island.name}::${island.atoll_administrative_code}`, slug);
    entities.push({
      type: "island",
      slug,
      title: island.name,
      atollSlug,
      isInhabited: true,
      href: `/maldives/islands/${slug}/`,
      tokens: new Set(distinctiveTokens(island.name)),
    });
  }

  // Uninhabited resort islands — Task 5 seeds one per accommodation whose
  // `island_is_inhabited` is false and it isn't already in islands.json.
  // Same disjoint-slug-namespace caveat as the real generator (see this
  // file's header note): best-effort, for matching/review.
  const accommodations = loadJson("accommodations", "accommodations.json");
  for (const acc of accommodations) {
    if (acc.island_is_inhabited !== false) continue;
    const key = `${acc.island_name}::${acc.atoll_administrative_code}`;
    if (islandSlugByKey.has(key)) continue;
    const atollSlug = atollSlugByCode.get(acc.atoll_administrative_code);
    if (!atollSlug) continue;
    const slug = assignUniqueSlug(acc.island_name, usedLocationSlugs, atollSlug);
    islandSlugByKey.set(key, slug);
    entities.push({
      type: "island",
      slug,
      title: acc.island_name,
      atollSlug,
      isInhabited: false,
      href: `/maldives/islands/${slug}/`,
      tokens: new Set(distinctiveTokens(acc.island_name)),
    });
  }

  // Accommodations
  const usedAccommodationSlugs = new Set();
  const SEGMENT = { hotel: "hotels", resort: "resorts", guesthouse: "guesthouses", villa: "villas", other: "hotels" };
  for (const acc of accommodations) {
    const slug = assignUniqueSlug(acc.name, usedAccommodationSlugs, acc.island_name);
    const segment = SEGMENT[acc.accommodation_type] ?? "hotels";
    entities.push({
      type: acc.accommodation_type,
      slug,
      title: acc.name,
      href: `/maldives/${segment}/${slug}/`,
      atollCode: acc.atoll_administrative_code,
      islandName: acc.island_name,
      tokens: new Set([
        ...distinctiveTokens(acc.name),
        ...distinctiveTokens(acc.island_name ?? ""),
        ...distinctiveTokens(acc.operator_name ?? ""),
      ]),
    });
  }

  // Activities — general + diving + fishing + surfing all share one table
  // and one URL space, but diving/fishing/surfing each have their own
  // dedicated route segment (Tasks 7-9).
  const usedActivitySlugs = new Set();
  function addActivities(file, categorySegment) {
    const rows = loadJson(...file);
    for (const row of rows) {
      const slug = assignUniqueSlug(row.name, usedActivitySlugs, row.operator_name ?? row.island_name ?? "");
      entities.push({
        type: categorySegment === "activities" ? "activity" : categorySegment,
        slug,
        title: row.name,
        href: `/maldives/${categorySegment}/${slug}/`,
        atollCode: row.atoll_administrative_code,
        islandName: row.island_name,
        tokens: new Set([
          ...distinctiveTokens(row.name),
          ...distinctiveTokens(row.island_name ?? ""),
          ...distinctiveTokens(row.operator_name ?? ""),
        ]),
      });
    }
  }
  addActivities(["activities", "activities.json"], "activities");
  addActivities(["diving", "activities.json"], "diving");
  addActivities(["fishing", "activities.json"], "fishing");
  addActivities(["surfing", "activities.json"], "surfing");

  // Dive sites / surf breaks (physical locations, not bookable — Tasks 8-9)
  const usedSiteSlugs = new Set();
  for (const site of loadJson("diving", "dive_sites.json")) {
    const slug = assignUniqueSlug(site.name, usedSiteSlugs, site.nearby_island_name ?? "");
    entities.push({
      type: "dive_site",
      slug,
      title: site.name,
      href: `/maldives/dive-sites/${slug}/`,
      atollCode: site.atoll_administrative_code,
      islandName: site.nearby_island_name,
      tokens: new Set([...distinctiveTokens(site.name), ...distinctiveTokens(site.nearby_island_name ?? "")]),
    });
  }
  const usedBreakSlugs = new Set();
  for (const brk of loadJson("surfing", "surf_breaks.json")) {
    const slug = assignUniqueSlug(brk.name, usedBreakSlugs, brk.nearby_island_name ?? "");
    entities.push({
      type: "surf_break",
      slug,
      title: brk.name,
      href: `/maldives/surf-breaks/${slug}/`,
      atollCode: brk.atoll_administrative_code,
      islandName: brk.nearby_island_name,
      tokens: new Set([...distinctiveTokens(brk.name), ...distinctiveTokens(brk.nearby_island_name ?? "")]),
    });
  }

  // Packages
  const usedPackageSlugs = new Set();
  for (const pkg of loadJson("packages", "packages.json")) {
    const slug = assignUniqueSlug(pkg.name, usedPackageSlugs);
    entities.push({
      type: "package",
      slug,
      title: pkg.name,
      href: `/maldives/packages/${slug}/`,
      tokens: new Set(distinctiveTokens(pkg.name)),
    });
  }

  // Transfer routes (route = discoverable node; individual services are
  // not their own SEO entity — Task 10/13 convention)
  const usedRouteSlugs = new Set();
  const routeSeen = new Set();
  for (const route of loadJson("transfers", "routes.json")) {
    if (!route.origin_name || !route.destination_name) continue;
    const key = `${route.origin_name}->${route.destination_name}`;
    if (routeSeen.has(key)) continue;
    routeSeen.add(key);
    const originSlug = slugify(route.origin_name);
    const destSlug = slugify(route.destination_name);
    const slug = assignUniqueSlug(`${originSlug}-to-${destSlug}`, usedRouteSlugs);
    entities.push({
      type: "transfer_route",
      slug,
      title: `${route.origin_name} to ${route.destination_name}`,
      href: `/maldives/transfers/${slug}/`,
      tokens: new Set([...distinctiveTokens(route.origin_name), ...distinctiveTokens(route.destination_name)]),
    });
  }

  return entities;
}

// The legacy site's atolls/<folder>/ names use slightly different
// transliteration than our seeded atoll names in a few cases (e.g.
// "alifu-alifu" vs. our "Alif Alif Atoll", "alifu-dhaalu" vs. "Alif
// Dhaal Atoll") — close enough to read, but NOT a safe token-overlap
// match (naive matching mis-scored "alifu-alifu" against "Gaafu Alifu
// Atoll" instead, since both names literally contain "alifu"). Rather
// than a fuzzy-matching heuristic for this specific, bounded, known set
// of 20 real atolls, this is an explicit, verified folder-name ->
// administrative-code table.
export const ATOLL_FOLDER_TO_CODE = {
  "alifu-alifu": "AA",
  "alifu-dhaalu": "ADh",
  "baa-atoll": "B",
  "dhaalu-atoll": "Dh",
  "faafu-atoll": "F",
  "gaafu-alifu-atoll": "GA",
  "gaafu-dhaalu-atoll": "GDh",
  "gnaviyani-atoll": "Gn",
  "haa-alifu": "HA",
  "haa-alifu-atoll": "HA",
  "haa-dhaalu-atoll": "HDh",
  "kaafu-atoll": "K",
  "laamu-atoll": "L",
  "lhaviyani-atoll": "Lh",
  "meemu-atoll": "M",
  "noonu-atoll": "N",
  "raa-atoll": "R",
  "seenu-atoll": "S",
  "shaviyani-atoll": "Sh",
  "thaa-atoll": "Th",
  "vaavu-atoll": "V",
};

/** Scores a candidate filename/path's distinctive tokens against one
 * entity's token set — the fraction of the SMALLER token set that's
 * present in the larger one, so a long descriptive filename isn't
 * penalized for containing extra words beyond the entity's own name. */
export function tokenOverlapScore(fileTokens, entityTokens) {
  if (fileTokens.size === 0 || entityTokens.size === 0) return 0;
  let hits = 0;
  for (const t of entityTokens) if (fileTokens.has(t)) hits += 1;
  if (hits === 0) return 0;
  // Jaccard (overlap / union), not overlap / smaller-set-size — the
  // latter lets a single short, generic shared token (e.g. "alifu")
  // claim a perfect score against any entity whose name happens to
  // contain it, regardless of the entity's other, non-matching tokens.
  const union = new Set([...fileTokens, ...entityTokens]).size;
  let score = hits / union;
  // Still give a full-containment match (every entity token present in
  // the file's tokens) a floor, since a longer descriptive filename
  // shouldn't be penalized for containing extra words beyond the
  // entity's own name.
  if (hits === entityTokens.size) score = Math.max(score, 0.7);
  return score;
}
