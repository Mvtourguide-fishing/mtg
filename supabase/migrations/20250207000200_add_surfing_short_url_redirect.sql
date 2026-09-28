-- Convenience redirect: the site owner (and likely visitors) naturally
-- guessed the short /surfing URL, which was never a real link on either
-- the old site or the new one (legacy URLs were always longer, e.g.
-- /maldives-surfing-islands-and-resorts.html; the real current page is
-- /maldives/surfing/). Adds a short alias so it works anyway.

insert into url_redirects (source_path, target_type, target_path, status_code, notes)
values ('/surfing', 'path', '/maldives/surfing/', 301, '[redirect, confidence=high] Short convenience alias -- never a real URL on either site, added because visitors naturally guess it.')
on conflict (source_path) do update set target_type = excluded.target_type, target_path = excluded.target_path, status_code = excluded.status_code, notes = excluded.notes, updated_at = now();
