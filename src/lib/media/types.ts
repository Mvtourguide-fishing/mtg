// Domain types for the media read layer (Task 14). `media_assets` +
// `node_media` already existed in the Task 2/3 foundation schema — this is
// the first repository to actually read them (see
// supabase/migrations/20250101000200_media_assets.sql and the node_media
// table in 20250101000900_community.sql).

/** Matches node_media.role's check constraint, widened in Task 14 to add
 * 'content' (an article body image) and 'map' — see
 * supabase/migrations/20250110000100_legacy_migration_schema.sql. */
export type MediaRole = "hero" | "gallery" | "thumbnail" | "content" | "map";

export interface MediaAsset {
  id: string;
  mediaType: "image" | "youtube";
  /** Path within the `media` Storage bucket (never a full URL — see
   * publicStorageUrl()). Null for a `youtube` asset, which uses
   * youtubeId instead. */
  storagePath: string | null;
  youtubeId: string | null;
  altText: string | null;
  credit: string | null;
  width: number | null;
  height: number | null;
}

export interface NodeMediaItem {
  role: MediaRole;
  sortOrder: number;
  asset: MediaAsset;
}

/** The public Storage URL for a `media_assets.storage_path` (bucket
 * "media" — created public in
 * supabase/migrations/20250110000100_legacy_migration_schema.sql). A pure
 * function (no DB access, just NEXT_PUBLIC_SUPABASE_URL — safe to inline
 * into a client bundle), so it lives here rather than in repository.ts,
 * which is server-only. Returns null when the env var isn't configured, so
 * callers can skip rendering rather than emit a broken src — same "never
 * fabricate" rule Task 14 applied to the migration scripts themselves. */
export function publicStorageUrl(storagePath: string): string | null {
  const base = process.env.NEXT_PUBLIC_SUPABASE_URL;
  if (!base) return null;
  const encodedPath = storagePath
    .split("/")
    .map((segment) => encodeURIComponent(segment))
    .join("/");
  return `${base.replace(/\/$/, "")}/storage/v1/object/public/media/${encodedPath}`;
}
