-- Real, purpose-named legacy images for the transfer category hub pages
-- (main hub, airport/resort/island/hotel/speedboat-transfers, the
-- speedboat charter directory, the ferry schedule page, and the
-- seaplane/domestic-flight "coming soon" sections), none of which had any
-- hero image before. These pages are not node-backed, so the ids below
-- are referenced directly by src/lib/transfers/category-images.ts rather
-- than via node_media. Every filename was found already purpose-named on
-- the legacy site itself (e.g. "maldives-airport-transfers.webp",
-- "private-speedboat-charter-maldives.webp") -- never invented.
insert into media_assets (id, media_type, storage_path, alt_text) values
  ('5f7b2509-92c8-fbfb-83a9-2bf74649ab4f', 'image', 'legacy/images/transfers/maldives-transfers.webp', 'Maldives transfers'),
  ('ceacc1c5-71e5-0d8c-dc4f-29d06f0153da', 'image', 'legacy/images/transfers/maldives-airport-transfers.webp', 'Maldives airport transfers'),
  ('cdd2e7cc-2917-c029-24b3-9853e7dba7e8', 'image', 'legacy/images/transfers/maldives-resort-transfers.webp', 'Maldives resort transfers'),
  ('3a77847b-1b23-e2a1-d7cc-8a2481214f0a', 'image', 'legacy/images/transfers/maldives-island-transfers.webp', 'Maldives island transfers'),
  ('88336ddc-f145-5d47-0d0d-a95b31a0b925', 'image', 'legacy/images/transfers/maldives-hotel-transfers.webp', 'Maldives hotel transfers'),
  ('d2d092f3-fa1d-99cd-ee64-bef3c62f556a', 'image', 'legacy/images/transfers/maldives-speedboat-transfers.webp', 'Maldives speedboat transfers'),
  ('99737dda-3e6d-c1d0-7061-0d5b0e75a0d1', 'image', 'legacy/images/transfers/private-speedboat-charter-maldives.webp', 'Private speedboat charter in the Maldives'),
  ('c77f4ccd-fd8e-5749-a8ea-7c45b0bad74a', 'image', 'legacy/images/transfers/maldives-transportation.webp', 'Maldives public transportation'),
  ('9c4c56d1-9fe2-230e-99ed-b40cca564218', 'image', 'legacy/images/transfers/maldives-seaplane-transfers.webp', 'Maldives seaplane transfers'),
  ('c84af170-4290-5719-145a-f317e30b11d4', 'image', 'legacy/images/transfers/maldives-domestic-flight.webp', 'Maldives domestic flight transfers')
on conflict (id) do nothing;
