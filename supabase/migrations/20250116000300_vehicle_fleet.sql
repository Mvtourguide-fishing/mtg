-- Car Transfers fleet (Task 20 §17 follow-up): the owner's real fleet —
-- 2x 4-seater car, 2x 6-seater car, 1 minibus, 1 large bus — represented
-- as 4 listings (one per vehicle TYPE, not one row per physical unit,
-- per the owner's own confirmation) rather than 6 near-duplicate rows.
-- Capacity for the 4/6-seater cars is self-evident from their name;
-- minibus (15) and bus (30) capacities are the owner's own stated
-- figures, not invented. No price anywhere — pricing is still "to be
-- confirmed" (see src/components/vehicles/car-transfers-section.tsx's
-- own header comment), same no-fabrication rule as every other
-- inquiry-only product on this platform.

insert into nodes (id, node_type, slug, title, summary, status, meta_title, meta_description, published_at) values
  ('1f4a2e6b-5c9d-4a3f-8b7e-2d6c9a1f3e50', 'vehicle', '4-seater-car', '4-Seater Car', 'Private car transfer for up to 4 passengers around Malé and the local islands. Pricing to be confirmed; hourly and custom private hire available.', 'published', '4-Seater Car Transfer | Maldives Tour Guide', 'Private 4-seater car transfer in the Maldives, around Malé and local islands. Hourly and custom private hire available.', now())
on conflict (node_type, slug) do nothing;
insert into vehicles (id, vehicle_type, capacity, luggage_capacity, facilities, active)
  select id, 'car', 4, null, '{}', true from nodes where node_type = 'vehicle' and slug = '4-seater-car'
on conflict (id) do nothing;
insert into bookable_products (id, booking_mode, base_price, currency, max_guests)
  select id, 'inquiry', null, null, 4 from nodes where node_type = 'vehicle' and slug = '4-seater-car'
on conflict (id) do nothing;

insert into nodes (id, node_type, slug, title, summary, status, meta_title, meta_description, published_at) values
  ('2a5b3f7c-6d0e-4b4a-9c8f-3e7d0a2f4e61', 'vehicle', '6-seater-car', '6-Seater Car', 'Private car transfer for up to 6 passengers around Malé and the local islands. Pricing to be confirmed; hourly and custom private hire available.', 'published', '6-Seater Car Transfer | Maldives Tour Guide', 'Private 6-seater car transfer in the Maldives, around Malé and local islands. Hourly and custom private hire available.', now())
on conflict (node_type, slug) do nothing;
insert into vehicles (id, vehicle_type, capacity, luggage_capacity, facilities, active)
  select id, 'car', 6, null, '{}', true from nodes where node_type = 'vehicle' and slug = '6-seater-car'
on conflict (id) do nothing;
insert into bookable_products (id, booking_mode, base_price, currency, max_guests)
  select id, 'inquiry', null, null, 6 from nodes where node_type = 'vehicle' and slug = '6-seater-car'
on conflict (id) do nothing;

insert into nodes (id, node_type, slug, title, summary, status, meta_title, meta_description, published_at) values
  ('3b6c4a8d-7e1f-4c5b-ad9a-4f8e1b3a5f72', 'vehicle', 'minibus', 'Minibus', 'Private minibus transfer for up to 15 passengers around Malé and the local islands. Pricing to be confirmed; hourly and custom private hire available.', 'published', 'Minibus Transfer | Maldives Tour Guide', 'Private minibus transfer for groups in the Maldives, around Malé and local islands. Hourly and custom private hire available.', now())
on conflict (node_type, slug) do nothing;
insert into vehicles (id, vehicle_type, capacity, luggage_capacity, facilities, active)
  select id, 'minibus', 15, null, '{}', true from nodes where node_type = 'vehicle' and slug = 'minibus'
on conflict (id) do nothing;
insert into bookable_products (id, booking_mode, base_price, currency, max_guests)
  select id, 'inquiry', null, null, 15 from nodes where node_type = 'vehicle' and slug = 'minibus'
on conflict (id) do nothing;

insert into nodes (id, node_type, slug, title, summary, status, meta_title, meta_description, published_at) values
  ('4c7d5b9e-8f20-4d6c-be0b-5a9f2c4b6083', 'vehicle', 'large-bus', 'Large Bus', 'Private bus transfer for up to 30 passengers around Malé and the local islands. Pricing to be confirmed; hourly and custom private hire available.', 'published', 'Large Bus Transfer | Maldives Tour Guide', 'Private large bus transfer for big groups in the Maldives, around Malé and local islands. Hourly and custom private hire available.', now())
on conflict (node_type, slug) do nothing;
insert into vehicles (id, vehicle_type, capacity, luggage_capacity, facilities, active)
  select id, 'bus', 30, null, '{}', true from nodes where node_type = 'vehicle' and slug = 'large-bus'
on conflict (id) do nothing;
insert into bookable_products (id, booking_mode, base_price, currency, max_guests)
  select id, 'inquiry', null, null, 30 from nodes where node_type = 'vehicle' and slug = 'large-bus'
on conflict (id) do nothing;
