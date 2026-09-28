# Sources and methodology

Data compiled September 2026 for a new `transfers` category: `routes.json` (15 directional
route+service bundles) and `schedules.json` (4 sourced recurring departure times). This is the
first pass at ground/sea/air transfer data in this repository.

**Access constraint:** direct `WebFetch`/page retrieval was blocked in this sandbox, exactly as
noted in every other `SOURCES.md` in this repo (`data/maldives/locations/SOURCES.md`,
`data/maldives/accommodations/SOURCES.md`, `data/maldives/activities/SOURCES.md`,
`data/maldives/fishing/SOURCES.md`, `data/maldives/diving/SOURCES.md`,
`data/maldives/surfing/SOURCES.md`). All research was done via the `WebSearch` tool, which returns
AI-generated summaries of search-result snippets rather than raw page content. Every fact below
passed through that summarization layer.

**The critical constraint for this category is different from every prior dataset:** the
`transfer_services` table's `price` column is `NOT NULL`, so unlike every other category in this
project, a `null` price does not mean "field omitted" — it means the whole entry is skipped. This
sharply narrowed what could be recorded: real, well-documented transfer operators and routes were
repeatedly found and then **excluded entirely** (not recorded with a `null` price) the moment no
specific number surfaced. See "Known gaps" below for the most notable of these.

**Geography cross-check:** every `origin_name`/`destination_name` +
`*_atoll_administrative_code` pair was checked directly against
`data/maldives/locations/islands.json` (193 inhabited islands) and, for the 6 resort islands,
against the pairs already recorded in `data/maldives/accommodations/accommodations.json`:
Vihamanaafushi/Kurumba (K), Kunfunadhoo/Soneva Fushi (B), Velassaru (K), Olhuveli/Six Senses Laamu
(L), Baros (K), Lankanfushi/Gili Lankanfushi (K); plus Malé, Hulhumalé (both MLE) and Maafushi,
Thulusdhoo, Himmafushi, Guraidhoo (Kaafu Atoll — distinct from the same-named island in Thaa
Atoll), Rasdhoo (AA), per the task brief's list of already-seeded inhabited islands. A Python
cross-check script was run against `islands.json` before finalizing this dataset (see below); every
`(name, atoll_administrative_code)` pair in `routes.json` matched a real, already-seeded location.

**The one new location this task allows — Velana International Airport:** confirmed via a
dedicated search ("Velana International Airport official name history renamed Ibrahim Nasir
2016") across maldives.net.mv, maldivesindependent.com, presidency.gov.mv, en.wikipedia.org and
corporatemaldives.com: Hulhulé Airport (opened 1960) → Malé International Airport (1981) →
Ibrahim Nasir International Airport (26 July 2011) → **Velana International Airport**, effective
1 January 2017 (inaugurated 31 December 2016 by then-President Abdulla Yameen; "Velana" is the
family house name of former President Ibrahim Nasir). No source found any renaming since 2017, so
"Velana International Airport" is confirmed as the still-current official name as of this research
date (19 September 2026). It sits on Hulhulé island, which is deliberately excluded from
`islands.json` as uninhabited and is administratively part of Malé City (`atoll_administrative_code:
MLE`) per `data/maldives/locations/atolls.json`'s own notes on the Malé City entry — `MLE` was used
as the atoll code for every entry with this airport as origin or destination.

**Provider linking:** six entries reuse an exact existing provider name already in this dataset,
each independently confirmed to run the specific transfer service recorded: **Universal Resorts**
(2 entries — Kurumba Maldives' and Velassaru Maldives' own speedboat transfers), **Soneva
Management (BVI) Limited** (1 entry — Soneva Fushi's own seaplane transfer, matching the pattern
already used for Soneva Fushi's dive-centre entry in `data/maldives/diving/SOURCES.md`), **Six
Senses** (1 entry — Six Senses Laamu's own domestic-flight-plus-speedboat transfer), **Kaani
Hotels** (1 entry — its Maafushi property's shared speedboat) and **iCom Tours** (1 entry — its
independent shared speedboat to Maafushi). Two entries use "Baros Maldives" and "Gili Lankanfushi"
themselves as `operator_name`, since — as already established in `data/maldives/diving/SOURCES.md`
and confirmed again directly against `accommodations.json` for this pass — neither resort island
has a distinct accommodation-operator name on record, and each transfer is the resort's own,
self-branded product. Four entries introduce a real, government/public operator not previously in
this dataset: **Maldives Transport and Contracting Company (MTCC)** (the public ferry authority;
used for 6 ferry entries) and **Maldives Ports Limited (MPL)** (the Sinamalé Bridge public bus
fare-setter; used for 1 entry). `Knight At Sea` and `Active Watersports Maafushi` (named in the
task brief's existing-provider list) were specifically searched for a transfer product and none
surfaced with a confirmed price, so neither is used in this dataset — see Known Gaps.

## Public ferries (MTCC) — Malé and North Malé Atoll islands

- **Public Ferry (Malé–Maafushi / Maafushi–Malé).** Queries: "MTCC public ferry Male Maafushi fare
  price 2026". Confirmed via holiday.com.mv, thingstodoplace.com, budgetmaldives.com and
  maldivesnomad.com: route 309, MVR 22 (~USD 1.50), ~90 minutes, departs Malé 15:00 daily except
  Friday via Gulhi and Guraidhoo. Distance (27 km) from holiday.com.mv's Maafushi transfer page.
  The reverse direction (Maafushi–Malé) is recorded as its own entry per the task rule, on the
  reasoning that sources describe MVR 22 as the route's flat fare (not a one-way-only figure) and
  the route-309 schedule explicitly includes a return leg.
- **Public Ferry (Malé–Guraidhoo / Guraidhoo–Malé).** Query: "MTCC public ferry Male Guraidhoo
  Kaafu fare price schedule". Confirmed via Wikipedia's "Guraidhoo (Kaafu Atoll)" page and
  moovitapp.com's route-309 listing: MVR 22, 2h15m, departs Malé same 15:00 run; a distinct,
  independently-sourced Guraidhoo-side return departure ("Saturday to Thursday at 7am") justifies
  recording Guraidhoo–Malé as its own directional entry, not an assumption of symmetry. A private
  speedboat alternative ("The Escape", ~USD 25, 45 min) also surfaced but its operator could not be
  confirmed, so it was not added.
- **Public Ferry (Malé–Himmafushi).** Query: "MTCC public ferry Male Himmafushi fare price
  schedule route", cross-checked with "budgetmaldives.com Male to Himmafushi ferry guide". Route
  308, departs Malé 14:30 daily except Friday, arrives Himmafushi 15:10 (40 min, corroborated by
  budgetmaldives.com's independently-stated 40-minute duration). Price is the weakest-confidence
  figure in this dataset: budgetmaldives.com states "around US$2 per person one-way", somewhat
  above (but in the same range as) the MVR 22 (~USD 1.50) flat fare cited for the Maafushi/Guraidhoo
  routes on the same MTCC network — flagged as approximate rather than treated as identical to the
  other routes' fare. The reverse direction, despite a confirmed 08:00 Himmafushi departure, was
  deliberately not added as its own entry to avoid padding the dataset with a near-duplicate at the
  same hedged fare.
- **Airport Ferry (Velana International Airport–Malé).** Query: "Velana International Airport
  ferry to Male fare MVR". Confirmed via thaiest.com, lifeofdoing.com, maldivesairport.com and
  maleairport.com: MVR 15 per trip (one source noted MVR 20 "first thing in the morning", not used
  as the recorded fare), 10-minute crossing, 24-hour service every 10-15 min by day / ~30 min
  overnight, up to 3 free luggage pieces per passenger. Operator (MTCC) recorded at moderate
  confidence — a follow-up search ("'airport ferry' Male MTCC OR 'Maldives Ports Limited' operator
  Hulhule terminal") confirmed MTCC as the current sole operator of the separate Malé–Hulhumalé
  ferry and as the general operator of Malé's public ferry terminals, but did not independently
  re-confirm MTCC specifically for this Hulhulé-airport route, which historical sources associate
  with a joint MACL/MPL/MTCC arrangement.
- **Sinamalé Bridge Public Bus (Malé–Hulhumalé).** Query: "Sinamalé bridge bus Male Hulhumale fare
  RTL price MVR". Confirmed via edition.mv, see.mv and corporatemaldives.com: MVR 10 one-way,
  effective from 1 January 2019 (free immediately after the bridge's September 2018 opening), paid
  via a rechargeable bus card (cash not accepted per the source). Operator recorded as Maldives
  Ports Limited (MPL), which the sourced reporting explicitly credits with setting this bus fare —
  distinct from MTCC, which a related search found now runs the separate passenger ferry on
  roughly the same corridor. Flagged as a stale-dated figure: no 2025/2026 source re-confirmed this
  exact fare is still current, only the original ~2019 announcement.

## Resort airport transfers (speedboat, seaplane, domestic flight)

- **Shared Speedboat Transfer (Kurumba Maldives, Universal Resorts).** Queries: "Kurumba Maldives
  speedboat transfer airport price per person"; "maldivestour.guide Kurumba Maldives Transfer $50
  speedboat price details". Confirmed via a summary of kurumba.com's own resort-information pages:
  USD 49.50++ per adult one-way (++ = 10% service charge + 16% GST excluded), independently
  corroborated by maldivestour.guide's "from $50" figure for the same transfer. A private option
  (USD 75++ per adult) was found but not added as a separate entry in this pass.
- **Shared Speedboat Transfer (Baros Maldives).** Query: "baros.com speedboat transfer shared
  private price per person round trip official". Confirmed via a summary citing baros.com's own
  FAQ: USD 260 per person, round trip, tax-inclusive, explicitly described as "shared... arranged
  according to guest international flights", 25-minute crossing. A closely matching but slightly
  lower USD 250-259 figure appeared in an earlier, separate search of secondary sources; USD 260
  was used as the figure most directly tied to baros.com. A "private transfer" option exists but is
  listed only as "rates on request" with no figure, so it was excluded per the NOT-NULL price rule.
- **Mandatory Speedboat Transfer (Velassaru Maldives, Universal Resorts).** Queries: "Velassaru
  Maldives speedboat transfer airport price per person round trip"; "velassaru.com speedboat
  transfer $187 one way round trip mandatory". USD 187 per person is the LOWEST-CONFIDENCE price in
  this dataset: it comes from aggregator sites (maldivestour.guide, callainamaldives.com) in the
  first search, and a dedicated follow-up search of velassaru.com's own FAQ could not
  independently re-confirm the exact figure (only the mandatory, resort-exclusive nature of the
  transfer was corroborated directly from the resort's own site). Whether the figure is one-way or
  round-trip is also explicitly unresolved in the source material itself.
- **Shared Return Speedboat Transfer (Gili Lankanfushi).** Query: "Gili Lankanfushi speedboat
  transfer airport price". Confirmed via a search summary: "shared return speedboat transfers from
  the airport are US$302 per person (excluding taxes and service charge)... USD 302.44 per person
  for a roundtrip." A looser corroborating range (~USD 240-300 per adult, "as of 2025") also
  surfaced. Distance (~20 km) and duration (30 min) from traveljee.com's "How to Get to Gili
  Lankanfushi" guide.
- **Shared Speedboat Transfer (Kaani Hotels, Maafushi).** Query: "Kaani Hotels Maafushi speedboat
  transfer airport price". Confirmed via a Tripadvisor forum thread ("Kaani speedboat to Maafushi
  USD$20/person") and makemytrip.global's Kaani Beach Hotel listing: USD 20 per person one-way, 35
  minutes; a private full-boat charter (USD 150, max 8 guests) was also found and its capacity
  recorded as context on this shared entry rather than added as its own line item.
- **Shared Speedboat Transfer (iCom Tours, Maafushi).** Queries: "maafushidive.com transport
  speedboat price Male airport Maafushi"; "'iCom Tours' Maafushi speedboat transfer price".
  Confirmed via maafushidive.com's own "Transport" page (which recommends booking scheduled
  speedboat tickets "through ICOMtours or MaafushiTours"): ~USD 25 per person, 45 minutes. A more
  recent, higher figure (USD 30, "prices checked May-June 2026") also surfaced alongside an older
  USD 20 figure in a dedicated iCom Tours search; USD 25 was used as the most consistently repeated
  figure across sources, flagged as likely to drift upward given the explicitly rising-price note.
- **Shared Seaplane Transfer (Soneva Fushi, Soneva Management (BVI) Limited).** Query: "Soneva
  Fushi seaplane transfer price fixed USD". Confirmed directly via soneva.com's own "Your Journey
  to Soneva Fushi" page: USD 950 per adult (USD 475 per child) round trip, shared seaplane, for the
  4 May-30 September 2026 season (the season current as of this research's date, 19 September
  2026); the same page states USD 1,300 per adult for the surrounding Jan-May and Oct-onward
  seasons — flagged as explicitly seasonal, due to change again from 1 October 2026. A private
  charter option (USD 7,000-9,600 nett one-way) was found but not recorded as its own entry, since
  it is a whole-aircraft charter rather than a discrete per-person product like the other entries
  here. The seaplane is operated in practice by Manta Air and/or Trans Maldivian Airways per a
  follow-up search, but since Soneva prices and sells this specific transfer as its own resort
  product, "Soneva Management (BVI) Limited" (the exact existing accommodation-operator name) was
  used as `operator_name`, matching the pattern from `data/maldives/diving/SOURCES.md`.
- **Domestic Flight & Speedboat Transfer (Six Senses Laamu, Six Senses).** Queries: "Six Senses
  Laamu domestic flight speedboat transfer price Kaadedhdhoo"; "Six Senses Laamu transfer shared or
  private speedboat Kadhdhoo $590". Confirmed via Six Senses'/travel-press coverage of "how to get
  to Six Senses Laamu": USD 590 per person round trip (subject to taxes/service charge) for a ~40
  minute Malé-Kadhdhoo domestic flight plus a ~15-20 minute speedboat to Olhuveli island. The
  speedboat leg from Kadhdhoo is confirmed as shared by default, with private/chartered boats
  available only on request at extra cost. `transfer_type` recorded as `domestic_flight` (the
  schema has no combined-transfer type) since the flight is the defining, longer leg; the
  speedboat leg is captured in `vehicle_type`/`dropoff_instructions` instead. A newer seaplane
  transfer option at Six Senses Laamu was also found but carried no confirmed USD figure, so it was
  not added as its own entry.

## Schedules

Only four genuinely time-specific, sourced departures were found and recorded in `schedules.json`,
all for MTCC public ferries (route 309 to Maafushi/Guraidhoo, and route 308 to Himmafushi) — no
resort speedboat, seaplane or domestic-flight transfer in this dataset publishes a fixed public
departure timetable (all are described as coordinated around individual guest flight arrivals), so
none of those 9 resort-transfer entries have a corresponding `schedules.json` row. This schema has
no way to express "every day except Friday" (the standard MTCC weekly off-day for all four
schedules recorded); `day_of_week` was set to `null` ("every day") as the closest available fit in
every case, with the Friday exception preserved in each entry's own `notes` field instead of being
silently dropped.

## Known gaps

1. **Public ferries to Thulusdhoo and Rasdhoo were specifically researched and excluded for lack
   of a confident, specific fare.** Thulusdhoo (route 308, same route family as Himmafushi) has a
   well-documented schedule (departs Malé 14:30 daily except Friday, arrives 16:00) but no source
   reviewed gave a Thulusdhoo-specific fare — only a generic "MVR 22-450 ($1.50-$30) depending on
   distance" range for the whole MTCC network, too imprecise to record with confidence. Rasdhoo
   (Alif Alif Atoll, a longer inter-atoll route) returned genuinely conflicting figures across two
   dedicated searches ("about €8 each way" vs. "generally between $4 and $9 per person, one way"),
   with no single number repeated consistently enough to use; this route was left out entirely
   rather than picking one of the conflicting figures.
2. **"Knight At Sea" (named in the task brief's existing-provider list) returned no transfer
   product or price in a dedicated search** ("'Knight At Sea' Maldives speedboat transfer price") —
   only generic industry-average speedboat pricing unrelated to that specific operator. Not used.
3. **"Active Watersports Maafushi" (also in the existing-provider list) was searched specifically
   for an airport transfer product** ("Active Watersports Maafushi speedboat transfer Male airport
   price") but no distinct price attributable to that operator (as opposed to the general
   Male-Maafushi speedboat market, or to Maafushi Dive and Water Sports' own transfer) surfaced.
   Not used, to avoid guessing a generic market price onto a specific operator.
4. **"The Escape" private speedboat to Guraidhoo (~USD 25, 45 min)** surfaced in the Guraidhoo
   ferry research but its operating company could not be confirmed by name in the snippets
   reviewed, so it was not added as its own entry despite having a specific price.
5. **Soneva Fushi's private seaplane charter (USD 7,000-9,600 nett one-way) and Baros Maldives' and
   Velassaru's private-transfer variants** were found with either no figure ("rates on request",
   Baros) or judged out of scope as whole-aircraft charters (Soneva) rather than per-person
   products comparable to the rest of this dataset, and were excluded from `routes.json` even
   though their shared/mandatory counterparts are included.
6. **Kurumba's and Velassaru's transfer prices carry `++`/mandatory-fee caveats that don't map
   cleanly onto a single schema field.** Kurumba's USD 49.50 figure explicitly excludes a 10%
   service charge and 16% GST ("++"); this is noted in that entry's own `notes` rather than folded
   into `price`, since the source itself quotes the pre-tax figure as the headline rate.
7. **General caveat — WebSearch summarization layer.** As with every other dataset in this
   repository, every fact above passed through an AI-generated search-result summary rather than
   raw source HTML, because `WebFetch` is blocked in this sandbox. Figures that could not be
   corroborated with reasonable confidence were excluded entirely rather than resolved by guessing
   — a stricter standard than other categories' `null`-field convention, since this schema's `price`
   field cannot be `null` at all.
8. **Coverage is intentionally partial and skews toward Malé-adjacent Kaafu Atoll routes and the 6
   named resort islands.** Real Maldives transfer operators and routes (particularly seaplane and
   domestic-flight transfers to more distant atolls, almost all of which are quote-based/bundled
   into a stay rather than fixed-priced) vastly outnumber what's recorded here. This first pass
   deliberately prioritized the routes most likely to publish a genuine fixed fare — government
   public ferries and resort-published speedboat/seaplane rate cards — per the task brief's own
   guidance.

## Totals

- `routes.json`: 15 entries, across 7 origin/destination islands + 1 airport (Malé, Maafushi,
  Guraidhoo, Himmafushi, Hulhumalé, Vihamanaafushi, Baros, Velassaru, Lankanfushi, Kunfunadhoo,
  Olhuveli — 11 distinct real locations) and 4 atolls (MLE, K, B, L). `transfer_type` values used:
  `ferry` (6), `speedboat` (7), `seaplane` (1), `domestic_flight` (1), `land_transfer` (1) — no
  `private_yacht` service was confirmed with a real fixed price in this pass. `shared_or_private`:
  `shared` (14), `private` (1, Velassaru, recorded as a reasonable inference rather than a directly
  quoted label — see that entry's own notes). Every entry carries a real, sourced, non-null `price`
  per the task's hard constraint; several are explicitly flagged in their own `notes` as
  approximate, seasonal, hedged, or lower-confidence rather than presented as exact.
- `schedules.json`: 4 entries, all MTCC public ferries (routes 308 and 309), each citing its
  `service_name`/`operator_name` exactly as recorded in `routes.json`.
