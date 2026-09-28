import Link from "next/link";

/**
 * Shared pagination control. `baseQuery` is any other active query-string
 * params (already URL-encoded, without a leading `?`/`&`) that must be
 * preserved across the page link — e.g. an active filter.
 */
export function Pagination({
  page,
  totalPages,
  basePath,
  baseQuery,
}: {
  page: number;
  totalPages: number;
  basePath: string;
  baseQuery?: string;
}) {
  if (totalPages <= 1) return null;
  const prefix = baseQuery ? `${baseQuery}&` : "";

  return (
    <nav aria-label="Pagination" className="mt-8 flex items-center gap-4 text-sm">
      {page > 1 && (
        <Link href={`${basePath}?${prefix}page=${page - 1}`} className="font-medium text-maldives-600 hover:text-ocean-800 hover:underline">
          ← Previous
        </Link>
      )}
      <span className="text-neutral-500">
        Page {page} of {totalPages}
      </span>
      {page < totalPages && (
        <Link href={`${basePath}?${prefix}page=${page + 1}`} className="font-medium text-maldives-600 hover:text-ocean-800 hover:underline">
          Next →
        </Link>
      )}
    </nav>
  );
}
