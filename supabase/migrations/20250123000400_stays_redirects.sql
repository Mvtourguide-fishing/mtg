-- Redirects the 147 migrated legacy resort/hotel/guesthouse pages to
-- their new canonical URL (Stays ecosystem, Phase 2).
-- GENERATED FILE — do not hand-edit. Regenerate with:
--   node scripts/generate-stays-redirects.mjs
-- Source: data/maldives/accommodations-v2/resolved-properties.json
--
-- Matches by node title via a join, not a locally-recomputed slug — see
-- this script's header comment for why. On conflict this UPDATEs (not
-- "do nothing"), same convention as 20250111000100_legacy_redirects.sql.

insert into url_redirects (source_path, target_type, target_path, status_code, notes)
select '/resorts/Aaaveee-Natures-Paradise/aaaveee-natures-paradise-maldives-island-resort.html', 'path', '/maldives/resorts/' || n.slug || '/', 301, '[stays-migration] Aaaveee Nature''s Paradise Island Resort Maldives migrated to the real Stays ecosystem catalogue.'
from nodes n where n.node_type = 'accommodation' and n.title = 'Aaaveee Nature''s Paradise Island Resort Maldives'
on conflict (source_path) do update set target_type = excluded.target_type, target_path = excluded.target_path, status_code = excluded.status_code, notes = excluded.notes, updated_at = now();

insert into url_redirects (source_path, target_type, target_path, status_code, notes)
select '/resorts/Adaaran-Hudhuranfushi/Adaaran-Select-Hudhuran-Fushi-Maldives.html', 'path', '/maldives/resorts/' || n.slug || '/', 301, '[stays-migration] Adaaran Select Hudhuran Fushi Island Resort Maldives migrated to the real Stays ecosystem catalogue.'
from nodes n where n.node_type = 'accommodation' and n.title = 'Adaaran Select Hudhuran Fushi Island Resort Maldives'
on conflict (source_path) do update set target_type = excluded.target_type, target_path = excluded.target_path, status_code = excluded.status_code, notes = excluded.notes, updated_at = now();

insert into url_redirects (source_path, target_type, target_path, status_code, notes)
select '/resorts/Adaaran-Select/Adaaran-Select-Meedhupparu-Maldives.html', 'path', '/maldives/resorts/' || n.slug || '/', 301, '[stays-migration] Adaaran Select Meedhupparu Island Resort Maldives migrated to the real Stays ecosystem catalogue.'
from nodes n where n.node_type = 'accommodation' and n.title = 'Adaaran Select Meedhupparu Island Resort Maldives'
on conflict (source_path) do update set target_type = excluded.target_type, target_path = excluded.target_path, status_code = excluded.status_code, notes = excluded.notes, updated_at = now();

insert into url_redirects (source_path, target_type, target_path, status_code, notes)
select '/resorts/Adaaran-Vadoo/Adaaran-Prestige-Vadoo-Maldives.html', 'path', '/maldives/resorts/' || n.slug || '/', 301, '[stays-migration] Adaaran Prestige Vadoo Island Resort Maldives migrated to the real Stays ecosystem catalogue.'
from nodes n where n.node_type = 'accommodation' and n.title = 'Adaaran Prestige Vadoo Island Resort Maldives'
on conflict (source_path) do update set target_type = excluded.target_type, target_path = excluded.target_path, status_code = excluded.status_code, notes = excluded.notes, updated_at = now();

insert into url_redirects (source_path, target_type, target_path, status_code, notes)
select '/resorts/Alila-Kothaifaru/Alila-Kothaifaru-Maldives.html', 'path', '/maldives/resorts/' || n.slug || '/', 301, '[stays-migration] Alila Kothaifaru Maldives Island Resort migrated to the real Stays ecosystem catalogue.'
from nodes n where n.node_type = 'accommodation' and n.title = 'Alila Kothaifaru Maldives Island Resort'
on conflict (source_path) do update set target_type = excluded.target_type, target_path = excluded.target_path, status_code = excluded.status_code, notes = excluded.notes, updated_at = now();

insert into url_redirects (source_path, target_type, target_path, status_code, notes)
select '/resorts/Alimathaa/Alimathaa-Maldives.html', 'path', '/maldives/resorts/' || n.slug || '/', 301, '[stays-migration] Nakai Alimathaa Island Resort Maldives migrated to the real Stays ecosystem catalogue.'
from nodes n where n.node_type = 'accommodation' and n.title = 'Nakai Alimathaa Island Resort Maldives'
on conflict (source_path) do update set target_type = excluded.target_type, target_path = excluded.target_path, status_code = excluded.status_code, notes = excluded.notes, updated_at = now();

insert into url_redirects (source_path, target_type, target_path, status_code, notes)
select '/resorts/Amari-Havodda/Amari-Havodda-Maldives.html', 'path', '/maldives/resorts/' || n.slug || '/', 301, '[stays-migration] Amari Havodda Maldives Island Resort migrated to the real Stays ecosystem catalogue.'
from nodes n where n.node_type = 'accommodation' and n.title = 'Amari Havodda Maldives Island Resort'
on conflict (source_path) do update set target_type = excluded.target_type, target_path = excluded.target_path, status_code = excluded.status_code, notes = excluded.notes, updated_at = now();

insert into url_redirects (source_path, target_type, target_path, status_code, notes)
select '/resorts/Amaya-Resort/Amaya-Resort-Kuda-Rah-Maldives.html', 'path', '/maldives/resorts/' || n.slug || '/', 301, '[stays-migration] Amaya Kuda Rah Island Resort Maldives migrated to the real Stays ecosystem catalogue.'
from nodes n where n.node_type = 'accommodation' and n.title = 'Amaya Kuda Rah Island Resort Maldives'
on conflict (source_path) do update set target_type = excluded.target_type, target_path = excluded.target_path, status_code = excluded.status_code, notes = excluded.notes, updated_at = now();

insert into url_redirects (source_path, target_type, target_path, status_code, notes)
select '/resorts/Amilla-Fushi/Amilla-Fushi-Maldives.html', 'path', '/maldives/resorts/' || n.slug || '/', 301, '[stays-migration] Amilla Fushi Island Resort Maldives migrated to the real Stays ecosystem catalogue.'
from nodes n where n.node_type = 'accommodation' and n.title = 'Amilla Fushi Island Resort Maldives'
on conflict (source_path) do update set target_type = excluded.target_type, target_path = excluded.target_path, status_code = excluded.status_code, notes = excluded.notes, updated_at = now();

insert into url_redirects (source_path, target_type, target_path, status_code, notes)
select '/resorts/Angaga-Island/Angaga-Island-Resort-Maldives.html', 'path', '/maldives/resorts/' || n.slug || '/', 301, '[stays-migration] Angaga Island Resort & Spa Maldives migrated to the real Stays ecosystem catalogue.'
from nodes n where n.node_type = 'accommodation' and n.title = 'Angaga Island Resort & Spa Maldives'
on conflict (source_path) do update set target_type = excluded.target_type, target_path = excluded.target_path, status_code = excluded.status_code, notes = excluded.notes, updated_at = now();

insert into url_redirects (source_path, target_type, target_path, status_code, notes)
select '/resorts/Angsana-Velavaru/Angsana-Velavaru-Maldives.html', 'path', '/maldives/resorts/' || n.slug || '/', 301, '[stays-migration] Angsana Velavaru Island Resort Maldives migrated to the real Stays ecosystem catalogue.'
from nodes n where n.node_type = 'accommodation' and n.title = 'Angsana Velavaru Island Resort Maldives'
on conflict (source_path) do update set target_type = excluded.target_type, target_path = excluded.target_path, status_code = excluded.status_code, notes = excluded.notes, updated_at = now();

insert into url_redirects (source_path, target_type, target_path, status_code, notes)
select '/resorts/Atmosphere-Kanifushi/Atmosphere-Kanifushi-Maldives.html', 'path', '/maldives/resorts/' || n.slug || '/', 301, '[stays-migration] Atmosphere Kanifushi Island Resort Maldives migrated to the real Stays ecosystem catalogue.'
from nodes n where n.node_type = 'accommodation' and n.title = 'Atmosphere Kanifushi Island Resort Maldives'
on conflict (source_path) do update set target_type = excluded.target_type, target_path = excluded.target_path, status_code = excluded.status_code, notes = excluded.notes, updated_at = now();

insert into url_redirects (source_path, target_type, target_path, status_code, notes)
select '/resorts/Ayada/Ayada-Maldives.html', 'path', '/maldives/resorts/' || n.slug || '/', 301, '[stays-migration] Ayada Maldives Island Resort migrated to the real Stays ecosystem catalogue.'
from nodes n where n.node_type = 'accommodation' and n.title = 'Ayada Maldives Island Resort'
on conflict (source_path) do update set target_type = excluded.target_type, target_path = excluded.target_path, status_code = excluded.status_code, notes = excluded.notes, updated_at = now();

insert into url_redirects (source_path, target_type, target_path, status_code, notes)
select '/resorts/Baglioni-Resort/Baglioni-Resort-Maldives.html', 'path', '/maldives/resorts/' || n.slug || '/', 301, '[stays-migration] Baglioni Island Resort Maldives migrated to the real Stays ecosystem catalogue.'
from nodes n where n.node_type = 'accommodation' and n.title = 'Baglioni Island Resort Maldives'
on conflict (source_path) do update set target_type = excluded.target_type, target_path = excluded.target_path, status_code = excluded.status_code, notes = excluded.notes, updated_at = now();

insert into url_redirects (source_path, target_type, target_path, status_code, notes)
select '/resorts/Bandos-Island/Bandos-Island-Maldives.html', 'path', '/maldives/resorts/' || n.slug || '/', 301, '[stays-migration] Bandos Island Resort Maldives migrated to the real Stays ecosystem catalogue.'
from nodes n where n.node_type = 'accommodation' and n.title = 'Bandos Island Resort Maldives'
on conflict (source_path) do update set target_type = excluded.target_type, target_path = excluded.target_path, status_code = excluded.status_code, notes = excluded.notes, updated_at = now();

insert into url_redirects (source_path, target_type, target_path, status_code, notes)
select '/resorts/Banyan-Tree/Banyan-Tree-Vabbinfaru-Maldives.html', 'path', '/maldives/resorts/' || n.slug || '/', 301, '[stays-migration] Banyan Tree Vabbinfaru Island Resort Maldives migrated to the real Stays ecosystem catalogue.'
from nodes n where n.node_type = 'accommodation' and n.title = 'Banyan Tree Vabbinfaru Island Resort Maldives'
on conflict (source_path) do update set target_type = excluded.target_type, target_path = excluded.target_path, status_code = excluded.status_code, notes = excluded.notes, updated_at = now();

insert into url_redirects (source_path, target_type, target_path, status_code, notes)
select '/resorts/Baros-Island/Baros-Island-Maldives.html', 'path', '/maldives/resorts/' || n.slug || '/', 301, '[stays-migration] Same resort as the already-seeded "baros-maldives" — redirected there directly, not to a duplicate page.'
from nodes n where n.node_type = 'accommodation' and n.slug = 'baros-maldives'
on conflict (source_path) do update set target_type = excluded.target_type, target_path = excluded.target_path, status_code = excluded.status_code, notes = excluded.notes, updated_at = now();

insert into url_redirects (source_path, target_type, target_path, status_code, notes)
select '/resorts/COMO-Cocoa/COMO-Cocoa-Island-Maldives.html', 'path', '/maldives/resorts/' || n.slug || '/', 301, '[stays-migration] COMO Cocoa Island Resort Maldives migrated to the real Stays ecosystem catalogue.'
from nodes n where n.node_type = 'accommodation' and n.title = 'COMO Cocoa Island Resort Maldives'
on conflict (source_path) do update set target_type = excluded.target_type, target_path = excluded.target_path, status_code = excluded.status_code, notes = excluded.notes, updated_at = now();

insert into url_redirects (source_path, target_type, target_path, status_code, notes)
select '/resorts/COMO-Maalifushi/COMO-Maalifushi-Maldives.html', 'path', '/maldives/resorts/' || n.slug || '/', 301, '[stays-migration] COMO Maalifushi Island Resort Maldives migrated to the real Stays ecosystem catalogue.'
from nodes n where n.node_type = 'accommodation' and n.title = 'COMO Maalifushi Island Resort Maldives'
on conflict (source_path) do update set target_type = excluded.target_type, target_path = excluded.target_path, status_code = excluded.status_code, notes = excluded.notes, updated_at = now();

insert into url_redirects (source_path, target_type, target_path, status_code, notes)
select '/resorts/Cinnamon-Dhonveli/Cinnamon-Dhonveli-Maldives.html', 'path', '/maldives/resorts/' || n.slug || '/', 301, '[stays-migration] Cinnamon Dhonveli Island Resort Maldives migrated to the real Stays ecosystem catalogue.'
from nodes n where n.node_type = 'accommodation' and n.title = 'Cinnamon Dhonveli Island Resort Maldives'
on conflict (source_path) do update set target_type = excluded.target_type, target_path = excluded.target_path, status_code = excluded.status_code, notes = excluded.notes, updated_at = now();

insert into url_redirects (source_path, target_type, target_path, status_code, notes)
select '/resorts/Cinnamon-Hakuraa/Cinnamon-Hakuraa-Huraa-Maldives.html', 'path', '/maldives/resorts/' || n.slug || '/', 301, '[stays-migration] Cinnamon Hakuraa Huraa Island Resort Maldives migrated to the real Stays ecosystem catalogue.'
from nodes n where n.node_type = 'accommodation' and n.title = 'Cinnamon Hakuraa Huraa Island Resort Maldives'
on conflict (source_path) do update set target_type = excluded.target_type, target_path = excluded.target_path, status_code = excluded.status_code, notes = excluded.notes, updated_at = now();

insert into url_redirects (source_path, target_type, target_path, status_code, notes)
select '/resorts/Cinnamon-Velifushi/Cinnamon-Velifushi-Maldives.html', 'path', '/maldives/resorts/' || n.slug || '/', 301, '[stays-migration] Cinnamon Velifushi Island Resort Maldives migrated to the real Stays ecosystem catalogue.'
from nodes n where n.node_type = 'accommodation' and n.title = 'Cinnamon Velifushi Island Resort Maldives'
on conflict (source_path) do update set target_type = excluded.target_type, target_path = excluded.target_path, status_code = excluded.status_code, notes = excluded.notes, updated_at = now();

insert into url_redirects (source_path, target_type, target_path, status_code, notes)
select '/resorts/Coco-Bodu-Hithi/Coco-Bodu-Hithi-Maldives.html', 'path', '/maldives/resorts/' || n.slug || '/', 301, '[stays-migration] Coco Bodu Hithi Island Resort Maldives migrated to the real Stays ecosystem catalogue.'
from nodes n where n.node_type = 'accommodation' and n.title = 'Coco Bodu Hithi Island Resort Maldives'
on conflict (source_path) do update set target_type = excluded.target_type, target_path = excluded.target_path, status_code = excluded.status_code, notes = excluded.notes, updated_at = now();

insert into url_redirects (source_path, target_type, target_path, status_code, notes)
select '/resorts/Cocogiri-Island/Cocogiri-Island-Resort-Maldives.html', 'path', '/maldives/resorts/' || n.slug || '/', 301, '[stays-migration] Cocogiri Island Resort Maldives migrated to the real Stays ecosystem catalogue.'
from nodes n where n.node_type = 'accommodation' and n.title = 'Cocogiri Island Resort Maldives'
on conflict (source_path) do update set target_type = excluded.target_type, target_path = excluded.target_path, status_code = excluded.status_code, notes = excluded.notes, updated_at = now();

insert into url_redirects (source_path, target_type, target_path, status_code, notes)
select '/resorts/Cocoon/Cocoon-Maldives.html', 'path', '/maldives/resorts/' || n.slug || '/', 301, '[stays-migration] Cocoon Island Resort Maldives migrated to the real Stays ecosystem catalogue.'
from nodes n where n.node_type = 'accommodation' and n.title = 'Cocoon Island Resort Maldives'
on conflict (source_path) do update set target_type = excluded.target_type, target_path = excluded.target_path, status_code = excluded.status_code, notes = excluded.notes, updated_at = now();

insert into url_redirects (source_path, target_type, target_path, status_code, notes)
select '/resorts/Conrad-Rangali/Conrad-Maldives-Rangali-Island.html', 'path', '/maldives/resorts/' || n.slug || '/', 301, '[stays-migration] Conrad Maldives Rangali Island Resort Maldives migrated to the real Stays ecosystem catalogue.'
from nodes n where n.node_type = 'accommodation' and n.title = 'Conrad Maldives Rangali Island Resort Maldives'
on conflict (source_path) do update set target_type = excluded.target_type, target_path = excluded.target_path, status_code = excluded.status_code, notes = excluded.notes, updated_at = now();

insert into url_redirects (source_path, target_type, target_path, status_code, notes)
select '/resorts/Cora-Cora/Cora-Cora-Maldives.html', 'path', '/maldives/resorts/' || n.slug || '/', 301, '[stays-migration] Cora Cora Maldives Island Resort Maldives migrated to the real Stays ecosystem catalogue.'
from nodes n where n.node_type = 'accommodation' and n.title = 'Cora Cora Maldives Island Resort Maldives'
on conflict (source_path) do update set target_type = excluded.target_type, target_path = excluded.target_path, status_code = excluded.status_code, notes = excluded.notes, updated_at = now();

insert into url_redirects (source_path, target_type, target_path, status_code, notes)
select '/resorts/Dhigali/Dhigali-Maldives.html', 'path', '/maldives/resorts/' || n.slug || '/', 301, '[stays-migration] Dhigali Maldives Island Resort migrated to the real Stays ecosystem catalogue.'
from nodes n where n.node_type = 'accommodation' and n.title = 'Dhigali Maldives Island Resort'
on conflict (source_path) do update set target_type = excluded.target_type, target_path = excluded.target_path, status_code = excluded.status_code, notes = excluded.notes, updated_at = now();

insert into url_redirects (source_path, target_type, target_path, status_code, notes)
select '/resorts/Dhiggiri/Dhiggiri-Maldives.html', 'path', '/maldives/resorts/' || n.slug || '/', 301, '[stays-migration] NAKAI Dhiggiri Island Resort Maldives migrated to the real Stays ecosystem catalogue.'
from nodes n where n.node_type = 'accommodation' and n.title = 'NAKAI Dhiggiri Island Resort Maldives'
on conflict (source_path) do update set target_type = excluded.target_type, target_path = excluded.target_path, status_code = excluded.status_code, notes = excluded.notes, updated_at = now();

insert into url_redirects (source_path, target_type, target_path, status_code, notes)
select '/resorts/Dhigufaru-Island/Dhigufaru-Island-Resort-Maldives.html', 'path', '/maldives/resorts/' || n.slug || '/', 301, '[stays-migration] Dhigufaru Island Resort Maldives migrated to the real Stays ecosystem catalogue.'
from nodes n where n.node_type = 'accommodation' and n.title = 'Dhigufaru Island Resort Maldives'
on conflict (source_path) do update set target_type = excluded.target_type, target_path = excluded.target_path, status_code = excluded.status_code, notes = excluded.notes, updated_at = now();

insert into url_redirects (source_path, target_type, target_path, status_code, notes)
select '/resorts/Diamonds-Thudufushi/Diamonds-Thudufushi-Island-Maldives.html', 'path', '/maldives/resorts/' || n.slug || '/', 301, '[stays-migration] Diamond Thudufushi Maldives Resort and Spa migrated to the real Stays ecosystem catalogue.'
from nodes n where n.node_type = 'accommodation' and n.title = 'Diamond Thudufushi Maldives Resort and Spa'
on conflict (source_path) do update set target_type = excluded.target_type, target_path = excluded.target_path, status_code = excluded.status_code, notes = excluded.notes, updated_at = now();

insert into url_redirects (source_path, target_type, target_path, status_code, notes)
select '/resorts/Dusit-Thani/Dusit-Thani-Maldives.html', 'path', '/maldives/resorts/' || n.slug || '/', 301, '[stays-migration] Dusit Thani Island Resort Maldives migrated to the real Stays ecosystem catalogue.'
from nodes n where n.node_type = 'accommodation' and n.title = 'Dusit Thani Island Resort Maldives'
on conflict (source_path) do update set target_type = excluded.target_type, target_path = excluded.target_path, status_code = excluded.status_code, notes = excluded.notes, updated_at = now();

insert into url_redirects (source_path, target_type, target_path, status_code, notes)
select '/resorts/Emerald-Maldives/Emerald-Maldives-Resort-and-Spa.html', 'path', '/maldives/resorts/' || n.slug || '/', 301, '[stays-migration] Emerald Maldives Resort & Spa Fasmendhoo migrated to the real Stays ecosystem catalogue.'
from nodes n where n.node_type = 'accommodation' and n.title = 'Emerald Maldives Resort & Spa Fasmendhoo'
on conflict (source_path) do update set target_type = excluded.target_type, target_path = excluded.target_path, status_code = excluded.status_code, notes = excluded.notes, updated_at = now();

insert into url_redirects (source_path, target_type, target_path, status_code, notes)
select '/resorts/Eriyadu-Island/Eriyadu-Island-Resort-Maldives.html', 'path', '/maldives/resorts/' || n.slug || '/', 301, '[stays-migration] Eriyadu Island Resort Maldives migrated to the real Stays ecosystem catalogue.'
from nodes n where n.node_type = 'accommodation' and n.title = 'Eriyadu Island Resort Maldives'
on conflict (source_path) do update set target_type = excluded.target_type, target_path = excluded.target_path, status_code = excluded.status_code, notes = excluded.notes, updated_at = now();

insert into url_redirects (source_path, target_type, target_path, status_code, notes)
select '/resorts/Faarufushi/Faarufushi-Island-Maldives.html', 'path', '/maldives/resorts/' || n.slug || '/', 301, '[stays-migration] Emerald Faarufushi Island Resort Maldives migrated to the real Stays ecosystem catalogue.'
from nodes n where n.node_type = 'accommodation' and n.title = 'Emerald Faarufushi Island Resort Maldives'
on conflict (source_path) do update set target_type = excluded.target_type, target_path = excluded.target_path, status_code = excluded.status_code, notes = excluded.notes, updated_at = now();

insert into url_redirects (source_path, target_type, target_path, status_code, notes)
select '/resorts/Fairmont/Fairmont-Maldives-Sirru-FenFushi.html', 'path', '/maldives/resorts/' || n.slug || '/', 301, '[stays-migration] Fairmont Maldives Sirru Fen Fushi migrated to the real Stays ecosystem catalogue.'
from nodes n where n.node_type = 'accommodation' and n.title = 'Fairmont Maldives Sirru Fen Fushi'
on conflict (source_path) do update set target_type = excluded.target_type, target_path = excluded.target_path, status_code = excluded.status_code, notes = excluded.notes, updated_at = now();

insert into url_redirects (source_path, target_type, target_path, status_code, notes)
select '/resorts/Filitheyo-Island/Filitheyo-Island-Resort-Maldives.html', 'path', '/maldives/resorts/' || n.slug || '/', 301, '[stays-migration] Filitheyo Island Resort Maldives migrated to the real Stays ecosystem catalogue.'
from nodes n where n.node_type = 'accommodation' and n.title = 'Filitheyo Island Resort Maldives'
on conflict (source_path) do update set target_type = excluded.target_type, target_path = excluded.target_path, status_code = excluded.status_code, notes = excluded.notes, updated_at = now();

insert into url_redirects (source_path, target_type, target_path, status_code, notes)
select '/resorts/Finolhu/Finolhu-Maldives.html', 'path', '/maldives/resorts/' || n.slug || '/', 301, '[stays-migration] Finolhu Maldives Island Resort Kanufushi migrated to the real Stays ecosystem catalogue.'
from nodes n where n.node_type = 'accommodation' and n.title = 'Finolhu Maldives Island Resort Kanufushi'
on conflict (source_path) do update set target_type = excluded.target_type, target_path = excluded.target_path, status_code = excluded.status_code, notes = excluded.notes, updated_at = now();

insert into url_redirects (source_path, target_type, target_path, status_code, notes)
select '/resorts/Four-Seasons-Giraavaru/Four-Seasons-Maldives-Landaa-Giraavaru.html', 'path', '/maldives/resorts/' || n.slug || '/', 301, '[stays-migration] Four Seasons Resort Maldives at Landaa Giraavaru migrated to the real Stays ecosystem catalogue.'
from nodes n where n.node_type = 'accommodation' and n.title = 'Four Seasons Resort Maldives at Landaa Giraavaru'
on conflict (source_path) do update set target_type = excluded.target_type, target_path = excluded.target_path, status_code = excluded.status_code, notes = excluded.notes, updated_at = now();

insert into url_redirects (source_path, target_type, target_path, status_code, notes)
select '/resorts/Four-Seasons-Huraa/Four-Seasons-Maldives-Kuda-Huraa.html', 'path', '/maldives/resorts/' || n.slug || '/', 301, '[stays-migration] FOUR SEASONS RESORT MALDIVES AT KUDA HURAA migrated to the real Stays ecosystem catalogue.'
from nodes n where n.node_type = 'accommodation' and n.title = 'FOUR SEASONS RESORT MALDIVES AT KUDA HURAA'
on conflict (source_path) do update set target_type = excluded.target_type, target_path = excluded.target_path, status_code = excluded.status_code, notes = excluded.notes, updated_at = now();

insert into url_redirects (source_path, target_type, target_path, status_code, notes)
select '/resorts/Four-Seasons-Voavah/Four-Seasons-Maldives-Private-Island-Voavah.html', 'path', '/maldives/resorts/' || n.slug || '/', 301, '[stays-migration] Four Seasons Maldives Private Island at Voavah Resort Maldives migrated to the real Stays ecosystem catalogue.'
from nodes n where n.node_type = 'accommodation' and n.title = 'Four Seasons Maldives Private Island at Voavah Resort Maldives'
on conflict (source_path) do update set target_type = excluded.target_type, target_path = excluded.target_path, status_code = excluded.status_code, notes = excluded.notes, updated_at = now();

insert into url_redirects (source_path, target_type, target_path, status_code, notes)
select '/resorts/Fun-Island/Fun-Island-Resort-Maldives.html', 'path', '/maldives/resorts/' || n.slug || '/', 301, '[stays-migration] Fun Island Resort & Spa Maldives migrated to the real Stays ecosystem catalogue.'
from nodes n where n.node_type = 'accommodation' and n.title = 'Fun Island Resort & Spa Maldives'
on conflict (source_path) do update set target_type = excluded.target_type, target_path = excluded.target_path, status_code = excluded.status_code, notes = excluded.notes, updated_at = now();

insert into url_redirects (source_path, target_type, target_path, status_code, notes)
select '/resorts/Furaveri/Furaveri-Maldives.html', 'path', '/maldives/resorts/' || n.slug || '/', 301, '[stays-migration] Furaveri Maldives Island Resort migrated to the real Stays ecosystem catalogue.'
from nodes n where n.node_type = 'accommodation' and n.title = 'Furaveri Maldives Island Resort'
on conflict (source_path) do update set target_type = excluded.target_type, target_path = excluded.target_path, status_code = excluded.status_code, notes = excluded.notes, updated_at = now();

insert into url_redirects (source_path, target_type, target_path, status_code, notes)
select '/resorts/Fushifaru/Fushifaru-Maldives.html', 'path', '/maldives/resorts/' || n.slug || '/', 301, '[stays-migration] Fushifaru Maldives Island Resort migrated to the real Stays ecosystem catalogue.'
from nodes n where n.node_type = 'accommodation' and n.title = 'Fushifaru Maldives Island Resort'
on conflict (source_path) do update set target_type = excluded.target_type, target_path = excluded.target_path, status_code = excluded.status_code, notes = excluded.notes, updated_at = now();

insert into url_redirects (source_path, target_type, target_path, status_code, notes)
select '/resorts/Gangehi-Island/Gangehi-Island-Resort-Maldives.html', 'path', '/maldives/resorts/' || n.slug || '/', 301, '[stays-migration] Gangehi Island Resort Maldives migrated to the real Stays ecosystem catalogue.'
from nodes n where n.node_type = 'accommodation' and n.title = 'Gangehi Island Resort Maldives'
on conflict (source_path) do update set target_type = excluded.target_type, target_path = excluded.target_path, status_code = excluded.status_code, notes = excluded.notes, updated_at = now();

insert into url_redirects (source_path, target_type, target_path, status_code, notes)
select '/resorts/Gili-Lankanfushi/Gili-Lankanfushi-Maldives.html', 'path', '/maldives/resorts/' || n.slug || '/', 301, '[stays-migration] Same resort as the already-seeded "gili-lankanfushi" — redirected there directly, not to a duplicate page.'
from nodes n where n.node_type = 'accommodation' and n.slug = 'gili-lankanfushi'
on conflict (source_path) do update set target_type = excluded.target_type, target_path = excluded.target_path, status_code = excluded.status_code, notes = excluded.notes, updated_at = now();

insert into url_redirects (source_path, target_type, target_path, status_code, notes)
select '/resorts/Grand-Park-Kodhipparu/Grand-Park-Kodhipparu-Maldives.html', 'path', '/maldives/resorts/' || n.slug || '/', 301, '[stays-migration] Grand Park Kodhipparu Maldives Island Resort migrated to the real Stays ecosystem catalogue.'
from nodes n where n.node_type = 'accommodation' and n.title = 'Grand Park Kodhipparu Maldives Island Resort'
on conflict (source_path) do update set target_type = excluded.target_type, target_path = excluded.target_path, status_code = excluded.status_code, notes = excluded.notes, updated_at = now();

insert into url_redirects (source_path, target_type, target_path, status_code, notes)
select '/resorts/Hard-Rock-Hotel/Hard-Rock-Hotel-Maldives.html', 'path', '/maldives/resorts/' || n.slug || '/', 301, '[stays-migration] Hard Rock Hotel Maldives Island Resort migrated to the real Stays ecosystem catalogue.'
from nodes n where n.node_type = 'accommodation' and n.title = 'Hard Rock Hotel Maldives Island Resort'
on conflict (source_path) do update set target_type = excluded.target_type, target_path = excluded.target_path, status_code = excluded.status_code, notes = excluded.notes, updated_at = now();

insert into url_redirects (source_path, target_type, target_path, status_code, notes)
select '/resorts/Heritance-Aarah/Heritance-Aarah-Maldives.html', 'path', '/maldives/resorts/' || n.slug || '/', 301, '[stays-migration] Heritance Aarah Maldives Island Resort migrated to the real Stays ecosystem catalogue.'
from nodes n where n.node_type = 'accommodation' and n.title = 'Heritance Aarah Maldives Island Resort'
on conflict (source_path) do update set target_type = excluded.target_type, target_path = excluded.target_path, status_code = excluded.status_code, notes = excluded.notes, updated_at = now();

insert into url_redirects (source_path, target_type, target_path, status_code, notes)
select '/resorts/Hideaway-Beach/Hideaway-Beach-Resort-Maldives.html', 'path', '/maldives/resorts/' || n.slug || '/', 301, '[stays-migration] Hideaway Beach Resort & Spa Maldives Island migrated to the real Stays ecosystem catalogue.'
from nodes n where n.node_type = 'accommodation' and n.title = 'Hideaway Beach Resort & Spa Maldives Island'
on conflict (source_path) do update set target_type = excluded.target_type, target_path = excluded.target_path, status_code = excluded.status_code, notes = excluded.notes, updated_at = now();

insert into url_redirects (source_path, target_type, target_path, status_code, notes)
select '/resorts/Hotel-Riu/Hotel-Riu-Palace-Maldives.html', 'path', '/maldives/resorts/' || n.slug || '/', 301, '[stays-migration] RIU Palace Maldives Island Resort migrated to the real Stays ecosystem catalogue.'
from nodes n where n.node_type = 'accommodation' and n.title = 'RIU Palace Maldives Island Resort'
on conflict (source_path) do update set target_type = excluded.target_type, target_path = excluded.target_path, status_code = excluded.status_code, notes = excluded.notes, updated_at = now();

insert into url_redirects (source_path, target_type, target_path, status_code, notes)
select '/resorts/Hurawalhi-Island/Hurawalhi-Island-Resort-Maldives.html', 'path', '/maldives/resorts/' || n.slug || '/', 301, '[stays-migration] Hurawalhi Island Resort Maldives migrated to the real Stays ecosystem catalogue.'
from nodes n where n.node_type = 'accommodation' and n.title = 'Hurawalhi Island Resort Maldives'
on conflict (source_path) do update set target_type = excluded.target_type, target_path = excluded.target_path, status_code = excluded.status_code, notes = excluded.notes, updated_at = now();

insert into url_redirects (source_path, target_type, target_path, status_code, notes)
select '/resorts/Innahura/Innahura-Maldives-Resort.html', 'path', '/maldives/resorts/' || n.slug || '/', 301, '[stays-migration] Innahura Maldives Island Resort migrated to the real Stays ecosystem catalogue.'
from nodes n where n.node_type = 'accommodation' and n.title = 'Innahura Maldives Island Resort'
on conflict (source_path) do update set target_type = excluded.target_type, target_path = excluded.target_path, status_code = excluded.status_code, notes = excluded.notes, updated_at = now();

insert into url_redirects (source_path, target_type, target_path, status_code, notes)
select '/resorts/InterContinental/InterContinental-Maldives-Maamunagau-Resort.html', 'path', '/maldives/resorts/' || n.slug || '/', 301, '[stays-migration] InterContinental Maldives Maamunagau Island Resort migrated to the real Stays ecosystem catalogue.'
from nodes n where n.node_type = 'accommodation' and n.title = 'InterContinental Maldives Maamunagau Island Resort'
on conflict (source_path) do update set target_type = excluded.target_type, target_path = excluded.target_path, status_code = excluded.status_code, notes = excluded.notes, updated_at = now();

insert into url_redirects (source_path, target_type, target_path, status_code, notes)
select '/resorts/JA-Manafaru/JA-Manafaru-Maldives.html', 'path', '/maldives/resorts/' || n.slug || '/', 301, '[stays-migration] JA Manafaru Maldives Island Resort migrated to the real Stays ecosystem catalogue.'
from nodes n where n.node_type = 'accommodation' and n.title = 'JA Manafaru Maldives Island Resort'
on conflict (source_path) do update set target_type = excluded.target_type, target_path = excluded.target_path, status_code = excluded.status_code, notes = excluded.notes, updated_at = now();

insert into url_redirects (source_path, target_type, target_path, status_code, notes)
select '/resorts/JOALI/JOALI-Maldives.html', 'path', '/maldives/resorts/' || n.slug || '/', 301, '[stays-migration] JOALI Maldives Island Resort migrated to the real Stays ecosystem catalogue.'
from nodes n where n.node_type = 'accommodation' and n.title = 'JOALI Maldives Island Resort'
on conflict (source_path) do update set target_type = excluded.target_type, target_path = excluded.target_path, status_code = excluded.status_code, notes = excluded.notes, updated_at = now();

insert into url_redirects (source_path, target_type, target_path, status_code, notes)
select '/resorts/JW-Marriott/JW-Marriott-Maldives-Resort.html', 'path', '/maldives/resorts/' || n.slug || '/', 301, '[stays-migration] JW Marriott Maldives Island Resort migrated to the real Stays ecosystem catalogue.'
from nodes n where n.node_type = 'accommodation' and n.title = 'JW Marriott Maldives Island Resort'
on conflict (source_path) do update set target_type = excluded.target_type, target_path = excluded.target_path, status_code = excluded.status_code, notes = excluded.notes, updated_at = now();

insert into url_redirects (source_path, target_type, target_path, status_code, notes)
select '/resorts/Jumeirah-Olhahali/Jumeirah-Olhahali-Island-Maldives.html', 'path', '/maldives/resorts/' || n.slug || '/', 301, '[stays-migration] Jumeirah Maldives Olhahali Island Resort migrated to the real Stays ecosystem catalogue.'
from nodes n where n.node_type = 'accommodation' and n.title = 'Jumeirah Maldives Olhahali Island Resort'
on conflict (source_path) do update set target_type = excluded.target_type, target_path = excluded.target_path, status_code = excluded.status_code, notes = excluded.notes, updated_at = now();

insert into url_redirects (source_path, target_type, target_path, status_code, notes)
select '/resorts/Kandima/Kandima-Maldives.html', 'path', '/maldives/resorts/' || n.slug || '/', 301, '[stays-migration] Kandima Maldives Island Resort migrated to the real Stays ecosystem catalogue.'
from nodes n where n.node_type = 'accommodation' and n.title = 'Kandima Maldives Island Resort'
on conflict (source_path) do update set target_type = excluded.target_type, target_path = excluded.target_path, status_code = excluded.status_code, notes = excluded.notes, updated_at = now();

insert into url_redirects (source_path, target_type, target_path, status_code, notes)
select '/resorts/Kandolhu/Kandolhu-Maldives.html', 'path', '/maldives/resorts/' || n.slug || '/', 301, '[stays-migration] Kandolhu Maldives Island Resort migrated to the real Stays ecosystem catalogue.'
from nodes n where n.node_type = 'accommodation' and n.title = 'Kandolhu Maldives Island Resort'
on conflict (source_path) do update set target_type = excluded.target_type, target_path = excluded.target_path, status_code = excluded.status_code, notes = excluded.notes, updated_at = now();

insert into url_redirects (source_path, target_type, target_path, status_code, notes)
select '/resorts/Komandoo-Island/Komandoo-Island-Resort-Maldives.html', 'path', '/maldives/resorts/' || n.slug || '/', 301, '[stays-migration] Komandoo Island Resort and Spa Maldives migrated to the real Stays ecosystem catalogue.'
from nodes n where n.node_type = 'accommodation' and n.title = 'Komandoo Island Resort and Spa Maldives'
on conflict (source_path) do update set target_type = excluded.target_type, target_path = excluded.target_path, status_code = excluded.status_code, notes = excluded.notes, updated_at = now();

insert into url_redirects (source_path, target_type, target_path, status_code, notes)
select '/resorts/Kudadoo/Kudadoo-Maldives-Private-Island.html', 'path', '/maldives/resorts/' || n.slug || '/', 301, '[stays-migration] Kudadoo Maldives Private Island Resort migrated to the real Stays ecosystem catalogue.'
from nodes n where n.node_type = 'accommodation' and n.title = 'Kudadoo Maldives Private Island Resort'
on conflict (source_path) do update set target_type = excluded.target_type, target_path = excluded.target_path, status_code = excluded.status_code, notes = excluded.notes, updated_at = now();

insert into url_redirects (source_path, target_type, target_path, status_code, notes)
select '/resorts/Kurumba/Kurumba-Maldives.html', 'path', '/maldives/resorts/' || n.slug || '/', 301, '[stays-migration] Same resort as the already-seeded "kurumba-maldives" — redirected there directly, not to a duplicate page.'
from nodes n where n.node_type = 'accommodation' and n.slug = 'kurumba-maldives'
on conflict (source_path) do update set target_type = excluded.target_type, target_path = excluded.target_path, status_code = excluded.status_code, notes = excluded.notes, updated_at = now();

insert into url_redirects (source_path, target_type, target_path, status_code, notes)
select '/resorts/LUX-South/LUX-South-Ari-Atoll-Maldives.html', 'path', '/maldives/resorts/' || n.slug || '/', 301, '[stays-migration] LUX* South Ari Atoll Resorts Maldives Island migrated to the real Stays ecosystem catalogue.'
from nodes n where n.node_type = 'accommodation' and n.title = 'LUX* South Ari Atoll Resorts Maldives Island'
on conflict (source_path) do update set target_type = excluded.target_type, target_path = excluded.target_path, status_code = excluded.status_code, notes = excluded.notes, updated_at = now();

insert into url_redirects (source_path, target_type, target_path, status_code, notes)
select '/resorts/Lily-beach/Lily-beach-Resort-Maldives.html', 'path', '/maldives/resorts/' || n.slug || '/', 301, '[stays-migration] Lily Beach Resort & Spa Maldives Island Resort migrated to the real Stays ecosystem catalogue.'
from nodes n where n.node_type = 'accommodation' and n.title = 'Lily Beach Resort & Spa Maldives Island Resort'
on conflict (source_path) do update set target_type = excluded.target_type, target_path = excluded.target_path, status_code = excluded.status_code, notes = excluded.notes, updated_at = now();

insert into url_redirects (source_path, target_type, target_path, status_code, notes)
select '/resorts/Maayafushi/Nakai-Maayafushi-Island-Resort-Maldives.html', 'path', '/maldives/resorts/' || n.slug || '/', 301, '[stays-migration] NAKAI Maayafushi Maldives Island Resort migrated to the real Stays ecosystem catalogue.'
from nodes n where n.node_type = 'accommodation' and n.title = 'NAKAI Maayafushi Maldives Island Resort'
on conflict (source_path) do update set target_type = excluded.target_type, target_path = excluded.target_path, status_code = excluded.status_code, notes = excluded.notes, updated_at = now();

insert into url_redirects (source_path, target_type, target_path, status_code, notes)
select '/resorts/Makunudu-Island/Makunudu-Island-Maldives.html', 'path', '/maldives/resorts/' || n.slug || '/', 301, '[stays-migration] Makunudu Island Resort Maldives migrated to the real Stays ecosystem catalogue.'
from nodes n where n.node_type = 'accommodation' and n.title = 'Makunudu Island Resort Maldives'
on conflict (source_path) do update set target_type = excluded.target_type, target_path = excluded.target_path, status_code = excluded.status_code, notes = excluded.notes, updated_at = now();

insert into url_redirects (source_path, target_type, target_path, status_code, notes)
select '/resorts/Malahini-Kuda-Bandos/Malahini-Kuda-Bandos-Maldives.html', 'path', '/maldives/resorts/' || n.slug || '/', 301, '[stays-migration] Malahini Kuda Bandos Maldives Island Resort migrated to the real Stays ecosystem catalogue.'
from nodes n where n.node_type = 'accommodation' and n.title = 'Malahini Kuda Bandos Maldives Island Resort'
on conflict (source_path) do update set target_type = excluded.target_type, target_path = excluded.target_path, status_code = excluded.status_code, notes = excluded.notes, updated_at = now();

insert into url_redirects (source_path, target_type, target_path, status_code, notes)
select '/resorts/Medhufushi-Island/Medhufushi-Island-ResortMaldives.html', 'path', '/maldives/resorts/' || n.slug || '/', 301, '[stays-migration] Medhufushi Island Resort Maldives migrated to the real Stays ecosystem catalogue.'
from nodes n where n.node_type = 'accommodation' and n.title = 'Medhufushi Island Resort Maldives'
on conflict (source_path) do update set target_type = excluded.target_type, target_path = excluded.target_path, status_code = excluded.status_code, notes = excluded.notes, updated_at = now();

insert into url_redirects (source_path, target_type, target_path, status_code, notes)
select '/resorts/Meeru-Island/Meeru-Island-Resort-Maldives.html', 'path', '/maldives/resorts/' || n.slug || '/', 301, '[stays-migration] Meeru Island Resort & Spa Maldives migrated to the real Stays ecosystem catalogue.'
from nodes n where n.node_type = 'accommodation' and n.title = 'Meeru Island Resort & Spa Maldives'
on conflict (source_path) do update set target_type = excluded.target_type, target_path = excluded.target_path, status_code = excluded.status_code, notes = excluded.notes, updated_at = now();

insert into url_redirects (source_path, target_type, target_path, status_code, notes)
select '/resorts/Milaidhoo/Milaidhoo-Maldives.html', 'path', '/maldives/resorts/' || n.slug || '/', 301, '[stays-migration] Milaidhoo Maldives Island Resort migrated to the real Stays ecosystem catalogue.'
from nodes n where n.node_type = 'accommodation' and n.title = 'Milaidhoo Maldives Island Resort'
on conflict (source_path) do update set target_type = excluded.target_type, target_path = excluded.target_path, status_code = excluded.status_code, notes = excluded.notes, updated_at = now();

insert into url_redirects (source_path, target_type, target_path, status_code, notes)
select '/resorts/Mirihi-Island/Mirihi-Island-Resort-Maldives.html', 'path', '/maldives/resorts/' || n.slug || '/', 301, '[stays-migration] Mirihi Island Resort Maldives migrated to the real Stays ecosystem catalogue.'
from nodes n where n.node_type = 'accommodation' and n.title = 'Mirihi Island Resort Maldives'
on conflict (source_path) do update set target_type = excluded.target_type, target_path = excluded.target_path, status_code = excluded.status_code, notes = excluded.notes, updated_at = now();

insert into url_redirects (source_path, target_type, target_path, status_code, notes)
select '/resorts/Movenpick/Movenpick-Resort-Kuredhivaru-Maldives.html', 'path', '/maldives/resorts/' || n.slug || '/', 301, '[stays-migration] Movenpick Resort Kuredhivaru Maldives Resort migrated to the real Stays ecosystem catalogue.'
from nodes n where n.node_type = 'accommodation' and n.title = 'Movenpick Resort Kuredhivaru Maldives Resort'
on conflict (source_path) do update set target_type = excluded.target_type, target_path = excluded.target_path, status_code = excluded.status_code, notes = excluded.notes, updated_at = now();

insert into url_redirects (source_path, target_type, target_path, status_code, notes)
select '/resorts/Nika-Island/Nika-Island-Reosrt-Maldives.html', 'path', '/maldives/resorts/' || n.slug || '/', 301, '[stays-migration] Nika Island Resort & Spa Maldives migrated to the real Stays ecosystem catalogue.'
from nodes n where n.node_type = 'accommodation' and n.title = 'Nika Island Resort & Spa Maldives'
on conflict (source_path) do update set target_type = excluded.target_type, target_path = excluded.target_path, status_code = excluded.status_code, notes = excluded.notes, updated_at = now();

insert into url_redirects (source_path, target_type, target_path, status_code, notes)
select '/resorts/Noku/Noku-Maldives.html', 'path', '/maldives/resorts/' || n.slug || '/', 301, '[stays-migration] Noku Maldives Island Resort migrated to the real Stays ecosystem catalogue.'
from nodes n where n.node_type = 'accommodation' and n.title = 'Noku Maldives Island Resort'
on conflict (source_path) do update set target_type = excluded.target_type, target_path = excluded.target_path, status_code = excluded.status_code, notes = excluded.notes, updated_at = now();

insert into url_redirects (source_path, target_type, target_path, status_code, notes)
select '/resorts/Nova/Nova-Maldives.html', 'path', '/maldives/resorts/' || n.slug || '/', 301, '[stays-migration] NOVA Maldives Island Resort migrated to the real Stays ecosystem catalogue.'
from nodes n where n.node_type = 'accommodation' and n.title = 'NOVA Maldives Island Resort'
on conflict (source_path) do update set target_type = excluded.target_type, target_path = excluded.target_path, status_code = excluded.status_code, notes = excluded.notes, updated_at = now();

insert into url_redirects (source_path, target_type, target_path, status_code, notes)
select '/resorts/OBLU-NATURE-Helengeli/OBLU-NATURE-Helengeli-Maldives.html', 'path', '/maldives/resorts/' || n.slug || '/', 301, '[stays-migration] OBLU NATURE Helengeli Maldives Island Resort migrated to the real Stays ecosystem catalogue.'
from nodes n where n.node_type = 'accommodation' and n.title = 'OBLU NATURE Helengeli Maldives Island Resort'
on conflict (source_path) do update set target_type = excluded.target_type, target_path = excluded.target_path, status_code = excluded.status_code, notes = excluded.notes, updated_at = now();

insert into url_redirects (source_path, target_type, target_path, status_code, notes)
select '/resorts/OBLU-SELECT-Lobigili/OBLU-SELECT-Lobigili-Maldives.html', 'path', '/maldives/resorts/' || n.slug || '/', 301, '[stays-migration] OBLU SELECT Lobigili Maldives Island Resort migrated to the real Stays ecosystem catalogue.'
from nodes n where n.node_type = 'accommodation' and n.title = 'OBLU SELECT Lobigili Maldives Island Resort'
on conflict (source_path) do update set target_type = excluded.target_type, target_path = excluded.target_path, status_code = excluded.status_code, notes = excluded.notes, updated_at = now();

insert into url_redirects (source_path, target_type, target_path, status_code, notes)
select '/resorts/OBLU-SELECT-Sangeli/OBLU-SELECT-Sangeli-Maldives.html', 'path', '/maldives/resorts/' || n.slug || '/', 301, '[stays-migration] OBLU SELECT Sangeli Maldives Island Resort migrated to the real Stays ecosystem catalogue.'
from nodes n where n.node_type = 'accommodation' and n.title = 'OBLU SELECT Sangeli Maldives Island Resort'
on conflict (source_path) do update set target_type = excluded.target_type, target_path = excluded.target_path, status_code = excluded.status_code, notes = excluded.notes, updated_at = now();

insert into url_redirects (source_path, target_type, target_path, status_code, notes)
select '/resorts/OBLU-XPERIENCE-Ailafushi/OBLU-XPERIENCE-Ailafushi-Maldives.html', 'path', '/maldives/resorts/' || n.slug || '/', 301, '[stays-migration] OBLU XPErience Ailafushi Maldives Island Resort migrated to the real Stays ecosystem catalogue.'
from nodes n where n.node_type = 'accommodation' and n.title = 'OBLU XPErience Ailafushi Maldives Island Resort'
on conflict (source_path) do update set target_type = excluded.target_type, target_path = excluded.target_path, status_code = excluded.status_code, notes = excluded.notes, updated_at = now();

insert into url_redirects (source_path, target_type, target_path, status_code, notes)
select '/resorts/OZEN-LIFE-MAADHOO/OZEN-LIFE-MAADHOO-Maldives.html', 'path', '/maldives/resorts/' || n.slug || '/', 301, '[stays-migration] Ozen Life Maadhoo Maldives Island Resort migrated to the real Stays ecosystem catalogue.'
from nodes n where n.node_type = 'accommodation' and n.title = 'Ozen Life Maadhoo Maldives Island Resort'
on conflict (source_path) do update set target_type = excluded.target_type, target_path = excluded.target_path, status_code = excluded.status_code, notes = excluded.notes, updated_at = now();

insert into url_redirects (source_path, target_type, target_path, status_code, notes)
select '/resorts/One-and-Only/One-and-Only-Reethirah-Maldives.html', 'path', '/maldives/resorts/' || n.slug || '/', 301, '[stays-migration] One & Only Reethi Rah Maldives Island Resort migrated to the real Stays ecosystem catalogue.'
from nodes n where n.node_type = 'accommodation' and n.title = 'One & Only Reethi Rah Maldives Island Resort'
on conflict (source_path) do update set target_type = excluded.target_type, target_path = excluded.target_path, status_code = excluded.status_code, notes = excluded.notes, updated_at = now();

insert into url_redirects (source_path, target_type, target_path, status_code, notes)
select '/resorts/Outrigger-Konotta/Outrigger-Konotta-Maldives.html', 'path', '/maldives/resorts/' || n.slug || '/', 301, '[stays-migration] Outrigger Konotta Maldives Island Resort migrated to the real Stays ecosystem catalogue.'
from nodes n where n.node_type = 'accommodation' and n.title = 'Outrigger Konotta Maldives Island Resort'
on conflict (source_path) do update set target_type = excluded.target_type, target_path = excluded.target_path, status_code = excluded.status_code, notes = excluded.notes, updated_at = now();

insert into url_redirects (source_path, target_type, target_path, status_code, notes)
select '/resorts/Outrigger-Maafushivaru/Outrigger-Maafushivaru-Maldives.html', 'path', '/maldives/resorts/' || n.slug || '/', 301, '[stays-migration] Outrigger Maldives Maafushivaru Resort Island migrated to the real Stays ecosystem catalogue.'
from nodes n where n.node_type = 'accommodation' and n.title = 'Outrigger Maldives Maafushivaru Resort Island'
on conflict (source_path) do update set target_type = excluded.target_type, target_path = excluded.target_path, status_code = excluded.status_code, notes = excluded.notes, updated_at = now();

insert into url_redirects (source_path, target_type, target_path, status_code, notes)
select '/resorts/Ozen-Reserve-Bolifushi/Ozen-Reserve-Bolifushi-Maldives.html', 'path', '/maldives/resorts/' || n.slug || '/', 301, '[stays-migration] Ozen Reserve Bolifushi Maldives Island Resort migrated to the real Stays ecosystem catalogue.'
from nodes n where n.node_type = 'accommodation' and n.title = 'Ozen Reserve Bolifushi Maldives Island Resort'
on conflict (source_path) do update set target_type = excluded.target_type, target_path = excluded.target_path, status_code = excluded.status_code, notes = excluded.notes, updated_at = now();

insert into url_redirects (source_path, target_type, target_path, status_code, notes)
select '/resorts/Palm-Beach/Palm-Beach-Island-Maldives.html', 'path', '/maldives/resorts/' || n.slug || '/', 301, '[stays-migration] Palm Beach Island Resort & Spa Maldives migrated to the real Stays ecosystem catalogue.'
from nodes n where n.node_type = 'accommodation' and n.title = 'Palm Beach Island Resort & Spa Maldives'
on conflict (source_path) do update set target_type = excluded.target_type, target_path = excluded.target_path, status_code = excluded.status_code, notes = excluded.notes, updated_at = now();

insert into url_redirects (source_path, target_type, target_path, status_code, notes)
select '/resorts/Park-Hyatt/Park-Hyatt-Maldives-Hadahaa.html', 'path', '/maldives/resorts/' || n.slug || '/', 301, '[stays-migration] Park Hyatt Maldives Hadahaa Island Resort migrated to the real Stays ecosystem catalogue.'
from nodes n where n.node_type = 'accommodation' and n.title = 'Park Hyatt Maldives Hadahaa Island Resort'
on conflict (source_path) do update set target_type = excluded.target_type, target_path = excluded.target_path, status_code = excluded.status_code, notes = excluded.notes, updated_at = now();

insert into url_redirects (source_path, target_type, target_path, status_code, notes)
select '/resorts/Patina-Maldives/Patina-Maldives-Fari-Island-Maldives.html', 'path', '/maldives/resorts/' || n.slug || '/', 301, '[stays-migration] The Patina Maldives Fari Island Resort migrated to the real Stays ecosystem catalogue.'
from nodes n where n.node_type = 'accommodation' and n.title = 'The Patina Maldives Fari Island Resort'
on conflict (source_path) do update set target_type = excluded.target_type, target_path = excluded.target_path, status_code = excluded.status_code, notes = excluded.notes, updated_at = now();

insert into url_redirects (source_path, target_type, target_path, status_code, notes)
select '/resorts/Pullman/Pullman-Maldives.html', 'path', '/maldives/resorts/' || n.slug || '/', 301, '[stays-migration] Pullman Maldives Maamutaa Island Resort migrated to the real Stays ecosystem catalogue.'
from nodes n where n.node_type = 'accommodation' and n.title = 'Pullman Maldives Maamutaa Island Resort'
on conflict (source_path) do update set target_type = excluded.target_type, target_path = excluded.target_path, status_code = excluded.status_code, notes = excluded.notes, updated_at = now();

insert into url_redirects (source_path, target_type, target_path, status_code, notes)
select '/resorts/Radisson-Blu/Radisson-Blu-Maldives.html', 'path', '/maldives/resorts/' || n.slug || '/', 301, '[stays-migration] Radisson Blu Maldives Island Resort migrated to the real Stays ecosystem catalogue.'
from nodes n where n.node_type = 'accommodation' and n.title = 'Radisson Blu Maldives Island Resort'
on conflict (source_path) do update set target_type = excluded.target_type, target_path = excluded.target_path, status_code = excluded.status_code, notes = excluded.notes, updated_at = now();

insert into url_redirects (source_path, target_type, target_path, status_code, notes)
select '/resorts/Raffles/Raffles-Maldives-Meradhoo-Resort.html', 'path', '/maldives/resorts/' || n.slug || '/', 301, '[stays-migration] Raffles Maldives Meradhoo Island Resort migrated to the real Stays ecosystem catalogue.'
from nodes n where n.node_type = 'accommodation' and n.title = 'Raffles Maldives Meradhoo Island Resort'
on conflict (source_path) do update set target_type = excluded.target_type, target_path = excluded.target_path, status_code = excluded.status_code, notes = excluded.notes, updated_at = now();

insert into url_redirects (source_path, target_type, target_path, status_code, notes)
select '/resorts/Rahaa-Resort/Rahaa-Resort-Maldives.html', 'path', '/maldives/resorts/' || n.slug || '/', 301, '[stays-migration] Rahaa Resort Maldives Island migrated to the real Stays ecosystem catalogue.'
from nodes n where n.node_type = 'accommodation' and n.title = 'Rahaa Resort Maldives Island'
on conflict (source_path) do update set target_type = excluded.target_type, target_path = excluded.target_path, status_code = excluded.status_code, notes = excluded.notes, updated_at = now();

insert into url_redirects (source_path, target_type, target_path, status_code, notes)
select '/resorts/Reethi-Beach/Reethi-Beach-Resort-Maldives.html', 'path', '/maldives/resorts/' || n.slug || '/', 301, '[stays-migration] Reethi Beach Resort Maldives migrated to the real Stays ecosystem catalogue.'
from nodes n where n.node_type = 'accommodation' and n.title = 'Reethi Beach Resort Maldives'
on conflict (source_path) do update set target_type = excluded.target_type, target_path = excluded.target_path, status_code = excluded.status_code, notes = excluded.notes, updated_at = now();

insert into url_redirects (source_path, target_type, target_path, status_code, notes)
select '/resorts/Reethi-Faru/Reethi-Faru-Reosrt-Maldives.html', 'path', '/maldives/resorts/' || n.slug || '/', 301, '[stays-migration] Reethi Faru Resort Maldives Island migrated to the real Stays ecosystem catalogue.'
from nodes n where n.node_type = 'accommodation' and n.title = 'Reethi Faru Resort Maldives Island'
on conflict (source_path) do update set target_type = excluded.target_type, target_path = excluded.target_path, status_code = excluded.status_code, notes = excluded.notes, updated_at = now();

insert into url_redirects (source_path, target_type, target_path, status_code, notes)
select '/resorts/Residence-Dhigurah/The-Residence-Dhigurah-Maldives.html', 'path', '/maldives/resorts/' || n.slug || '/', 301, '[stays-migration] The Residence Maldives at Dhigurah Island Resort migrated to the real Stays ecosystem catalogue.'
from nodes n where n.node_type = 'accommodation' and n.title = 'The Residence Maldives at Dhigurah Island Resort'
on conflict (source_path) do update set target_type = excluded.target_type, target_path = excluded.target_path, status_code = excluded.status_code, notes = excluded.notes, updated_at = now();

insert into url_redirects (source_path, target_type, target_path, status_code, notes)
select '/resorts/Residence-Falhumaafushi/The-Residence-Falhumaafushi-Maldives.html', 'path', '/maldives/resorts/' || n.slug || '/', 301, '[stays-migration] The Residence Maldives at Falhumaafushi Island Resort migrated to the real Stays ecosystem catalogue.'
from nodes n where n.node_type = 'accommodation' and n.title = 'The Residence Maldives at Falhumaafushi Island Resort'
on conflict (source_path) do update set target_type = excluded.target_type, target_path = excluded.target_path, status_code = excluded.status_code, notes = excluded.notes, updated_at = now();

insert into url_redirects (source_path, target_type, target_path, status_code, notes)
select '/resorts/Rihiveli/Rihiveli-Maldives.html', 'path', '/maldives/resorts/' || n.slug || '/', 301, '[stays-migration] Rihiveli Maldives migrated to the real Stays ecosystem catalogue.'
from nodes n where n.node_type = 'accommodation' and n.title = 'Rihiveli Maldives'
on conflict (source_path) do update set target_type = excluded.target_type, target_path = excluded.target_path, status_code = excluded.status_code, notes = excluded.notes, updated_at = now();

insert into url_redirects (source_path, target_type, target_path, status_code, notes)
select '/resorts/Robinson-Club/Robinson-Club-Noonu-Maldives.html', 'path', '/maldives/resorts/' || n.slug || '/', 301, '[stays-migration] Robinson Club Noonu Maldives Island Resort migrated to the real Stays ecosystem catalogue.'
from nodes n where n.node_type = 'accommodation' and n.title = 'Robinson Club Noonu Maldives Island Resort'
on conflict (source_path) do update set target_type = excluded.target_type, target_path = excluded.target_path, status_code = excluded.status_code, notes = excluded.notes, updated_at = now();

insert into url_redirects (source_path, target_type, target_path, status_code, notes)
select '/resorts/Robinson-Maldives/Robinson-Maldives.html', 'path', '/maldives/resorts/' || n.slug || '/', 301, '[stays-migration] Robinson Club Maldives Island Resort migrated to the real Stays ecosystem catalogue.'
from nodes n where n.node_type = 'accommodation' and n.title = 'Robinson Club Maldives Island Resort'
on conflict (source_path) do update set target_type = excluded.target_type, target_path = excluded.target_path, status_code = excluded.status_code, notes = excluded.notes, updated_at = now();

insert into url_redirects (source_path, target_type, target_path, status_code, notes)
select '/resorts/Royal-Island/Royal-Island-Reosrt-Maldives.html', 'path', '/maldives/resorts/' || n.slug || '/', 301, '[stays-migration] Royal Island Premium All Inclusive Maldives Island Resort migrated to the real Stays ecosystem catalogue.'
from nodes n where n.node_type = 'accommodation' and n.title = 'Royal Island Premium All Inclusive Maldives Island Resort'
on conflict (source_path) do update set target_type = excluded.target_type, target_path = excluded.target_path, status_code = excluded.status_code, notes = excluded.notes, updated_at = now();

insert into url_redirects (source_path, target_type, target_path, status_code, notes)
select '/resorts/SAii-Lagoon/SAii-Lagoon-Maldives.html', 'path', '/maldives/resorts/' || n.slug || '/', 301, '[stays-migration] Saii Lagoon Maldives Island Resort migrated to the real Stays ecosystem catalogue.'
from nodes n where n.node_type = 'accommodation' and n.title = 'Saii Lagoon Maldives Island Resort'
on conflict (source_path) do update set target_type = excluded.target_type, target_path = excluded.target_path, status_code = excluded.status_code, notes = excluded.notes, updated_at = now();

insert into url_redirects (source_path, target_type, target_path, status_code, notes)
select '/resorts/Safari-Island/safari-island-maldives-mushimas-migili.html', 'path', '/maldives/resorts/' || n.slug || '/', 301, '[stays-migration] Safari Island Resort and Spa Maldives migrated to the real Stays ecosystem catalogue.'
from nodes n where n.node_type = 'accommodation' and n.title = 'Safari Island Resort and Spa Maldives'
on conflict (source_path) do update set target_type = excluded.target_type, target_path = excluded.target_path, status_code = excluded.status_code, notes = excluded.notes, updated_at = now();

insert into url_redirects (source_path, target_type, target_path, status_code, notes)
select '/resorts/Sheraton/Sheraton-Maldives-Full-Moon.html', 'path', '/maldives/resorts/' || n.slug || '/', 301, '[stays-migration] Sheraton Maldives Full Moon Resort & Spa Island migrated to the real Stays ecosystem catalogue.'
from nodes n where n.node_type = 'accommodation' and n.title = 'Sheraton Maldives Full Moon Resort & Spa Island'
on conflict (source_path) do update set target_type = excluded.target_type, target_path = excluded.target_path, status_code = excluded.status_code, notes = excluded.notes, updated_at = now();

insert into url_redirects (source_path, target_type, target_path, status_code, notes)
select '/resorts/Six-Senses-Kanuhura/Six-Senses-Kanuhura-Maldives.html', 'path', '/maldives/resorts/' || n.slug || '/', 301, '[stays-migration] Six Senses Kanuhura Maldives Private Island migrated to the real Stays ecosystem catalogue.'
from nodes n where n.node_type = 'accommodation' and n.title = 'Six Senses Kanuhura Maldives Private Island'
on conflict (source_path) do update set target_type = excluded.target_type, target_path = excluded.target_path, status_code = excluded.status_code, notes = excluded.notes, updated_at = now();

insert into url_redirects (source_path, target_type, target_path, status_code, notes)
select '/resorts/Six-Senses-Laamu/Six-Senses-Laamu-Maldives.html', 'path', '/maldives/resorts/' || n.slug || '/', 301, '[stays-migration] Same resort as the already-seeded "six-senses-laamu" — redirected there directly, not to a duplicate page.'
from nodes n where n.node_type = 'accommodation' and n.slug = 'six-senses-laamu'
on conflict (source_path) do update set target_type = excluded.target_type, target_path = excluded.target_path, status_code = excluded.status_code, notes = excluded.notes, updated_at = now();

insert into url_redirects (source_path, target_type, target_path, status_code, notes)
select '/resorts/Siyam-World/Siyam-World-Maldives.html', 'path', '/maldives/resorts/' || n.slug || '/', 301, '[stays-migration] Siyam World Maldives Island Resort migrated to the real Stays ecosystem catalogue.'
from nodes n where n.node_type = 'accommodation' and n.title = 'Siyam World Maldives Island Resort'
on conflict (source_path) do update set target_type = excluded.target_type, target_path = excluded.target_path, status_code = excluded.status_code, notes = excluded.notes, updated_at = now();

insert into url_redirects (source_path, target_type, target_path, status_code, notes)
select '/resorts/Soneva-Fushi/Soneva-Fushi-Maldives.html', 'path', '/maldives/resorts/' || n.slug || '/', 301, '[stays-migration] Same resort as the already-seeded "soneva-fushi" — redirected there directly, not to a duplicate page.'
from nodes n where n.node_type = 'accommodation' and n.slug = 'soneva-fushi'
on conflict (source_path) do update set target_type = excluded.target_type, target_path = excluded.target_path, status_code = excluded.status_code, notes = excluded.notes, updated_at = now();

insert into url_redirects (source_path, target_type, target_path, status_code, notes)
select '/resorts/Soneva-Jani/Soneva-Jani-Maldives.html', 'path', '/maldives/resorts/' || n.slug || '/', 301, '[stays-migration] Soneva Jani Maldives Island Resort migrated to the real Stays ecosystem catalogue.'
from nodes n where n.node_type = 'accommodation' and n.title = 'Soneva Jani Maldives Island Resort'
on conflict (source_path) do update set target_type = excluded.target_type, target_path = excluded.target_path, status_code = excluded.status_code, notes = excluded.notes, updated_at = now();

insert into url_redirects (source_path, target_type, target_path, status_code, notes)
select '/resorts/South-Palm/South-Palm-Resort-Maldives.html', 'path', '/maldives/resorts/' || n.slug || '/', 301, '[stays-migration] South Palm Resort Maldives Island migrated to the real Stays ecosystem catalogue.'
from nodes n where n.node_type = 'accommodation' and n.title = 'South Palm Resort Maldives Island'
on conflict (source_path) do update set target_type = excluded.target_type, target_path = excluded.target_path, status_code = excluded.status_code, notes = excluded.notes, updated_at = now();

insert into url_redirects (source_path, target_type, target_path, status_code, notes)
select '/resorts/Sun-Island/Sun-Island-Reosrt-Maldives.html', 'path', '/maldives/resorts/' || n.slug || '/', 301, '[stays-migration] Sun Island Resort & Spa Maldives migrated to the real Stays ecosystem catalogue.'
from nodes n where n.node_type = 'accommodation' and n.title = 'Sun Island Resort & Spa Maldives'
on conflict (source_path) do update set target_type = excluded.target_type, target_path = excluded.target_path, status_code = excluded.status_code, notes = excluded.notes, updated_at = now();

insert into url_redirects (source_path, target_type, target_path, status_code, notes)
select '/resorts/Sun-Siyam-IruVeli/Sun-Siyam-IruVeli-Maldives.html', 'path', '/maldives/resorts/' || n.slug || '/', 301, '[stays-migration] Sun Siyam Iru Veli Maldives Island Resort migrated to the real Stays ecosystem catalogue.'
from nodes n where n.node_type = 'accommodation' and n.title = 'Sun Siyam Iru Veli Maldives Island Resort'
on conflict (source_path) do update set target_type = excluded.target_type, target_path = excluded.target_path, status_code = excluded.status_code, notes = excluded.notes, updated_at = now();

insert into url_redirects (source_path, target_type, target_path, status_code, notes)
select '/resorts/Sun-Siyam-Olhuveli/Sun-Siyam-Olhuveli-Maldives.html', 'path', '/maldives/resorts/' || n.slug || '/', 301, '[stays-migration] Sun Siyam Olhuveli Maldives Island Resort migrated to the real Stays ecosystem catalogue.'
from nodes n where n.node_type = 'accommodation' and n.title = 'Sun Siyam Olhuveli Maldives Island Resort'
on conflict (source_path) do update set target_type = excluded.target_type, target_path = excluded.target_path, status_code = excluded.status_code, notes = excluded.notes, updated_at = now();

insert into url_redirects (source_path, target_type, target_path, status_code, notes)
select '/resorts/Sun-Siyam-ViluReef/Sun-Siyam-ViluReef-Maldives.html', 'path', '/maldives/resorts/' || n.slug || '/', 301, '[stays-migration] Sun Siyam Vilu Reef Maldives Island Resort migrated to the real Stays ecosystem catalogue.'
from nodes n where n.node_type = 'accommodation' and n.title = 'Sun Siyam Vilu Reef Maldives Island Resort'
on conflict (source_path) do update set target_type = excluded.target_type, target_path = excluded.target_path, status_code = excluded.status_code, notes = excluded.notes, updated_at = now();

insert into url_redirects (source_path, target_type, target_path, status_code, notes)
select '/resorts/Taj-Coral-Reef/Taj-Coral-Reef-Maldives.html', 'path', '/maldives/resorts/' || n.slug || '/', 301, '[stays-migration] Taj Coral Reef Resort & Spa Maldives migrated to the real Stays ecosystem catalogue.'
from nodes n where n.node_type = 'accommodation' and n.title = 'Taj Coral Reef Resort & Spa Maldives'
on conflict (source_path) do update set target_type = excluded.target_type, target_path = excluded.target_path, status_code = excluded.status_code, notes = excluded.notes, updated_at = now();

insert into url_redirects (source_path, target_type, target_path, status_code, notes)
select '/resorts/Taj-Exotica/Taj-Exotica-Maldives.html', 'path', '/maldives/resorts/' || n.slug || '/', 301, '[stays-migration] Taj Exotica Resort & Spa Maldives migrated to the real Stays ecosystem catalogue.'
from nodes n where n.node_type = 'accommodation' and n.title = 'Taj Exotica Resort & Spa Maldives'
on conflict (source_path) do update set target_type = excluded.target_type, target_path = excluded.target_path, status_code = excluded.status_code, notes = excluded.notes, updated_at = now();

insert into url_redirects (source_path, target_type, target_path, status_code, notes)
select '/resorts/The-Ritz-Carlton/The-Ritz-Carlton-Fari-island-Maldives.html', 'path', '/maldives/resorts/' || n.slug || '/', 301, '[stays-migration] The Ritz Carlton Maldives Fari Island Resort migrated to the real Stays ecosystem catalogue.'
from nodes n where n.node_type = 'accommodation' and n.title = 'The Ritz Carlton Maldives Fari Island Resort'
on conflict (source_path) do update set target_type = excluded.target_type, target_path = excluded.target_path, status_code = excluded.status_code, notes = excluded.notes, updated_at = now();

insert into url_redirects (source_path, target_type, target_path, status_code, notes)
select '/resorts/VARU-Atmosphere/VARU-by-Atmosphere-Maldives.html', 'path', '/maldives/resorts/' || n.slug || '/', 301, '[stays-migration] VARU by Atmosphere Maldives Island Resort migrated to the real Stays ecosystem catalogue.'
from nodes n where n.node_type = 'accommodation' and n.title = 'VARU by Atmosphere Maldives Island Resort'
on conflict (source_path) do update set target_type = excluded.target_type, target_path = excluded.target_path, status_code = excluded.status_code, notes = excluded.notes, updated_at = now();

insert into url_redirects (source_path, target_type, target_path, status_code, notes)
select '/resorts/Vakkaru/Vakkaru-Maldives.html', 'path', '/maldives/resorts/' || n.slug || '/', 301, '[stays-migration] Vakkaru Maldives Island Resort migrated to the real Stays ecosystem catalogue.'
from nodes n where n.node_type = 'accommodation' and n.title = 'Vakkaru Maldives Island Resort'
on conflict (source_path) do update set target_type = excluded.target_type, target_path = excluded.target_path, status_code = excluded.status_code, notes = excluded.notes, updated_at = now();

insert into url_redirects (source_path, target_type, target_path, status_code, notes)
select '/resorts/Velassaru/Velassaru-Maldives.html', 'path', '/maldives/resorts/' || n.slug || '/', 301, '[stays-migration] Same resort as the already-seeded "velassaru-maldives" — redirected there directly, not to a duplicate page.'
from nodes n where n.node_type = 'accommodation' and n.slug = 'velassaru-maldives'
on conflict (source_path) do update set target_type = excluded.target_type, target_path = excluded.target_path, status_code = excluded.status_code, notes = excluded.notes, updated_at = now();

insert into url_redirects (source_path, target_type, target_path, status_code, notes)
select '/resorts/Veligandu-Island/Veligandu-Island-Resort-Maldives.html', 'path', '/maldives/resorts/' || n.slug || '/', 301, '[stays-migration] Veligandu Island Resort & Spa Maldives migrated to the real Stays ecosystem catalogue.'
from nodes n where n.node_type = 'accommodation' and n.title = 'Veligandu Island Resort & Spa Maldives'
on conflict (source_path) do update set target_type = excluded.target_type, target_path = excluded.target_path, status_code = excluded.status_code, notes = excluded.notes, updated_at = now();

insert into url_redirects (source_path, target_type, target_path, status_code, notes)
select '/resorts/Vilamendhoo-Island/Vilamendhoo-Island-Resort-Maldives.html', 'path', '/maldives/resorts/' || n.slug || '/', 301, '[stays-migration] Vilamendhoo Island Resort & Spa Maldives migrated to the real Stays ecosystem catalogue.'
from nodes n where n.node_type = 'accommodation' and n.title = 'Vilamendhoo Island Resort & Spa Maldives'
on conflict (source_path) do update set target_type = excluded.target_type, target_path = excluded.target_path, status_code = excluded.status_code, notes = excluded.notes, updated_at = now();

insert into url_redirects (source_path, target_type, target_path, status_code, notes)
select '/resorts/Waldorf-Astoria/Waldorf-Astoria-Maldives-Ithaafushi.html', 'path', '/maldives/resorts/' || n.slug || '/', 301, '[stays-migration] Waldorf Astoria Maldives Ithaafushi Island Resort migrated to the real Stays ecosystem catalogue.'
from nodes n where n.node_type = 'accommodation' and n.title = 'Waldorf Astoria Maldives Ithaafushi Island Resort'
on conflict (source_path) do update set target_type = excluded.target_type, target_path = excluded.target_path, status_code = excluded.status_code, notes = excluded.notes, updated_at = now();

insert into url_redirects (source_path, target_type, target_path, status_code, notes)
select '/resorts/Westin-Miriandhoo/The-Westin-Miriandhoo-Maldives.html', 'path', '/maldives/resorts/' || n.slug || '/', 301, '[stays-migration] The Westin Maldives Miriandhoo Resort migrated to the real Stays ecosystem catalogue.'
from nodes n where n.node_type = 'accommodation' and n.title = 'The Westin Maldives Miriandhoo Resort'
on conflict (source_path) do update set target_type = excluded.target_type, target_path = excluded.target_path, status_code = excluded.status_code, notes = excluded.notes, updated_at = now();

insert into url_redirects (source_path, target_type, target_path, status_code, notes)
select '/resorts/You-and-Me/You-and-Me-Maldives.html', 'path', '/maldives/resorts/' || n.slug || '/', 301, '[stays-migration] You & Me by Cocoon Maldives Island Resort migrated to the real Stays ecosystem catalogue.'
from nodes n where n.node_type = 'accommodation' and n.title = 'You & Me by Cocoon Maldives Island Resort'
on conflict (source_path) do update set target_type = excluded.target_type, target_path = excluded.target_path, status_code = excluded.status_code, notes = excluded.notes, updated_at = now();

insert into url_redirects (source_path, target_type, target_path, status_code, notes)
select '/resorts/adaaran-club-rannalhi/adaaran-club-rannalhi-maldives.html', 'path', '/maldives/resorts/' || n.slug || '/', 301, '[stays-migration] Adaaran Club Rannalhi Island Resort Maldives migrated to the real Stays ecosystem catalogue.'
from nodes n where n.node_type = 'accommodation' and n.title = 'Adaaran Club Rannalhi Island Resort Maldives'
on conflict (source_path) do update set target_type = excluded.target_type, target_path = excluded.target_path, status_code = excluded.status_code, notes = excluded.notes, updated_at = now();

insert into url_redirects (source_path, target_type, target_path, status_code, notes)
select '/resorts/anantara-dhigu/anantara-dhigu-maldives.html', 'path', '/maldives/resorts/' || n.slug || '/', 301, '[stays-migration] Anantara Dhigu Island Resort Maldives migrated to the real Stays ecosystem catalogue.'
from nodes n where n.node_type = 'accommodation' and n.title = 'Anantara Dhigu Island Resort Maldives'
on conflict (source_path) do update set target_type = excluded.target_type, target_path = excluded.target_path, status_code = excluded.status_code, notes = excluded.notes, updated_at = now();

insert into url_redirects (source_path, target_type, target_path, status_code, notes)
select '/resorts/centara-rasfushi/centara-rasfushi-maldives.html', 'path', '/maldives/resorts/' || n.slug || '/', 301, '[stays-migration] Centara Rasfushi Island Resort Maldives migrated to the real Stays ecosystem catalogue.'
from nodes n where n.node_type = 'accommodation' and n.title = 'Centara Rasfushi Island Resort Maldives'
on conflict (source_path) do update set target_type = excluded.target_type, target_path = excluded.target_path, status_code = excluded.status_code, notes = excluded.notes, updated_at = now();

insert into url_redirects (source_path, target_type, target_path, status_code, notes)
select '/resorts/embudu-village/embudu-village-resort-maldives.html', 'path', '/maldives/resorts/' || n.slug || '/', 301, '[stays-migration] Embudu Village Island Maldives migrated to the real Stays ecosystem catalogue.'
from nodes n where n.node_type = 'accommodation' and n.title = 'Embudu Village Island Maldives'
on conflict (source_path) do update set target_type = excluded.target_type, target_path = excluded.target_path, status_code = excluded.status_code, notes = excluded.notes, updated_at = now();

insert into url_redirects (source_path, target_type, target_path, status_code, notes)
select '/resorts/fihalhohi/fihaalhohi-isand-resort-maldives.html', 'path', '/maldives/resorts/' || n.slug || '/', 301, '[stays-migration] Fihaalhohi Island Resort Maldives migrated to the real Stays ecosystem catalogue.'
from nodes n where n.node_type = 'accommodation' and n.title = 'Fihaalhohi Island Resort Maldives'
on conflict (source_path) do update set target_type = excluded.target_type, target_path = excluded.target_path, status_code = excluded.status_code, notes = excluded.notes, updated_at = now();

insert into url_redirects (source_path, target_type, target_path, status_code, notes)
select '/resorts/huvafenfushi/huvafen-fushi-maldives-island-resort.html', 'path', '/maldives/resorts/' || n.slug || '/', 301, '[stays-migration] Huvafen Fushi Island Resort Maldives migrated to the real Stays ecosystem catalogue.'
from nodes n where n.node_type = 'accommodation' and n.title = 'Huvafen Fushi Island Resort Maldives'
on conflict (source_path) do update set target_type = excluded.target_type, target_path = excluded.target_path, status_code = excluded.status_code, notes = excluded.notes, updated_at = now();

insert into url_redirects (source_path, target_type, target_path, status_code, notes)
select '/resorts/kuda-Villingili/kuda-Villingili-Resort-Maldives.html', 'path', '/maldives/resorts/' || n.slug || '/', 301, '[stays-migration] Kuda Villingili Resort Maldives migrated to the real Stays ecosystem catalogue.'
from nodes n where n.node_type = 'accommodation' and n.title = 'Kuda Villingili Resort Maldives'
on conflict (source_path) do update set target_type = excluded.target_type, target_path = excluded.target_path, status_code = excluded.status_code, notes = excluded.notes, updated_at = now();

insert into url_redirects (source_path, target_type, target_path, status_code, notes)
select '/resorts/nautilus/the-nautilus-island-maldives.html', 'path', '/maldives/resorts/' || n.slug || '/', 301, '[stays-migration] The Nautilus Island Resort Maldives migrated to the real Stays ecosystem catalogue.'
from nodes n where n.node_type = 'accommodation' and n.title = 'The Nautilus Island Resort Maldives'
on conflict (source_path) do update set target_type = excluded.target_type, target_path = excluded.target_path, status_code = excluded.status_code, notes = excluded.notes, updated_at = now();

insert into url_redirects (source_path, target_type, target_path, status_code, notes)
select '/resorts/paradise/paradise-island-resort-maldives.html', 'path', '/maldives/resorts/' || n.slug || '/', 301, '[stays-migration] Paradise Island Resort Maldives migrated to the real Stays ecosystem catalogue.'
from nodes n where n.node_type = 'accommodation' and n.title = 'Paradise Island Resort Maldives'
on conflict (source_path) do update set target_type = excluded.target_type, target_path = excluded.target_path, status_code = excluded.status_code, notes = excluded.notes, updated_at = now();

insert into url_redirects (source_path, target_type, target_path, status_code, notes)
select '/resorts/summer-island/summer-island-resort-maldives.html', 'path', '/maldives/resorts/' || n.slug || '/', 301, '[stays-migration] Summer Island Resort Maldives migrated to the real Stays ecosystem catalogue.'
from nodes n where n.node_type = 'accommodation' and n.title = 'Summer Island Resort Maldives'
on conflict (source_path) do update set target_type = excluded.target_type, target_path = excluded.target_path, status_code = excluded.status_code, notes = excluded.notes, updated_at = now();

insert into url_redirects (source_path, target_type, target_path, status_code, notes)
select '/resorts/vommuli/st-regis-vommuli-maldives-resort.html', 'path', '/maldives/resorts/' || n.slug || '/', 301, '[stays-migration] The St. Regis Vommuli Island Resort Maldives migrated to the real Stays ecosystem catalogue.'
from nodes n where n.node_type = 'accommodation' and n.title = 'The St. Regis Vommuli Island Resort Maldives'
on conflict (source_path) do update set target_type = excluded.target_type, target_path = excluded.target_path, status_code = excluded.status_code, notes = excluded.notes, updated_at = now();

insert into url_redirects (source_path, target_type, target_path, status_code, notes)
select '/resorts/w-maldives/w-maldives-island-resort.html', 'path', '/maldives/resorts/' || n.slug || '/', 301, '[stays-migration] W Maldives Island Resort Maldives migrated to the real Stays ecosystem catalogue.'
from nodes n where n.node_type = 'accommodation' and n.title = 'W Maldives Island Resort Maldives'
on conflict (source_path) do update set target_type = excluded.target_type, target_path = excluded.target_path, status_code = excluded.status_code, notes = excluded.notes, updated_at = now();

insert into url_redirects (source_path, target_type, target_path, status_code, notes)
select '/hotels/Amra-Palace/Amra-Palace-Hotel-Maldives-Gan-Island.html', 'path', '/maldives/hotels/' || n.slug || '/', 301, '[stays-migration] Amra Palace Island Hotel Maldives migrated to the real Stays ecosystem catalogue.'
from nodes n where n.node_type = 'accommodation' and n.title = 'Amra Palace Island Hotel Maldives'
on conflict (source_path) do update set target_type = excluded.target_type, target_path = excluded.target_path, status_code = excluded.status_code, notes = excluded.notes, updated_at = now();

insert into url_redirects (source_path, target_type, target_path, status_code, notes)
select '/hotels/arena-maafushi/arena-beach-hotel-in-maafushi-maldives.html', 'path', '/maldives/hotels/' || n.slug || '/', 301, '[stays-migration] Same resort as the already-seeded "arena-beach-hotel" — redirected there directly, not to a duplicate page.'
from nodes n where n.node_type = 'accommodation' and n.slug = 'arena-beach-hotel'
on conflict (source_path) do update set target_type = excluded.target_type, target_path = excluded.target_path, status_code = excluded.status_code, notes = excluded.notes, updated_at = now();

insert into url_redirects (source_path, target_type, target_path, status_code, notes)
select '/hotels/casa-retreat/casa-retreat-hotel-in-hulhumale-maldives.html', 'path', '/maldives/guesthouses/' || n.slug || '/', 301, '[stays-migration] casa-retreat migrated to the real Stays ecosystem catalogue.'
from nodes n where n.node_type = 'accommodation' and n.title = 'casa-retreat'
on conflict (source_path) do update set target_type = excluded.target_type, target_path = excluded.target_path, status_code = excluded.status_code, notes = excluded.notes, updated_at = now();

insert into url_redirects (source_path, target_type, target_path, status_code, notes)
select '/hotels/gaafaru-view-inn-maldives/gaafaru-view-inn-maldives.html', 'path', '/maldives/guesthouses/' || n.slug || '/', 301, '[stays-migration] Gaafari view inn Hotel Maldives migrated to the real Stays ecosystem catalogue.'
from nodes n where n.node_type = 'accommodation' and n.title = 'Gaafari view inn Hotel Maldives'
on conflict (source_path) do update set target_type = excluded.target_type, target_path = excluded.target_path, status_code = excluded.status_code, notes = excluded.notes, updated_at = now();

insert into url_redirects (source_path, target_type, target_path, status_code, notes)
select '/hotels/island-break-fulidhoo/island-break-hotel-fulidhoo.html', 'path', '/maldives/guesthouses/' || n.slug || '/', 301, '[stays-migration] Island Break Fulidhoo Maldives migrated to the real Stays ecosystem catalogue.'
from nodes n where n.node_type = 'accommodation' and n.title = 'Island Break Fulidhoo Maldives'
on conflict (source_path) do update set target_type = excluded.target_type, target_path = excluded.target_path, status_code = excluded.status_code, notes = excluded.notes, updated_at = now();

insert into url_redirects (source_path, target_type, target_path, status_code, notes)
select '/hotels/kaanibeach-maafushi/kaani-beach-hotel-in-maafushi-maldives.html', 'path', '/maldives/hotels/' || n.slug || '/', 301, '[stays-migration] Same resort as the already-seeded "kaani-beach-hotel" — redirected there directly, not to a duplicate page.'
from nodes n where n.node_type = 'accommodation' and n.slug = 'kaani-beach-hotel'
on conflict (source_path) do update set target_type = excluded.target_type, target_path = excluded.target_path, status_code = excluded.status_code, notes = excluded.notes, updated_at = now();

insert into url_redirects (source_path, target_type, target_path, status_code, notes)
select '/hotels/maagiri/maagiri-hotel-in-male-maldives.html', 'path', '/maldives/hotels/' || n.slug || '/', 301, '[stays-migration] Maagiri Hotel Male Maldives migrated to the real Stays ecosystem catalogue.'
from nodes n where n.node_type = 'accommodation' and n.title = 'Maagiri Hotel Male Maldives'
on conflict (source_path) do update set target_type = excluded.target_type, target_path = excluded.target_path, status_code = excluded.status_code, notes = excluded.notes, updated_at = now();

insert into url_redirects (source_path, target_type, target_path, status_code, notes)
select '/hotels/mantha-view-hotel/mantha-view-hotel-maldives.html', 'path', '/maldives/guesthouses/' || n.slug || '/', 301, '[stays-migration] Mantha view Hotel Maldives migrated to the real Stays ecosystem catalogue.'
from nodes n where n.node_type = 'accommodation' and n.title = 'Mantha view Hotel Maldives'
on conflict (source_path) do update set target_type = excluded.target_type, target_path = excluded.target_path, status_code = excluded.status_code, notes = excluded.notes, updated_at = now();

insert into url_redirects (source_path, target_type, target_path, status_code, notes)
select '/hotels/reveries-village/reveries-diving-village-surfandSpa.html', 'path', '/maldives/guesthouses/' || n.slug || '/', 301, '[stays-migration] reveries-village migrated to the real Stays ecosystem catalogue.'
from nodes n where n.node_type = 'accommodation' and n.title = 'reveries-village'
on conflict (source_path) do update set target_type = excluded.target_type, target_path = excluded.target_path, status_code = excluded.status_code, notes = excluded.notes, updated_at = now();

insert into url_redirects (source_path, target_type, target_path, status_code, notes)
select '/hotels/rosemery-maafushi/rosemery-hotel-in-maafushi-maldives.html', 'path', '/maldives/hotels/' || n.slug || '/', 301, '[stays-migration] rosemery-maafushi migrated to the real Stays ecosystem catalogue.'
from nodes n where n.node_type = 'accommodation' and n.title = 'rosemery-maafushi'
on conflict (source_path) do update set target_type = excluded.target_type, target_path = excluded.target_path, status_code = excluded.status_code, notes = excluded.notes, updated_at = now();

insert into url_redirects (source_path, target_type, target_path, status_code, notes)
select '/hotels/surfview-male/surfview-hotel-in-male-maldives.html', 'path', '/maldives/guesthouses/' || n.slug || '/', 301, '[stays-migration] Surfview Hotel Male Maldives migrated to the real Stays ecosystem catalogue.'
from nodes n where n.node_type = 'accommodation' and n.title = 'Surfview Hotel Male Maldives'
on conflict (source_path) do update set target_type = excluded.target_type, target_path = excluded.target_path, status_code = excluded.status_code, notes = excluded.notes, updated_at = now();

