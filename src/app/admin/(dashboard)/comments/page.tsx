import Link from "next/link";

import { CommentModerationButtons } from "@/components/admin/comment-moderation-buttons";
import { Badge } from "@/components/ui/badge";
import { EmptyState } from "@/components/ui/empty-state";
import { Pagination } from "@/components/ui/pagination";
import { COMMENT_STATUSES, getCommentsAdmin } from "@/lib/admin/comments-repository";

const STATUS_TONE: Record<string, "neutral" | "maldives" | "aqua" | "outline"> = {
  visible: "maldives",
  flagged: "outline",
  removed: "neutral",
};

export default async function AdminCommentsPage({ searchParams }: { searchParams: Promise<{ status?: string; page?: string }> }) {
  const sp = await searchParams;
  const status =
    sp.status && (COMMENT_STATUSES as readonly string[]).includes(sp.status) ? (sp.status as (typeof COMMENT_STATUSES)[number]) : undefined;
  const page = Math.max(1, Number(sp.page) || 1);

  const results = await getCommentsAdmin({ status, page });
  const totalPages = Math.max(1, Math.ceil(results.total / results.pageSize));

  return (
    <div>
      <h1 className="text-2xl font-semibold text-ocean-900">Article comments ({results.total})</h1>
      <p className="mt-1 text-sm text-neutral-600">
        No customer-facing comment form exists on the site yet, so this list is expected to be empty until one is built — the table and
        moderation tools are ready for when it is.
      </p>

      <nav className="mt-4 flex gap-2 text-sm">
        <Link href="/admin/comments" className={`rounded-full px-3.5 py-2 font-medium ${!status ? "bg-lagoon-100 text-ocean-900" : "text-neutral-600 hover:bg-neutral-100"}`}>
          All
        </Link>
        {COMMENT_STATUSES.map((s) => (
          <Link
            key={s}
            href={`/admin/comments?status=${s}`}
            className={`rounded-full px-3.5 py-2 font-medium capitalize ${status === s ? "bg-lagoon-100 text-ocean-900" : "text-neutral-600 hover:bg-neutral-100"}`}
          >
            {s}
          </Link>
        ))}
      </nav>

      {results.items.length === 0 ? (
        <div className="mt-8">
          <EmptyState title="No comments yet" />
        </div>
      ) : (
        <ul className="mt-6 space-y-3">
          {results.items.map((c) => (
            <li key={c.id} className="rounded-2xl border border-neutral-200 bg-white p-4">
              <div className="flex flex-wrap items-start justify-between gap-3">
                <div>
                  <div className="flex items-center gap-2">
                    <Badge tone={STATUS_TONE[c.status]}>{c.status}</Badge>
                    <span className="text-sm text-neutral-600">
                      on {c.articleTitle} — {new Date(c.createdAt).toLocaleDateString()}
                    </span>
                  </div>
                  <p className="mt-2 whitespace-pre-wrap text-sm text-neutral-700">{c.body}</p>
                </div>
                <CommentModerationButtons commentId={c.id} status={c.status} />
              </div>
            </li>
          ))}
        </ul>
      )}

      <Pagination page={page} totalPages={totalPages} basePath="/admin/comments" baseQuery={status ? `status=${status}` : undefined} />
    </div>
  );
}
