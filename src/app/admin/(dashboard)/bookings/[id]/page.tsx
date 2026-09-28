import Link from "next/link";
import { notFound } from "next/navigation";

import { BookingStatusForm } from "@/components/admin/booking-status-form";
import { requireStaff } from "@/lib/admin/auth";
import { getBookingByIdAdmin } from "@/lib/admin/bookings-repository";

function Field({ label, value }: { label: string; value: string | number | null | undefined }) {
  if (value === null || value === undefined || value === "") return null;
  return (
    <div>
      <dt className="text-xs font-semibold uppercase tracking-wide text-neutral-500">{label}</dt>
      <dd className="mt-0.5 text-sm text-neutral-900">{value}</dd>
    </div>
  );
}

export default async function AdminBookingDetailPage({ params }: { params: Promise<{ id: string }> }) {
  // Defense in depth on top of the parent layout's requireStaff() — same
  // pattern as /admin/users, since a page and its layout can in principle
  // fetch in parallel. Not currently exploitable (getBookingByIdAdmin goes
  // through RLS-respecting createClient(), so bookings_staff_read still
  // blocks a non-staff read either way), but cheap to make explicit.
  await requireStaff();
  const { id } = await params;
  const booking = await getBookingByIdAdmin(id);
  if (!booking) notFound();

  return (
    <div className="max-w-4xl">
      <Link href="/admin/bookings" className="text-sm text-maldives-600 hover:underline">
        ← All bookings
      </Link>

      <h1 className="mt-2 font-mono text-2xl font-semibold text-ocean-900">{booking.bookingReference}</h1>
      <p className="mt-1 text-neutral-700">{booking.productTitle}</p>

      <div className="mt-6 grid grid-cols-1 gap-6 lg:grid-cols-3">
        <div className="space-y-6 lg:col-span-2">
          <section className="rounded-2xl border border-neutral-200 bg-white p-4">
            <h2 className="text-sm font-semibold uppercase tracking-wide text-neutral-500">Customer</h2>
            <dl className="mt-3 grid grid-cols-2 gap-4">
              <Field label="Name" value={booking.customerName} />
              <Field label="Email" value={booking.customerEmail} />
              <Field label="Phone" value={booking.customerPhone} />
              <Field label="WhatsApp" value={booking.customerWhatsapp} />
            </dl>
          </section>

          <section className="rounded-2xl border border-neutral-200 bg-white p-4">
            <h2 className="text-sm font-semibold uppercase tracking-wide text-neutral-500">Request details</h2>
            <dl className="mt-3 grid grid-cols-2 gap-4">
              <Field label="Source" value={booking.source} />
              <Field label="Product type" value={booking.productType} />
              <Field label="Origin" value={booking.originTitle} />
              <Field label="Destination" value={booking.destinationTitle} />
              <Field label="Travel date" value={booking.travelDate} />
              <Field label="Travel time" value={booking.travelTime} />
              <Field label="Return date" value={booking.returnDate} />
              <Field label="Return time" value={booking.returnTime} />
              <Field label="Trip type" value={booking.tripType} />
              <Field label="Adults" value={booking.adults} />
              <Field label="Children" value={booking.children} />
              <Field label="Infants" value={booking.infants} />
              <Field label="Flight number" value={booking.flightNumber} />
            </dl>
            {booking.specialRequests && (
              <div className="mt-4">
                <dt className="text-xs font-semibold uppercase tracking-wide text-neutral-500">Special requests</dt>
                <dd className="mt-0.5 whitespace-pre-wrap text-sm text-neutral-900">{booking.specialRequests}</dd>
              </div>
            )}
          </section>

          <section className="rounded-2xl border border-neutral-200 bg-white p-4">
            <h2 className="text-sm font-semibold uppercase tracking-wide text-neutral-500">Pricing &amp; notifications</h2>
            <dl className="mt-3 grid grid-cols-2 gap-4">
              <Field label="Estimated price" value={booking.estimatedPrice != null ? `${booking.currency} ${booking.estimatedPrice}` : null} />
              <Field label="Quoted price" value={booking.quotedPrice != null ? `${booking.currency} ${booking.quotedPrice}` : null} />
              <Field label="Notification status" value={booking.notificationStatus} />
              <Field label="Submitted" value={new Date(booking.createdAt).toLocaleString()} />
              <Field label="Last updated" value={new Date(booking.updatedAt).toLocaleString()} />
            </dl>
          </section>
        </div>

        <div>
          <BookingStatusForm bookingId={booking.id} currentStatus={booking.status} currentNotes={booking.internalNotes ?? ""} />
        </div>
      </div>
    </div>
  );
}
