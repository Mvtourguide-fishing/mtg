-- Site-owner-reported bug: /snorkeling-and-diving-activities-in-maldives.html
-- 404s. Investigation found this exact legacy file existed at THREE paths
-- on the old site (release/public_html/snorkeling-and-diving-activities-in-maldives.html,
-- .../transfer/snorkeling-and-diving-activities-in-maldives.html, and
-- .../tours/snorkeling-and-diving-activities-in-maldives.html), but the
-- original Task 16 redirect migration
-- (20250111000100_legacy_redirects.sql) only ever covered the /transfer/
-- one. These two were simply missed, not deliberately excluded — same
-- content, same real target.

insert into url_redirects (source_path, target_type, target_path, status_code, notes)
values ('/snorkeling-and-diving-activities-in-maldives.html', 'path', '/maldives/activities/', 301, '[redirect, confidence=high] Same content as /transfer/snorkeling-and-diving-activities-in-maldives.html (duplicate legacy path, missed in the original Task 16 redirect pass) -- general snorkeling/diving/water-sports activities hub, mapped to the activities directory.')
on conflict (source_path) do update set target_type = excluded.target_type, target_path = excluded.target_path, status_code = excluded.status_code, notes = excluded.notes, updated_at = now();

insert into url_redirects (source_path, target_type, target_path, status_code, notes)
values ('/tours/snorkeling-and-diving-activities-in-maldives.html', 'path', '/maldives/activities/', 301, '[redirect, confidence=high] Same content as /transfer/snorkeling-and-diving-activities-in-maldives.html (duplicate legacy path, missed in the original Task 16 redirect pass) -- general snorkeling/diving/water-sports activities hub, mapped to the activities directory.')
on conflict (source_path) do update set target_type = excluded.target_type, target_path = excluded.target_path, status_code = excluded.status_code, notes = excluded.notes, updated_at = now();
