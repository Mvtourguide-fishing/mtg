-- Site-owner request (follow-up to 20250202000100/200): a real
-- island-hopping tour for guests in Gaafu Alifu Atoll, using photos the
-- owner uploaded directly to assets/uploads/activities/island-hopping/.
-- (That same upload batch also supplied the hero/gallery for the separate,
-- real "Island Hopping Excursion Male Atoll" activity created in
-- 20250202000100 — its own distinct legacy content, attached below once
-- this batch's media_assets rows exist.)
--
-- This is a new product, not a legacy-content recreation like the rest of
-- this migration series, so no fixed price is claimed (matching the
-- existing private speedboat charter pattern in
-- src/components/speedboats/speedboat-detail-page.tsx: "No fixed public
-- price... Request a quote") rather than inventing one. It's operated by
-- the same real Maamendhoo-based provider as the MFH fishing charters
-- (20250119000100), since that is the one real operator this catalogue has
-- on record in Gaafu Alifu Atoll.
--
-- Location note: the owner's request grouped "The Residence Dhigurah" with
-- the other 3 named resorts, but this codebase's own (already-verified)
-- location data has The Residence Maldives at Dhigurah Island Resort in
-- Alif Dhaalu Atoll, not Gaafu Alifu (see
-- the-residence-maldives-at-dhigurah-island-resort's node_locations row,
-- parent atoll 'alif-dhaalu') — likely a mix-up with the similarly-named
-- but geographically different Residence property. It is deliberately left
-- out of this Gaafu Alifu tour's locations below rather than tagged
-- somewhere it doesn't belong; flagged to the owner to confirm.
--
-- Kooddoo (home to Kooddoo Airport, the atoll's domestic gateway, and
-- Mercure Maldives Kooddoo Resort) did not yet exist as a location at all,
-- so it's added here as real, uncontroversial geography. No accommodation
-- node is created for "Mercure Maldives Kooddoo" itself — this catalogue's
-- own established rule (20250126000300_remove_unsourced_accommodations.sql)
-- is to never seed an accommodation without a verified source page, and
-- none exists for it here; Kooddoo is tagged only as a tour location/pickup
-- point.

insert into nodes (node_type, slug, title, summary, status, meta_title, meta_description, published_at)
values ('location', 'kooddoo', 'Kooddoo', 'Kooddoo is an inhabited island in Gaafu Alifu Atoll, Maldives, home to Kooddoo Airport.', 'published', 'Kooddoo, Gaafu Alifu Atoll | Maldives Islands | MTG', 'Kooddoo is an inhabited island in Gaafu Alifu Atoll, Maldives, home to Kooddoo Airport.', now())
on conflict (node_type, slug) do nothing;

insert into locations (id, location_type, parent_id, path, is_inhabited)
select n.id, 'island', p.id, (p_loc.path || 'kooddoo'::ltree), true
from nodes n, nodes p join locations p_loc on p_loc.id = p.id
where n.node_type = 'location' and n.slug = 'kooddoo'
  and p.node_type = 'location' and p.slug = 'gaafu-alifu'
on conflict (id) do nothing;

insert into nodes (node_type, slug, title, summary, status, meta_title, meta_description, published_at)
values (
  'activity', 'gaafu-alifu-island-hopping-tour', 'Gaafu Alifu Island Hopping Tour',
  'Gaafu Alifu Island Hopping Tour is a local island-hopping and culture tour around Gaafu Alifu Atoll, available to guests staying at Maldives Fishing and Holidays Lodge (Maamendhoo) and nearby resorts including The Residence Maldives at Falhumaafushi, Pullman Maldives Maamutaa, and Park Hyatt Maldives Hadahaa. Visit real local islands, a fishing village, and the local market, with pickup arranged from your resort or Kooddoo Airport. No fixed public price — cost depends on route, duration, and group size. Request a quote and we will follow up directly with an itinerary.',
  'published',
  'Gaafu Alifu Island Hopping Tour | Maldives Tour Guide',
  'Gaafu Alifu Island Hopping Tour is a local island-hopping and culture tour around Gaafu Alifu Atoll, available to guests at Maamendhoo and nearby resorts.',
  now()
)
on conflict (node_type, slug) do nothing;

insert into activities (id, activity_category, operated_by_provider_id)
select n.id, 'island_hopping', p.id
from nodes n, nodes p where n.node_type = 'activity' and n.slug = 'gaafu-alifu-island-hopping-tour' and p.node_type = 'provider' and p.slug = 'maldives-fishing-and-holiday'
on conflict (id) do nothing;

insert into node_locations (node_id, location_id, relation)
select n.id, l.id, 'primary' from nodes n, nodes l where n.node_type = 'activity' and n.slug = 'gaafu-alifu-island-hopping-tour' and l.node_type = 'location' and l.slug = 'maamendhoo-gaafu-alifu'
on conflict (node_id, location_id) do nothing;

insert into node_locations (node_id, location_id, relation)
select n.id, l.id, 'secondary' from nodes n, nodes l where n.node_type = 'activity' and n.slug = 'gaafu-alifu-island-hopping-tour' and l.node_type = 'location' and l.slug = 'falhumaafushi'
on conflict (node_id, location_id) do nothing;

insert into node_locations (node_id, location_id, relation)
select n.id, l.id, 'secondary' from nodes n, nodes l where n.node_type = 'activity' and n.slug = 'gaafu-alifu-island-hopping-tour' and l.node_type = 'location' and l.slug = 'maamutaa'
on conflict (node_id, location_id) do nothing;

insert into node_locations (node_id, location_id, relation)
select n.id, l.id, 'secondary' from nodes n, nodes l where n.node_type = 'activity' and n.slug = 'gaafu-alifu-island-hopping-tour' and l.node_type = 'location' and l.slug = 'hadahaa'
on conflict (node_id, location_id) do nothing;

insert into node_locations (node_id, location_id, relation)
select n.id, l.id, 'secondary' from nodes n, nodes l where n.node_type = 'activity' and n.slug = 'gaafu-alifu-island-hopping-tour' and l.node_type = 'location' and l.slug = 'kooddoo'
on conflict (node_id, location_id) do nothing;

insert into bookable_products (id, booking_mode)
select id, 'inquiry' from nodes where node_type = 'activity' and slug = 'gaafu-alifu-island-hopping-tour'
on conflict (id) do nothing;

delete from node_media where role = 'hero' and node_id = (select id from nodes where node_type = 'activity' and slug = 'gaafu-alifu-island-hopping-tour');
insert into node_media (node_id, media_id, role, sort_order) select id, '92388d6f-6543-a3cc-b60a-98efb37829c0', 'hero', 0 from nodes where node_type = 'activity' and slug = 'gaafu-alifu-island-hopping-tour' on conflict (node_id, media_id, role) do nothing;
insert into node_media (node_id, media_id, role, sort_order) select id, 'c742c024-7507-22ea-a996-b6ae773b4174', 'gallery', 1 from nodes where node_type = 'activity' and slug = 'gaafu-alifu-island-hopping-tour' on conflict (node_id, media_id, role) do nothing;
insert into node_media (node_id, media_id, role, sort_order) select id, '4c0edd3e-bb81-bcb8-d1f7-890a3a962f4c', 'gallery', 2 from nodes where node_type = 'activity' and slug = 'gaafu-alifu-island-hopping-tour' on conflict (node_id, media_id, role) do nothing;
insert into node_media (node_id, media_id, role, sort_order) select id, '73f638f5-133c-0a50-ee18-ebfdc983c895', 'gallery', 3 from nodes where node_type = 'activity' and slug = 'gaafu-alifu-island-hopping-tour' on conflict (node_id, media_id, role) do nothing;
insert into node_media (node_id, media_id, role, sort_order) select id, '1d24de20-21f8-c291-83c4-6d970d50d1c7', 'gallery', 4 from nodes where node_type = 'activity' and slug = 'gaafu-alifu-island-hopping-tour' on conflict (node_id, media_id, role) do nothing;
insert into node_media (node_id, media_id, role, sort_order) select id, '3b67e938-259e-48aa-604e-24dab70ab899', 'gallery', 5 from nodes where node_type = 'activity' and slug = 'gaafu-alifu-island-hopping-tour' on conflict (node_id, media_id, role) do nothing;

-- Island Hopping Excursion Male Atoll (real, separate Male Atoll activity
-- created in 20250202000100) also draws its hero/gallery from this same
-- island-hopping/ upload batch — attached here, once this migration's
-- earlier media_assets rows (from 20250202000200) exist.
insert into node_media (node_id, media_id, role, sort_order) select id, '92388d6f-6543-a3cc-b60a-98efb37829c0', 'hero', 0 from nodes where node_type = 'activity' and slug = 'island-hopping-excursion-male-atoll' on conflict (node_id, media_id, role) do nothing;
insert into node_media (node_id, media_id, role, sort_order) select id, '5497fe83-2d61-fbb7-719d-f60d7cff092d', 'gallery', 1 from nodes where node_type = 'activity' and slug = 'island-hopping-excursion-male-atoll' on conflict (node_id, media_id, role) do nothing;
insert into node_media (node_id, media_id, role, sort_order) select id, 'c742c024-7507-22ea-a996-b6ae773b4174', 'gallery', 2 from nodes where node_type = 'activity' and slug = 'island-hopping-excursion-male-atoll' on conflict (node_id, media_id, role) do nothing;
insert into node_media (node_id, media_id, role, sort_order) select id, '4c0edd3e-bb81-bcb8-d1f7-890a3a962f4c', 'gallery', 3 from nodes where node_type = 'activity' and slug = 'island-hopping-excursion-male-atoll' on conflict (node_id, media_id, role) do nothing;
insert into node_media (node_id, media_id, role, sort_order) select id, '73f638f5-133c-0a50-ee18-ebfdc983c895', 'gallery', 4 from nodes where node_type = 'activity' and slug = 'island-hopping-excursion-male-atoll' on conflict (node_id, media_id, role) do nothing;
