import type { MediaAsset } from "@/lib/media/types";

/**
 * Task 21: real legacy images used as a LAST-RESORT fallback for demo
 * packages whose anchored real entity (accommodation/activity) has no
 * hero image of its own yet. Every id below is computed the same way
 * every other Task 14+ script does —
 * deterministicUuid("legacy-media::" + relativePath) — so it resolves to
 * a real row already created by
 * supabase/migrations/20250115000100_full_legacy_image_library.sql
 * (confirmed against data/maldives/migration/
 * full-legacy-image-library-manifest.json before hardcoding). No new
 * migration needed; these ids already exist. Most demo packages never
 * reach this fallback at all — see demo.ts's resolution order.
 */

export function asset(id: string, storagePath: string, altText: string): MediaAsset {
  return { id, mediaType: "image", storagePath, youtubeId: null, altText, credit: null, width: null, height: null };
}

export const PACKAGE_CATEGORY_FALLBACK_IMAGES = {
  luxury: asset("415eec24-cb9d-38b4-f50b-3ae454ec3340", "legacy/images/overwater-hammock-in-maldives.webp", "Overwater hammock in the Maldives"),
  family: asset("b2dd1496-624c-b618-ac54-584a6d521434", "legacy/images/family-friendly-resort-in-maldives.webp", "Family-friendly resort in the Maldives"),
  honeymoon: asset("3a026c96-ee91-6bdc-6997-0bb4c46a947e", "legacy/images/maldives-honeymoons.webp", "Maldives honeymoons"),
  adultsOnly: asset("a61a1207-4442-db99-d0a4-f929d1c5d429", "legacy/images/things-to-do-in-maldives-for-couples.webp", "Things to do in the Maldives for couples"),
  budget: asset("994c5411-0851-6d11-e362-a38bdc6da9f3", "legacy/images/maldives-hotel.webp", "Maldives hotel"),
  diving: asset("26b550f8-e366-ffc3-e1a7-081a18ccadb4", "legacy/images/maldives-diving-activities.webp", "Maldives diving activities"),
  fishing: asset("e39bcc5a-22e2-4c59-2b5f-cc5f02f481eb", "legacy/images/maldives-fishing-activities.webp", "Maldives fishing activities"),
  surfing: asset("7ae65646-fc62-e395-f51a-9e1bae536501", "legacy/images/maldives-surfing-holiday-package.webp", "Maldives surfing holiday package"),
  liveaboard: asset("8c1c0e97-e7b4-a6fb-83c5-b9c0bb1d6715", "legacy/images/activities/liveaboard-dive-vessels.webp", "Liveaboard dive vessels in the Maldives"),
  mainHub: asset("a613b5e9-e3f6-e3af-319b-0f609deceef7", "legacy/images/maldives-vacations-and-honeymoons.webp", "Maldives vacations and honeymoons"),
} as const;

export type PackageCategoryFallbackKey = keyof typeof PACKAGE_CATEGORY_FALLBACK_IMAGES;

/**
 * Dedicated hero images for the /maldives/diving/ and /maldives/fishing/
 * hub pages specifically — kept separate from PACKAGE_CATEGORY_FALLBACK_IMAGES
 * above (which also doubles as the category fallback thumbnail for demo
 * packages with no accommodation photo of their own, via demo.ts) so
 * swapping just these two hub-page heroes never changes any package card
 * elsewhere on the site.
 *
 * DIVING_HERO_IMAGE: a different real legacy diving photo (verified against
 * data/maldives/migration/full-legacy-image-library-manifest.json) than the
 * one still used as the general diving category fallback.
 *
 * FISHING_HERO_IMAGE: one of the owner's own newly-uploaded fishing photos
 * (assets/uploads/fishing/images/gallery/) rather than a legacy image — see
 * scripts/attach-fishing-uploads.mjs, which registers this file's
 * media_assets row (not yet in the legacy library).
 */
export const DIVING_HERO_IMAGE = asset("eec07825-78df-21de-fc72-7e604440e43c", "legacy/images/diving/scuba-divers-maldives.webp", "Scuba divers in the Maldives");
export const FISHING_HERO_IMAGE = asset(
  "cdb0fc20-985d-4734-a1c8-79b6d020e07a",
  "uploads/assets/uploads/fishing/images/gallery/fishing-charter-boat.webp",
  "Maldives fishing charter boat",
);
