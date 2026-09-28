# Sources and methodology

Data compiled September 2026 for `atolls.json` (21 entries: 20 administrative atolls + Malé City)
and `islands.json` (193 inhabited islands).

**Access constraint:** direct `WebFetch`/page retrieval was blocked in this sandbox. All research
was done via the `WebSearch` tool, which returns AI-generated summaries of search-result snippets
rather than raw page content. Every fact below is therefore filtered through that summarization
step. Where a summary was internally inconsistent (e.g. "seven inhabited islands" but only six
named), that inconsistency is called out explicitly rather than silently resolved by guessing.

## Administrative structure / atoll codes

- Query: "Maldives administrative atolls list codes 20 atolls Malé City Wikipedia" — confirmed
  the 20-atoll + Malé City structure and that Malé, Hulhulé, Hulhumalé and Villimalé are
  geographically in North Malé Atoll but administratively separate from Kaafu Atoll.
- Query: "Malé City administrative division Villingili Hulhumalé Hulhulé Wikipedia component
  islands" — confirmed Malé City's constituent islands (Malé, Hulhulé [airport, uninhabited],
  Hulhumalé, Villimalé/Villingili, plus industrial/reclaimed Gulhifalhu, Thilafushi,
  Giraavarufalhu, which are excluded from islands.json as non-residential).
- Per-atoll Wikipedia searches (see below) individually confirmed each atoll's English
  administrative-code letter(s) and, for most, the Dhivehi/Thaana letter code in parenthetical
  form (e.g. "HA (Dhivehi: ހއ)", "Lh (ޅ)", "GDh (ގދ)").
- For atolls where the Dhivehi code was not explicitly quoted in a snippet (AA, ADh, GA, Sh,
  Dh, Gn, S), the value was derived from the well-established, consistent Thaana-alphabetical-
  order pattern used for all other codes that *were* confirmed (Haa=ހ, Shaviyani=ށ, Noonu=ނ,
  Raa=ރ, Baa=ބ, Lhaviyani=ޅ, Kaafu=ކ, Alif=އ, Vaavu=ވ, Meemu=މ, Faafu=ފ, Dhaalu=ދ, Thaa=ތ,
  Laamu=ލ, Gaafu=ގ, Gnaviyani=ޏ, Seenu=ސ). This is standard, widely-documented Maldivian usage,
  but these specific derived values were not individually re-confirmed by a quoted snippet.
- Note: search summaries also surfaced a *different*, older single-Latin-letter sequential code
  system (A, B, C, D... assigned strictly in north-to-south atoll order) which is NOT what this
  dataset uses. The task's own example (`"K"`, `"HA"`, `"ADh"`) specifies the standard
  Thaana-alphabet-derived code system, which is what was used throughout `administrative_code`.
- Malé City has no Thaana-letter code in the same system as the 20 atolls (it is a "City", not
  a lettered atoll). `"MLE"` was used as a practical placeholder code; this is a judgment call,
  not a confirmed official single-source code — flag for review before production use.

## Per-atoll island-list queries

- **HA (Haa Alif):** "Haa Alif Atoll Wikipedia code capital inhabited islands list" → 14 islands
  named, consistent with the atoll's known ~14-island inhabited count.
- **HDh (Haa Dhaalu):** "Haa Dhaalu Atoll Wikipedia code capital inhabited islands list" plus a
  follow-up "Haa Dhaalu Atoll 17 inhabited islands complete list ..." → 14 islands consistently
  named across both searches. One snippet claimed "only 13 are inhabited" per an unnamed
  secondary source, conflicting with the 14 explicitly named islands. Used the 14 named islands;
  flagged as a low-confidence count discrepancy (see Known Gaps).
- **Sh (Shaviyani):** initial search returned only 5 islands; follow-up query listing candidate
  names ("Shaviyani Atoll inhabited islands complete list Funadhoo Komandoo Feydhoo Milandhoo
  Maroshi Narudhoo Lhaimagu Maakandoodhoo Kanditheemu Goidhoo") returned a fuller 14-island list
  which was used. "Maakandoodhoo" (from the query, not a real island) was correctly rejected by
  the search summary in favor of "Maaungoodhoo".
- **N (Noonu):** "Noonu Atoll Wikipedia code capital inhabited islands list" → 13 islands,
  consistent with known figures.
- **R (Raa):** "Raa Atoll Wikipedia code capital inhabited islands list" plus a cross-check
  "Raa Atoll 16 inhabited islands official complete list statoids atollsofmaldives.gov.mv" →
  the same 16-island list returned both times, including "Maamigili". This name is unusual
  because "Maamingili"/"Maamigili" is much better known as an island in Alif Dhaalu Atoll. Since
  Wikipedia was quoted identically twice, it was kept but flagged low-confidence (see Known Gaps).
- **B (Baa):** "Baa Atoll Wikipedia code capital inhabited islands list" → 13 islands, matches
  known figures.
- **Lh (Lhaviyani):** "Lhaviyani Atoll Wikipedia code capital inhabited islands list Naifaru
  Hinnavaru Kurendhoo" → 4 islands (Naifaru, Hinnavaru, Kurendhoo, Olhuvelifushi), which matches
  Lhaviyani's known small inhabited-island count.
- **K (Kaafu):** "Kaafu Atoll Wikipedia code capital inhabited islands list Thulusdhoo
  Himmafushi Guraidhoo" → returned 10 islands including Malé; Malé was excluded per the
  confirmed Malé-City-is-separate finding above, leaving 9 islands in Kaafu Atoll proper.
- **AA (Alif Alif / North Ari):** two searches, the second specifically enumerating candidate
  names ("... capital Rasdhoo inhabited islands complete list Ukulhas Mathiveri Feridhoo
  Himandhoo Maalhos Bodufolhudhoo Thoddoo") → consistent 8-island list, matches the commonly
  cited "8 inhabited / 25 uninhabited of 33 total" figure.
- **ADh (Alif Dhaalu / South Ari):** "Alif Dhaalu Atoll South Ari Atoll Wikipedia code capital
  inhabited islands Mahibadhoo Dhangethi Dhidhdhoo" → 10 islands, explicitly stated as "10 of 49
  islands are inhabited" — count and names agree.
- **V (Vaavu):** "Vaavu Atoll Wikipedia code capital inhabited islands list Felidhoo Keyodhoo
  Fulidhoo Rakeedhoo" → 5 islands, matches Vaavu's known small inhabited-island count.
- **M (Meemu):** "Meemu Atoll Wikipedia code capital inhabited islands list Muli ..." → 8 islands,
  explicitly confirmed against every name in the query.
- **F (Faafu):** "Faafu Atoll Wikipedia code capital inhabited islands list Nilandhoo Magoodhoo
  Bileddhoo Dharaboodhoo Feeali" → 5 islands, explicitly stated as "5 inhabited of 23 total".
- **Dh (Dhaalu):** two searches, including a follow-up specifically asking for the "seven"
  inhabited islands. Both times the source text asserted "seven of the islands are inhabited"
  but only ever named six (Bandidhoo, Hulhudheli, Kudahuvadhoo, Maaenboodhoo, Meedhoo,
  Rinbudhoo). The 7th name could not be found. **Not guessed — see Known Gaps.**
- **Th (Thaa):** "Thaa Atoll Wikipedia code capital inhabited islands list Veymandoo Guraidhoo
  Vandhoo Buruni Hirilandhoo" → 13 islands, matches Thaa's known inhabited-island count.
- **L (Laamu):** two searches. The second ("Laamu Atoll inhabited islands official list 12
  Kadhdhoo uninhabited airport") clarified that Kadhdhoo, despite appearing in one source's
  "inhabited" list, is in fact dominated by the atoll airport; a separate targeted search
  ("Gan Addu Atoll inhabited island airport ... 2026", used for Seenu) established the general
  pattern that Maldivian airport islands are typically population-free, reinforcing the decision
  to exclude Kadhdhoo here. The raw list also contained both "Maamendhoo" and "Maandhoo", which
  are almost certainly the same island under two spellings/transcription variants; only
  "Maamendhoo" was kept to avoid a possible duplicate. Final Laamu list: 12 islands.
- **GA (Gaafu Alifu):** "Gaafu Alifu Atoll Wikipedia code capital inhabited islands list
  Villingili Vilingili Maamendhoo Kolamaafushi" → 10 islands, matches known figures.
- **GDh (Gaafu Dhaalu):** two searches, both stating "10 ... inhabited" but naming only 9
  (Fares-Maathodaa, Fiyoari, Gaddhoo, Hoandeddhoo, Madaveli, Nadellaa, Rathafandhoo, Thinadhoo,
  Vaadhoo). The 10th name could not be found despite a targeted follow-up query. **Not guessed —
  see Known Gaps.**
- **Gn (Gnaviyani / Fuvahmulah):** "Gnaviyani Atoll Fuvahmulah Wikipedia code capital single
  island administrative" → confirmed as a single-island atoll (Fuvahmulah itself).
- **S (Seenu / Addu):** three searches. The first two gave the "traditional" picture (Hithadhoo,
  Maradhoo, Maradhoo-Feydhoo, Feydhoo, Gan, Hulhudhoo, Hulhu-Meedhoo, Meedhoo). A follow-up
  ("Addu City wards inhabited islands ... list") surfaced a **recent (late 2025 / 2026)
  administrative change**: following an October 2025 referendum, a 3 November 2025 presidential
  decree designated Addu Hulhudhoo and Addu Meedhoo as separate inhabited islands, redefining
  Addu City itself as only Hithadhoo, Maradhoo, Maradhoo-Feydhoo and Feydhoo. A further query
  ("Gan Addu Atoll inhabited island airport current status 2026") confirmed Gan itself remains
  uninhabited (airport only) and is not part of Addu City. Final Seenu list used: Hithadhoo,
  Maradhoo, Maradhoo-Feydhoo, Feydhoo, Hulhudhoo, Meedhoo (6 islands); Gan excluded.

## Known gaps / low-confidence entries

These are flagged rather than silently padded:

1. **Dhaalu Atoll (Dh) — incomplete island list.** Sources consistently state "seven islands are
   inhabited" but only six could be individually named across multiple queries: Bandidhoo,
   Hulhudheli, Kudahuvadhoo, Maaenboodhoo, Meedhoo, Rinbudhoo. A 7th inhabited island almost
   certainly exists (candidates like "Gemendhoo" were explicitly identified in search results as
   *abandoned/uninhabited*, so it was not used as a guess). **Action needed:** verify against an
   authoritative source (e.g. NBS Maldives census island list or atollsofmaldives.gov.mv) before
   treating `islands.json` as complete for Dh.

2. **Gaafu Dhaalu Atoll (GDh) — incomplete island list.** Sources consistently state "10 ...
   inhabited" but only 9 could be named: Fares-Maathodaa, Fiyoari, Gaddhoo, Hoandeddhoo,
   Madaveli, Nadellaa, Rathafandhoo, Thinadhoo, Vaadhoo. **Action needed:** same as above.

3. **Raa Atoll (R) — one uncertain island name.** "Maamigili" is included in Raa's 16-island
   list because it was returned identically by Wikipedia-sourced search snippets on two separate
   query passes, but this name is much better known as belonging to Alif Dhaalu Atoll
   ("Maamingili"/"Maamigili"). It is plausible both atolls have a similarly-named island (name
   reuse across atolls is common in the Maldives — e.g. "Meedhoo", "Vaadhoo", "Guraidhoo",
   "Omadhoo" all repeat), but this specific entry could not be independently cross-checked beyond
   the search-summary layer. **Action needed:** verify directly before production use.

4. **Haa Dhaalu Atoll (HDh) — count discrepancy.** 14 islands were consistently named, but one
   search summary cited an unnamed secondary source claiming only 13 inhabited islands (out of
   35 total). The 14 explicitly-named islands were kept since names, not just a count, were
   available; flagged in case the true figure is 13 and one listed name is stale/wrong.

5. **Laamu Atoll (L) — possible duplicate.** Raw search results included both "Maamendhoo" and
   "Maandhoo" as if they were two separate islands. Only "Maamendhoo" was kept on the
   assumption these are the same island (spelling/transcription variance); if a genuinely
   distinct "Maandhoo" exists in Laamu Atoll, it is currently missing from `islands.json`.

6. **Malé City administrative code.** No authoritative single source for a standard
   letter/short code for Malé City (unlike the 20 lettered atolls) was found via WebSearch.
   `"MLE"` was used as a reasonable placeholder; treat `atolls.json`'s Malé City
   `administrative_code` as provisional.

7. **General caveat — WebSearch summarization layer.** Because raw pages could not be fetched
   (WebFetch is blocked in this sandbox), every figure above passed through an AI-generated
   search-result summary rather than being read directly from source HTML/tables. Spelling
   variants (e.g. "Fiyoari"/"Fiyoaree", "Kalhaidhoo"/"Kalaidhoo", "Rinbudhoo"/"Ribudhoo",
   "Dhiyamigili"/"Dhiyamingili") were normalized to a single spelling per island in
   `islands.json`, with the variant noted in that island's `notes` field where seen.

## Islands deliberately excluded

- **Malé City:** Hulhulé (airport island, no permanent population), Thilafushi and Gulhifalhu
  (industrial/reclaimed islands, not residential administrative islands).
- **Laamu Atoll:** Kadhdhoo (dominated by the atoll's airport; not treated as a residential
  inhabited island despite appearing in one source's list).
- **Seenu Atoll:** Gan (Gan International Airport island; explicitly confirmed uninhabited/no
  permanent population, separate from the inhabited Addu City islands).

## Totals

- `atolls.json`: 21 entries (20 administrative atolls + Malé City).
- `islands.json`: 193 inhabited islands, within the expected ~185–200 national range (the
  November 2025 Addu restructuring, which split one former ward into two separately-designated
  islands, nudges the figure toward the higher end of that range relative to older sources).
