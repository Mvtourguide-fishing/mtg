# Sources and methodology

Data compiled September 2026 for `activities.json` (16 entries).

**Access constraint:** direct `WebFetch`/page retrieval was blocked in this sandbox. All research
was done via the `WebSearch` tool, which returns AI-generated summaries of search-result snippets
rather than raw page content — the same constraint noted in `data/maldives/locations/SOURCES.md`
and `data/maldives/accommodations/SOURCES.md`. Every fact below passed through that summarization
layer rather than being read directly from source HTML. Where a summary itself flagged internal
disagreement, or simply did not surface a figure, the corresponding field was left `null` in
`activities.json` rather than guessed, per the task's hard rule.

**Geography cross-check:** every `island_name` / `atoll_administrative_code` pair used here was
checked directly against the existing `island_name`/`atoll_administrative_code` pairs already
present in `data/maldives/accommodations/accommodations.json` (which in turn were checked against
`data/maldives/locations/islands.json`), so every activity is anchored to a place already in the
seeded dataset: Maafushi (K), Thulusdhoo (K), Vihamanaafushi/Kurumba (K), Velassaru (K), Baros (K),
Kunfunadhoo/Soneva Fushi (B), Olhuveli/Six Senses Laamu (L).

**Provider linking:** where an activity is run by one of the four existing provider companies in
`providers.json` (Universal Resorts, Soneva Management (BVI) Limited, Six Senses, Kaani Hotels),
`operator_name` uses that exact string so the activity links to the existing provider record
instead of creating a duplicate. Other real, independently-verified operators (iCom Tours, The
Perfect Wave Cokes Surf Camp, Maafushi Dive and Water Sports, Active Watersports Maafushi, Divers
Baros Maldives) use their own real names; a new provider record can be created for each of these.

## Maafushi-based independent operators

- **iCom Tours — Snorkeling, Dolphin Watching & Sandbank Package.** Queries: "Maafushi sandbank
  snorkeling trip tour operator price"; "'iCom Tours' Maafushi excursions sandbank snorkeling
  price". Confirmed via icomtours.com/excursions/sandbank and multiple Tripadvisor reviews of
  "iCom Tours" (Maafushi Island): a real, well-reviewed local excursion operator. $25/person
  4-stop package (two snorkel spots, dolphin watching, sandbank) confirmed; duration not stated in
  snippets, left `null`.
- **Maafushi Dive and Water Sports** (three entries: Discover Scuba Diving, PADI Open Water Diver
  Course, Private Snorkeling Trip). Queries: "Maafushi scuba diving center PADI name"; "Maafushi
  Dive and Watersports PADI Discover Scuba Diving price course"; "Eco Dive Club Maafushi price
  PADI open water course". Confirmed via maafushidive.com (the operator's own site, returned
  directly in search results): a real 5-Star PADI Gold Palm dive centre on Maafushi Island, Kaafu
  Atoll. DSD price $75, Open Water course price $475 (3-day course), private snorkeling trip $150
  — all confirmed via distinct product pages on the operator's own site. Durations largely not
  stated in the minutes-level detail the schema wants, left `null`. Other, competing Maafushi dive
  centres were also surfaced (Maafushi Scuba, Eco Dive Club, The Dive Squad) but not individually
  added, to avoid padding the dataset with under-verified duplicates from the same island.
- **Active Watersports Maafushi — Private Dolphin Cruise.** Query: "'Active Watersports' Maafushi
  dolphin cruise price duration". Confirmed via activemaldives.com/dolphin-cruise and Tripadvisor
  listing/reviews for "Active Watersports Maafushi": a real Maafushi water-sports operator. 60-min
  private dolphin cruise for up to 2 people confirmed (duration and capacity both stated
  explicitly); price not found in the snippets reviewed (a price-list page exists on the
  operator's own site but its figures were not returned by search), left `null`.
- **Full-Day Snorkeling & Island Hopping Tour.** Query: "Maafushi island hopping tour local
  islands price multiple islands". Confirmed via a Viator listing
  (viator.com/tours/Maafushi-Island/...-d50612-154002P58), priced at $90/person ($180 for 2), with
  Gulhi and Guraidhoo named as common stops in general island-hopping coverage. Booked through the
  Viator marketplace rather than through one clearly identified local operating company, so
  `operator_name` left `null` rather than attributing it to Viator (a booking platform, not the
  operator) or guessing a local company name.
- **Kaani Tours (Kaani Hotels) — Sandbank, Snorkeling & Dolphin Watching Excursions.** Query:
  "'Kaani Tours' Maafushi excursions operator relationship Kaani Hotels". Confirmed via
  visitmaldives.com ("Kaani Hotels & Tours: Redefining Summer Holidays in the Maldives") and
  Tripadvisor's "Kaani Tours" (Maafushi Island) listing: Kaani Tours functions as the excursion arm
  of the same Kaani Hotels group already in `providers.json` (operator of Kaani Beach Hotel).
  `operator_name` set to the exact existing string "Kaani Hotels" to link the two records. Carries
  the same lower-confidence caveat as the existing Kaani Hotels provider entry (see Known Gaps
  below and in `accommodations/SOURCES.md`): no formal registered-company confirmation, brand-level
  only. No single confirmed price/duration for a specific package, left `null`.

## Thulusdhoo (surfing)

- **The Perfect Wave Cokes Surf Camp — Private Surf Lesson.** Query: "Thulusdhoo surf camp surfing
  lessons operator Cokes"; follow-up "Cokes Surf Camp Thulusdhoo surf lesson price beginner".
  Confirmed via surfcamp-online.com (operator profile naming owner Brian James),
  cokessurfcampmaldives.com and Tripadvisor reviews: a real, well-reviewed surf camp sited directly
  on the "Cokes" surf break, Thulusdhoo Island, Kaafu Atoll. Private lesson pricing confirmed:
  $75/hr for 1 person, $120 for 2, $150 for 3-4 (base rate used as `price_from`, duration recorded
  as 60 min). Reviews describe the main break itself as not beginner-friendly even though lessons
  are offered across levels, so `difficulty` was left `null` rather than picking one value.

## Baros Maldives (independent dive centre)

- **Divers Baros Maldives — Guided Reef Dive.** Queries: "Baros Maldives excursions dolphin cruise
  sandbank diving"; "Baros Maldives dive centre name 'Divers Baros' PADI five star gold palm".
  Confirmed via baros.com/divers-baros-maldives/diving, the PADI dive-center directory
  (padi.com/dive-center/maldives/divers-baros-maldives/) and the resort's own dive brochure PDF:
  a real, long-established (opened 1979) PADI Five Star Gold Palm dive centre, first Reef
  Check-certified EcoDive Centre in the Maldives, running twice-daily trips to 30+ sites near Baros
  Maldives (North Male Atoll). Recorded as its own operator identity, separate from Baros
  Maldives' accommodation-level operator (already `null` in `accommodations.json` due to
  conflicting/no parent-company information). Price and per-dive duration not found in snippets
  reviewed, left `null`.

## Resort-run activities (existing providers)

- **Universal Resorts / Kurumba Maldives** (three entries: Sunset Dolphin Cruise, Sandbank Picnic,
  Malé Guided Tour). Queries: "Kurumba Maldives excursions activities dolphin cruise sandbank";
  "Niva Kurumba Sunset Dolphin Cruise price duration minimum age"; "Kurumba Maldives 'Cultural
  Island Experience' OR 'Male Guided Tour' excursion details". Confirmed via
  nivakurumba.com/experience/dolphin-exploration-cruise/ (the resort's own current site, mid-rebrand
  to "Niva Kurumba Maldives"), HolidayVibe Maldives' Kurumba excursions page, and Tripadvisor guest
  reviews. Sunset Dolphin Cruise: $65/adult, ~120 min, corroborated across two independent sources.
  Sandbank Picnic: explicitly "recommended for ages 10 years and above" per HolidayVibe. Malé
  Guided Tour: run 9am-12pm (180 min) per guest reviews; price not found. A separate "Cultural
  Island Experience" excursion was also referenced by name but not detailed enough in any snippet
  to add as its own verified entry.
- **Universal Resorts / Velassaru Maldives — Night Fishing Excursion.** Query: "Velassaru Maldives
  spa treatments excursions dolphin cruise". Confirmed via velassaru.com/experiences/ and
  corroborating aMaldives/Turquoise Holidays coverage: big-game and night fishing excursions run
  through the resort's own "Immersion Dive and Watersports Centre." Price and duration not found,
  left `null`. (Velassaru also offers manta-spotting and night-snorkelling excursions per the same
  sources, but only the fishing excursion was added here to keep `fishing` as a represented
  category without over-padding Velassaru specifically.)
- **Soneva Management (BVI) Limited / Soneva Fushi** (two entries: Sunset Dolphin Cruise, Soneva
  Soul 60-Minute Spa Treatment). Queries: "Soneva Fushi excursions dolphin cruise sandbank picnic
  activities"; "Soneva Fushi spa treatment price". Confirmed via soneva.com's own experience pages
  (soneva.com/experience/sunset-dolphin-cruise/, soneva.com/soneva-soul/our-spas/): dolphin cruise
  with seasonal manta ray/pilot whale sighting chance (price/duration not found, left `null`); a
  60-minute Soneva Soul spa treatment priced at USD 195 plus 12% government tax and 10% service
  charge (only the base treatment price recorded in `price_from`).
- **Six Senses / Six Senses Laamu — Traditional Handline Fishing Trip.** Query: "Six Senses Laamu
  excursions manta snorkeling sandbank dolphin cruise price"; follow-up "Six Senses Laamu spa
  treatments overwater". Confirmed via sixsenses.com's own experience/excursion pages for the
  Laamu property: fishing trips including "big game, night fishing, and traditional handline
  fishing" are listed among bookable excursions. Only the traditional handline option was recorded
  to keep the entry maximally locally-flavoured and avoid picking an arbitrary duplicate; price and
  duration not found, left `null`. The property's well-documented Manta Trust research
  partnership and manta-snorkeling trips, and its overwater spa (nine treatment nests, some with
  glass floors, 90-minute minimum for the signature wellness program), were also surfaced but not
  added as separate entries to avoid over-representing one resort at the expense of atoll/category
  breadth.

## Totals by category

`general`: 1 · `excursion`: 5 · `island_hopping`: 1 · `watersports`: 1 · `spa`: 1 · `culture`: 1 ·
`fishing`: 2 · `diving`: 3 · `surfing`: 1 — all nine schema category values are represented at
least once, across 16 total entries.

## Totals by operator

Universal Resorts: 4 · Maafushi Dive and Water Sports: 3 · Soneva Management (BVI) Limited: 2 ·
Six Senses: 1 · Kaani Hotels: 1 · iCom Tours: 1 · The Perfect Wave Cokes Surf Camp: 1 · Active
Watersports Maafushi: 1 · Divers Baros Maldives: 1 · unverified/`null`: 1 (the Viator-marketplace
island-hopping tour). 15 of 16 entries (94%) carry a confidently-verified operator name; 4 of those
15 use one of the four existing provider records (Universal Resorts, Soneva Management (BVI)
Limited, Six Senses, Kaani Hotels) and link to them exactly by name, and 5 introduce new,
independently-verified real operators (iCom Tours, Maafushi Dive and Water Sports, Active
Watersports Maafushi, The Perfect Wave Cokes Surf Camp, Divers Baros Maldives).

## Known gaps / low-confidence entries

1. **Most prices and durations were simply not surfaced by search, not disputed.** Unlike the
   accommodations dataset (where several fields were `null` due to *conflicting* figures across
   sources), most `null` price/duration fields here reflect the WebSearch summarization layer
   simply not returning a specific number for that field, even when the activity itself is well
   confirmed as real. This is expected given many operators keep detailed pricing on booking-flow
   pages that don't surface as indexable snippets. Treat these `null`s as "not found," not "does
   not exist."
2. **Kaani Tours / Kaani Hotels — brand-level operator, not a confirmed legal entity.** Same
   caveat as the existing `providers.json` entry: "Kaani Hotels" is a consistently-used brand name
   across Kaani Beach Hotel, Kaani Grand Seaview, Kaani Palm Beach and the "Kaani Tours" excursion
   arm, but no snippet reviewed surfaced a registered company name for the group. Treat the
   "Sandbank, Snorkeling & Dolphin Watching Excursions" entry as provisional in the same way as the
   Kaani Beach Hotel accommodation record.
3. **Full-Day Snorkeling & Island Hopping Tour — no single named operator.** This entry was sourced
   from a Viator marketplace listing rather than a directly-identified local tour company, so
   `operator_name` is `null`. Maafushi has many competing island-hopping operators (Arena, iComm/
   iCom Tours, Kaani Tours and others were all mentioned in passing across searches); this generic
   entry was kept deliberately un-attributed rather than guessing which specific company runs the
   exact Viator-listed itinerary.
4. **Divers Baros Maldives — operator distinct from the resort's own (unresolved) operator.**
   `accommodations.json` already leaves Baros Maldives' own operator_name `null` due to no
   confirmed parent management company. "Divers Baros Maldives" is a separate, confidently
   verified real identity (the dive centre itself, PADI-listed under that exact name) and is used
   here as its own operator — this does not resolve or contradict the resort-level gap, it is a
   different, narrower fact.
5. **Sunset/night fishing trip pricing on Maafushi was too inconsistent to use.** An initial
   search for a generic Maafushi sunset fishing trip returned prices ranging from $65 to $141 for
   what may or may not be comparable trip lengths/inclusions (BBQ dinner vs. not, different
   operators including Arena and iComm mentioned by name in reviews but not tied to a specific
   priced listing with confidence). Rather than add a weakly-sourced generic Maafushi fishing
   entry, `fishing` category coverage was instead filled with two resort-run trips (Six Senses
   Laamu, Velassaru) where the activity itself is clearly confirmed even though price/duration are
   `null`.
6. **General caveat — WebSearch summarization layer.** As with the accommodations and locations
   datasets, every fact above passed through an AI-generated search-result summary rather than raw
   source HTML, because `WebFetch` is blocked in this sandbox. Figures that could not be
   corroborated with reasonable confidence were left `null` rather than resolved by guessing.
7. **Coverage is intentionally partial.** This directory covers 16 individually-sourced activities
   out of the very large number of real, bookable tours/excursions/courses that exist across
   Maafushi alone (let alone the rest of the Maldives). It is a small, solidly-sourced seed set,
   not a comprehensive activities catalogue. Several other real, named operators and activities
   were surfaced during research but deliberately left out to avoid diluting sourcing quality:
   other Maafushi dive centres (Maafushi Scuba, Eco Dive Club, The Dive Squad), other Maafushi
   excursion operators (Arena, "iComm"), Gili Lankanfushi's dolphin cruise and Ocean Paradise Dive
   Centre, and Six Senses Laamu's manta-snorkeling trips and overwater spa.

## Totals

- `activities.json`: 16 entries, covering all 9 schema `activity_category` values, spanning 7
  islands/resort-islands across 3 atolls (K, B, L) already present in the seeded dataset.
