-- Site-owner request: change where the old
-- /maldives-transportation-ferry-speedboat-transfers.html link lands.
-- Previously redirected to /maldives-ferry-schedule/ (the dedicated ferry
-- timetable page this legacy page's real route data was migrated into,
-- Task 20) -- now pointed at the main Transfers hub instead, per the
-- owner's explicit choice. The ferry schedule page itself is unaffected
-- and still reachable from the Transfers hub.

insert into url_redirects (source_path, target_type, target_path, status_code, notes)
values ('/maldives-transportation-ferry-speedboat-transfers.html', 'path', '/maldives/transfers/', 301, '[redirect, confidence=high] Site owner explicitly requested this old link land on the main Transfers hub instead of the dedicated Ferry Schedule page.')
on conflict (source_path) do update set target_type = excluded.target_type, target_path = excluded.target_path, status_code = excluded.status_code, notes = excluded.notes, updated_at = now();
