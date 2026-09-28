-- Task 17 production-readiness audit: two Travel Guide articles imported
-- from the legacy site with a title/meta_title that was truncated
-- mid-sentence during the original scrape/import, both ending in a
-- dangling "for" — visible in the page <h1>, breadcrumbs, nav cards, and
-- the SEO <title> tag / search-result snippet.
--
-- Fixed by dropping the incomplete trailing "for" rather than guessing
-- what the original full title said (there is no way to recover that, and
-- inventing a plausible-sounding completion would itself be fabricated
-- content). The slug is intentionally left unchanged — it's already the
-- canonical URL (with a legacy redirect pointing at it), and rewriting it
-- now would require a new redirect on top of an already-established one
-- for no correctness gain, since the slug's URL segment was already
-- truncated in a self-consistent way (readers never see the slug, unlike
-- the title).
--
-- This is a corrective UPDATE, not an edit to the original migration
-- file — that migration (20250110000300_legacy_articles.sql) may or may
-- not already be applied to a live database, and an UPDATE is safe
-- either way (it no-ops if the original insert hasn't run yet and the
-- corrected values get inserted directly; it fixes the row in place if it
-- already ran).

update nodes
  set title = 'Best Maldives Honeymoon Packages',
      meta_title = 'Best Maldives Honeymoon Packages | Maldives Travel Guide | MTG'
  where node_type = 'article' and slug = 'best-maldives-honeymoon-packages-for';

update nodes
  set title = 'Maldives Weather Guide: Month by Month Climate Information',
      meta_title = 'Maldives Weather Guide: Month by Month Climate Information | Maldives Travel Guide | MTG'
  where node_type = 'article' and slug = 'maldives-weather-guide-month-by-month-climate-information-for';

-- Same audit: scripts/generate-activity-seed.mjs's summary template had no
-- a/an grammar logic ("${act.name} is a ${label} on ..."), which reads
-- fine for consonant-starting category labels but produced "is a
-- excursion" / "is a activity" / "is a island-hopping trip" wherever the
-- label starts with a vowel sound — visible in both the public summary
-- text and the SEO meta_description (the generator writes the same
-- string to both columns). The generator itself is now fixed to compute
-- the right article going forward; this corrects the 14 rows the old,
-- buggy version already produced. `replace()` is safe here because each
-- phrase is specific enough (activity name + category label combination)
-- that it can't coincidentally match unrelated text.
update nodes
  set summary = replace(summary, 'is a excursion', 'is an excursion'),
      meta_description = replace(meta_description, 'is a excursion', 'is an excursion')
  where node_type = 'activity' and (summary like '%is a excursion%' or meta_description like '%is a excursion%');

update nodes
  set summary = replace(summary, 'is a activity', 'is an activity'),
      meta_description = replace(meta_description, 'is a activity', 'is an activity')
  where node_type = 'activity' and (summary like '%is a activity%' or meta_description like '%is a activity%');

update nodes
  set summary = replace(summary, 'is a island-hopping trip', 'is an island-hopping trip'),
      meta_description = replace(meta_description, 'is a island-hopping trip', 'is an island-hopping trip')
  where node_type = 'activity' and (summary like '%is a island-hopping trip%' or meta_description like '%is a island-hopping trip%');
