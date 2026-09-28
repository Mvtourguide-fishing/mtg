# Maldives Attractions — sources

## The first 12 (Malé)

The first 12 entries in `attractions.json` are drawn verbatim (paraphrased
for length, no facts invented) from the "Places to Visit in Male" section
(§3.1–3.14) of the legacy article **"Beautiful Places to Visit in
Maldives"** (`articles.slug = 'beautiful-places-to-visit-in-maldives'`,
already imported by `20250110000300_legacy_articles.sql`). Two of that
section's 14 sub-entries were excluded because they're real inhabited
islands already represented as their own `locations` rows, not standalone
attractions: §3.8 Hulhumalé Island and §3.10 Villingili Island.

## The next 5 (broader geographic coverage)

Added to reduce the Malé-only concentration of the first batch, drawn from
two other already-imported legacy articles:

- **Hanifaru Bay** (Baa Atoll, marine) and **M6m Underwater Restaurant,
  Ozen Life Maadhoo** (Kaafu Atoll, landmark) — from
  `articles.slug = 'the-maldives'` (the legacy "The Maldives" overview
  article's own numbered "places to visit" list).
- **Vaadhoo Island — Sea of Stars** (Raa Atoll, natural) — also from
  `'the-maldives'`, describing the real bioluminescent-beach phenomenon
  (not to be confused with the unrelated `dive-sites/vaadhoo-caves` entry
  in Kaafu Atoll — a different real place with a similar name).
- **Maafushi Bikini Beach** (Kaafu Atoll, beach) and **Thoddoo Beach**
  (Alif Alif Atoll, beach) — from `'beautiful-places-to-visit-in-maldives'`'s
  own beach-guide section, same article as the Malé batch.

Neither Hanifaru Bay nor the Ozen Maadhoo restaurant ties to one specific
seeded inhabited island (Hanifaru is an open-water/reserve site; Ozen
Maadhoo is an uninhabited resort island not in the seeded islands
dataset), so both are parented directly to their real atoll instead —
the same `atoll → poi` relationship the taxonomy already allows (see
`location_type_hierarchy_rules`), just without an intermediate island.

## Architecture

Each attraction is seeded as a `locations` row (`location_type = 'poi'`),
parented under a real `male`/`vaadhoo`/`maafushi`/`thoddoo` island node or
a real `baa`/`kaafu` atoll node — the same architecture Task 8 established
for dive sites (`location_type = 'dive_site'`) and surf breaks
(`location_type = 'surf_break'`). No new table, no duplicate entity model.

## Images

Every image is a real file from the legacy site's own image library
(`data/maldives/migration/full-legacy-image-library-manifest.json`),
matched by the exact `<figure><img src="...">` embedded in that specific
§3.x section of the source article — i.e. the image the legacy site
itself displayed for that landmark, not a name-matched guess. Two
entries had no embedded image in the source article:

- **Victory Monument** — no image available; the card/detail page
  render without a hero image rather than use an unrelated photo.
- **Tsunami Monument** — no image in the source article's own markup,
  but a genuinely on-topic photo (`Tsunami-Monument-in-Mal.webp`) exists
  elsewhere in the legacy image library and was used instead.

## Known gaps

- No independent verification beyond the legacy site's own text (e.g. no
  cross-check against Wikipedia or official tourism sources) — same
  sourcing standard already applied to the dive-sites dataset.
- `best_for` and `attraction_type` are editorial classifications added
  here, not verbatim from the source.
