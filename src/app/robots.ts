import type { MetadataRoute } from "next";

import { getSiteUrl } from "@/lib/seo/site";

/** Task 16 §31: no accidental blocking of the real site, no leftover
 * migration-only noindex rules (there were never any — this file didn't
 * exist before this task). Search results (`/maldives/search/?q=...`)
 * are left crawlable rather than blanket-disallowed here: the page
 * itself already sends a per-page `noindex` when a query is present
 * (src/components/search/search-page.tsx) and stays indexable with no
 * query (the search entry page is real content) — a robots.txt
 * disallow would be blunter than that and would stop a crawler from
 * ever revisiting a stray indexed result URL to see the noindex tag. */
export default function robots(): MetadataRoute.Robots {
  const siteUrl = getSiteUrl();
  return {
    rules: {
      userAgent: "*",
      allow: "/",
      disallow: ["/api/", "/admin/"],
    },
    sitemap: `${siteUrl}/sitemap.xml`,
  };
}
