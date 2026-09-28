// Domain types for the category/taxonomy read layer (Task 7). Categories
// share the `nodes` backbone exactly like locations/providers/accommodations
// — see docs/SYSTEM_ARCHITECTURE_AND_DATABASE_DESIGN.md §9/§13.

export type CategoryGroup =
  | "accommodation-type"
  | "activity-type"
  | "amenity"
  | "traveler-type"
  | "package-style"
  | "duration-band"
  | "inclusion"
  | "theme"
  | "article-category"
  | "transfer-category";

export interface CategorySummary {
  id: string;
  slug: string;
  title: string;
  categoryGroup: CategoryGroup;
}
