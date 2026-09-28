import Link from "next/link";

import { ReviewModerationButtons } from "@/components/admin/review-moderation-buttons";
import { Badge } from "@/components/ui/badge";
import { EmptyState } from "@/components/ui/empty-state";
import { Pagination } from "@/components/ui/pagination";
import { getReviewsAdmin, REVIEW_STATUSES } from "@/lib/admin/reviews-repository";

const STATUS_TONE: Record<string, "neutral" | "maldives" | "aqua" | "outline"> = {
  pending: "outline",
  published: "maldives",
  rejected: "neutral",
};

export default async function AdminReviewsPage({ searchParams }: { searchParams: Promise<{ status?: string; page?: string }> }) {
  const sp = await searchParams;
  const status = sp.status && (REVIEW_STATUSES as readonly string[]).includes(sp.status) ? (sp.status as (typeof REVIEW_STATUSES)[number]) : undefined;
  const page = Math.max(1, Number(sp.page) || 1);

  const results = await getReviewsAdmin({ status, page });
  const totalPages = Math.max(1, Math.ceil(results.total / results.pageSize));

  return (
    <div>
      <h1 className="text-2xl font-semibold text-ocean-900">Reviews ({results.total})</h1>

      <nav className="mt-4 flex gap-2 text-sm">
        <Link href="/admin/reviews" className={`rounded-full px-3.5 py-2 font-medium ${!status ? "bg-lagoon-100 text-ocean-900" : "text-neutral-600 hover:bg-neutral-100"}`}>
          All
        </Link>
        {REVIEW_STATUSES.map((s) => (
          <Link
            key={s}
            href={`/admin/reviews?status=${s}`}
            className={`rounded-full px-3.5 py-2 font-medium capitalize ${status === s ? "bg-lagoon-100 text-ocean-900" : "text-neutral-600 hover:bg-neutral-100"}`}
          >
            {s}
          </Link>
        ))}
      </nav>

      {results.items.length === 0 ? (
        <div className="mt-8">
          <EmptyState title="No reviews match this filter" />
        </div>
      ) : (
        <ul className="mt-6 space-y-3">
          {results.items.map((r) => (
            <li key={r.id} className="rounded-2xl border border-neutral-200 bg-white p-4">
              <div className="flex flex-wrap items-start justify-between gap-3">
                <div>
                  <div className="flex items-center gap-2">
                    <Badge tone={STATUS_TONE[r.status]}>{r.status}</Badge>
                    <span className="text-sm font-semibold text-ocean-900">{"★".repeat(r.rating)}</span>
                  </div>
                  <p className="mt-1 text-sm text-neutral-600">
                    {r.nodeTitle} — {r.reviewerName}
                    {r.reviewerEmail ? ` (${r.reviewerEmail})` : ""} — {new Date(r.createdAt).toLocaleDateString()}
                  </p>
                  {r.title && <p className="mt-2 font-medium text-ocean-900">{r.title}</p>}
                  {r.body && <p className="mt-1 whitespace-pre-wrap text-sm text-neutral-700">{r.body}</p>}
                </div>
                <ReviewModerationButtons reviewId={r.id} status={r.status} />
              </div>
            </li>
          ))}
        </ul>
      )}

      <Pagination page={page} totalPages={totalPages} basePath="/admin/reviews" baseQuery={status ? `status=${status}` : undefined} />
    </div>
  );
}
