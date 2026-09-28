# Sources and methodology

Unlike every prior task's dataset, this one required no new external research. All 6
packages in `packages.json` are **MTG-curated itineraries**, assembled entirely from
accommodations, activities, and transfer services already sourced, verified, and seeded
in Tasks 5 (accommodations), 6–9 (activities/fishing/diving/surfing), and 10 (transfers).
None of these packages is attributed to, or represents itself as, a product sold by an
external tour operator — `operator_name` is `null` on every one, which the seed generator
turns into `packages.operated_by_provider_id = null`, and the package detail page
explicitly labels each one "An MTG-curated itinerary."

## Composition logic

Each package references real entities by their existing slug/service identifier — the
seed generator resolves these against the already-migrated database (accommodations from
Task 5, activities from Tasks 6–9, transfer routes/services from Task 10) rather than
re-describing them. Every accommodation, activity, and transfer service used already has
its own citation trail in `data/maldives/accommodations/SOURCES.md`,
`data/maldives/{activities,fishing,diving,surfing}/SOURCES.md`, and
`data/maldives/transfers/SOURCES.md`.

## Why no package has a price

`packages.price_from` is left `null` on every entry. The accommodations table has no
per-night rate column at all (only a `price_tier` band and, for two properties,
`all_inclusive`), so there is no real, verified lodging cost to sum into a package total
— and lodging is normally the dominant cost of a multi-night stay. Rather than invent a
number, every package is represented as a quote-based product: the detail page shows the
real, individually-priced activity and transfer components that ARE verified (from Tasks
6–10), and states plainly that a full package quote is available on request. This matches
the task brief's explicit instruction not to create a fake "from $X" price.

## Package-by-package composition notes

1. **5-Night Maafushi Local Island Escape** — accommodation: Kaani Beach Hotel (Task 5).
   Transfer: Velana Airport → Maafushi, Kaani Hotels' own shared speedboat (Task 10).
   Activities: Fun Dive (Single Tank) via Maafushi Dive and Water Sports (Task 8); Sunset
   Fishing Trip via Kaani Hotels (Task 7).
2. **7-Night Kurumba Resort Escape** — accommodation: Kurumba Maldives (Task 5). Transfer:
   Velana Airport → Vihamanaafushi, Universal Resorts' shared speedboat (Task 10).
   Activities: PADI Open Water Diver Course via Euro-Divers Kurumba (Task 8); Sunset Reef
   Fishing via Universal Resorts (Task 7).
3. **Maldives Honeymoon Escape — Soneva Fushi** — accommodation: Soneva Fushi, the one
   property in this dataset with a confirmed `all_inclusive = true` (Task 5). Transfer:
   Velana Airport → Kunfunadhoo, Soneva's own shared seaplane (Task 10, seasonal fare —
   see that route's own page). Activity: Fun Dive via Soleni Dive Center (Task 8).
4. **Maldives Diving Holiday — Baros** — accommodation: Baros Maldives (Task 5). Transfer:
   Velana Airport → Baros, Baros' own shared speedboat (Task 10). Activities: Discover
   Scuba Diving and Fluo Night Diving, both via Divers Baros Maldives (Task 8).
5. **Family Maldives Holiday — Velassaru** — accommodation: Velassaru Maldives (Task 5).
   Transfer: Velana Airport → Velassaru, Universal Resorts' mandatory speedboat (Task 10
   — flagged there as the dataset's lowest-confidence transfer price). Activities:
   Discover Scuba Diving via Immersion Dive Centre (Task 8); Big Game Fishing Trip via
   Universal Resorts (Task 7).
6. **Maldives Fishing & Island Hopping Package** — accommodation: Kaani Beach Hotel
   (Task 5, reused from package 1). Transfers: Velana Airport → Malé (MTCC airport ferry)
   and Malé ↔ Maafushi (MTCC public ferry, both directions — Task 10, including that
   route's own sourced 15:00 departure time). Activity: Night Fishing Trip via iCom Tours
   (Task 7).

## Known gaps

- **No return-to-airport transfer is recorded for any package.** Task 10 only sourced the
  arrival direction for every resort/independent airport transfer (`Velana Airport → X`);
  the reverse leg was never independently verified (per Task 10's own rule against
  assuming a route is symmetric), so it does not exist as a real `transfer_services` row
  to reference. Every package's final "Departure" stage says this plainly in its
  description rather than inventing a return-transfer item.
- **No Malé accommodation exists in this dataset**, so package 6 treats Malé as a same-day
  transit stop (arrive via the airport ferry, continue to Maafushi on the same afternoon's
  15:00 public ferry) rather than an overnight stay.
- **Guraidhoo was deliberately left out of the island-hopping package** despite having
  real round-trip MTCC ferry data (Task 10), because there is no accommodation on
  Guraidhoo in this dataset and no verified same-day round-trip connection time to
  support a honest day-excursion description.
- Six themes/traveler-types from the full taxonomy list (solo, long-stay, luxury, mix
  islands, local-island-resort, adventure, culture, wellness) have no package tagged with
  them yet — there simply wasn't a real, well-supported combination of existing
  accommodations/activities/transfers to justify one in this conservative first pass.
