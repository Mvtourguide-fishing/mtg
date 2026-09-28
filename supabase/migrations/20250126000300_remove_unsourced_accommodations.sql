-- Owner-requested removal: 5 accommodations from the original Task 5
-- seed (20250103000100_seed_accommodations.sql) that have no
-- corresponding page anywhere in the legacy website scrape (release/) —
-- unlike every other accommodation on the site, there was never a real
-- source page to verify these 5 against. Archived, never hard-deleted
-- (keeps the row/history), with each current MTG URL 301'd to its real
-- island page rather than left as a dead link for anyone who bookmarked
-- or indexed it.
--
-- coral-grand-beach-spa   (hotel, Hulhumalé)
-- dhaankolhu-rasdhoo      (guesthouse, Rasdhoo)
-- go-surf-maldives        (guesthouse, Thulusdhoo)
-- sealavie-inn            (guesthouse, Ukulhas)
-- whaleshark-beach        (guesthouse, Dhigurah)

insert into url_redirects (source_path, target_type, target_path, status_code, notes)
values ('/maldives/hotels/coral-grand-beach-spa/', 'path', '/maldives/islands/hulhumale/', 301, 'Removed: no corresponding page found anywhere in the legacy website scrape to verify this listing against.')
on conflict (source_path) do update set target_type = excluded.target_type, target_path = excluded.target_path, status_code = excluded.status_code, notes = excluded.notes, updated_at = now();

insert into url_redirects (source_path, target_type, target_path, status_code, notes)
values ('/maldives/guesthouses/dhaankolhu-rasdhoo/', 'path', '/maldives/islands/rasdhoo/', 301, 'Removed: no corresponding page found anywhere in the legacy website scrape to verify this listing against.')
on conflict (source_path) do update set target_type = excluded.target_type, target_path = excluded.target_path, status_code = excluded.status_code, notes = excluded.notes, updated_at = now();

insert into url_redirects (source_path, target_type, target_path, status_code, notes)
values ('/maldives/guesthouses/go-surf-maldives/', 'path', '/maldives/islands/thulusdhoo/', 301, 'Removed: no corresponding page found anywhere in the legacy website scrape to verify this listing against.')
on conflict (source_path) do update set target_type = excluded.target_type, target_path = excluded.target_path, status_code = excluded.status_code, notes = excluded.notes, updated_at = now();

insert into url_redirects (source_path, target_type, target_path, status_code, notes)
values ('/maldives/guesthouses/sealavie-inn/', 'path', '/maldives/islands/ukulhas/', 301, 'Removed: no corresponding page found anywhere in the legacy website scrape to verify this listing against.')
on conflict (source_path) do update set target_type = excluded.target_type, target_path = excluded.target_path, status_code = excluded.status_code, notes = excluded.notes, updated_at = now();

insert into url_redirects (source_path, target_type, target_path, status_code, notes)
values ('/maldives/guesthouses/whaleshark-beach/', 'path', '/maldives/islands/dhigurah/', 301, 'Removed: no corresponding page found anywhere in the legacy website scrape to verify this listing against.')
on conflict (source_path) do update set target_type = excluded.target_type, target_path = excluded.target_path, status_code = excluded.status_code, notes = excluded.notes, updated_at = now();

update nodes set status = 'archived'
where node_type = 'accommodation'
  and slug in ('coral-grand-beach-spa', 'dhaankolhu-rasdhoo', 'go-surf-maldives', 'sealavie-inn', 'whaleshark-beach');
