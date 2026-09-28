"use server";

import type { BookingSource } from "@/lib/bookings/copy";
import { sendBookingNotifications } from "@/lib/bookings/notifications";
import { createClient } from "@/lib/supabase/server";

/**
 * Connects to the booking system Task 2/3 already built
 * (supabase/migrations/20250101001000_booking.sql /
 * 20250101001300_functions_triggers.sql's create_booking_inquiry RPC) —
 * never a second, disconnected booking implementation. That RPC already
 * handles guest checkout (user_id is auth.uid(), nullable), server-side
 * validation (customer_name/email required, valid email format), and
 * auto-generates the booking_reference (MTG-<year>-<sequence>) via its
 * own trigger. This action is a thin, typed wrapper around it — the ONLY
 * new thing here is a UI ever calling it, which nothing in the codebase
 * did before Task 18.
 *
 * Task 13 (Booking & Inquiries) extends this with: a honeypot spam check
 * (rejected before the RPC is ever called, so a filled honeypot never
 * creates a row or consumes the RPC's rate-limit budget), a structured
 * `source` passed through to the RPC's new p_source param, and firing
 * notifications after a successful insert. Server-side duplicate-
 * submission and rate-limit throttling live in the RPC itself (see
 * supabase/migrations/20250130000100_booking_source_and_throttle.sql) —
 * not here — so they can't be bypassed by calling the RPC directly.
 */

/** Classic hidden-field spam trap: real visitors never see or fill this
 * input (see the `honeypot` field on both form components), so any
 * non-empty value here is treated as automated spam and silently
 * rejected before touching the database at all. */
function isSpam(honeypot: string | undefined): boolean {
  return Boolean(honeypot && honeypot.trim().length > 0);
}

const GENERIC_ERROR = "Something went wrong. Please try again.";

export interface TransferBookingInquiryInput {
  transferServiceId: string;
  originLocationId: string | null;
  destinationLocationId: string | null;
  originTitle: string;
  destinationTitle: string;
  customerName: string;
  customerEmail: string;
  customerPhone: string;
  customerWhatsapp: string;
  travelDate: string; // YYYY-MM-DD
  travelTime: string | null; // HH:MM
  returnDate: string | null;
  returnTime: string | null;
  tripType: "one_way" | "round_trip";
  adults: number;
  children: number;
  infants: number;
  flightNumber: string | null;
  specialRequests: string | null;
  estimatedPrice: number | null;
  currency: string;
  /** Hidden honeypot field — must always be empty for a real submission. */
  honeypot?: string;
}

export interface TransferBookingInquiryResult {
  ok: boolean;
  bookingReference?: string;
  error?: string;
}

export async function createTransferBookingInquiry(
  input: TransferBookingInquiryInput,
): Promise<TransferBookingInquiryResult> {
  if (isSpam(input.honeypot)) return { ok: false, error: GENERIC_ERROR };

  const name = input.customerName.trim();
  const email = input.customerEmail.trim();

  if (!name) return { ok: false, error: "Please enter your name." };
  if (!/^[^@\s]+@[^@\s]+\.[^@\s]+$/.test(email)) return { ok: false, error: "Please enter a valid email address." };
  if (!input.travelDate) return { ok: false, error: "Please choose a travel date." };
  if (input.tripType === "round_trip" && !input.returnDate) {
    return { ok: false, error: "Please choose a return date for a round trip." };
  }

  // src/types/database.ts is a placeholder (`Functions: Record<string,
  // never>`, see its own header comment — this Supabase project's types
  // haven't been generated from a live/local DB yet). Rather than widen
  // the shared client's own type, the mismatch is contained to exactly
  // this one call via an explicit, narrow unknown-cast — the RPC's real
  // parameter/return shape is documented and enforced by the hand-written
  // types on this function's own signature instead.
  const supabase = await createClient();
  const rpcArgs = {
    p_product_type: "transfer_service",
    p_product_node_id: null,
    p_transfer_service_id: input.transferServiceId,
    p_customer_name: name,
    p_customer_email: email,
    p_customer_phone: input.customerPhone.trim() || null,
    p_customer_whatsapp: input.customerWhatsapp.trim() || null,
    p_origin_location_id: input.originLocationId,
    p_destination_location_id: input.destinationLocationId,
    p_travel_date: input.travelDate,
    p_travel_time: input.travelTime || null,
    p_return_date: input.returnDate || null,
    p_return_time: input.returnTime || null,
    p_trip_type: input.tripType,
    p_adults: input.adults,
    p_children: input.children,
    p_infants: input.infants,
    p_flight_number: input.flightNumber?.trim() || null,
    p_special_requests: input.specialRequests?.trim() || null,
    p_estimated_price: input.estimatedPrice,
    p_currency: input.currency,
    p_source: "transfer" satisfies BookingSource,
  };
  const { data, error } = await supabase
    .rpc("create_booking_inquiry" as unknown as never, rpcArgs as unknown as undefined)
    .single<{ id: string; booking_reference: string }>();

  if (error || !data) {
    return { ok: false, error: friendlyRpcError(error?.message) };
  }

  await sendBookingNotifications({
    bookingId: data.id,
    bookingReference: data.booking_reference,
    productTitle: `${input.originTitle} to ${input.destinationTitle}`,
    source: "transfer",
    customerName: name,
    customerEmail: email,
    customerPhone: input.customerPhone.trim() || null,
    requestedDate: input.travelDate,
    adults: input.adults,
    children: input.children,
    specialRequests: input.specialRequests?.trim() || null,
    estimatedPrice: input.estimatedPrice,
    currency: input.currency,
  });

  return { ok: true, bookingReference: data.booking_reference };
}

/**
 * Task 20: the same RPC, for a node-backed inquiry with no fixed
 * origin/destination/trip-type (private speedboat charter, car transfer)
 * — product_type='node' is the RPC's own generic path (already used by
 * package inquiries), never a second booking system. No price is ever
 * passed: these products have no public price.
 */
export interface NodeInquiryInput {
  productNodeId: string;
  productTitle: string;
  source: BookingSource;
  customerName: string;
  customerEmail: string;
  customerPhone: string;
  customerWhatsapp: string;
  preferredDate: string | null; // YYYY-MM-DD
  preferredTime: string | null; // HH:MM
  adults: number;
  children: number;
  /** For products priced per day (fishing charters) where a guest wants
   * more than one day. No dedicated bookings column exists for this yet,
   * so it's folded into specialRequests/notes and — when more than a
   * single day — recorded via the existing trip_type='multi_day' value
   * (never used by node inquiries before this). */
  numberOfDays?: number | null;
  specialRequests: string | null;
  /** Hidden honeypot field — must always be empty for a real submission. */
  honeypot?: string;
}

export async function createNodeInquiry(input: NodeInquiryInput): Promise<TransferBookingInquiryResult> {
  if (isSpam(input.honeypot)) return { ok: false, error: GENERIC_ERROR };

  const name = input.customerName.trim();
  const email = input.customerEmail.trim();

  if (!name) return { ok: false, error: "Please enter your name." };
  if (!/^[^@\s]+@[^@\s]+\.[^@\s]+$/.test(email)) return { ok: false, error: "Please enter a valid email address." };

  const numberOfDays = input.numberOfDays && input.numberOfDays > 0 ? Math.floor(input.numberOfDays) : null;
  const specialRequests = [
    numberOfDays !== null ? `Number of days: ${numberOfDays}.` : null,
    input.specialRequests?.trim() || null,
  ]
    .filter(Boolean)
    .join(" ") || null;

  const supabase = await createClient();
  const rpcArgs = {
    p_product_type: "node",
    p_product_node_id: input.productNodeId,
    p_transfer_service_id: null,
    p_customer_name: name,
    p_customer_email: email,
    p_customer_phone: input.customerPhone.trim() || null,
    p_customer_whatsapp: input.customerWhatsapp.trim() || null,
    p_origin_location_id: null,
    p_destination_location_id: null,
    p_travel_date: input.preferredDate || null,
    p_travel_time: input.preferredTime || null,
    p_return_date: null,
    p_return_time: null,
    p_trip_type: numberOfDays !== null && numberOfDays > 1 ? "multi_day" : "n_a",
    p_adults: input.adults,
    p_children: input.children,
    p_infants: 0,
    p_flight_number: null,
    p_special_requests: specialRequests,
    p_estimated_price: null,
    p_currency: "USD",
    p_source: input.source,
  };
  const { data, error } = await supabase
    .rpc("create_booking_inquiry" as unknown as never, rpcArgs as unknown as undefined)
    .single<{ id: string; booking_reference: string }>();

  if (error || !data) {
    return { ok: false, error: friendlyRpcError(error?.message) };
  }

  await sendBookingNotifications({
    bookingId: data.id,
    bookingReference: data.booking_reference,
    productTitle: input.productTitle,
    source: input.source,
    customerName: name,
    customerEmail: email,
    customerPhone: input.customerPhone.trim() || null,
    requestedDate: input.preferredDate,
    adults: input.adults,
    children: input.children,
    specialRequests: input.specialRequests?.trim() || null,
    estimatedPrice: null,
    currency: "USD",
  });

  return { ok: true, bookingReference: data.booking_reference };
}

/** The RPC's own guard-rail exceptions (duplicate submission, rate limit)
 * are written as plain human-readable messages precisely so they can be
 * shown to the customer as-is; anything else (a genuine failure) falls
 * back to a generic, non-technical message. */
function friendlyRpcError(message: string | undefined): string {
  if (message && (message.includes("already submitted this request") || message.includes("Too many requests from this email"))) {
    return message;
  }
  return "We couldn't submit your request right now. Please try again or contact us on WhatsApp.";
}
