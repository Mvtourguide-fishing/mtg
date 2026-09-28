"use server";

import { createClient } from "@/lib/supabase/server";

/**
 * Wraps the submit_review RPC (Task 20 §34) — same guest-safe pattern as
 * createTransferBookingInquiry: server-side validation, then a thin,
 * typed call. Reviews are inserted with status='pending' by the RPC
 * itself and never shown until moderated, so this action never claims a
 * submission is "published".
 */

export interface SubmitReviewInput {
  nodeId: string;
  rating: number;
  title: string;
  body: string;
  guestName: string;
  guestEmail: string;
}

export interface SubmitReviewResult {
  ok: boolean;
  error?: string;
}

export async function submitReview(input: SubmitReviewInput): Promise<SubmitReviewResult> {
  const name = input.guestName.trim();
  const email = input.guestEmail.trim();

  if (!Number.isInteger(input.rating) || input.rating < 1 || input.rating > 5) {
    return { ok: false, error: "Please choose a rating between 1 and 5." };
  }
  if (!name) return { ok: false, error: "Please enter your name." };
  if (!/^[^@\s]+@[^@\s]+\.[^@\s]+$/.test(email)) return { ok: false, error: "Please enter a valid email address." };
  if (!input.body.trim()) return { ok: false, error: "Please write a short review." };

  const supabase = await createClient();
  const rpcArgs = {
    p_node_id: input.nodeId,
    p_rating: input.rating,
    p_title: input.title.trim() || null,
    p_body: input.body.trim(),
    p_guest_name: name,
    p_guest_email: email,
  };

  // src/types/database.ts is still the Task 3 placeholder (see the
  // identical, already-documented cast in src/lib/bookings/actions.ts) —
  // narrowly scoped to this one call, not a widening of the shared type.
  const { error } = await supabase.rpc("submit_review" as unknown as never, rpcArgs as unknown as undefined);

  if (error) {
    return { ok: false, error: "We couldn't submit your review right now. Please try again." };
  }

  return { ok: true };
}
