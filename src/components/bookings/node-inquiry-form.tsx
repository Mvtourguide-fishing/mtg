"use client";

import { useState, useTransition } from "react";

import { Button } from "@/components/ui/button";
import { createNodeInquiry } from "@/lib/bookings/actions";
import type { BookingSource } from "@/lib/bookings/copy";

const WHATSAPP_NUMBER = "9607794332";

export interface NodeInquiryFormProps {
  productNodeId: string;
  productTitle: string;
  /** Structured booking source (Task 13 §18) — which vertical this
   * inquiry came from, for later admin reporting. */
  source: BookingSource;
  /** Shown above the submit button — e.g. "Request Private Charter",
   * "Enquire About This Vehicle". */
  submitLabel: string;
  /** Adds a "Number of days" field — for products priced per day (fishing
   * charters) where a guest may want more than one day, unlike a fixed
   * single-slot activity. Off by default so every other vertical's form
   * is unchanged. */
  showNumberOfDays?: boolean;
}

/**
 * Generic inquiry form for a bookable node with no fixed price/route —
 * private speedboat charters and car transfers (Task 20 §14/§17). Same
 * guest-safe RPC and WhatsApp-continuation pattern as RequestBookingForm,
 * just without the transfer-specific origin/destination/trip-type fields
 * that don't apply here.
 */
export function NodeInquiryForm({ productNodeId, productTitle, source, submitLabel, showNumberOfDays }: NodeInquiryFormProps) {
  const [isPending, startTransition] = useTransition();
  const [error, setError] = useState<string | null>(null);
  const [submitted, setSubmitted] = useState<{
    reference: string;
    customerName: string;
    preferredDate: string | null;
    adults: number;
    children: number;
    numberOfDays: number | null;
  } | null>(null);

  if (submitted) {
    const { reference } = submitted;
    const waMessage = encodeURIComponent(`Hi, I'd like to follow up on my request ${reference} (${productTitle}).`);
    return (
      <div className="rounded-2xl border border-maldives-200 bg-maldives-50 p-6 text-center">
        <p className="text-lg font-semibold text-ocean-900">Booking Request Received</p>
        <dl className="mt-3 space-y-1 text-left text-sm text-neutral-700">
          <div>
            <dt className="inline font-medium text-neutral-900">Reference: </dt>
            <dd className="inline font-mono font-semibold">{reference}</dd>
          </div>
          <div>
            <dt className="inline font-medium text-neutral-900">Product: </dt>
            <dd className="inline">{productTitle}</dd>
          </div>
          {submitted.preferredDate && (
            <div>
              <dt className="inline font-medium text-neutral-900">Requested date: </dt>
              <dd className="inline">{submitted.preferredDate}</dd>
            </div>
          )}
          {submitted.numberOfDays !== null && (
            <div>
              <dt className="inline font-medium text-neutral-900">Number of days: </dt>
              <dd className="inline">{submitted.numberOfDays}</dd>
            </div>
          )}
          <div>
            <dt className="inline font-medium text-neutral-900">Guests: </dt>
            <dd className="inline">
              {submitted.adults} adult{submitted.adults === 1 ? "" : "s"}
              {submitted.children ? `, ${submitted.children} child${submitted.children === 1 ? "" : "ren"}` : ""}
            </dd>
          </div>
          <div>
            <dt className="inline font-medium text-neutral-900">Name: </dt>
            <dd className="inline">{submitted.customerName}</dd>
          </div>
        </dl>
        <p className="mt-3 text-sm text-neutral-700">
          This is a request, not a confirmed booking. Our team will review availability and contact you using the details you provided.
        </p>
        <a
          href={`https://wa.me/${WHATSAPP_NUMBER}?text=${waMessage}`}
          target="_blank"
          rel="noopener noreferrer"
          className="mt-4 inline-flex items-center justify-center gap-2 rounded-full bg-[#25D366] px-5 py-2.5 text-sm font-medium text-white hover:opacity-90"
        >
          Continue on WhatsApp
        </a>
      </div>
    );
  }

  return (
    <form
      className="space-y-4"
      onSubmit={(event) => {
        event.preventDefault();
        setError(null);
        const form = event.currentTarget;
        const data = new FormData(form);

        startTransition(async () => {
          const customerName = String(data.get("customerName") ?? "");
          const preferredDate = String(data.get("preferredDate") ?? "") || null;
          const adults = Number(data.get("adults") ?? 1) || 1;
          const children = Number(data.get("children") ?? 0) || 0;
          const numberOfDays = showNumberOfDays ? Number(data.get("numberOfDays") ?? 1) || 1 : null;

          const result = await createNodeInquiry({
            productNodeId,
            productTitle,
            source,
            customerName,
            customerEmail: String(data.get("customerEmail") ?? ""),
            customerPhone: String(data.get("customerPhone") ?? ""),
            customerWhatsapp: String(data.get("customerWhatsapp") ?? ""),
            preferredDate,
            preferredTime: String(data.get("preferredTime") ?? "") || null,
            adults,
            children,
            numberOfDays,
            specialRequests: String(data.get("specialRequests") ?? "") || null,
            honeypot: String(data.get("website") ?? ""),
          });

          if (!result.ok) {
            setError(result.error ?? "Something went wrong. Please try again.");
            return;
          }
          if (result.bookingReference) {
            setSubmitted({ reference: result.bookingReference, customerName, preferredDate, adults, children, numberOfDays });
          }
        });
      }}
    >
      {/* Honeypot: hidden from real visitors, so any bot that fills every
          field it finds trips this and gets silently rejected server-side
          (see isSpam() in src/lib/bookings/actions.ts). Off-screen rather
          than display:none, since some scrapers skip display:none fields. */}
      <div aria-hidden="true" style={{ position: "absolute", left: "-9999px", top: "auto", width: 1, height: 1, overflow: "hidden" }}>
        <label>
          Website
          <input type="text" name="website" tabIndex={-1} autoComplete="off" />
        </label>
      </div>

      <div className="grid grid-cols-1 gap-4 sm:grid-cols-2">
        <Field label="Full name" name="customerName" type="text" required autoComplete="name" />
        <Field label="Email" name="customerEmail" type="email" required autoComplete="email" />
        <Field label="Phone" name="customerPhone" type="tel" autoComplete="tel" />
        <Field label="WhatsApp number" name="customerWhatsapp" type="tel" />
      </div>

      <div className="grid grid-cols-1 gap-4 sm:grid-cols-2">
        <Field label="Preferred date (optional)" name="preferredDate" type="date" />
        <Field label="Preferred time (optional)" name="preferredTime" type="time" />
      </div>

      <div className="grid grid-cols-2 gap-4">
        <Field label="Adults" name="adults" type="number" min={1} defaultValue={2} />
        <Field label="Children" name="children" type="number" min={0} defaultValue={0} />
      </div>

      {showNumberOfDays && (
        <div className="grid grid-cols-2 gap-4">
          <Field label="Number of days" name="numberOfDays" type="number" min={1} defaultValue={1} />
        </div>
      )}

      <label className="block text-sm">
        <span className="mb-1 block font-medium text-neutral-700">What would you like to do? (optional)</span>
        <textarea
          name="specialRequests"
          rows={3}
          placeholder="Destination, duration, occasion, anything else useful to know"
          className="w-full rounded-xl border border-neutral-300 px-3 py-2 text-sm focus:border-maldives-500 focus:outline-none focus-visible:ring-2 focus-visible:ring-maldives-500 focus-visible:ring-offset-1"
        />
      </label>

      {error && (
        <p role="alert" className="text-sm text-red-600">
          {error}
        </p>
      )}

      <div className="flex items-center justify-end gap-4 border-t border-neutral-200 pt-4">
        <Button type="submit" disabled={isPending}>
          {isPending ? "Sending…" : submitLabel}
        </Button>
      </div>
    </form>
  );
}

function Field({
  label,
  name,
  type,
  required,
  autoComplete,
  min,
  defaultValue,
}: {
  label: string;
  name: string;
  type: string;
  required?: boolean;
  autoComplete?: string;
  min?: number;
  defaultValue?: number;
}) {
  return (
    <label className="block text-sm">
      <span className="mb-1 block font-medium text-neutral-700">
        {label}
        {required && <span aria-hidden="true"> *</span>}
      </span>
      <input
        name={name}
        type={type}
        required={required}
        autoComplete={autoComplete}
        min={min}
        defaultValue={defaultValue}
        className="min-touch-target w-full rounded-xl border border-neutral-300 px-3 py-2 text-sm focus:border-maldives-500 focus:outline-none focus-visible:ring-2 focus-visible:ring-maldives-500 focus-visible:ring-offset-1"
      />
    </label>
  );
}
