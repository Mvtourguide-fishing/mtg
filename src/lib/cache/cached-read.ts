import "server-only";

import { unstable_cache } from "next/cache";

/**
 * Wraps a public, read-only Supabase data-access function in Next's
 * time-based Data Cache.
 *
 * Map values need special handling because Next's cache serialization does
 * not preserve JavaScript Map instances. We serialize Maps as entry arrays
 * and reconstruct them when the cached value is read.
 */
export function cachedRead<Args extends unknown[], Result>(
  fn: (...args: Args) => Promise<Result>,
  keyParts: string[],
  revalidateSeconds = 300,
): (...args: Args) => Promise<Result> {
  const cached = unstable_cache(
    async (...args: Args) => {
      const result = await fn(...args);

      if (result instanceof Map) {
        return {
          __cachedReadMap: true as const,
          entries: Array.from(result.entries()),
        };
      }

      return result;
    },
    keyParts,
    { revalidate: revalidateSeconds },
  );

  return async (...args: Args): Promise<Result> => {
    const result = await cached(...args);

    if (
      result &&
      typeof result === "object" &&
      "__cachedReadMap" in result &&
      result.__cachedReadMap === true &&
      "entries" in result &&
      Array.isArray(result.entries)
    ) {
      return new Map(result.entries) as Result;
    }

    return result as Result;
  };
}