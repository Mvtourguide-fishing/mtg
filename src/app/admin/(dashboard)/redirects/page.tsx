import Link from "next/link";

import { RedirectToggleButton } from "@/components/admin/redirect-toggle-button";
import { Badge } from "@/components/ui/badge";
import { EmptyState } from "@/components/ui/empty-state";
import { Pagination } from "@/components/ui/pagination";
import { getRedirectsAdmin } from "@/lib/admin/redirects-repository";

export default async function AdminRedirectsPage({ searchParams }: { searchParams: Promise<{ q?: string; page?: string }> }) {
  const sp = await searchParams;
  const page = Math.max(1, Number(sp.page) || 1);

  const results = await getRedirectsAdmin({ search: sp.q, page });
  const totalPages = Math.max(1, Math.ceil(results.total / results.pageSize));

  return (
    <div>
      <h1 className="text-2xl font-semibold text-ocean-900">Redirects ({results.total})</h1>
      <p className="mt-1 text-sm text-neutral-600">View, search, and enable/disable. Creating new redirects isn&rsquo;t built yet — see the final report.</p>

      <form method="get" className="mt-4 flex gap-3">
        <input
          name="q"
          defaultValue={sp.q ?? ""}
          placeholder="Source or target path"
          className="w-72 rounded-xl border border-neutral-300 px-3 py-2 text-sm focus:border-maldives-500 focus:outline-none focus-visible:ring-2 focus-visible:ring-maldives-500 focus-visible:ring-offset-1"
        />
        <button type="submit" className="rounded-full bg-maldives-600 px-4 py-2 text-sm font-medium text-white hover:bg-ocean-800">
          Search
        </button>
        {sp.q && (
          <Link href="/admin/redirects" className="self-center text-sm text-neutral-600 underline">
            Clear
          </Link>
        )}
      </form>

      {results.items.length === 0 ? (
        <div className="mt-8">
          <EmptyState title="No redirects match this search" />
        </div>
      ) : (
        <div className="mt-6 overflow-x-auto rounded-2xl border border-neutral-200 bg-white">
          <table className="w-full min-w-[800px] text-left text-sm">
            <thead className="border-b border-neutral-200 bg-neutral-50 text-xs font-semibold uppercase tracking-wide text-neutral-500">
              <tr>
                <th className="px-4 py-3">Source</th>
                <th className="px-4 py-3">Target</th>
                <th className="px-4 py-3">Code</th>
                <th className="px-4 py-3">Status</th>
                <th className="px-4 py-3" />
              </tr>
            </thead>
            <tbody className="divide-y divide-neutral-100">
              {results.items.map((r) => (
                <tr key={r.id} className="hover:bg-neutral-50">
                  <td className="px-4 py-3 font-mono text-xs">{r.sourcePath}</td>
                  <td className="px-4 py-3 font-mono text-xs">
                    {r.targetType === "node" ? r.targetNodeTitle : r.targetPath}
                    <span className="ml-2 text-neutral-400">({r.targetType})</span>
                  </td>
                  <td className="px-4 py-3">{r.statusCode}</td>
                  <td className="px-4 py-3">
                    <Badge tone={r.isActive ? "maldives" : "neutral"}>{r.isActive ? "Active" : "Disabled"}</Badge>
                  </td>
                  <td className="px-4 py-3">
                    <RedirectToggleButton redirectId={r.id} isActive={r.isActive} />
                  </td>
                </tr>
              ))}
            </tbody>
          </table>
        </div>
      )}

      <Pagination page={page} totalPages={totalPages} basePath="/admin/redirects" baseQuery={sp.q ? `q=${encodeURIComponent(sp.q)}` : undefined} />
    </div>
  );
}
