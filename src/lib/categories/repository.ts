import "server-only";

import { createClient } from "@/lib/supabase/public";
import type { CategoryGroup, CategorySummary } from "@/lib/categories/types";

/**
 * Server-side category/taxonomy data-access layer (Task 7). Categories
 * share the `nodes` backbone (see src/lib/locations/repository.ts and
 * src/lib/providers/repository.ts for the identical pattern) — this is the
 * first repository to read them, added because the fishing vertical needs
 * to filter activities by fishing-type tag (a node_categories
 * relationship), not by a relational column.
 */

// `categories!categories_id_fkey!inner(...)` — not a plain embed. See the
// identical note in src/lib/locations/repository.ts: without `!inner`,
// filtering on an embedded column doesn't restrict which `nodes` rows come
// back, and the relationship name is required because `nodes` and
// `categories` are connected two ways — the direct `categories.id ->
// nodes.id` FK, and a second, indirect path via the `node_categories`
// junction table — so PostgREST returns PGRST201 ("more than one
// relationship was found") unless the FK is named explicitly. Confirmed
// against a live Supabase project.
const NODE_CATEGORY_SELECT = "id, slug, title, categories!categories_id_fkey!inner(category_group)";

type NodeCategoryRow = {
  id: string;
  slug: string;
  title: string;
  categories: { category_group: CategoryGroup } | { category_group: CategoryGroup }[] | null;
};

function categorySummaryOf(row: NodeCategoryRow): CategorySummary | null {
  const c = Array.isArray(row.categories) ? row.categories[0] : row.categories;
  if (!c) return null;
  return { id: row.id, slug: row.slug, title: row.title, categoryGroup: c.category_group };
}

export async function getCategoriesByGroup(group: CategoryGroup): Promise<CategorySummary[]> {
  const supabase = await createClient();
  const { data, error } = await supabase
    .from("nodes")
    .select(NODE_CATEGORY_SELECT)
    .eq("node_type", "category")
    .eq("status", "published")
    .eq("categories.category_group", group)
    .order("title", { ascending: true })
    .returns<NodeCategoryRow[]>();

  if (error || !data) return [];
  return data.map(categorySummaryOf).filter((c): c is CategorySummary => c !== null);
}

export async function getCategoryBySlug(slug: string, group?: CategoryGroup): Promise<CategorySummary | null> {
  const supabase = await createClient();
  let query = supabase
    .from("nodes")
    .select(NODE_CATEGORY_SELECT)
    .eq("node_type", "category")
    .eq("status", "published")
    .eq("slug", slug);

  if (group) query = query.eq("categories.category_group", group);

  const { data, error } = await query.maybeSingle<NodeCategoryRow>();
  if (error || !data) return null;
  return categorySummaryOf(data);
}

/** node_ids of every node tagged with this category — used to compose a
 * category-tag filter on top of another repository's relational filters
 * (see ActivityFilters.nodeIds). */
export async function getNodeIdsByCategory(categoryId: string): Promise<string[]> {
  const supabase = await createClient();
  const { data, error } = await supabase
    .from("node_categories")
    .select("node_id")
    .eq("category_id", categoryId)
    .returns<Array<{ node_id: string }>>();

  if (error || !data) return [];
  return data.map((row) => row.node_id);
}
