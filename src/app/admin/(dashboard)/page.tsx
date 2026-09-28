import Link from "next/link";

import { getDashboardStats } from "@/lib/admin/dashboard";

const BOOKING_STATUS_LABEL: Record<string, string> = {
  new: "New",
  contacted: "Contacted",
  pending: "Pending",
  confirmed: "Confirmed",
  cancelled: "Cancelled",
  completed: "Completed",
};

function StatTile({ label, value, href }: { label: string; value: number; href?: string }) {
  const content = (
    <>
      <p className="text-2xl font-semibold text-ocean-900">{value.toLocaleString()}</p>
      <p className="mt-1 text-sm text-neutral-600">{label}</p>
    </>
  );
  const className = "rounded-2xl border border-neutral-200 bg-white p-4 transition-colors hover:border-maldives-300";
  return href ? (
    <Link href={href} className={className}>
      {content}
    </Link>
  ) : (
    <div className={className}>{content}</div>
  );
}

export default async function AdminDashboardPage() {
  const stats = await getDashboardStats();

  return (
    <div className="space-y-10">
      <div>
        <h1 className="text-2xl font-semibold text-ocean-900">Dashboard</h1>
        <p className="mt-1 text-sm text-neutral-600">Live counts from the database — nothing here is estimated.</p>
      </div>

      <section>
        <h2 className="text-lg font-semibold text-ocean-900">Bookings ({stats.bookingsTotal})</h2>
        <div className="mt-3 grid grid-cols-2 gap-3 sm:grid-cols-3 lg:grid-cols-6">
          {Object.entries(stats.bookingsByStatus).map(([status, count]) => (
            <StatTile key={status} label={BOOKING_STATUS_LABEL[status] ?? status} value={count} href={`/admin/bookings?status=${status}`} />
          ))}
        </div>
      </section>

      <section>
        <h2 className="text-lg font-semibold text-ocean-900">Content</h2>
        <div className="mt-3 grid grid-cols-2 gap-3 sm:grid-cols-3 lg:grid-cols-4">
          <StatTile label="Accommodations" value={stats.accommodations} />
          <StatTile label="Activities (total)" value={stats.activitiesTotal} />
          <StatTile label="Fishing activities" value={stats.activitiesFishing} />
          <StatTile label="Diving activities" value={stats.activitiesDiving} />
          <StatTile label="Surfing activities" value={stats.activitiesSurfing} />
          <StatTile label="Transfer routes" value={stats.transferRoutes} />
          <StatTile label="Packages" value={stats.packages} />
          <StatTile label="Articles" value={stats.articles} />
          <StatTile label="Providers" value={stats.providers} href="/admin/providers" />
          <StatTile label="Atolls" value={stats.atolls} href="/admin/locations" />
          <StatTile label="Islands" value={stats.islands} href="/admin/locations" />
          <StatTile label="Media assets" value={stats.media} />
        </div>
      </section>

      <section>
        <h2 className="text-lg font-semibold text-ocean-900">Needs attention</h2>
        <div className="mt-3 grid grid-cols-2 gap-3 sm:grid-cols-4">
          <StatTile label="Reviews pending" value={stats.reviewsPending} href="/admin/reviews?status=pending" />
          <StatTile label="Reviews (total)" value={stats.reviewsTotal} href="/admin/reviews" />
          <StatTile label="Comments flagged" value={stats.commentsFlagged} href="/admin/comments?status=flagged" />
          <StatTile label="Comments (total)" value={stats.commentsTotal} href="/admin/comments" />
        </div>
      </section>

      <section>
        <h2 className="text-lg font-semibold text-ocean-900">SEO</h2>
        <div className="mt-3 grid grid-cols-2 gap-3 sm:grid-cols-4">
          <StatTile label="URL redirects" value={stats.redirects} href="/admin/redirects" />
        </div>
      </section>
    </div>
  );
}
