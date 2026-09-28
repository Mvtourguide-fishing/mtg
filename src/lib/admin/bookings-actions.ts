"use server";

import { revalidatePath } from "next/cache";

import { requireStaff } from "@/lib/admin/auth";
import { BOOKING_STATUSES, type BookingStatus } from "@/lib/admin/booking-status";
import { createClient } from "@/lib/supabase/server";

/**
 * requireStaff() here is defense in depth, not the primary guard — the
 * primary guard is `bookings_staff_update` RLS (supabase/migrations/
 * 20250101001400_rls_policies.sql), which blocks a non-staff write at the
 * database layer regardless of what this function does. Both checks use
 * the same RLS-respecting `createClient()`, never the service-role client
 * — a booking status change is exactly the kind of write RLS already
 * governs correctly, so there's no reason to bypass it.
 */

export interface AdminActionResult {
  ok: boolean;
  error?: string;
}

export async function updateBookingStatus(id: string, status: string): Promise<AdminActionResult> {
  await requireStaff();
  if (!(BOOKING_STATUSES as readonly string[]).includes(status)) return { ok: false, error: "Invalid status." };

  const supabase = await createClient();
  const { error } = await supabase
    .from("bookings")
    .update({ status } as unknown as never)
    .eq("id", id);
  if (error) return { ok: false, error: error.message };

  revalidatePath(`/admin/bookings/${id}`);
  revalidatePath("/admin/bookings");
  revalidatePath("/admin");
  return { ok: true };
}

export async function updateBookingNotes(id: string, internalNotes: string): Promise<AdminActionResult> {
  await requireStaff();

  const supabase = await createClient();
  const { error } = await supabase
    .from("bookings")
    .update({ internal_notes: internalNotes.trim() || null } as unknown as never)
    .eq("id", id);
  if (error) return { ok: false, error: error.message };

  revalidatePath(`/admin/bookings/${id}`);
  return { ok: true };
}

export type { BookingStatus };
