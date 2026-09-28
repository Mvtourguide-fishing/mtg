import "server-only";

import { createClient } from "@/lib/supabase/server";
import type { NodeStatus } from "@/lib/admin/node-actions";

/**
 * Admin-only provider reads (all statuses, unlike src/lib/providers/
 * repository.ts which only ever returns `status='published'` for the
 * public site). Same `providers!inner(...)` shape as the public
 * repository, governed by `providers_staff_all` RLS instead of
 * `providers_public_read`.
 */

const PAGE_SIZE = 30;

const NODE_PROVIDER_SELECT =
  "id, slug, title, summary, status, meta_title, meta_description, providers!inner(legal_name, contact_email, contact_phone, website_url, license_number, is_verified)";

interface NodeProviderRow {
  id: string;
  slug: string;
  title: string;
  summary: string | null;
  status: NodeStatus;
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
}

export interface AdminProviderItem {
  id: string;
  slug: string;
  title: string;
  summary: string | null;
  status: NodeStatus;
  metaTitle: string | null;
  metaDescription: string | null;
  legalName: string | null;
  contactEmail: string | null;
  contactPhone: string | null;
  websiteUrl: string | null;
  licenseNumber: string | null;
  isVerified: boolean;
}

function toAdminProvider(row: NodeProviderRow): AdminProviderItem | null {
  const p = Array.isArray(row.providers) ? row.providers[0] : row.providers;
  if (!p) return null;
  return {
    id: row.id,
    slug: row.slug,
    title: row.title,
    summary: row.summary,
    status: row.status,
    metaTitle: row.meta_title,
    metaDescription: row.meta_description,
    legalName: p.legal_name,
    contactEmail: p.contact_email,
    contactPhone: p.contact_phone,
    websiteUrl: p.website_url,
    licenseNumber: p.license_number,
    isVerified: p.is_verified ?? false,
  };
}

export interface AdminProviderListResult {
  items: AdminProviderItem[];
  total: number;
  page: number;
  pageSize: number;
}

export async function getProvidersAdmin(options: { search?: string; page?: number } = {}): Promise<AdminProviderListResult> {
  const page = Math.max(1, options.page ?? 1);
  const from = (page - 1) * PAGE_SIZE;
  const to = from + PAGE_SIZE - 1;

  const supabase = await createClient();
  let query = supabase.from("nodes").select(NODE_PROVIDER_SELECT, { count: "exact" }).eq("node_type", "provider").order("title", { ascending: true });
  if (options.search?.trim()) query = query.ilike("title", `%${options.search.trim()}%`);

  const { data, error, count } = await query.range(from, to).returns<NodeProviderRow[]>();
  if (error || !data) return { items: [], total: 0, page, pageSize: PAGE_SIZE };

  const items = data.map(toAdminProvider).filter((p): p is AdminProviderItem => p !== null);
  return { items, total: count ?? items.length, page, pageSize: PAGE_SIZE };
}

export async function getProviderByIdAdmin(id: string): Promise<AdminProviderItem | null> {
  const supabase = await createClient();
  const { data, error } = await supabase.from("nodes").select(NODE_PROVIDER_SELECT).eq("node_type", "provider").eq("id", id).maybeSingle<NodeProviderRow>();
  if (error || !data) return null;
  return toAdminProvider(data);
}
