/**
 * Pure validation, no "use server"/"server-only" — needs to be callable
 * from both server actions (src/lib/admin/node-actions.ts) and, if a form
 * ever wants live inline feedback, client components. A "use server" file
 * can only export async functions (Next.js requirement for Server Actions
 * modules), which is why this couldn't just live inside node-actions.ts.
 */
const SLUG_PATTERN = /^[a-z0-9]+(?:-[a-z0-9]+)*$/;

export function validateSlug(slug: string): string | null {
  if (!slug) return "Slug is required.";
  if (slug.length > 200) return "Slug is too long.";
  if (!SLUG_PATTERN.test(slug)) return "Slug must be lowercase letters, numbers, and hyphens only (no spaces, no leading/trailing/double hyphens).";
  return null;
}
