// Domain types for the provider read layer. Hand-written for the same
// reason as src/lib/locations/types.ts: no live Supabase project exists in
// this environment to generate real Database types from yet.

export interface ProviderSummary {
  id: string;
  slug: string;
  title: string;
  summary: string | null;
  isVerified: boolean;
}

export interface ProviderDetail extends ProviderSummary {
  legalName: string | null;
  contactEmail: string | null;
  contactPhone: string | null;
  websiteUrl: string | null;
  licenseNumber: string | null;
  metaTitle: string | null;
  metaDescription: string | null;
}

export interface PaginatedResult<T> {
  items: T[];
  total: number;
  page: number;
  pageSize: number;
}
