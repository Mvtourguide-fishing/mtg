import Link from "next/link";

import { Badge } from "@/components/ui/badge";
import { EmptyState } from "@/components/ui/empty-state";
import { Pagination } from "@/components/ui/pagination";
import { BOOKING_STATUSES } from "@/lib/admin/booking-status";
import { getBookingsAdmin } from "@/lib/admin/bookings-repository";

const STATUS_TONE: Record<string, "neutral" | "maldives" | "aqua" | "outline"> = {
  new: "aqua",
  contacted: "outline",
  pending: "outline",
  confirmed: "maldives",
  cancelled: "neutral",
  completed: "maldives",
};

interface SearchParams {
  q?: string;
  status?: string;
  productType?: string;
  dateFrom?: string;
  dateTo?: string;
  page?: string;
}

export default async function AdminBookingsPage({ searchParams }: { searchParams: Promise<SearchParams> }) {
  const sp = await searchParams;
  const status = sp.status && (BOOKING_STATUSES as readonly string[]).includes(sp.status) ? sp.status : undefined;
  const productType = sp.productType === "node" || sp.productType === "transfer_service" ? sp.productType : undefined;
  const page = Math.max(1, Number(sp.page) || 1);

  const results = await getBookingsAdmin({
    search: sp.q,
    status: status as (typeof BOOKING_STATUSES)[number] | undefined,
    productType,
    dateFrom: sp.dateFrom,
    dateTo: sp.dateTo,
    page,
  });
  const totalPages = Math.max(1, Math.ceil(results.total / results.pageSize));

  const baseParams = new URLSearchParams();
  if (sp.q) baseParams.set("q", sp.q);
  if (status) baseParams.set("status", status);
  if (productType) baseParams.set("productType", productType);
  if (sp.dateFrom) baseParams.set("dateFrom", sp.dateFrom);
  if (sp.dateTo) baseParams.set("dateTo", sp.dateTo);
  const baseQuery = baseParams.toString() || undefined;

  return (
    <div>
      <h1 className="text-2xl font-semibold text-ocean-900">Bookings ({results.total})</h1>

      <form method="get" className="mt-4 flex flex-wrap items-end gap-3">
        <label className="text-sm">
          <span className="mb-1 block font-medium text-neutral-700">Search</span>
          <input
            name="q"
            defaultValue={sp.q ?? ""}
            placeholder="Reference, name, or email"
            className="w-64 rounded-xl border border-neutral-300 px-3 py-2 text-sm focus:border-maldives-500 focus:outline-none focus-visible:ring-2 focus-visible:ring-maldives-500 focus-visible:ring-offset-1"
          />
        </label>
        <label className="text-sm">
          <span className="mb-1 block font-medium text-neutral-700">Status</span>
          <select name="status" defaultValue={status ?? ""} className="rounded-xl border border-neutral-300 px-3 py-2 text-sm">
            <option value="">All</option>
            {BOOKING_STATUSES.map((s) => (
              <option key={s} value={s}>
                {s}
              </option>
            ))}
          </select>
        </label>
        <label className="text-sm">
          <span className="mb-1 block font-medium text-neutral-700">Product type</span>
          <select name="productType" defaultValue={productType ?? ""} className="rounded-xl border border-neutral-300 px-3 py-2 text-sm">
            <option value="">All</option>
            <option value="node">Node (accommodation/activity/package/…)</option>
            <option value="transfer_service">Transfer service</option>
          </select>
        </label>
        <label className="text-sm">
          <span className="mb-1 block font-medium text-neutral-700">Travel date from</span>
          <input type="date" name="dateFrom" defaultValue={sp.dateFrom ?? ""} className="rounded-xl border border-neutral-300 px-3 py-2 text-sm" />
        </label>
        <label className="text-sm">
          <span className="mb-1 block font-medium text-neutral-700">to</span>
          <input type="date" name="dateTo" defaultValue={sp.dateTo ?? ""} className="rounded-xl border border-neutral-300 px-3 py-2 text-sm" />
        </label>
        <button type="submit" className="rounded-full bg-maldives-600 px-4 py-2 text-sm font-medium text-white hover:bg-ocean-800">
          Filter
        </button>
        {(sp.q || status || productType || sp.dateFrom || sp.dateTo) && (
          <Link href="/admin/bookings" className="text-sm text-neutral-600 underline">
            Clear
          </Link>
        )}
      </form>

      {results.items.length === 0 ? (
        <div className="mt-8">
          <EmptyState title="No bookings match these filters" />
        </div>
      ) : (
        <div className="mt-6 overflow-x-auto rounded-2xl border border-neutral-200 bg-white">
          <table className="w-full min-w-[900px] text-left text-sm">
            <thead className="border-b border-neutral-200 bg-neutral-50 text-xs font-semibold uppercase tracking-wide text-neutral-500">
              <tr>
                <th className="px-4 py-3">Reference</th>
                <th className="px-4 py-3">Product</th>
                <th className="px-4 py-3">Customer</th>
                <th className="px-4 py-3">Travel date</th>
                <th className="px-4 py-3">Guests</th>
                <th className="px-4 py-3">Status</th>
                <th className="px-4 py-3">Submitted</th>
              </tr>
            </thead>
            <tbody className="divide-y divide-neutral-100">
              {results.items.map((b) => (
                <tr key={b.id} className="hover:bg-neutral-50">
                  <td className="px-4 py-3">
                    <Link href={`/admin/bookings/${b.id}`} className="font-mono font-medium text-maldives-600 hover:underline">
                      {b.bookingReference}
                    </Link>
                  </td>
                  <td className="px-4 py-3">{b.productTitle}</td>
                  <td className="px-4 py-3">
                    <div>{b.customerName}</div>
                    <div className="text-xs text-neutral-500">{b.customerEmail}</div>
                  </td>
                  <td className="px-4 py-3">{b.travelDate ?? "—"}</td>
                  <td className="px-4 py-3">
                    {b.adults}A{b.children ? ` ${b.children}C` : ""}
                  </td>
                  <td className="px-4 py-3">
                    <Badge tone={STATUS_TONE[b.status] ?? "neutral"}>{b.status}</Badge>
                  </td>
                  <td className="px-4 py-3 text-neutral-500">{new Date(b.createdAt).toLocaleDateString()}</td>
                </tr>
              ))}
            </tbody>
          </table>
        </div>
      )}

      <Pagination page={page} totalPages={totalPages} basePath="/admin/bookings" baseQuery={baseQuery} />
    </div>
  );
}
