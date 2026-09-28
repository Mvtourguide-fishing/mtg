import Link from "next/link";

import { Badge } from "@/components/ui/badge";
import { EmptyState } from "@/components/ui/empty-state";
import { Pagination } from "@/components/ui/pagination";
import { getLocationsAdmin } from "@/lib/admin/locations-repository";

const LOCATION_TYPES = ["country", "atoll", "island", "locality", "airport", "seaport", "harbour", "poi", "dive_site", "surf_break", "fishing_spot"];

const STATUS_TONE: Record<string, "neutral" | "maldives" | "aqua" | "outline"> = {
  draft: "outline",
  published: "maldives",
  archived: "neutral",
};

export default async function AdminLocationsPage({ searchParams }: { searchParams: Promise<{ q?: string; type?: string; page?: string }> }) {
  const sp = await searchParams;
  const page = Math.max(1, Number(sp.page) || 1);
  const locationType = sp.type && LOCATION_TYPES.includes(sp.type) ? sp.type : undefined;

  const results = await getLocationsAdmin({ search: sp.q, locationType, page });
  const totalPages = Math.max(1, Math.ceil(results.total / results.pageSize));

  const baseParams = new URLSearchParams();
  if (sp.q) baseParams.set("q", sp.q);
  if (locationType) baseParams.set("type", locationType);
  const baseQuery = baseParams.toString() || undefined;

  return (
    <div>
      <h1 className="text-2xl font-semibold text-ocean-900">Locations ({results.total})</h1>
      <p className="mt-1 text-sm text-neutral-600">
        Editing title, summary, status, geography, and SEO only — location type and parent are structural and not editable here.
      </p>

      <form method="get" className="mt-4 flex flex-wrap items-end gap-3">
        <label className="text-sm">
          <span className="mb-1 block font-medium text-neutral-700">Search</span>
          <input
            name="q"
            defaultValue={sp.q ?? ""}
            className="w-64 rounded-xl border border-neutral-300 px-3 py-2 text-sm focus:border-maldives-500 focus:outline-none focus-visible:ring-2 focus-visible:ring-maldives-500 focus-visible:ring-offset-1"
          />
        </label>
        <label className="text-sm">
          <span className="mb-1 block font-medium text-neutral-700">Type</span>
          <select name="type" defaultValue={locationType ?? ""} className="rounded-xl border border-neutral-300 px-3 py-2 text-sm">
            <option value="">All</option>
            {LOCATION_TYPES.map((t) => (
              <option key={t} value={t}>
                {t.replace(/_/g, " ")}
              </option>
            ))}
          </select>
        </label>
        <button type="submit" className="rounded-full bg-maldives-600 px-4 py-2 text-sm font-medium text-white hover:bg-ocean-800">
          Filter
        </button>
        {(sp.q || locationType) && (
          <Link href="/admin/locations" className="self-center text-sm text-neutral-600 underline">
            Clear
          </Link>
        )}
      </form>

      {results.items.length === 0 ? (
        <div className="mt-8">
          <EmptyState title="No locations match these filters" />
        </div>
      ) : (
        <div className="mt-6 overflow-x-auto rounded-2xl border border-neutral-200 bg-white">
          <table className="w-full min-w-[700px] text-left text-sm">
            <thead className="border-b border-neutral-200 bg-neutral-50 text-xs font-semibold uppercase tracking-wide text-neutral-500">
              <tr>
                <th className="px-4 py-3">Title</th>
                <th className="px-4 py-3">Type</th>
                <th className="px-4 py-3">Parent</th>
                <th className="px-4 py-3">Status</th>
              </tr>
            </thead>
            <tbody className="divide-y divide-neutral-100">
              {results.items.map((l) => (
                <tr key={l.id} className="hover:bg-neutral-50">
                  <td className="px-4 py-3">
                    <Link href={`/admin/locations/${l.id}`} className="font-medium text-maldives-600 hover:underline">
                      {l.title}
                    </Link>
                  </td>
                  <td className="px-4 py-3 capitalize text-neutral-600">{l.locationType.replace(/_/g, " ")}</td>
                  <td className="px-4 py-3 text-neutral-600">{l.parentTitle ?? "—"}</td>
                  <td className="px-4 py-3">
                    <Badge tone={STATUS_TONE[l.status]}>{l.status}</Badge>
                  </td>
                </tr>
              ))}
            </tbody>
          </table>
        </div>
      )}

      <Pagination page={page} totalPages={totalPages} basePath="/admin/locations" baseQuery={baseQuery} />
    </div>
  );
}
