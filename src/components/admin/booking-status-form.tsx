"use client";

import { useRouter } from "next/navigation";
import { useState, useTransition } from "react";

import { Button } from "@/components/ui/button";
import { BOOKING_STATUSES } from "@/lib/admin/booking-status";
import { updateBookingNotes, updateBookingStatus, type AdminActionResult } from "@/lib/admin/bookings-actions";

export function BookingStatusForm({ bookingId, currentStatus, currentNotes }: { bookingId: string; currentStatus: string; currentNotes: string }) {
  const router = useRouter();
  const [status, setStatus] = useState(currentStatus);
  const [notes, setNotes] = useState(currentNotes);
  const [isPending, startTransition] = useTransition();
  const [savedAt, setSavedAt] = useState<number | null>(null);
  const [error, setError] = useState<string | null>(null);

  function save() {
    setError(null);
    startTransition(async () => {
      const [statusResult, notesResult]: [AdminActionResult, AdminActionResult] = await Promise.all([
        status !== currentStatus ? updateBookingStatus(bookingId, status) : Promise.resolve({ ok: true }),
        notes !== currentNotes ? updateBookingNotes(bookingId, notes) : Promise.resolve({ ok: true }),
      ]);
      if (!statusResult.ok || !notesResult.ok) {
        setError(statusResult.error ?? notesResult.error ?? "Something went wrong.");
        return;
      }
      setSavedAt(Date.now());
      router.refresh();
    });
  }

  const dirty = status !== currentStatus || notes !== currentNotes;

  return (
    <div className="space-y-4 rounded-2xl border border-neutral-200 bg-white p-4">
      <label className="block text-sm">
        <span className="mb-1 block font-medium text-neutral-700">Status</span>
        <select
          value={status}
          onChange={(e) => setStatus(e.target.value)}
          className="w-full rounded-xl border border-neutral-300 px-3 py-2 text-sm focus:border-maldives-500 focus:outline-none focus-visible:ring-2 focus-visible:ring-maldives-500 focus-visible:ring-offset-1"
        >
          {BOOKING_STATUSES.map((s) => (
            <option key={s} value={s}>
              {s}
            </option>
          ))}
        </select>
      </label>

      <label className="block text-sm">
        <span className="mb-1 block font-medium text-neutral-700">Internal notes (staff only — never shown to the customer)</span>
        <textarea
          value={notes}
          onChange={(e) => setNotes(e.target.value)}
          rows={4}
          className="w-full rounded-xl border border-neutral-300 px-3 py-2 text-sm focus:border-maldives-500 focus:outline-none focus-visible:ring-2 focus-visible:ring-maldives-500 focus-visible:ring-offset-1"
        />
      </label>

      {error && (
        <p role="alert" className="text-sm text-red-600">
          {error}
        </p>
      )}

      <div className="flex items-center gap-3">
        <Button size="sm" onClick={save} disabled={isPending || !dirty}>
          {isPending ? "Saving…" : "Save changes"}
        </Button>
        {!dirty && savedAt && <span className="text-sm text-neutral-500">Saved.</span>}
      </div>
    </div>
  );
}
