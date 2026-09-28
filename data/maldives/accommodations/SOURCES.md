# Sources and methodology

Data compiled September 2026 for `accommodations.json` (14 entries) and `providers.json`
(4 distinct operator companies).

**Access constraint:** direct `WebFetch`/page retrieval was blocked in this sandbox. All research
was done via the `WebSearch` tool, which returns AI-generated summaries of search-result snippets
rather than raw page content, the same constraint noted in `data/maldives/locations/SOURCES.md`.
Every fact below passed through that summarization layer rather than being read directly from
source HTML. Where sources disagreed or a figure could not be pinned down, that is called out
explicitly below and the corresponding field was left `null` in `accommodations.json` rather than
guessed, per the task's hard rule.

**Geography cross-check:** every `island_name` / `atoll_administrative_code` pair was checked
against the already-seeded `data/maldives/locations/atolls.json` and `islands.json`. For
resort islands (all marked `island_is_inhabited: false`), the island is deliberately *not* one of
the 193 seeded inhabited islands — that is expected, since Maldives resorts are built on their own
separate, otherwise-uninhabited islands. For guesthouse/hotel entries, the island name was checked
to match exactly the spelling already used in `islands.json` (e.g. "Hulhumalé", "Villingili").

## Resorts

- **Kurumba Maldives** — Queries: "Kurumba Maldives resort island name atoll operator Universal
  Resorts"; "Kurumba Maldives star rating room count overwater villas"; "Niva Kurumba Niva
  Velassaru rebrand Universal Resorts 2025 2026". Confirmed via Wikipedia, kurumba.com,
  resortlife.travel, maldives-magazine.com, and rebrand-announcement coverage (WTM Global Hub,
  edition.mv, see.mv, thearrival.mv, dated October 2025): island Vihamanaafushi, North Male Atoll
  (code K), operator Universal Resorts, 5-star, 180 rooms, no overwater villas (a stated design
  choice). Confirmed the property is mid-rebrand to "Niva Kurumba Maldives" under a new "VERSA
  Hospitality" management brand, effective 31 March 2026 — some booking platforms already show
  the new name.
- **Soneva Fushi** — Query: "Soneva Fushi resort island Baa Atoll Kunfunadhoo operator Soneva";
  follow-up "Soneva Fushi room count villas all inclusive star rating". Confirmed via Forbes
  Travel Guide, soneva.com, Scott Dunn, Amex Travel, TripAdvisor, theworlds50best.com: island
  Kunfunadhoo, Baa Atoll (code B), operator "Soneva Management (BVI) Limited" (owner/lessee
  "Bunny Holdings (BVI) Ltd" per Forbes Travel Guide), 64 villas, all-inclusive via the "Soneva
  Unlimited" program, overwater "Water Reserves"/water villas confirmed. Marketing materials
  describe it as "7-star"; not used as `star_rating` since that is not a real hotel-classification
  tier (left `null`).
- **Velassaru Maldives** — Query: "Velassaru Maldives resort island South Male Atoll operator";
  follow-up "Velassaru Maldives island name Velassaru Falhu Kaafu Atoll". Confirmed via Kuoni,
  Maldives Magazine, Trivago, Wikipedia (Kaafu Atoll): island Velassaru (the resort's own island,
  not a separately-named sub-island), South Male Atoll, administratively part of Kaafu Atoll
  (code K), operator Universal Resorts, 5-star, water villas confirmed. Also caught in the same
  VERSA Hospitality / "Niva Velassaru Maldives" rebrand as Kurumba (effective 15 Jan 2026).
- **Six Senses Laamu** — Query: "Six Senses Laamu resort island name Laamu Atoll operator";
  follow-up "Six Senses Laamu villa count overwater villas all inclusive". Confirmed via Virtuoso,
  Mr & Mrs Smith, Amex Travel, sixsenses.com, Michelin Guide, TripAdvisor: island Olhuveli, Laamu
  Atoll (code L; the only resort in that atoll), operator/brand Six Senses, 94 total villas of
  which 73 are water villas (overwater confirmed true). All-inclusive status and a
  property-specific star rating were not confidently confirmed and left `null`.
- **Baros Maldives** — Query: "Baros Maldives resort island atoll operator company"; follow-up
  "Baros Maldives room count overwater villas star rating". Confirmed via Kuoni, baros.com,
  Africa Odyssey, SLH, foratravel.com: island Baros, North Male Atoll (code K), 75 rooms,
  overwater "Water Villas" confirmed, widely described as 5-star (one marketing source
  speculated "6-star" but this was not treated as confirmed). No parent operator company found —
  multiple sources describe it as independently run; SLH (Small Luxury Hotels of the World) is a
  marketing consortium membership, not an operating company, so `operator_name` left `null`.
- **Gili Lankanfushi** — Query: "Gili Lankanfushi resort island North Male Atoll operator";
  follow-up "Gili Lankanfushi star rating current operator management company 2025". Confirmed
  via Black Tomato, Amex Travel, gili-lankanfushi.com, Lightfoot Travel: island Lankanfushi,
  North Male Atoll (code K), 45 villas, all overwater on stilts, widely described as 5-star.
  Operator left `null` — see Known Gaps below.

## Guesthouses / hotels on inhabited islands

- **Arena Beach Hotel (Maafushi, K)** — Queries: "best guesthouses hotels Maafushi island Kaafu
  Atoll names"; "Arena Beach Hotel Maafushi room count star rating". Confirmed real, well-known
  Maafushi beachfront hotel, 4-star (TripAdvisor). Room count conflicting (136 vs. 233 across
  aggregators) — left `null`; see Known Gaps.
- **Kaani Beach Hotel (Maafushi, K)** — Query: "Kaani Beach Hotel Maafushi operator Kaani Hotels
  room count star rating". Confirmed real hotel, 18 rooms, part of a locally-branded "Kaani
  Hotels" group (also runs Kaani Grand Seaview, Kaani Palm Beach, both also on Maafushi). Star
  rating conflicting (3 vs. 4-star) — left `null`.
- **Go Surf Maldives (Thulusdhoo, K)** — Query: "Thulusdhoo island guesthouse hotel name Kaafu
  Atoll surfing". Confirmed real surf guesthouse on Thulusdhoo (a well-documented surf-tourism
  island, home to the "Cokes" break); the property's own site (go-surf.site) appeared directly in
  results. Room count, star rating and operator not found — left `null`.
- **SeaLaVie Inn (Ukulhas, AA)** — Query: "Ukulhas island guesthouse hotel name Alif Alif Atoll".
  Confirmed via a dedicated island-guide site (ukulhasmaldives.com) with a property-specific
  review page: a 5-room guesthouse. Star rating, operator, website not found — left `null`.
- **Whaleshark Beach (Dhigurah, ADh)** — Query: "Dhigurah island guesthouse hotel name whale
  shark Alif Dhaalu Atoll". Confirmed 23-room guesthouse on Dhigurah, a well-known whale-shark/
  manta tourism island in South Ari (Alif Dhaalu) Atoll. Star rating, operator, website not
  found — left `null`.
- **Dhaankolhu Rasdhoo (Rasdhoo, AA)** — Query: "Rasdhoo island guesthouse hotel name Alif Alif
  Atoll". Confirmed via a dedicated guesthouse profile page (amaldives.com): a 9-room guesthouse
  on Rasdhoo, the Alif Alif/North Ari Atoll capital. Several other real Rasdhoo guesthouses were
  also surfaced (Ras Rana Lodge, Ras Atoll Inn, Rasdu View Inn, Rasdhoo Island Inn Beach Front,
  Rasdhoo Dive Lodge) but were deliberately not added individually, to avoid padding the dataset
  with multiple under-verified entries from the same island at the expense of broader atoll
  coverage.
- **Crystal View Maldives Guest House (Gulhi, K)** — Query: "Gulhi island guesthouse hotel name
  Kaafu Atoll". Confirmed real guesthouse on Gulhi Island via TripAdvisor and several booking
  aggregators. A similarly-named "Crystal View Palace" was separately described in one snippet as
  a "2-star guest house" in Kaafu Gulhi; it was not clear whether this is the same property, so no
  star rating was attached — see Known Gaps.
- **Coral Grand Beach & Spa (Hulhumalé, MLE)** — Query: "best hotels Hulhumale island Maldives
  names"; follow-up "'Coral Grand Beach' Hulhumale hotel rooms star rating". Confirmed real
  20-room hotel on Hulhumalé (Malé City, code MLE). Star rating explicitly disputed across
  sources (3-star vs. 4-star, and a TripAdvisor user review titled "Not a 4 star hotel") — left
  `null`.

## Providers

Four distinct operator companies were confirmed with reasonable confidence and written up in
`providers.json`: Universal Resorts (Kurumba Maldives, Velassaru Maldives — both mid-rebrand to
the "Niva" brand under a new "VERSA Hospitality" management arm as of the September 2026 research
date), Soneva Management (BVI) Limited (Soneva Fushi), Six Senses (Six Senses Laamu), and Kaani
Hotels (Kaani Beach Hotel — lower confidence, brand-level only, see Known Gaps). Nine of the
fourteen accommodations had no confidently-verified operator and were left with `operator_name:
null` rather than guessed: Baros Maldives and Gili Lankanfushi (both independent/conflicting per
search results), and all six of the smaller guesthouse/hotel entries on inhabited islands, where
no parent management company beyond the property's own name and, in one case, a locally-branded
group name (Kaani Hotels) was found.

## Known gaps / low-confidence entries

These are flagged rather than silently resolved:

1. **Gili Lankanfushi — conflicting operator information.** Recent (2025-dated) press describes
   the resort operating independently, with its own General Manager and Director of Operations
   appointed directly in 2025 and no parent company named. A separate, undated (likely older)
   headline states "HPL Hotels & Resorts takes over at Gili Lankanfushi, Maldives," and the
   property was also historically associated with the Soneva brand under an earlier name (Soneva
   Gili) before becoming independent. Given this conflict, `operator_name` was left `null` for
   Gili Lankanfushi rather than picking one candidate. **Action needed:** verify current
   management/ownership directly (e.g. official press releases or the property's own "About"
   page) before treating operator status as settled.

2. **Kaani Hotels — brand name only, not a confirmed legal operator.** "Kaani Beach Hotel" is
   consistently described across booking sites as part of a "Kaani Hotels" family of Maafushi
   properties (alongside Kaani Grand Seaview and Kaani Palm Beach), but no snippet reviewed
   surfaced a registered company name, ownership entity, or official group website for "Kaani
   Hotels" — it may be an informal/marketing grouping rather than a single legal operator.
   Recorded in `providers.json` with this caveat; treat as provisional.

3. **Arena Beach Hotel (Maafushi) — room count discrepancy.** Two travel-booking aggregators
   (Orbitz, Kayak) cite 136 rooms; a separate aggregator cites 233. Neither figure was corroborated
   by a primary/official source in the snippets reviewed, so `room_count` was left `null` rather
   than picking either number.

4. **Kaani Beach Hotel and Coral Grand Beach & Spa — conflicting star ratings.** Both properties
   have directly conflicting star classifications across major booking platforms (3-star on some,
   4-star on others; one TripAdvisor review for Coral Grand Beach & Spa is literally titled "Not a
   4 star hotel"). Since third-party "star ratings" for Maldivian guesthouses are often
   self-declared by the property to booking platforms rather than independently/officially
   verified, and the two figures genuinely disagree here, `star_rating` was left `null` for both
   rather than picking one side of the conflict.

5. **Crystal View Maldives Guest House (Gulhi) — possible name confusion with "Crystal View
   Palace."** One search snippet described a "Crystal View Palace" as a 2-star guest house "in
   Kaafu Gulhi," which may or may not be the same property as "Crystal View Maldives Guest House"
   (also confirmed on Gulhi via TripAdvisor under that exact name). Because this could not be
   resolved with confidence, no star rating was attached to either name to avoid mis-attributing
   a rating to the wrong specific property.

6. **General caveat — WebSearch summarization layer.** As with the locations dataset, every fact
   above passed through an AI-generated search-result summary rather than raw source HTML/tables,
   because `WebFetch` is blocked in this sandbox. Where a summary itself flagged internal
   disagreement (differing room counts, differing star ratings, an ambiguous operator), that
   disagreement is preserved above and reflected as a `null` field rather than resolved by
   guessing.

7. **Coverage is intentionally partial, not a full accommodation census.** This directory covers
   14 individually-verified accommodations (6 resorts, 3 hotels, 5 guesthouses) out of the
   1,000+ registered Maldivian tourist accommodations that actually exist. It is meant as a small,
   solidly-sourced seed set, not a comprehensive inventory — many more real, verifiable properties
   exist on Maafushi, Rasdhoo, Ukulhas and elsewhere that were surfaced during research (see the
   per-island notes above) but were deliberately left out to avoid diluting sourcing quality by
   over-expanding the list.

## Totals

- `accommodations.json`: 14 entries — 6 resorts, 3 hotels, 5 guesthouses, 0 villas, 0 other.
- `providers.json`: 4 distinct operator companies.
