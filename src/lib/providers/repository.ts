import "server-only";

import { cachedRead } from "@/lib/cache/cached-read";
import { createClient } from "@/lib/supabase/public";
import type { PaginatedResult, ProviderDetail, ProviderSummary } from "@/lib/providers/types";

/**
 * Server-side provider data-access layer, mirroring the pattern established
 * in src/lib/locations/repository.ts: pages call these functions instead of
 * querying Supabase directly, and everything here only returns published
 * providers (public read, no user context — matches the
 * `providers_public_read` RLS policy).
 */

// `providers!inner(...)` — not a plain embed. See the identical note in
// src/lib/locations/repository.ts: without `!inner`, filtering on an
// embedded column doesn't restrict which `nodes` rows come back.
const NODE_PROVIDER_SELECT =
  "id, slug, title, summary, meta_title, meta_description, providers!inner(legal_name, contact_email, contact_phone, website_url, license_number, is_verified)";

type NodeProviderRow = {
  id: string;
  slug: string;
  title: string;
  summary: string | null;
  meta_title: string | null;
  meta_description: string | null;
  providers:
    | {
        legal_name: string | null;
        contact_email: string | null;
        contact_phone: string | null;
        website_url: string | null;
        license_number: string | null;
        is_verified: boolean | null;
      }
    | Array<{
        legal_name: string | null;
        contact_email: string | null;
        contact_phone: string | null;
        website_url: string | null;
        license_number: string | null;
        is_verified: boolean | null;
      }>
    | null;
};

// Owner asked (this session) not to display this one provider's company
// name anywhere on the site — every page/listing that shows a provider's
// name reads it from `title` below, which every repository function in
// this file funnels through, so redacting it once here covers all of them
// (accommodation/activity/package/transfer "Operated by" lines, the
// provider directory and detail page, and JSON-LD Organization names)
// without special-casing each individual page. The underlying node/slug/
// contact data is untouched — only the displayed name changes.
const REDACTED_PROVIDER_NAMES: Record<string, string> = {
  "maldives-fishing-and-holiday": "Local Fishing Operator",
};

function providerDetailOf(row: NodeProviderRow): ProviderDetail | null {
  const p = Array.isArray(row.providers) ? row.providers[0] : row.providers;
  if (!p) return null;

  return {
    id: row.id,
    slug: row.slug,
    title: REDACTED_PROVIDER_NAMES[row.slug] ?? row.title,
    summary: row.summary,
    isVerified: p.is_verified ?? false,
    legalName: p.legal_name,
    contactEmail: p.contact_email,
    contactPhone: p.contact_phone,
    websiteUrl: p.website_url,
    licenseNumber: p.license_number,
    metaTitle: row.meta_title,
    metaDescription: row.meta_description,
  };
}

function providerSummaryOf(row: NodeProviderRow): ProviderSummary | null {
  const detail = providerDetailOf(row);
  if (!detail) return null;
  const { id, slug, title, summary, isVerified } = detail;
  return { id, slug, title, summary, isVerified };
}

export interface GetProvidersOptions {
  page?: number;
  pageSize?: number;
}

async function getProvidersUncached(options: GetProvidersOptions = {}): Promise<PaginatedResult<ProviderSummary>> {
  const page = Math.max(1, options.page ?? 1);
  const pageSize = Math.min(100, Math.max(1, options.pageSize ?? 48));
  const from = (page - 1) * pageSize;
  const to = from + pageSize - 1;

  const supabase = await createClient();
  const { data, error, count } = await supabase
    .from("nodes")
    .select(NODE_PROVIDER_SELECT, { count: "exact" })
    .eq("node_type", "provider")
    .eq("status", "published")
    .order("title", { ascending: true })
    .range(from, to)
    .returns<NodeProviderRow[]>();

  if (error || !data) return { items: [], total: 0, page, pageSize };

  const items = data.map(providerSummaryOf).filter((p): p is ProviderSummary => p !== null);
  return { items, total: count ?? items.length, page, pageSize };
}

export const getProviders = cachedRead(getProvidersUncached, ["providers"]);

export async function getProviderBySlug(slug: string): Promise<ProviderDetail | null> {
  const supabase = await createClient();
  const { data, error } = await supabase
    .from("nodes")
    .select(NODE_PROVIDER_SELECT)
    .eq("node_type", "provider")
    .eq("status", "published")
    .eq("slug", slug)
    .maybeSingle<NodeProviderRow>();

  if (error || !data) return null;
  return providerDetailOf(data);
}

/** Batch lookup, used by the accommodation repository to avoid N+1 queries. */
export async function getProviderSummariesByIds(ids: string[]): Promise<Map<string, ProviderSummary>> {
  const map = new Map<string, ProviderSummary>();
  if (ids.length === 0) return map;

  const supabase = await createClient();
  const { data, error } = await supabase
    .from("nodes")
    .select(NODE_PROVIDER_SELECT)
    .eq("node_type", "provider")
    .eq("status", "published")
    .in("id", ids)
    .returns<NodeProviderRow[]>();

  if (error || !data) return map;

  for (const row of data) {
    const summary = providerSummaryOf(row);
    if (summary) map.set(summary.id, summary);
  }
  return map;
}

export interface SearchProvidersOptions {
  limit?: number;
}

export async function searchProviders(query: string, options: SearchProvidersOptions = {}): Promise<ProviderSummary[]> {
  const trimmed = query.trim();
  if (trimmed.length === 0) return [];

  const supabase = await createClient();
  const { data, error } = await supabase
    .from("nodes")
    .select(NODE_PROVIDER_SELECT)
    .eq("node_type", "provider")
    .eq("status", "published")
    .ilike("title", `%${trimmed}%`)
    .order("title", { ascending: true })
    .limit(options.limit ?? 20)
    .returns<NodeProviderRow[]>();

  if (error || !data) return [];
  return data.map(providerSummaryOf).filter((p): p is ProviderSummary => p !== null);
}
