import type { MediaAsset } from "@/lib/media/types";

/**
 * Fixed hero images for the transfer hub/category pages, none of which
 * are node-backed (so node_media doesn't apply). The original ids here
 * pointed at "legacy/images/transfers/*.webp" paths from the still-unrun
 * full legacy image library migration (never actually uploaded to
 * Storage — see the identical gap documented in
 * src/lib/fishing/fish-species.ts), so these hero images were broken in
 * production. The owner re-uploaded fresh copies of the same photos to
 * assets/uploads/transfers/ (filenames matching the old legacy ones
 * closely enough to confirm they're the same intended images), registered
 * by supabase/migrations/20250129000200_transfer_category_images.sql /
 * scripts/attach-transfer-category-images.mjs. domesticFlightComingSoon
 * has no real replacement in that upload and still points at the old
 * (currently broken) legacy path rather than a guessed substitute.
 */

function asset(id: string, storagePath: string, altText: string): MediaAsset {
  return { id, mediaType: "image", storagePath, youtubeId: null, altText, credit: null, width: null, height: null };
}

export const TRANSFER_CATEGORY_IMAGES = {
  mainHub: asset("4ed61c4d-2c5d-5d73-af3f-79fee2418314", "uploads/assets/uploads/transfers/maldives-transfers.webp", "Maldives transfers"),
  airportTransfers: asset("47c95968-8088-625a-98d2-20130258283c", "uploads/assets/uploads/transfers/maldives-taxi-transfer.webp", "Maldives airport transfers"),
  resortTransfers: asset("79238d89-7cc6-2d55-bafe-9e7affa84902", "uploads/assets/uploads/transfers/maldives-resort-transfer-300x300.webp", "Maldives resort transfers"),
  islandTransfers: asset("309f778c-2470-d34d-9428-64310c62eb13", "uploads/assets/uploads/transfers/maldives-island-transfers.webp", "Maldives island transfers"),
  hotelTransfers: asset("621881e3-d458-7642-3d73-a3ccec438396", "uploads/assets/uploads/transfers/maldives-bus-transfer.webp", "Maldives hotel transfers"),
  speedboatTransfers: asset("57316a45-c325-79d0-5ec4-be975efe817d", "uploads/assets/uploads/transfers/maldives-speed-boat-transfers.webp", "Maldives speedboat transfers"),
  speedboatCharterHub: asset("2492fc47-c79b-8611-5825-74dd404540ce", "uploads/assets/uploads/transfers/maldives-speed-boat-transfers-870x500.webp", "Private speedboat charter in the Maldives"),
  ferryScheduleHub: asset("d865b111-b65a-6d09-bf58-728668c5829a", "uploads/assets/uploads/transfers/maldives-transportation.webp", "Maldives public transportation"),
  seaplaneComingSoon: asset("0740246b-2750-179c-8fa7-927170412361", "uploads/assets/uploads/transfers/maldives-seaplane-transfers.webp", "Maldives seaplane transfers"),
  domesticFlightComingSoon: asset("c84af170-4290-5719-145a-f317e30b11d4", "legacy/images/transfers/maldives-domestic-flight.webp", "Maldives domestic flight transfers"),
} as const;
