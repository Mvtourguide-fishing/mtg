// Query normalization and relevance scoring for site-wide search (Task 13
// §8-9). Deliberately simple and deterministic — no fuzzy-matching
// library, no external search index. Handles the normal variation a real
// visitor types (case, extra whitespace, basic punctuation) without
// producing unrelated results.

const MAX_QUERY_LENGTH = 100;

/** Collapses whitespace, strips characters that can't meaningfully match
 * a title anyway (keeps letters/numbers/spaces and a few common
 * punctuation marks used in real titles, e.g. "Malé", "7-Night"), and
 * caps length so a pathological input can't drive an expensive query. */
export function normalizeQuery(raw: string): string {
  return raw
    .normalize("NFC")
    .trim()
    .replace(/\s+/g, " ")
    .replace(/[^\p{L}\p{N}\s'’\-]/gu, "")
    .slice(0, MAX_QUERY_LENGTH);
}

export function tokenize(query: string): string[] {
  return normalizeQuery(query)
    .toLowerCase()
    .split(" ")
    .filter((token) => token.length > 0);
}

function escapeRegExp(value: string): string {
  return value.replace(/[.*+?^${}()|[\]\\]/g, "\\$&");
}

/**
 * Scores how well `title` matches `query`, following the priority order
 * in Task 13 §9: exact > prefix > whole-word > substring > multi-token >
 * unrelated-by-title (only reachable via a location/category match).
 * Deterministic — equal inputs always produce equal scores, so ties fall
 * back to the caller's stable secondary sort (title, then id).
 */
export function scoreTitleMatch(title: string, query: string): number {
  const t = title.toLowerCase();
  const q = query.toLowerCase().trim();
  if (!q) return 0;

  if (t === q) return 100;
  if (t.startsWith(q)) return 85;
  if (new RegExp(`\\b${escapeRegExp(q)}`, "i").test(title)) return 65;
  if (t.includes(q)) return 45;

  const tokens = tokenize(q);
  if (tokens.length > 1) {
    const hits = tokens.filter((token) => t.includes(token)).length;
    if (hits === tokens.length) return 35;
    if (hits > 0) return 20;
  }

  return 0;
}

/** Base score for a result that was only surfaced through a targeted
 * location/category/type expansion (e.g. "resort dhaalu" resolving to
 * accommodations of type=resort in Dhaalu Atoll) rather than a direct
 * title match — still relevant, ranked below anything that matched the
 * title text itself. */
export const EXPANSION_MATCH_SCORE = 15;

/** Strips diacritics for comparison only (never for display) — e.g.
 * "Malé" and "male" both fold to "male". Postgres ILIKE can't do this
 * without the `unaccent` extension, which this task doesn't add, so
 * anywhere the underlying data is compared in application code (the
 * multi-token AND filter below) folds first. */
export function foldDiacritics(value: string): string {
  return value.normalize("NFD").replace(/[̀-ͯ]/g, "").toLowerCase();
}

/** True when every token appears in `title` as a substring, accent- and
 * case-insensitively — the fallback relevance test for multi-word queries
 * whose words don't appear contiguously in that order in the real title
 * (e.g. "airport maafushi" against "Velana International Airport to
 * Maafushi", or plain "male" against "Malé"). */
export function tokensAllPresent(title: string, tokens: string[]): boolean {
  const folded = foldDiacritics(title);
  return tokens.every((token) => folded.includes(foldDiacritics(token)));
}

// A small, explicit table of known real place-name spellings that a
// visitor will very commonly type without the accent (Task 13 §8: "common
// spelling differences where safely possible" — deliberately narrow, not
// a general fuzzy-matching system). Longer/more specific patterns are
// listed first so e.g. "male city" is replaced whole rather than leaving
// a dangling "city" after a bare "male" substitution.
const KNOWN_PLACE_NAME_VARIANTS: Array<[RegExp, string]> = [
  [/\bmale city\b/gi, "Malé City"],
  [/\bhulhumale\b/gi, "Hulhumalé"],
  [/\bvillimale\b/gi, "Villimalé"],
  [/\bmale\b/gi, "Malé"],
];

/** Rewrites known unaccented place-name spellings to their real seeded
 * form so ILIKE-based search (which can't fold accents itself) still
 * finds them. Applied once, right after normalizeQuery, before the query
 * reaches any repository search function. */
export function expandKnownPlaceNames(query: string): string {
  let result = query;
  for (const [pattern, replacement] of KNOWN_PLACE_NAME_VARIANTS) {
    result = result.replace(pattern, replacement);
  }
  return result;
}
