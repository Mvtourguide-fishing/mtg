-- Fix: Velana International Airport's own `locations` row
-- (supabase/migrations/20250108000100_seed_transfers.sql) was seeded
-- without lat/lng. Since every transfer_routes row in this project
-- originates there, RouteMap (Task 20 §33) silently rendered nothing on
-- every single route page -- not a "missing data, correctly omitted"
-- case, a real gap.
--
-- Coordinates are the legacy site's own, stated identically in three
-- independent places on its own transfer pages (confirmed across
-- multiple release/public_html/transfer/*.html files, e.g.
-- baros-Island-Maldives-Transfer.html): the page's own JSON-LD
-- ("Place" -> "geo" -> latitude/longitude), the visible "Departure
-- Point" text ("Coordinates: 4.1918°N, 73.5290°E"), and the page's own
-- Leaflet map script (`var airportCoords = [4.1918, 73.5290]`) -- a
-- real, legacy-sourced fact, not invented.
update locations
set lat = 4.1918, lng = 73.5290
where id = (select id from nodes where node_type = 'location' and slug = 'velana-international-airport')
  and lat is null and lng is null;
