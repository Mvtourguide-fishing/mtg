import "server-only";

import { createClient } from "@/lib/supabase/server";

/**
 * Admin-only redirect reads. View/search/toggle only, per Task 15 §13 —
 * redirect CREATION is deliberately not built this round: the existing
 * chain-prevention trigger (`prevent_redirect_chains()`, supabase/
 * migrations/20250101001300_functions_triggers.sql) is delicate, and the
 * spec is explicit not to change the SEO migration strategy in this task.
 * A create/edit UI belongs in its own round with its own validation
 * against that trigger, not bolted on here for the sake of completeness.
 */

const PAGE_SIZE = 30;

export interface AdminRedirectItem {
  id: string;
  sourcePath: string;
  targetType: "node" | "path" | "external_url";
  targetNodeId: string | null;
  targetNodeTitle: string | null;
  targetPath: string | null;
  statusCode: number;
  isActive: boolean;
  notes: string | null;
  createdAt: string;
}

interface RedirectRow {
  id: string;
  source_path: string;
  target_type: "node" | "path" | "external_url";
  target_node_id: string | null;
  target_path: string | null;
  status_code: number;
  is_active: boolean;
  notes: string | null;
  created_at: string;
}

export interface AdminRedirectListResult {
  items: AdminRedirectItem[];
  total: number;
  page: number;
  pageSize: number;
}

export async function getRedirectsAdmin(options: { search?: string; activeOnly?: boolean; page?: number } = {}): Promise<AdminRedirectListResult> {
  const page = Math.max(1, options.page ?? 1);
  const from = (page - 1) * PAGE_SIZE;
  const to = from + PAGE_SIZE - 1;

  const supabase = await createClient();
  let query = supabase.from("url_redirects").select("*", { count: "exact" }).order("created_at", { ascending: false });
  if (options.activeOnly) query = query.eq("is_active", true);
  if (options.search?.trim()) {
    const term = options.search.trim();
    query = query.or(`source_path.ilike.%${term}%,target_path.ilike.%${term}%`);
  }

  const { data, error, count } = await query.range(from, to).returns<RedirectRow[]>();
  if (error || !data) return { items: [], total: 0, page, pageSize: PAGE_SIZE };

  const nodeIds = [...new Set(data.filter((r) => r.target_node_id).map((r) => r.target_node_id as string))];
  const { data: nodes } = nodeIds.length
    ? await supabase.from("nodes").select("id, title, node_type, slug").in("id", nodeIds).returns<Array<{ id: string; title: string; node_type: string; slug: string }>>()
    : { data: [] as Array<{ id: string; title: string; node_type: string; slug: string }> };
  const nodeById = new Map((nodes ?? []).map((n) => [n.id, n]));

  const items: AdminRedirectItem[] = data.map((r) => {
    const node = r.target_node_id ? nodeById.get(r.target_node_id) : undefined;
    return {
      id: r.id,
      sourcePath: r.source_path,
      targetType: r.target_type,
      targetNodeId: r.target_node_id,
      targetNodeTitle: node ? `${node.title} (${node.node_type})` : null,
      targetPath: r.target_path,
      statusCode: r.status_code,
      isActive: r.is_active,
      notes: r.notes,
      createdAt: r.created_at,
    };
  });

  return { items, total: count ?? items.length, page, pageSize: PAGE_SIZE };
}
