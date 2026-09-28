import "server-only";

import { getAccommodationSummariesByIds } from "@/lib/accommodations/repository";
import { ACCOMMODATION_TYPE_SEGMENT } from "@/lib/accommodations/types";
import { getActivitySummariesByIds } from "@/lib/activities/repository";
import { activityHref } from "@/lib/activities/types";
import { getCategoriesByGroup } from "@/lib/categories/repository";
import type { CategorySummary } from "@/lib/categories/types";
import { getLocationSummariesByIds } from "@/lib/locations/repository";
import type { LocationSummary } from "@/lib/locations/types";
import { getHeroMediaByNodeIds, resolveStorageImageSrcs } from "@/lib/media/repository";
import type { MediaAsset } from "@/lib/media/types";
import { getPackageSummariesByIds } from "@/lib/packages/repository";
import { createClient } from "@/lib/supabase/public";
import { getTransferRoutesByIds } from "@/lib/transfers/repository";
import type { ArticleDetail, ArticleSummary, GetArticlesOptions, PaginatedResult, RelatedEntityLink } from "@/lib/articles/types";

/**
 * Server-side article data-access layer (Task 14), following the same
 * pattern as every other vertical repository in this codebase (see
 * src/lib/packages/repository.ts's header comment for the fuller
 * rationale): pages call these functions, never Supabase directly, and
 * every function only returns published articles.
 *
 * `articles!inner(...)` is a plain embed with no FK name required —
 * `articles.id` has exactly one relationship to `nodes` (its primary key
 * IS the nodes.id FK), and unlike `categories`/`locations` nothing else
 * references `articles` as a junction table, so there is no second path
 * for PostgREST to be ambiguous about. Confirmed against
 * supabase/migrations/20250101000700_packages.sql (where the `articles`
 * table was created) before writing this file.
 */

const NODE_ARTICLE_SELECT =
  "id, slug, title, summary, meta_title, meta_description, published_at, articles!inner(body, reading_time_minutes)";

type ArticleFields = { body: string; reading_time_minutes: number | null };

type NodeArticleRow = {
  id: string;
  slug: string;
  title: string;
  summary: string | null;
  meta_title: string | null;
  meta_description: string | null;
  published_at: string | null;
  // Defensive-coded as possibly-an-array — see the identical note in
  // src/lib/locations/repository.ts and src/lib/packages/repository.ts.
  articles: ArticleFields | ArticleFields[] | null;
};

interface BareArticle {
  id: string;
  slug: string;
  title: string;
  summary: string | null;
  metaTitle: string | null;
  metaDescription: string | null;
  publishedAt: string | null;
  body: string;
  readingTimeMinutes: number | null;
}

function bareArticleOf(row: NodeArticleRow): BareArticle | null {
  const a = Array.isArray(row.articles) ? row.articles[0] : row.articles;
  if (!a) return null;

  return {
    id: row.id,
    slug: row.slug,
    title: row.title,
    summary: row.summary,
    metaTitle: row.meta_title,
    metaDescription: row.meta_description,
    publishedAt: row.published_at,
    body: a.body,
    readingTimeMinutes: a.reading_time_minutes,
  };
}

function toSummary(bare: BareArticle, category: CategorySummary | null, heroImage: MediaAsset | null): ArticleSummary {
  return {
    id: bare.id,
    slug: bare.slug,
    title: bare.title,
    summary: bare.summary,
    category,
    heroImage,
    readingTimeMinutes: bare.readingTimeMinutes,
    publishedAt: bare.publishedAt,
  };
}

/** Batch-resolve each article's single "article-category" tag. Fetches the
 * whole (small, ~13-category) article-category group once and matches it
 * against node_categories rows in application code — deliberately avoids
 * embedding through node_categories, same reasoning as
 * getCategoriesForPackage in src/lib/packages/repository.ts: category_id
 * references categories directly, and categories.id is itself a nodes.id
 * FK, so an embed here would hit the identical two-path ambiguity already
 * fixed elsewhere via a named relationship (commit 06a9254). */
async function attachCategories(articleIds: string[]): Promise<Map<string, CategorySummary>> {
  const result = new Map<string, CategorySummary>();
  if (articleIds.length === 0) return result;

  const supabase = await createClient();
  const { data, error } = await supabase
    .from("node_categories")
    .select("node_id, category_id")
    .in("node_id", articleIds)
    .returns<Array<{ node_id: string; category_id: string }>>();

  if (error || !data || data.length === 0) return result;

  const categories = await getCategoriesByGroup("article-category");
  const categoriesById = new Map(categories.map((c) => [c.id, c]));

  for (const row of data) {
    if (result.has(row.node_id)) continue; // one category per article by migration design
    const category = categoriesById.get(row.category_id);
    if (category) result.set(row.node_id, category);
  }
  return result;
}

async function toSummaries(bares: BareArticle[]): Promise<ArticleSummary[]> {
  const ids = bares.map((b) => b.id);
  const [categoriesById, heroById] = await Promise.all([attachCategories(ids), getHeroMediaByNodeIds(ids)]);
  return bares.map((b) => toSummary(b, categoriesById.get(b.id) ?? null, heroById.get(b.id) ?? null));
}

export async function getArticles(options: GetArticlesOptions = {}): Promise<PaginatedResult<ArticleSummary>> {
  const page = Math.max(1, options.page ?? 1);
  const pageSize = Math.min(100, Math.max(1, options.pageSize ?? 24));
  const from = (page - 1) * pageSize;
  const to = from + pageSize - 1;

  const supabase = await createClient();

  let nodeIdFilter: string[] | null = null;
  if (options.category) {
    const categories = await getCategoriesByGroup("article-category");
    const category = categories.find((c) => c.slug === options.category);
    if (!category) return { items: [], total: 0, page, pageSize };

    const { data: tagRows } = await supabase
      .from("node_categories")
      .select("node_id")
      .eq("category_id", category.id)
      .returns<Array<{ node_id: string }>>();
    nodeIdFilter = Array.from(new Set((tagRows ?? []).map((row) => row.node_id)));
    if (nodeIdFilter.length === 0) return { items: [], total: 0, page, pageSize };
  }

  let query = supabase
    .from("nodes")
    .select(NODE_ARTICLE_SELECT, { count: "exact" })
    .eq("node_type", "article")
    .eq("status", "published");

  if (nodeIdFilter) query = query.in("id", nodeIdFilter);

  const { data, error, count } = await query
    .order("published_at", { ascending: false })
    .range(from, to)
    .returns<NodeArticleRow[]>();

  if (error || !data) return { items: [], total: 0, page, pageSize };

  const bares = data.map(bareArticleOf).filter((b): b is BareArticle => b !== null);
  const items = await toSummaries(bares);
  return { items, total: count ?? items.length, page, pageSize };
}

/** Most recently published articles, for the homepage Travel Guide section
 * (Task 14 §29/30). */
export async function getRecentArticles(limit = 3): Promise<ArticleSummary[]> {
  const result = await getArticles({ page: 1, pageSize: limit });
  return result.items;
}

export async function getArticleBySlug(slug: string): Promise<ArticleDetail | null> {
  const supabase = await createClient();
  const { data, error } = await supabase
    .from("nodes")
    .select(NODE_ARTICLE_SELECT)
    .eq("node_type", "article")
    .eq("status", "published")
    .eq("slug", slug)
    .maybeSingle<NodeArticleRow>();

  if (error || !data) return null;
  const bare = bareArticleOf(data);
  if (!bare) return null;

  const [[summary], relatedLocations, relatedContent] = await Promise.all([
    toSummaries([bare]),
    getRelatedLocationsForArticle(bare.id),
    getRelatedContentForArticle(bare.id),
  ]);

  return {
    ...summary,
    metaTitle: bare.metaTitle,
    metaDescription: bare.metaDescription,
    bodyHtml: resolveStorageImageSrcs(bare.body),
    relatedLocations,
    relatedEntities: relatedContent.relatedEntities,
    relatedArticles: relatedContent.relatedArticles,
  };
}

async function getRelatedLocationsForArticle(articleId: string): Promise<LocationSummary[]> {
  const supabase = await createClient();
  const { data, error } = await supabase
    .from("node_locations")
    .select("location_id")
    .eq("node_id", articleId)
    .returns<Array<{ location_id: string }>>();

  if (error || !data || data.length === 0) return [];

  const locationsById = await getLocationSummariesByIds(data.map((row) => row.location_id));
  return data.map((row) => locationsById.get(row.location_id)).filter((l): l is LocationSummary => Boolean(l));
}

/** Every `node_relationships` target for this article, grouped by the
 * related node's actual `node_type` (island/atoll/dive_site/surf_break are
 * excluded — those go through node_locations/getRelatedLocationsForArticle
 * instead, see scripts/import-legacy-articles.mjs's writeCommitMigration).
 * Filters to published targets only, same as every other repository in
 * this codebase (Task 15 §5-11). */
async function getRelatedNodeIdsByType(articleId: string): Promise<Map<string, string[]>> {
  const supabase = await createClient();
  const { data, error } = await supabase
    .from("node_relationships")
    .select("related_node_id")
    .eq("node_id", articleId)
    .eq("relation_type", "related")
    .returns<Array<{ related_node_id: string }>>();

  if (error || !data || data.length === 0) return new Map();

  const relatedIds = Array.from(new Set(data.map((row) => row.related_node_id)));
  const { data: nodeRows, error: nodeError } = await supabase
    .from("nodes")
    .select("id, node_type")
    .eq("status", "published")
    .in("id", relatedIds)
    .returns<Array<{ id: string; node_type: string }>>();

  if (nodeError || !nodeRows) return new Map();

  const byType = new Map<string, string[]>();
  for (const row of nodeRows) {
    const list = byType.get(row.node_type) ?? [];
    list.push(row.id);
    byType.set(row.node_type, list);
  }
  return byType;
}

/** Resolves an article's node_relationships into real, typed, already-
 * published entity links (accommodation/activity/package/transfer_route)
 * plus other related articles — every href/title/image comes straight from
 * each vertical's own repository, so this can never render a dead link or
 * fabricated content (Task 15 §5-11/§43). */
async function getRelatedContentForArticle(
  articleId: string,
): Promise<{ relatedEntities: RelatedEntityLink[]; relatedArticles: ArticleSummary[] }> {
  const byType = await getRelatedNodeIdsByType(articleId);
  if (byType.size === 0) return { relatedEntities: [], relatedArticles: [] };

  const [accommodations, activities, packages, transferRoutes] = await Promise.all([
    getAccommodationSummariesByIds(byType.get("accommodation") ?? []),
    getActivitySummariesByIds(byType.get("activity") ?? []),
    getPackageSummariesByIds(byType.get("package") ?? []),
    getTransferRoutesByIds(byType.get("transfer_route") ?? []),
  ]);

  const relatedEntities: RelatedEntityLink[] = [
    ...Array.from(accommodations.values()).map((a) => ({
      id: a.id,
      type: "accommodation" as const,
      title: a.title,
      href: `/maldives/${ACCOMMODATION_TYPE_SEGMENT[a.accommodationType]}/${a.slug}/`,
      image: a.heroImage,
    })),
    ...Array.from(activities.values()).map((a) => ({
      id: a.id,
      type: "activity" as const,
      title: a.title,
      href: activityHref(a),
      image: a.heroImage,
    })),
    ...Array.from(packages.values()).map((p) => ({
      id: p.id,
      type: "package" as const,
      title: p.title,
      href: `/maldives/packages/${p.slug}/`,
      image: null,
    })),
    ...Array.from(transferRoutes.values()).map((r) => ({
      id: r.id,
      type: "transfer_route" as const,
      title: r.title,
      href: `/maldives/transfers/${r.slug}/`,
      image: null,
    })),
  ];

  let relatedArticles: ArticleSummary[] = [];
  const articleNodeIds = byType.get("article") ?? [];
  if (articleNodeIds.length > 0) {
    const supabase = await createClient();
    const { data, error } = await supabase
      .from("nodes")
      .select(NODE_ARTICLE_SELECT)
      .eq("node_type", "article")
      .eq("status", "published")
      .in("id", articleNodeIds)
      .returns<NodeArticleRow[]>();

    if (!error && data) {
      const bares = data.map(bareArticleOf).filter((b): b is BareArticle => b !== null);
      relatedArticles = await toSummaries(bares);
    }
  }

  return { relatedEntities, relatedArticles };
}

/** Reverse lookup: real, published articles related to any of the given
 * (already query-matched) node ids — via the same node_relationships and
 * node_locations rows the migration persists from the article's own side
 * (see getRelatedContentForArticle/getRelatedLocationsForArticle above).
 * Used by the search layer (Task 15 §44) so a query matching e.g. "Baros
 * Maldives" can also surface an article that discusses Baros, without the
 * query needing to literally appear in that article's own title — reusing
 * the same relationship data, never a second search index. */
export async function getArticlesRelatedToNodes(nodeIds: string[]): Promise<ArticleSummary[]> {
  if (nodeIds.length === 0) return [];
  const supabase = await createClient();

  const [relResult, locResult] = await Promise.all([
    supabase
      .from("node_relationships")
      .select("node_id")
      .in("related_node_id", nodeIds)
      .eq("relation_type", "related")
      .returns<Array<{ node_id: string }>>(),
    supabase.from("node_locations").select("node_id").in("location_id", nodeIds).returns<Array<{ node_id: string }>>(),
  ]);

  const articleIds = new Set<string>();
  for (const row of relResult.data ?? []) articleIds.add(row.node_id);
  for (const row of locResult.data ?? []) articleIds.add(row.node_id);
  if (articleIds.size === 0) return [];

  const { data, error } = await supabase
    .from("nodes")
    .select(NODE_ARTICLE_SELECT)
    .eq("node_type", "article")
    .eq("status", "published")
    .in("id", Array.from(articleIds))
    .returns<NodeArticleRow[]>();

  if (error || !data) return [];
  const bares = data.map(bareArticleOf).filter((b): b is BareArticle => b !== null);
  return toSummaries(bares);
}

/** Every article-category actually tagged on at least one published
 * article — the same "only show a filter that can return something" rule
 * used for diving/fishing/surfing types (Tasks 7-9) and packages
 * (Task 11). */
export async function getArticleCategoriesInUse(): Promise<CategorySummary[]> {
  const all = await getCategoriesByGroup("article-category");
  if (all.length === 0) return [];

  const supabase = await createClient();
  const { data: articleRows, error: articleError } = await supabase
    .from("nodes")
    .select("id")
    .eq("node_type", "article")
    .eq("status", "published")
    .returns<Array<{ id: string }>>();

  if (articleError || !articleRows || articleRows.length === 0) return [];
  const articleIds = new Set(articleRows.map((row) => row.id));

  const { data: tagRows, error: tagError } = await supabase
    .from("node_categories")
    .select("node_id, category_id")
    .in(
      "category_id",
      all.map((c) => c.id),
    )
    .returns<Array<{ node_id: string; category_id: string }>>();

  if (tagError || !tagRows) return [];
  const inUseCategoryIds = new Set(tagRows.filter((row) => articleIds.has(row.node_id)).map((row) => row.category_id));
  return all.filter((c) => inUseCategoryIds.has(c.id));
}

export interface SearchArticlesOptions {
  limit?: number;
}

/** Title search for the site-wide search layer (Task 13/14) — same
 * ilike-title pattern as searchAccommodations/searchPackages/etc. */
export async function searchArticles(query: string, options: SearchArticlesOptions = {}): Promise<ArticleSummary[]> {
  const trimmed = query.trim();
  if (trimmed.length === 0) return [];

  const supabase = await createClient();
  const { data, error } = await supabase
    .from("nodes")
    .select(NODE_ARTICLE_SELECT)
    .eq("node_type", "article")
    .eq("status", "published")
    .ilike("title", `%${trimmed}%`)
    .order("title", { ascending: true })
    .limit(options.limit ?? 20)
    .returns<NodeArticleRow[]>();

  if (error || !data) return [];

  const bares = data.map(bareArticleOf).filter((b): b is BareArticle => b !== null);
  return toSummaries(bares);
}
