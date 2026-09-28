-- Site-owner-reported 404: /maldives-surfing-islands-and-resorts.html had
-- no redirect at all (missed in the original Task 16 pass, same class of
-- gap as the snorkeling/diving page fixed in 20250206000100). Real,
-- substantial legacy page (1270 lines, pageType "surfing" in
-- legacy-url-inventory.json) -- sent to the current Surfing hub, which
-- already covers surf lessons/camps and real surf breaks. Not recreated
-- as its own page here; flagged to the owner as a candidate for a fuller
-- rebuild later, the same way Male City Tour/Whale Submarine were.

insert into url_redirects (source_path, target_type, target_path, status_code, notes)
values ('/maldives-surfing-islands-and-resorts.html', 'path', '/maldives/surfing/', 301, '[redirect, confidence=high] Real legacy surfing overview page, missed in the original Task 16 redirect pass -- sent to the current Surfing hub.')
on conflict (source_path) do update set target_type = excluded.target_type, target_path = excluded.target_path, status_code = excluded.status_code, notes = excluded.notes, updated_at = now();
