# Sources and methodology

Data compiled September 2026 for `activities.json` (10 new entries) and `fishing_spots.json`
(empty array — see the dedicated section below), extending the `fishing` activity category
without duplicating the 2 fishing activities that already exist in
`data/maldives/activities/activities.json` ("Night Fishing Excursion" at Velassaru / Universal
Resorts, and "Traditional Handline Fishing Trip" at Olhuveli / Six Senses).

**Access constraint:** direct `WebFetch`/page retrieval was blocked in this sandbox, exactly as
noted in `data/maldives/locations/SOURCES.md`, `data/maldives/accommodations/SOURCES.md` and
`data/maldives/activities/SOURCES.md`. All research was done via the `WebSearch` tool, which
returns AI-generated summaries of search-result snippets rather than raw page content. Every fact
below passed through that summarization layer. Where a summary flagged internal disagreement, gave
only a range instead of a single figure, or simply did not surface a number, the corresponding
field was left `null` rather than guessed, per the task's hard rule.

**Geography cross-check:** every `island_name` / `atoll_administrative_code` pair was checked
against `data/maldives/locations/islands.json` and `data/maldives/locations/atolls.json`. Note in
particular that **Hulhumalé is administratively part of Malé City (code `MLE`), not Kaafu Atoll
(`K`)**, per `islands.json` and the note on the Kaafu Atoll record in `atolls.json`, even though it
sits geographically inside North Malé Atoll — this is why the Hulhumalé-based charter below uses
`MLE` rather than `K`.

**Provider linking:** where a trip is run by one of the 9 existing providers/operators named in the
task brief, `operator_name` uses that exact string. This dataset reuses **Active Watersports
Maafushi** (2 entries), **Kaani Hotels** (1 entry, the "Kaani Tours" excursion arm, same
resolution already used in `activities/activities.json`), **iCom Tours** (1 entry) and **Universal
Resorts** (2 entries, one each for its Kurumba/Vihamanaafushi and Velassaru properties) and
**Soneva Management (BVI) Limited** (1 entry) — no new provider record is strictly required for
those six entries. One genuinely new, independently-verified operator is introduced: **Knight At
Sea** (a Hulhumalé-based sportfishing charter run by Captain Hussain). Two entries (Gili
Lankanfushi, Baros) have `operator_name: null` because no confidently-attributable operating
company was found for the fishing trip specifically, consistent with how `accommodations.json`
and `activities/activities.json` already leave those two resort islands' operator identities
unresolved or narrowly scoped.

## Maafushi-based independent operators

- **Active Watersports Maafushi — Sunset Fishing Trip.** Queries: "activemaldives.com sunset
  fishing price duration Maafushi"; "Maafushi night fishing trip local operator price sunset
  fishing". Confirmed via activemaldives.com/sunset-fishing (the operator's own page — Active
  Watersports Maafushi is already a provider used in `activities/activities.json` for its Private
  Dolphin Cruise). $30/person, 3 hours (180 min), described as traditional deep-sea line fishing
  (reel, line, hook, bait; no experience required), catch BBQ'd/served for dinner afterward.
  Classified `handline_fishing` since the source explicitly describes line-and-hook technique.
- **Active Watersports Maafushi — Private Sport Fishing Trip.** Query: "activemaldives.com sport
  fishing big game price duration Maafushi". Confirmed via activemaldives.com/sport-fishing, a
  second, separately-marketed product from the same operator (private speedboat sport fishing,
  "99% catch rate", soft drinks/snacks included). Duration stated only as a "4-5 hour" range for 1
  person (no single figure), and price not surfaced in snippets reviewed; both left `null`.
  Classified `sport_fishing` to distinguish it from the operator's traditional/handline sunset
  product.
- **Kaani Hotels (Kaani Tours) — Sunset Fishing Trip.** Queries: "Maafushi night fishing trip local
  operator price sunset fishing"; "'Kaani Tours' night fishing Maafushi price duration review";
  "'Kaani Tours' sunset fishing $25 OR $30 Maafushi Tripadvisor". Confirmed via multiple Tripadvisor
  review summaries for "Kaani Tours" (Maafushi Island) — the same excursion arm of the Kaani
  Hotels group already linked to the existing `operator_name` "Kaani Hotels" in
  `activities/activities.json`. Sunset fishing priced at $25/person (repeated specifically for
  fishing across summaries); a $30 figure appears elsewhere but attached to a "full day excursion"
  rather than fishing specifically, so was not used. `fishing_type` left `null` — no source
  specified the exact method for this operator's trip. Reviews also mention "night fishing" and
  "big game fishing" run by the same company, but night fishing had no price/detail beyond praise
  in reviews (would duplicate the sunset trip's character too closely to add with confidence as a
  separate product), and the big-game fishing reviews included a billing dispute (quoted $500,
  charged $600, one reviewer titled their review "BIG GAME FISHING IS A SCAM") — too
  inconsistent/disputed to add as a priced entry, so neither was included. Carries the same
  brand-level (not registered-company-confirmed) caveat already flagged for "Kaani Hotels" in
  `accommodations/SOURCES.md`.
- **iCom Tours — Night Fishing Trip.** Query: "'iCom Tours' Maafushi fishing trip". Confirmed via
  icomtours.com's own excursions list (which names "night fishing" alongside sunset cruising,
  dolphin watching and sandbank picnics) and multiple Tripadvisor reviews for "iCom Tours" praising
  its night fishing trips by name. iCom Tours is already a provider used in
  `activities/activities.json`. Price and duration not found in snippets reviewed; left `null`.

## Malé-area sport/big-game fishing charter

- **Knight At Sea — Marlin & Big Game Fishing Charter.** Queries: "Maldives big game fishing
  charter Male Hulhumale sport fishing operator price"; "Knight At Sea Hulhumale sportfishing
  Captain Hussain price boat". Confirmed via a FishingBooker.com charter listing and a
  corroborating Tom's Catch listing ("Marlin Fishing in Maldives Aboard Knight At Sea with Captain
  Hussain"): a real Hulhumalé-based charter run by Captain Hussain on a 27-foot center-console boat
  (4-passenger capacity, recorded as `max_participants`), trolling and bottom fishing for Wahoo,
  Giant Trevally, Yellowfin Tuna and similar species. A marlin-package price of roughly EUR 1,361
  was quoted, but since it is not in USD and bundles several inclusions rather than being a clean
  per-trip base rate, `price_from` was left `null` rather than converted. Other Malé/Hulhumalé
  charters were also surfaced (Salt Rigger Fishing/Captain Yaan, Ocean Strike Fishing/Captain
  Moosa) but were not added: their pricing in search summaries was either a generic
  marketplace/aggregator "starting from" figure not clearly tied to one specific trip type, or not
  surfaced at all, so Knight At Sea (with a directly-sourced boat, captain name and price context)
  was kept as the single representative entry for this category rather than padding with weaker
  sourcing.

## Resort-run fishing trips (existing providers)

- **Universal Resorts / Kurumba Maldives (Vihamanaafushi) — Sunset Reef Fishing.** Query: "Kurumba
  Maldives big game fishing excursion trip price" → "holiday.com.mv Kurumba Maldives excursions
  list fishing dolphin sandbank". Confirmed via the resort's own excursions factsheet PDF
  (kurumba.com) and HolidayVibe Maldives' Kurumba excursions page, both of which list "Sunset Reef
  Fishing" and "Sports Fishing" as two separate bookable excursions. Only "Sunset Reef Fishing" was
  added (the more locally-distinctive named product), to avoid over-representing this one resort
  island alongside its existing Sandbank Picnic / Malé Guided Tour / Sunset Dolphin Cruise entries.
  Price and duration not found; left `null`.
- **Universal Resorts / Velassaru Maldives — Big Game Fishing Trip.** Query: "Velassaru Maldives
  big game fishing trip price duration Immersion Dive Watersports". Confirmed via Velassaru's own
  watersports team page (facebook.com/ImmersionVelassaru) and corroborating aMaldives/ZuBlu
  coverage: Big Game Fishing runs 5:30-9:30 (a 4-hour / 240-minute early-morning trip), run through
  the same Immersion Dive and Watersports Centre as the resort's existing "Night Fishing
  Excursion" entry — a distinct product, not a duplicate, now with a confirmed duration where the
  existing entry has none. Price not found; left `null`.
- **Soneva Management (BVI) Limited / Soneva Fushi — "Fishing is a Family Matter".** Query: "Soneva
  Fushi big game fishing trip excursion price" → "soneva.com experience fishing excursion Soneva
  Fushi". Confirmed via soneva.com's own Signature Experiences page: a named excursion fishing
  alongside local Maldivian fisherman "Rocket" and his family using traditional/sustainable
  methods, starting 17:30 with the catch served as dinner at 19:30. That window covers fishing
  plus dinner together, not fishing time alone, so `duration_minutes` was left `null` rather than
  computed from the two timestamps. Price not found; left `null`. Distinct from the resort's
  existing Sunset Dolphin Cruise / Soneva Soul spa entries, same operator.

## Resort islands with an unresolved/no operator

- **Gili Lankanfushi — Big Game Fishing Trip.** Query: "Gili Lankanfushi resort fishing excursion
  trip". Confirmed via gili-lankanfushi.com/experience/excursions (the resort's own guided
  excursions page): big-game fishing for tuna and billfish aboard the resort's 14-metre Riviera
  yacht, corroborated by guest reviews mentioning wahoo/yellowfin tuna catches. `operator_name`
  left `null`: Gili Lankanfushi's own management company is already `null` in
  `accommodations.json` due to conflicting information (independent-resort press vs. an
  unconfirmed older "HPL Hotels & Resorts" headline), and no separate named watersports company was
  found for this trip. Price and duration not found; left `null`.
- **Baros Maldives — Golden Reel Adventure.** Queries: "baros.com fishing excursion trip Baros
  Maldives"; "Baros Maldives 'Divers Baros' OR watersports team runs fishing trips operator name".
  Confirmed via baros.com/experiences/excursions (resort's own excursions page): a named 4-5 hour
  excursion exploring five distinct traditional Maldivian fishing techniques aboard an authentic
  dhoni. The same page also separately lists plain "Traditional Hand-Line Fishing" and
  "Sunrise/Sunset Fishing Trips" as simpler, less-distinctive options not added here to avoid
  padding near-duplicate listings from one page. `fishing_type` left `null` since the named
  excursion explicitly spans multiple techniques rather than one. `operator_name` left `null`:
  "Divers Baros Maldives" (already used for the existing "Guided Reef Dive" activities.json entry)
  is described on baros.com primarily in a diving/water-sports context
  (baros.com/divers-baros-maldives/water-sports), while this excursion lives on a separate,
  general excursions page with no named operating company, so attributing it to Divers Baros
  Maldives would not be confidently verified; Baros Maldives' own resort-level operator is likewise
  already `null` in `accommodations.json`. Duration given only as a "4-5 hour" range; left `null`.

## `fishing_spots.json` — why it is empty

A dedicated search pass looked for individually-named, multiply-cited fishing grounds the way
"Banana Reef" or "Manta Point" are named, consistently-cited dive sites. Query: "Maldives famous
named fishing ground channel spot 'fishing' traditional Maldivian"; follow-up: "named fishing spot
Maldives big game fishing 'kandu' OR reef specific location cited operators trolling".

What surfaced instead was consistently generic-geographic, not site-specific:

- **Kandus (inter-atoll/reef channels)** are repeatedly described as productive fishing grounds in
  general (e.g. for Dogtooth Tuna via deep jigging), but as a *category* of feature, not one
  specific, individually-named channel that tourism operators or charters cite by name as a
  destination the way a dive site is named on a dive-site map.
- **Atoll-level generalities**: sources describe North Malé, South Malé, Ari, Meemu, Vaavu and
  Laamu Atolls' channels as "well-known fishing grounds," Huvadhu Kandu (Suvadiva Channel) as
  biodiverse and tied to the fishing industry, and Faresmaathoda (Huvadhu Atoll) as a "fishing hub"
  island — all real, but at the scale of an atoll, a channel category or an island, not a single
  named ground.
- Two individually-named channels did surface by name — Maavaru Kandu and Fulidhoo Kandu — but the
  only descriptive detail found for them was about coral/scenery (framed as dive-site character:
  "rocky overhangs," "pastel soft corals"), not as a specifically-and-repeatedly cited *fishing*
  destination. Using them here would mean re-purposing dive-site sourcing as fishing-site sourcing,
  which was judged too weak a basis to include with confidence.

Given the hard rule against fabricating place names, `fishing_spots.json` is therefore written as
an empty array `[]` rather than populated with generic channel/atoll names dressed up as specific
"spots." This matches the task brief's own anticipated outcome: Maldives fishing tourism content
consistently anchors trips to their departure island or resort ("fishing near/around Maafushi",
"Velassaru's Immersion Dive and Watersports Centre runs big game fishing"), not to individually
named, multiply-cited fishing grounds — which is exactly how every entry in `activities.json` above
is structured (anchored to `island_name`, not to a named ground).

## Totals by `fishing_type`

`handline_fishing`: 1 · `sport_fishing`: 1 · `night_fishing`: 1 · `big_game_fishing`: 3 ·
`reef_fishing`: 1 · `traditional_fishing`: 1 · `null` (source didn't specify, or spans multiple
techniques): 2. 10 entries total, 8 of 10 (80%) carry a specific `fishing_type`.

## Totals by operator

Active Watersports Maafushi: 2 · Universal Resorts: 2 · Kaani Hotels: 1 · iCom Tours: 1 · Soneva
Management (BVI) Limited: 1 · Knight At Sea (new): 1 · `null`/unresolved: 2 (Gili Lankanfushi,
Baros Maldives). 8 of 10 entries (80%) carry a confidently-verified operator name; 7 of those 8 use
one of the existing provider records exactly by name (Active Watersports Maafushi x2, Universal
Resorts x2, Kaani Hotels, iCom Tours, Soneva Management (BVI) Limited), and 1 introduces a new,
independently-verified real operator (Knight At Sea).

## Totals by island / atoll

Maafushi (K): 4 · Hulhumalé (MLE): 1 · Vihamanaafushi (K): 1 · Velassaru (K): 1 · Lankanfushi (K):
1 · Kunfunadhoo (B): 1 · Baros (K): 1. Spans 3 atolls (K, MLE, B) and 7 distinct
islands/resort-islands, none of which duplicate the islands used by the 2 pre-existing fishing
activities (Velassaru and Olhuveli) for the *same* trip — note Velassaru does reappear here, but
with a second, distinct, newly-verified fishing product (Big Game Fishing Trip, confirmed 240-min
duration) rather than a re-creation of the existing Night Fishing Excursion.

## Known gaps / low-confidence entries

1. **Most prices and durations were simply not surfaced by search, not disputed.** As in
   `activities/SOURCES.md`, the large majority of `null` price/duration fields reflect the
   WebSearch summarization layer not returning a specific figure, even where the trip itself is
   clearly confirmed as real — not a sign of conflicting information. Treat these `null`s as "not
   found," not "does not exist." Only 2 of 10 entries have a confirmed `price_from` (both on
   Maafushi: Active Watersports Maafushi's Sunset Fishing Trip at $30, Kaani Tours' Sunset Fishing
   Trip at $25) and only 1 has a confirmed `duration_minutes` (Velassaru's Big Game Fishing Trip,
   240 min).
2. **Kaani Hotels — same brand-level caveat as elsewhere in this dataset.** No registered-company
   confirmation was found for "Kaani Hotels" as a legal entity; treat this operator record as
   provisional, consistent with `accommodations/SOURCES.md` and `activities/SOURCES.md`.
3. **Kaani Tours' big-game fishing product was deliberately excluded**, not merely left unpriced:
   review evidence included a specific billing-dispute complaint (quoted $500 vs. charged $600) and
   a review titled "BIG GAME FISHING IS A SCAM." The underlying activity (Kaani Tours running big
   game fishing trips) is plausibly real, but the pricing signal was judged too unreliable to
   record even as a `null`-price entry, so it was left out entirely rather than included with
   unresolvable doubt hanging over the operator's conduct on that specific product.
4. **Two entries have `operator_name: null` by design** (Gili Lankanfushi, Baros Maldives'
   "Golden Reel Adventure") — see the "Resort islands with an unresolved/no operator" section
   above for the specific reasoning in each case; neither is a gap in research effort so much as a
   case where the confidently-identifiable operator (the resort brand itself) isn't a company name
   distinct enough from the resort/island itself to record, and a plausible-but-unconfirmed
   candidate (Divers Baros Maldives) was deliberately not guessed onto the Baros entry.
5. **`fishing_type` is `null` for 2 of 10 entries** where the source either didn't specify a single
   technique (Kaani Tours' Sunset Fishing Trip) or explicitly described multiple techniques in one
   named product (Baros' Golden Reel Adventure) — see the per-entry notes above.
6. **`fishing_spots.json` is intentionally an empty array.** See the dedicated section above for
   the reasoning: no individually-named, multiply-and-specifically-cited fishing ground was found
   with confidence, as distinct from generic channel/atoll-level fishing-ground descriptions.
7. **General caveat — WebSearch summarization layer.** As with every other dataset in this
   repository, every fact above passed through an AI-generated search-result summary rather than
   raw source HTML, because `WebFetch` is blocked in this sandbox. Figures that could not be
   corroborated with reasonable confidence were left `null` rather than resolved by guessing.
8. **Coverage is intentionally partial.** This directory covers 10 individually-sourced fishing
   activities out of a much larger real universe of bookable Maldives fishing trips (nearly every
   inhabited local island and resort in the country offers some form of fishing excursion). Several
   other real, named operators were surfaced but deliberately left out to keep sourcing quality
   high: other Malé/Hulhumalé sportfishing charters (Salt Rigger Fishing, Ocean Strike Fishing),
   other Maafushi excursion/watersports operators (Maldives Fellas Excursions and Watersports,
   Maafushi Dive and Water Sports — which lists "fishing charters & tours" among its services but
   with no individually-priced or dated product surfaced in snippets reviewed), and other resorts'
   fishing offerings referenced only in passing (e.g. Six Senses Laamu's "big game" and "night
   fishing" options beyond the traditional handline trip already in `activities.json`).

## Totals

- `activities.json`: 10 new entries (plus the 2 pre-existing fishing entries in
  `activities/activities.json`, for 12 fishing activities total across the dataset), spanning 7
  islands/resort-islands across 3 atolls (K, MLE, B).
- `fishing_spots.json`: 0 entries (empty array by design — see reasoning above).
