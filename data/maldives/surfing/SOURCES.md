# Sources and methodology

Data compiled September 2026 for a new `surfing` category, split per the task brief's critical
distinction into `activities.json` (9 new entries: commercial, bookable surf products) and
`surf_breaks.json` (13 entries: physical, non-commercial surf breaks/spots). This extends the
surfing category without duplicating the one surfing activity that already exists in
`data/maldives/activities/activities.json` ("Private Surf Lesson (Cokes)" at Thulusdhoo, Kaafu
Atoll, operated by "The Perfect Wave Cokes Surf Camp", $75/hour private lesson).

**Access constraint:** direct `WebFetch`/page retrieval was blocked in this sandbox, exactly as
noted in `data/maldives/locations/SOURCES.md`, `data/maldives/accommodations/SOURCES.md`,
`data/maldives/activities/SOURCES.md`, `data/maldives/fishing/SOURCES.md` and
`data/maldives/diving/SOURCES.md`. All research was done via the `WebSearch` tool, which returns
AI-generated summaries of search-result snippets rather than raw page content. Every fact below
passed through that summarization layer. Where a summary gave only a range instead of a single
figure, flagged internal disagreement between sources, or simply did not surface a number, the
corresponding field was left `null` rather than guessed, per the task's hard rule. Ranges and
compound skill-level labels (e.g. "intermediate to advanced") were deliberately NOT collapsed into
a single `difficulty` enum value -- they were left `null` and preserved as free text in `wave_notes`
instead, since picking one side of a stated range would misrepresent the source.

**Geography cross-check:** every `island_name`/`nearby_island_name` + `atoll_administrative_code`
pair was checked directly against `data/maldives/locations/islands.json` (193 inhabited islands)
and, for the 6 resort islands, against the pairs already recorded in
`data/maldives/accommodations/accommodations.json`: Vihamanaafushi/Kurumba (K),
Kunfunadhoo/Soneva Fushi (B), Velassaru (K), Olhuveli/Six Senses Laamu (L), Baros (K),
Lankanfushi/Gili Lankanfushi (K). A Python cross-check script was run against both files before
finalizing this dataset; every `island_name` in `activities.json` and every non-null
`nearby_island_name` in `surf_breaks.json` matched one of these 199 real (island, atoll) pairs.
Several real, well-documented breaks and one well-documented resort surf program are associated in
sources with islands that are *not* in this list (uninhabited resort islands like Thanburudhoo,
Kanifinolhu and the conflicting Kanuhuraa/Farukolhufushi/"Shaya Island" names given for Cinnamon
Dhonveli/Pasta Point, or the similarly uninhabited COMO Maalifushi) -- in every such case
`nearby_island_name` was left `null` for the break, and **no commercial activity was created** for
any operator based on one of those unverifiable islands, since `island_name` is a required field in
`activities.json`.

**Provider linking:** three activities reuse an exact existing provider name already in this
dataset (not a coincidence -- each was independently confirmed to run a real surf product): **Six
Senses** (2 activities, Six Senses Laamu's own Tropicsurf-run surf program), **Maafushi Dive and
Water Sports** (1 activity, "Wave Surfing" at Guraidhoo Corner) and **Active Watersports Maafushi**
(1 activity, its own separately-branded "Wave Surfing" product, also at Guraidhoo Corner -- kept as
a distinct entry from Maafushi Dive and Water Sports' product since both are independently real,
competing operators serving the same break). One activity reuses the existing operator "The Perfect
Wave Cokes Surf Camp" (a new, distinct group-lesson product from the existing private-lesson entry).
Four new, real, independently-verified surf-specific operators are introduced: **Twin Palms
Surfhouse** (Thulusdhoo), **Amphibuzz** (the watersports brand at Season Paradise hotel,
Thulusdhoo -- kept distinct from "Season Paradise" itself, matching the resort/dive-centre pattern
already established in `data/maldives/diving/SOURCES.md`), and **Jailbreak Surf Inn** (Himmafushi).
`iCom Tours` (an existing general tour-operator provider, Maafushi-based) was specifically searched
for a surf tie-in and none was found in the snippets reviewed, so it was not used here.

## Thulusdhoo (Kaafu Atoll) -- the Maldives' best-known surf hub

- **Group Surf Lesson (The Perfect Wave Cokes Surf Camp).** Queries: "Perfect Wave Cokes Surf Camp
  Thulusdhoo group lesson surf camp package price"; "Cokes Surf Camp Maldives group surf lesson 4
  days package price board rental". Confirmed via perfectwavetravel.com/nz/surf-trips/maldives/cokes-surf-camp
  and cokessurfcampmaldives.com: two ISA-qualified instructors, groups of up to 4 students, 2-hour
  sessions, all equipment provided, lessons run daily at Chickens/Baby Chickens/Ninjas/Sultans/Honkeys
  depending on conditions. No distinct group price found; `price_from` left `null`.
- **Guided Surf Boat Trip (Twin Palms Surfhouse).** Query: "Twin Palms Surfhouse Thulusdhoo surf
  package price lesson". Confirmed via twinpalmssurfhouse.com: a real, independent guesthouse
  offering 3-hour guided boat trips to Thulusdhoo-area breaks with a local captain, plus separate
  "personalised classes". No specific break named for the boat trip itself, so `surf_break_names`
  is empty; price not found, left `null`.
- **Surf Lesson & Surfboard Rental (Amphibuzz).** Queries: "Amphibuzz surf school Thulusdhoo Season
  Paradise lesson price beginner"; "'Season Paradise' Thulusdhoo surf guesthouse surf and stay
  package". Confirmed via amaldives.com's Amphibuzz operator listing and seasonparadise.mv/surfing/:
  a real watersports/surf-school brand on-site at Season Paradise hotel. Lesson price hedged as
  "can cost about $75"; board rental hedged as "about $35" -- both treated as lower-confidence,
  approximate figures rather than firm quotes.

## Himmafushi (Kaafu Atoll)

- **Multi-Day Surf Camp Package (Jailbreak Surf Inn).** Queries: "Jailbreak Surf Inn Himmafushi
  surf lesson package price beginner"; "Jailbreak surf break Maldives location Himmafushi
  Kanuhura". Confirmed via booking.com/tripadvisor.com listings and jailbreaksurfinn.com: a real
  surf guesthouse directly on Himmafushi at the Jailbreak break, offering B&B + 1 boat trip/day or
  full-board + up to 2 boat trips/day, to Jails/Honky's/Sultans by name. No standalone USD figure
  for the package (only room-night-style listings) surfaced, so `duration_minutes` and
  `price_from` were left `null`.

## Maafushi (Kaafu Atoll) -- two independent operators, same break

- **Wave Surfing (Maafushi Dive and Water Sports, existing operator).** Query: "maafushidive.com
  wave surfing product price Guraidhoo". Confirmed via maafushidive.com/products/wave-surfing: a
  60-minute session at Guraidhoo Corner, max 4 people, boards provided, $20/hour waiting charge for
  extra time (not used as the session price). Base price not found; left `null`.
- **Wave Surfing (Active Watersports Maafushi, existing operator).** Queries: "Maafushi surf lesson
  beginner surfing Active Watersports Maafushi"; "activemaldives.com price list wave surfing $ USD
  Maafushi". Confirmed via activemaldives.com/wave-surfing and followmetomaldives.com: a separate,
  independently-branded 60-minute session at the same break (Guraidhoo Corner), max 20 people,
  explicitly "beginner or experienced" (`difficulty: all_levels`). A $35/$60 figure that surfaced in
  the same search batch was for jet-ski rental, not wave surfing, and was deliberately excluded;
  `price_from` left `null`.

## Six Senses Laamu (Olhuveli, Laamu Atoll, existing operator: Six Senses)

- **Beginner Lagoon Surf Lesson & First Green Wave Private Surf Lesson.** Query: "Six Senses Laamu
  surf lesson Tropicsurf price beginner soul surfing program cost". Confirmed via
  sixsenses.com/en/experiences/soul-surfing and the resort's "Surfing with Tropicsurf" experience
  page, corroborated by curatedtravelmagazine.substack.com and theartsshelf.com: Six Senses Laamu's
  in-house program run with Tropicsurf. Beginner Lagoon Lessons "start from US$95++ per hour"; a
  private "first green wave" lesson is "US$145++ for 1.5 hours". The `++` in both figures denotes
  service charge/tax excluded from the quoted base rate -- flagged in both entries' notes. A
  separate "Learn to Surf" package (3 private lessons + meals + a spa treatment) was found but
  carried no confirmed USD price, so it was not added as its own entry.

## Surf breaks -- North/South Male Atoll (Kaafu, K)

- **Cokes, Chickens, Sultans, Honky's, Ninjas, Jailbreak, Guraidhoo Corner, Pasta Point.** Queries
  included: "Thulusdhoo surf breaks Cokes Chickens Honky's Ninjas Maldives"; "Chickens surf break
  location Himmafushi Thulusdhoo access"; "Honky's Ninjas surf break Maldives North Male Atoll
  location wave"; "Sultans surf break Maldives Male Atoll location"; "Jailbreak surf break Maldives
  location Himmafushi Kanuhura"; "Guraidhoo Corner surf break Maldives right left reef point wave
  description"; "Pasta Point surf break Ari Atoll Maldives Chaaya Island Dhonveli"; plus follow-up
  break-type queries ("reef break"/"point break" classification) for Cokes, Sultans/Honky's,
  Guraidhoo Corner. Sources: maldives-magazine.com, stokedfortravel.com, mondo.surf, amaldives.com,
  surf-forecast.com, surfatoll.com, dreamingofmaldives.com, swellnet.com, jonnymelon.com,
  surfsphere.com, atolltravel.com, waterwaystravel.com, islandii.com, mytourway.com,
  roamingsurfer.com, jailbreaksurfinn.com, and several guesthouse/tripadvisor/booking.com listings.
  Only Cokes (breaks directly off Thulusdhoo, matching the existing activity's own notes), Jailbreak
  (breaks off Himmafushi) and Guraidhoo Corner (10-15 min boat ride from Maafushi, named after
  Guraidhoo island itself) had a confidently-verifiable `nearby_island_name` from our 193-island
  list. Chickens, Sultans, Honky's, Ninjas and Pasta Point are each tied by sources to an
  uninhabited island (Viligilimathidhahuraa, Thanburudhoo/Thamburudhoo, Kanifinolhu, and a
  genuinely conflicting set of names for the Pasta Point/Cinnamon Dhonveli resort island) that is
  not in our dataset, so all five carry `nearby_island_name: null`.

## Surf breaks -- Laamu Atoll (L)

- **Yin-Yang.** See Six Senses Laamu queries above. `nearby_island_name: "Olhuveli"` since Yin-Yang
  is explicitly a few minutes by boat from Six Senses Laamu, one of the 6 resort islands already
  established in this dataset.
- **Isdoo Corner.** Queries: "Vato Riding Rush surf break Laamu Atoll Maldives" (searched per the
  task brief's suggested break names, but neither "Vato" nor "Riding Rush" surfaced enough
  independent documentation to add -- see Known Gaps); "Isdhoo Isdoo Corner surf break Laamu Atoll
  Maldives wave". Confirmed via stormrider.surf's Thaa/Laamu Atolls regional surf guide and
  en.wikipedia.org's "Isdhoo (Laamu Atoll)" page: a right-hander on the northeast tip of Laamu
  Atoll, named after and tied to Isdhoo, a real inhabited island in our 193-island list.

## Surf breaks -- Gaafu Dhaalu Atoll (GDh)

- **Tiger Stripes, Beacons, Castaways.** Queries: "Huvadhoo Gaafu Dhaalu Atoll surf breaks Maldives
  Tiger Stripe Castaways"; "Beacons Tiger Stripes Castaways surf break Gaafu Dhaalu Thinadhoo
  Vaadhoo nearby island"; "Tiger Stripes Beacons Castaways Gaafu Dhaalu 'reef break' type surf".
  Confirmed via blue-horizon.com.mv ("Southern Atolls Maldives Surf Breaks (Huvadhoo)"),
  dreamingofmaldives.com, bluestarsurfaris.com, suddenrush.com and airial.travel: three real, named,
  well-documented breaks on the southeast/southwest rim of Gaafu Dhaalu Atoll, reached by surf
  charter boat rather than from a single fixed island base. No source named a specific inhabited
  island as adjacent to any of the three, so `nearby_island_name` is `null` for all three.

## Known gaps

1. **Most prices, durations and max-participant figures were simply not surfaced by search, not
   disputed.** As in every other `SOURCES.md` in this repo, the large majority of `null` fields
   reflect the WebSearch summarization layer not returning a specific figure, even where the
   product/break itself is clearly confirmed as real. Of 9 activities, 4 have a confirmed
   `price_from` (2 explicitly hedged as approximate: Amphibuzz's $75 lesson and $35 rental); 3 have
   a confirmed `duration_minutes` value shared across 5 activities (60/90/120/180 min).
2. **COMO Maalifushi's real, well-documented "Learn to Surf"/"Surf Pro"/daily Surf Pass programs
   (Tropicsurf-run, Thaa Atoll) were deliberately excluded.** Pricing was unusually well-confirmed
   ($245/day Surf Pass; $6,170 "Learn to Surf" week; $7,390 "Surf Pro" week), but the resort's own
   island, "Maalifushi", is uninhabited and is not one of the 193 inhabited islands or the 6
   resort islands already established for this dataset -- and `island_name` is a required field in
   `activities.json`. Rather than guess it onto a nearby Thaa Atoll island, this whole
   operator/program was left out. The physical breaks Tropicsurf names at COMO Maalifushi ("Machine"
   at Laamu, "Farms" at Thaa, "Kasabu" at Dhaalu) were also not added as their own `surf_breaks.json`
   entries in this pass, for the same reason of not having a confidently-verifiable nearby island
   and out of a preference to keep this first surfing pass tightly scoped to breaks with clearer
   sourcing.
3. **Cinnamon Dhonveli / Pasta Point's commercial surf product was excluded for the same reason.**
   The resort explicitly markets exclusive guest access to Pasta Point, but its own island name is
   inconsistent across sources (Kanuhuraa vs. Farukolhufushi vs. the historical name "Shaya
   Island"), and none of those names are in our dataset. The break itself (Pasta Point) was still
   added to `surf_breaks.json`, with `nearby_island_name: null`, since a break's location field is
   nullable while an activity's `island_name` is not.
4. **"Vato" and "Riding Rush" (named in the task brief as example Laamu Atoll breaks) could not be
   independently confirmed.** WebSearch results for both names returned only general Laamu Atoll
   surf guides (which instead named Isdoo Corner, Machines, Coffins, Refugees Right/Left, House,
   Jetty C, Ying Yangs and Petrols as the documented breaks) without surfacing either name
   specifically. Neither was added; only Yin-Yang and Isdoo Corner (both independently
   well-documented) were included from Laamu Atoll.
5. **"Baby Chickens" (a break named alongside Chickens/Ninjas/Sultans/Honkeys in Cokes Surf Camp's
   own description of its group-lesson rotation) was not added as its own `surf_breaks.json`
   entry.** It surfaced only in that one operator-description context, with no independent wave/
   location detail found, so it was left out of `surf_breaks.json` and also out of the Group Surf
   Lesson activity's `surf_break_names` (which lists only the four names matching confirmed break
   entries).
6. **"Riptides" and "Kandooma Right" (mentioned alongside Guraidhoo Corner by the same South Male
   Atoll surf sources) were not added.** Riptides' exact reef location was not confirmed with
   enough confidence, and Kandooma Right's nearby island (Kandooma) is an uninhabited resort island
   not present in our 193-island/6-resort-island dataset, matching the same exclusion already noted
   for Kandooma in `data/maldives/diving/SOURCES.md`.
7. **Addu Atoll (Seenu, S) surf lessons were specifically searched for and not added.** Every
   source reviewed described Addu Atoll's breaks as hollow, powerful, shallow-reef waves generally
   unsuitable for beginners/improvers, and none surfaced a real, named, beginner-accessible
   commercial surf-lesson operator there with enough independent confirmation to add to this
   dataset.
8. **Two break-type labels were deliberately left `null` despite a shallow-reef description**
   (Isdoo Corner and Castaways), because no source reviewed used an explicit "reef break"/"point
   break"/etc. label for that specific spot, even though the surrounding geographic/wave
   description is consistent with a reef break -- per the task rule to use a `break_type` value
   only when the source actually describes it that way.
9. **Several `difficulty` fields were deliberately left `null` where a source gave a range or
   compound label** ("intermediate to advanced", "intermediate and advanced", "challenging but also
   suitable for intermediate surfers") rather than a single one of this dataset's four standard
   terms. The exact wording was preserved in each entry's own `wave_notes` instead of being
   collapsed into one label.
10. **General caveat -- WebSearch summarization layer.** As with every other dataset in this
    repository, every fact above passed through an AI-generated search-result summary rather than
    raw source HTML, because `WebFetch` is blocked in this sandbox. Figures that could not be
    corroborated with reasonable confidence were left `null` rather than resolved by guessing.
11. **Coverage is intentionally partial.** Real Maldives surf operators and breaks vastly outnumber
    what's recorded here. Other real, named entities were surfaced but deliberately left out to
    keep sourcing quality high in this first pass: several other Thulusdhoo guesthouses/surf camps
    (Batuta Maldives Surf View, Surf Yoga Camp, Canopus Retreat, Thulusdhoo Island Surf Villa),
    Kandooma Surf Resort (South Male Atoll -- excluded for the same uninhabited-island reason as
    Pasta Point and COMO Maalifushi), and numerous other Ari/Vaavu/Addu/Huvadhoo-area breaks and
    surf-charter boats (e.g. Grandezza, Horizon II, Sudden Rush) not individually verified against
    a confirmed island/atoll pairing for this pass.

## Totals

- `activities.json`: 9 new entries, across 4 islands (Thulusdhoo x4, Maafushi x2, Himmafushi x1,
  Olhuveli x2) and 2 atolls (K, L). 4 reuse an existing operator exactly (Six Senses x2, Maafushi
  Dive and Water Sports x1, Active Watersports Maafushi x1, The Perfect Wave Cokes Surf Camp x1 --
  5 entries across those exact-match operators); 3 new real surf-specific operators are introduced
  (Twin Palms Surfhouse, Amphibuzz, Jailbreak Surf Inn). `surf_type` values used: `surf_lesson` (6),
  `guided_surfing` (1), `board_rental` (1), `surf_camp` (1) -- no `surf_coaching`, `surf_excursion`
  or `surf_safari` product was confirmed with enough confidence to add in this pass. 4 of 9 have a
  confirmed `price_from`.
- `surf_breaks.json`: 13 entries across 3 atolls (K: 8, L: 2, GDh: 3). `break_type` values used:
  `reef_break` (9), `point_break` (2), `null` (2, Isdoo Corner and Castaways, per Known Gaps #8) --
  no `beach_break` or `channel` break was confirmed with enough confidence to add. 5 of 13 have a
  confirmed `nearby_island_name` (Cokes/Thulusdhoo, Jailbreak/Himmafushi, Guraidhoo Corner/Guraidhoo,
  Yin-Yang/Olhuveli, Isdoo Corner/Isdhoo); the remaining 8 are `null` for the documented reasons
  above (uninhabited or name-conflicting islands, or no island named at all).
