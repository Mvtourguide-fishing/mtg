# Sources and methodology

Data compiled September 2026 for `activities.json` (14 new entries) and `dive_sites.json` (12
entries), a new `diving` category that separates commercial, bookable diving **activities** from
physical, non-commercial dive **sites**, per the task brief's critical distinction. This extends
the diving category without duplicating the 3 diving activities that already exist in
`data/maldives/activities/activities.json` ("Discover Scuba Diving (DSD)" and "PADI Open Water
Diver Course" at Maafushi Dive and Water Sports/Maafushi, and "Guided Reef Dive" at Divers Baros
Maldives/Baros).

**Access constraint:** direct `WebFetch`/page retrieval was blocked in this sandbox, exactly as
noted in `data/maldives/locations/SOURCES.md`, `data/maldives/accommodations/SOURCES.md`,
`data/maldives/activities/SOURCES.md` and `data/maldives/fishing/SOURCES.md`. All research was
done via the `WebSearch` tool, which returns AI-generated summaries of search-result snippets
rather than raw page content. Every fact below passed through that summarization layer. Where a
summary flagged internal disagreement, gave only a range instead of a single figure, or simply did
not surface a number, the corresponding field was left `null` rather than guessed, per the task's
hard rule.

**Geography cross-check:** every `island_name`/`nearby_island_name` + `atoll_administrative_code`
pair was checked directly against `data/maldives/locations/islands.json` (193 inhabited islands)
and, for the 6 resort islands, against the `island_name`/`atoll_administrative_code` pairs already
recorded in `data/maldives/accommodations/accommodations.json`: Vihamanaafushi/Kurumba (K),
Kunfunadhoo/Soneva Fushi (B), Velassaru (K), Olhuveli/Six Senses Laamu (L), Baros (K),
Lankanfushi/Gili Lankanfushi (K). Several real, well-documented dive sites are associated in
sources with islands that are *not* in our 193-inhabited-island list (uninhabited resort islands
like Kudarah, Kandooma and Vaadhoo, or Lankanfinolhu, which is distinct from Lankanfushi/Gili
Lankanfushi despite the similar name) -- in every such case `nearby_island_name` was left `null`
rather than guessed onto a plausible-but-unconfirmed nearby island from our list.

**Provider linking:** two activities reuse an exact existing provider name from
`providers.json`-equivalent lists in this dataset ("Maafushi Dive and Water Sports" x3 including
the two not shown here that pre-date this file, "Divers Baros Maldives" x2). Seven new, real,
independently-verified dive operators are introduced (none of the 10 existing providers cover
resort dive centres beyond Baros/Maafushi): **Soleni Dive Center** (Soneva Fushi), **Deep Blue
Divers** (Six Senses Laamu), **Immersion Dive Centre** (Velassaru), **Sea Star Diving**
(Thulusdhoo), **Feenaa Diving Thulusdhoo** (Thulusdhoo), **Euro-Divers Kurumba** (Kurumba
Maldives/Vihamanaafushi) and **Ocean Paradise Dive Centre** (Gili Lankanfushi). In each resort
case, the dive centre is a distinct operating brand from the resort's own accommodation operator
already in `providers.json` (e.g. Euro-Divers Kurumba is distinct from "Universal Resorts"), the
same pattern already established for Baros/Divers Baros Maldives in `activities/SOURCES.md`. All
14 new activities carry a real, named, verified operator -- none use `operator_name: null`.

## Maafushi Dive and Water Sports (existing operator, 3 new products)

- **Fun Dive (Single Tank).** Queries: "maafushidive.com fun dive night dive price course";
  "maafushidive.com 'diving-rates' OR 'diving-price-list' night dive $". Confirmed via the
  operator's diving-rates/diving-price-list pages: $50 for a single dive by a certified diver, with
  package pricing down to $40/dive at high volume. Equipment, boat and dive guide included.
- **Advanced Open Water Diver Course.** Query: "'Maafushi Dive and Water Sports' Advanced Open
  Water course price". Confirmed via maafushidive.com/products/adventure-course and related
  collection pages: $400, 5 adventure dives (2 mandatory + 3 selectable). Difficulty left `null`
  since the source doesn't use one of the standard beginner/intermediate/advanced/all_levels labels
  for this specific product.
- **Night Diver Specialty Course.** Same query batch as above. Confirmed via
  maafushidive.com/products/night-dive: a 2-3 night, 3-adventure-dive PADI specialty course, $330,
  open to Open Water divers and Junior divers 12+ (recorded as `min_age`). The site's separate,
  non-certification "Night Dive" product (restricted to advanced/specialty-certified divers) was
  searched for repeatedly but no distinct price ever surfaced in snippets, so it was not added as
  its own entry to avoid an unpriced near-duplicate of this course.

## Divers Baros Maldives (existing operator, 2 new products)

- **Discover Scuba Diving.** Queries: "baros.com divers baros PADI Open Water course price fun
  dive"; "Baros Maldives 'Dive Course Prices' beginners open water $ May 2023". Confirmed via the
  operator's own "DIVE COURSE PRICES May 2023" PDF, filed under a "BEGINNERS DIVE PROGRAMMES"
  section: $195 for a 1-dive Discover Scuba Diving session -- `difficulty: "beginner"` used directly
  from the source's own section heading.
- **Fluo Night Diving.** Query: "baros.com 'Divers Baros Maldives' night dive price course PADI".
  Confirmed via baros.com/divers-baros-maldives/diving/fluo-night-diving: a UV-light fluorescence
  night dive with a pre-dive briefing on fluorescent marine life. Price/duration not found in
  snippets reviewed; left `null`.

## Resort dive centres (5 of the task's named resorts)

- **Soleni Dive Center — Fun Dive & PADI Open Water Diver Course (Soneva Fushi, Kunfunadhoo, B).**
  Queries: "Soneva Fushi dive center PADI Soneva scuba diving price course"; "Soleni Dive Center
  Soneva Fushi Discover Scuba Diving price". Confirmed via soleni.com/dive-center/rates: a real
  PADI-affiliated dive operation on Soneva Fushi, opened October 1995. Single dive $89 (equipment
  rental $33 and boat trip $42 appear to be billed as separate line items on the same rate card
  rather than bundled in), PADI Open Water course $1,090. The $89 base-dive figure was used as
  `price_from` for the Fun Dive entry, flagged in that entry's own notes as possibly excluding
  equipment/boat.
- **Deep Blue Divers — PADI Bubble Maker (Six Senses Laamu, Olhuveli, L).** Query: "Six Senses
  Laamu dive center PADI Deep Blue scuba diving price". Confirmed via search summaries citing the
  resort/dive-centre's own rate sheet: PADI Bubble Maker (children's introductory program) at USD
  150++ for ages 8-9, `min_age` recorded as 8. Deep Blue Divers is confirmed as Six Senses Laamu's
  own PADI 5-star dive centre.
- **Immersion Dive Centre — Discover Scuba Diving (Velassaru, K).** Query: "Velassaru dive center
  'Immersion' diving PADI price"; follow-up "Velassaru Immersion dive centre '$210' course
  discover scuba open water". Confirmed via velassaru.com/experiences/dive-discover/ and
  velassaru.com/experiences/sea/: Discover Scuba Diving (1-3 dives), training in the resort's own
  ~9m lagoon, explicitly described as for "beginners". A $210 figure surfaced in one summary but
  could not be confidently attached to this specific course, so `price_from` was left `null`.
- **Euro-Divers Kurumba — PADI Open Water Diver Course (Kurumba Maldives, Vihamanaafushi, K).**
  Queries: "Kurumba Maldives dive centre PADI Euro Divers price"; "Euro-Divers Kurumba single dive
  price PADI Open Water course". Confirmed via euro-divers.com/kurumba-maldives-dive-centre and the
  PADI dive-center listing for "Euro-Divers Niva Kurumba": a real, long-running (since 1972) PADI
  5-star dive operator at Kurumba Maldives. A EUR 216 figure surfaced once but could not be
  confidently tied to this course, so `price_from` was left `null`.
- **Ocean Paradise Dive Centre — Discover Scuba Diving (Gili Lankanfushi, Lankanfushi, K).**
  Queries: "Gili Lankanfushi dive center PADI scuba diving price"; "'Ocean Paradise' dive centre
  Gili Lankanfushi price course". Confirmed via gili-lankanfushi.com/experience/diving/ and the
  padi.com dive-center listing for "Ocean Paradise" (North Male Atoll): PADI courses for adults and
  children, most beginner training on the resort's own house reef. This same page/listing also
  named specific North Male Atoll sites the centre visits (Banana Reef, HP Reef, Rainbow Reef,
  Okobe Thila, Maagiri, Manta Point) -- used below to justify `nearby_island_name: "Lankanfushi"`
  for two of the dive-site entries. Price/duration not found in snippets reviewed; left `null`.

## Thulusdhoo independent dive centres (2 real operators beyond the 10 existing providers)

- **Sea Star Diving — PADI Open Water Diver Course.** Query: "Thulusdhoo dive center scuba diving
  PADI operator Maldives"; follow-up "'Sea Star Diving' Thulusdhoo price PADI Open Water course fun
  dive". Confirmed via seastarsdiving.com/padi-open-water-diver: a real PADI centre on Thulusdhoo
  established 2018, running boat dives to 25+ North Male Atoll sites. Course spans up to 4 days,
  `min_age` 15 (this operator's own stated policy, higher than PADI's generic minimum of 10).
  Price not found in snippets reviewed; left `null`.
- **Feenaa Diving Thulusdhoo — Discover Scuba Diving & Fun Dive.** Query: "'Feenaa' diving
  Thulusdhoo PADI course price review". Confirmed via a search-result pricing summary
  (feenaadive.com content indexed via search): Discover Scuba Diving $100 (beginners), single
  certified dive ~$65 (two dives ~$105) -- the single-dive figure was explicitly described as an
  estimate in the source itself, so it carries slightly lower confidence than the DSD price, noted
  in that entry.

## Known gaps / low-confidence entries

1. **Most prices, durations and max-participant figures were simply not surfaced by search, not
   disputed.** As in every other `SOURCES.md` in this repo, the large majority of `null` fields
   reflect the WebSearch summarization layer not returning a specific figure, even where the
   product itself is clearly confirmed as real. Of 14 activities, 9 have a confirmed `price_from`;
   none has a confirmed `duration_minutes` or `max_participants` (several courses instead note a
   multi-day/multi-night span in free text rather than a single timed-session duration, matching
   the convention already used for the existing PADI Open Water Diver Course entry at Maafushi).
2. **Soleni Dive Center's (Soneva Fushi) $89 Fun Dive price may understate the real cost.** The
   source's own rate card lists equipment rental ($33) and boat trip ($42) as separate line items
   alongside the $89 base dive rate; it's unclear from the summary whether these are always add-ons
   or sometimes included. $89 was used as `price_from` since it's the smallest confirmed figure
   directly tied to "a dive", but treat it as a lower bound rather than an all-inclusive price.
3. **Feenaa Diving Thulusdhoo's single-dive price ($65) is explicitly an estimate** per the source
   summary itself, distinct from its more plainly-stated $100 Discover Scuba Diving price.
4. **Two "$X" figures were deliberately excluded rather than used:** a $210 figure loosely
   associated with Velassaru's Immersion Dive Centre, and a EUR 216 figure loosely associated with
   Euro-Divers Kurumba. Neither could be confidently tied to the specific course entry recorded
   here (vs. some other product, date, or currency conversion), so both `price_from` fields were
   left `null` rather than guessed.
5. **HP Reef / "Rainbow Reef" naming ambiguity.** Several independent sources describe "HP Reef"
   as also known as "Rainbow Reef" (and "Girifushi Thila"), while Gili Lankanfushi's own dive
   centre lists "HP" and "Rainbow Reef" as two separate named sites on its trip roster. Rather than
   risk creating a duplicate site under two names, only "HP Reef" was added, with this ambiguity
   flagged directly in that entry's own notes.
6. **`nearby_island_name` is `null` for 4 of 12 dive sites** (Banana Reef, Kuda Rah Thila, Kandooma
   Thila, Vaadhoo Caves) because the real islands sources tie them to (Farukolhufushi in passing for
   Banana Reef; Kudarah, Kandooma and Vaadhoo as the specific nearby islands for the other three)
   are uninhabited resort islands not present in our 193-island + 6-resort-island dataset. Rather
   than guess onto a nearby-but-unconfirmed island from our list (e.g. attaching Kandooma Thila to
   Guraidhoo), these were left `null` per the task's hard rule.
7. **Two dive sites (Lankan Manta Point, Okobe Thila) use `nearby_island_name: "Lankanfushi"`** on
   the strength of Gili Lankanfushi's own dive centre (Ocean Paradise) explicitly naming both sites
   among the ones it runs trips to -- not because either site is physically adjacent to
   Lankanfushi/Gili Lankanfushi island itself (Manta Point in particular sits off Lankanfinolhu, a
   different, nearby island under a similar name). This is flagged in both entries' own notes.
8. **Fish Head's depth figures vary by source** (reef-top depth given as either ~5m or ~8m; overall
   depth described inconsistently as sloping to 20m/30m/42m depending on which side of the pinnacle
   and which source). The most consistently repeated 5m-30m range was used; the deeper south-side
   figure is noted as a variant in that entry's own notes rather than used directly.
9. **Maaya Thila's `experience_level` was deliberately left `null`** rather than picking one label,
   because the source itself describes suitability as conditional on the day's current ("can suit
   all levels" in calm conditions, but explicitly unsuitable for novices when current is running) —
   this nuance is preserved in `current_notes` instead of collapsing it into one static difficulty
   tier.
10. **General caveat — WebSearch summarization layer.** As with every other dataset in this
    repository, every fact above passed through an AI-generated search-result summary rather than
    raw source HTML, because `WebFetch` is blocked in this sandbox. Figures that could not be
    corroborated with reasonable confidence were left `null` rather than resolved by guessing.
11. **Coverage is intentionally partial.** Real Maldives diving operators and dive sites vastly
    outnumber what's recorded here. Several other real, named operators/sites were surfaced but
    deliberately left out to keep sourcing quality high: other Maafushi dive centres (Maafushi
    Scuba, Eco Dive Club, The Dive Squad), another Thulusdhoo operator (Thulusdhoo Dive, SSI-only,
    and Sea Retreats Dive and Water Sports Center), Maafushi Dive's "Alimatha Night Dive" (a
    nurse-shark night dive trip to Vaavu Atoll, outside our current island/atoll scope), and
    numerous other well-known dive sites across Ari, Vaavu, Baa and other atolls not yet
    individually verified for this pass.

## Totals

- `activities.json`: 14 new entries, all with a confirmed real operator name (0 with
  `operator_name: null`), across 7 islands/resort-islands (Maafushi, Baros, Kunfunadhoo, Olhuveli,
  Velassaru, Thulusdhoo, Vihamanaafushi, Lankanfushi -- 8 counting each once) and 3 atolls (K, B,
  L). `diving_type` values used: `discover_scuba_diving` (5), `dive_course` (6), `fun_diving` (3),
  `night_diving` (1) — note some entries were counted for their primary tag only where a product
  spans two concepts (e.g. the Night Diver Specialty Course is tagged `dive_course`, not
  `night_diving`, since it's fundamentally a certification product). 9 of 14 have a confirmed
  `price_from`.
- `dive_sites.json`: 12 entries across 3 atolls (K, ADh, AA). `site_type` values used: `reef` (2),
  `thila` (6), `channel` (2), `wreck` (1), `cave` (1) -- no `pinnacle` or `wall` site was added
  since no verified site's own sourcing described it with those exact terms (several "thila" sites
  are informally pinnacle-shaped, but "thila" was used as the site_type since that's the term the
  sources themselves use). 8 of 12 have a non-null `nearby_island_name` tied to a real island
  already in our dataset.
