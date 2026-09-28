import { createClient } from "@supabase/supabase-js";

/**
 * Legacy-URL redirect resolution (Task 16). The new app namespaces every
 * real route under `/maldives/` (plus the bare homepage `/` and `/api/*`)
 * — see src/app's top-level directories — so every legacy path from the
 * old site (root-level `.html` files, `/atolls/...`, `/transfer/...`,
 * `/tours/...`, etc.) is structurally distinguishable from a real new-site
 * request without needing to know the full new route table. This keeps
 * the url_redirects lookup off the hot path for the site's actual traffic
 * (Task 16 §35 — "avoid expensive database calls for every request where
 * possible").
 */
const NEW_APP_PATHS = ["/maldives", "/api"];
const NEVER_REDIRECT_EXACT = new Set(["/", "/favicon.ico", "/robots.txt", "/sitemap.xml"]);

export function looksLikeLegacyPath(pathname: string): boolean {
  if (NEVER_REDIRECT_EXACT.has(pathname)) return false;
  if (pathname.startsWith("/_next/")) return false;
  return !NEW_APP_PATHS.some((p) => pathname === p || pathname.startsWith(`${p}/`));
}

/** Legacy source paths were recorded (scripts/generate-redirect-seed.mjs)
 * as the exact on-disk `.html` path, no trailing slash, no query string,
 * no fragment. Strips those off an incoming request path the same way,
 * so a browser/crawler hitting a trailing-slash or query-string variant
 * of an old URL still resolves (Task 16 §8/§33/§34). */
export function normalizeLegacyPath(pathname: string): string {
  let normalized = pathname;
  try {
    normalized = decodeURIComponent(normalized);
  } catch {
    // malformed percent-encoding — use as-is
  }
  normalized = normalized.replace(/\/+$/, "");
  return normalized === "" ? "/" : normalized;
}

export interface ResolvedRedirect {
  targetPath: string;
  statusCode: 301 | 302 | 308;
}

/** Only ever returns a same-origin, server-relative path (starts with a
 * single `/`, never `//host/...` or `scheme://...`) — the open-redirect
 * guard required by Task 16 §36. url_redirects.target_path is always
 * populated by scripts/generate-redirect-seed.mjs from a real internal
 * app route, so this should never trip in practice; it's here as a
 * defensive read-time check, not a trust boundary this code relies on. */
function isSafeInternalPath(value: string): boolean {
  return value.startsWith("/") && !value.startsWith("//") && !/^\/[a-z]+:/i.test(value);
}

/**
 * Looks up an active redirect for `pathname` in `url_redirects`. Uses a
 * plain (non-session, non-cookie) Supabase client — this is a public,
 * unauthenticated read of `is_active` rows only (see the
 * `url_redirects_public_read` RLS policy), the same trust level as any
 * other anonymous visitor request, so no session/auth machinery is needed
 * for it. Returns null (never throws) on any failure — a redirect lookup
 * problem must never break the page a visitor is trying to reach.
 */
export async function resolveLegacyRedirect(pathname: string): Promise<ResolvedRedirect | null> {
  const url = process.env.NEXT_PUBLIC_SUPABASE_URL;
  const anonKey = process.env.NEXT_PUBLIC_SUPABASE_ANON_KEY;
  if (!url || !anonKey) return null;

  const sourcePath = normalizeLegacyPath(pathname);

  try {
    const supabase = createClient(url, anonKey);
    const { data, error } = await supabase
      .from("url_redirects")
      .select("target_type, target_path, status_code")
      .eq("source_path", sourcePath)
      .eq("is_active", true)
      .maybeSingle<{ target_type: string; target_path: string | null; status_code: number }>();

    if (error || !data) return null;
    if (data.target_type !== "path" || !data.target_path) return null;
    if (!isSafeInternalPath(data.target_path)) return null;
    if (![301, 302, 308].includes(data.status_code)) return null;

    return { targetPath: data.target_path, statusCode: data.status_code as 301 | 302 | 308 };
  } catch {
    return null;
  }
}
