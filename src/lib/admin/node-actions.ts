"use server";

import { requireStaff } from "@/lib/admin/auth";
import { validateSlug } from "@/lib/admin/slug";
import { createClient } from "@/lib/supabase/server";

/**
 * Generic write helper for the fields every node-backed entity shares
 * (title/slug/summary/status/meta_title/meta_description on `nodes`
 * itself) — reused by the providers and locations editors, and meant to
 * be reused again by future accommodation/activity/package/article
 * editors rather than each reimplementing slug validation and node writes.
 * This is the FIRST application code anywhere in the project to write to
 * `nodes` or its 1:1 child tables — confirmed by audit that every content
 * row to date was written by migration SQL, never by app code — so this
 * file is deliberately conservative: validate before writing, surface the
 * database's own constraint violations as friendly errors instead of
 * swallowing or working around them.
 */

export interface AdminActionResult {
  ok: boolean;
  error?: string;
}

export type NodeStatus = "draft" | "published" | "archived";
export const NODE_STATUSES: readonly NodeStatus[] = ["draft", "published", "archived"];

export interface NodeCoreInput {
  title: string;
  slug: string;
  summary: string | null;
  status: NodeStatus;
  metaTitle: string | null;
  metaDescription: string | null;
}

/** Updates the shared `nodes` columns for an existing node. Does not touch
 * any node_type-specific child table — callers combine this with their
 * own entity-specific update in the same server action. */
export async function updateNodeCore(nodeId: string, input: NodeCoreInput): Promise<AdminActionResult> {
  await requireStaff();

  const title = input.title.trim();
  if (!title) return { ok: false, error: "Title is required." };
  const slugError = validateSlug(input.slug);
  if (slugError) return { ok: false, error: slugError };

  const supabase = await createClient();
  const { error } = await supabase
    .from("nodes")
    .update({
      title,
      slug: input.slug,
      summary: input.summary?.trim() || null,
      status: input.status,
      meta_title: input.metaTitle?.trim() || null,
      meta_description: input.metaDescription?.trim() || null,
      published_at: input.status === "published" ? new Date().toISOString() : undefined,
    } as unknown as never)
    .eq("id", nodeId);

  if (error) {
    // `nodes` has `unique(node_type, slug)` — a duplicate slug within the
    // same node_type surfaces as a Postgres unique-violation.
    if (error.code === "23505") return { ok: false, error: "That slug is already used by another entry of the same type." };
    return { ok: false, error: error.message };
  }
  return { ok: true };
}

export interface CreateNodeInput extends NodeCoreInput {
  nodeType: string;
}

export type CreateNodeResult = { ok: true; id: string } | { ok: false; error: string };

/** Creates a new node. The caller is responsible for then inserting the
 * matching 1:1 child-table row (providers/locations/etc. all reference
 * `nodes.id` as their own primary key) and calling deleteOrphanedNode()
 * to roll back if that second insert fails — there's no cross-table
 * transaction available through PostgREST, so this is a deliberate
 * two-step create with explicit cleanup on partial failure. */
export async function createNode(input: CreateNodeInput): Promise<CreateNodeResult> {
  await requireStaff();

  const title = input.title.trim();
  if (!title) return { ok: false, error: "Title is required." };
  const slugError = validateSlug(input.slug);
  if (slugError) return { ok: false, error: slugError };

  const supabase = await createClient();
  const { data, error } = await supabase
    .from("nodes")
    .insert({
      node_type: input.nodeType,
      title,
      slug: input.slug,
      summary: input.summary?.trim() || null,
      status: input.status,
      meta_title: input.metaTitle?.trim() || null,
      meta_description: input.metaDescription?.trim() || null,
      published_at: input.status === "published" ? new Date().toISOString() : null,
    } as unknown as never)
    .select("id")
    .single<{ id: string }>();

  if (error || !data) {
    if (error?.code === "23505") return { ok: false, error: "That slug is already used by another entry of the same type." };
    return { ok: false, error: error?.message ?? "Failed to create." };
  }
  return { ok: true, id: data.id };
}

/** Best-effort rollback for a `createNode()` whose matching child-table
 * insert then failed — leaves nothing behind rather than an orphaned,
 * type-less `nodes` row with no accommodations/providers/etc. row to
 * match it. */
export async function deleteOrphanedNode(nodeId: string): Promise<void> {
  const supabase = await createClient();
  await supabase.from("nodes").delete().eq("id", nodeId);
}
