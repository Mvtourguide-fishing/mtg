import "server-only";

import { createAdminClient } from "@/lib/supabase/admin";

/**
 * MTG roadmap Task 13 §11/§12 — customer + internal notifications for a
 * newly created booking. Nothing in this project sent a notification
 * before this file existed (confirmed by audit: `booking_notifications`
 * had zero writers anywhere, and no email/Telegram integration existed at
 * all) — this is new delivery code, not a rewire of something existing.
 *
 * Design constraints from the spec, followed literally:
 *  - never fake delivery: only mark a row 'sent' if the provider actually
 *    accepted it;
 *  - never fail the booking itself over a missing/broken notification
 *    channel — the booking row is already committed by the time this runs;
 *  - never invent credentials — RESEND_API_KEY / RESEND_FROM_EMAIL /
 *    TELEGRAM_BOT_TOKEN / TELEGRAM_CHAT_ID are read from the environment
 *    only; if unset, the attempt is recorded as 'failed' with that reason,
 *    not silently skipped and not falsely reported as sent.
 *
 * Uses the service-role admin client (src/lib/supabase/admin.ts) because
 * `booking_notifications` intentionally has no anon/authenticated insert
 * policy (see supabase/migrations/20250101001400_rls_policies.sql) — this
 * is exactly the "trusted server-side code" case that client is reserved
 * for, and it is never imported into client code.
 */
export interface BookingNotificationInput {
  bookingId: string;
  bookingReference: string;
  productTitle: string;
  source: string;
  customerName: string;
  customerEmail: string;
  customerPhone: string | null;
  requestedDate: string | null;
  adults: number;
  children: number;
  specialRequests: string | null;
  estimatedPrice: number | null;
  currency: string;
}

const SITE_NAME = "Maldives Tour Guide (MTG)";
const WHATSAPP_NUMBER = "9607794332";
// Fallback only — the real recipient is platform_settings.
// booking_notification_email (seeded in
// supabase/migrations/20250101001500_seed_taxonomy.sql), editable without a
// deploy. This constant only covers the unlikely case that row is missing.
const DEFAULT_ADMIN_EMAIL = "contact@maldivestour.guide";

function escapeHtml(value: string): string {
  const map: Record<string, string> = { "&": "&amp;", "<": "&lt;", ">": "&gt;", '"': "&quot;", "'": "&#39;" };
  return value.replace(/[&<>"']/g, (c) => map[c]);
}

async function getAdminNotificationEmail(admin: ReturnType<typeof createAdminClient>): Promise<string> {
  const { data } = await admin.from("platform_settings").select("value").eq("key", "booking_notification_email").maybeSingle();
  return (data as { value: string } | null)?.value ?? DEFAULT_ADMIN_EMAIL;
}

interface DeliveryResult {
  ok: boolean;
  providerMessageId?: string;
  error?: string;
}

async function sendResendEmail(to: string, subject: string, html: string): Promise<DeliveryResult> {
  const apiKey = process.env.RESEND_API_KEY;
  if (!apiKey) return { ok: false, error: "RESEND_API_KEY is not configured" };

  const from = process.env.RESEND_FROM_EMAIL || "MTG Bookings <bookings@maldivestour.guide>";
  try {
    const res = await fetch("https://api.resend.com/emails", {
      method: "POST",
      headers: { Authorization: `Bearer ${apiKey}`, "Content-Type": "application/json" },
      body: JSON.stringify({ from, to, subject, html }),
    });
    const body = (await res.json().catch(() => null)) as { id?: string; message?: string } | null;
    if (!res.ok) return { ok: false, error: body?.message ?? `Resend responded ${res.status}` };
    return { ok: true, providerMessageId: body?.id };
  } catch (err) {
    return { ok: false, error: err instanceof Error ? err.message : "Unknown error calling Resend" };
  }
}

async function sendTelegramMessage(text: string): Promise<DeliveryResult> {
  const token = process.env.TELEGRAM_BOT_TOKEN;
  const chatId = process.env.TELEGRAM_CHAT_ID;
  if (!token || !chatId) return { ok: false, error: "TELEGRAM_BOT_TOKEN/TELEGRAM_CHAT_ID are not configured" };

  try {
    const res = await fetch(`https://api.telegram.org/bot${token}/sendMessage`, {
      method: "POST",
      headers: { "Content-Type": "application/json" },
      body: JSON.stringify({ chat_id: chatId, text, parse_mode: "HTML" }),
    });
    const body = (await res.json().catch(() => null)) as { ok?: boolean; description?: string } | null;
    if (!res.ok || body?.ok === false) return { ok: false, error: body?.description ?? `Telegram responded ${res.status}` };
    return { ok: true };
  } catch (err) {
    return { ok: false, error: err instanceof Error ? err.message : "Unknown error calling Telegram" };
  }
}

/**
 * Fires the customer confirmation, the internal email alert, and (if
 * configured) the internal Telegram alert for a booking that has already
 * been created, and records the outcome of every attempt in
 * `booking_notifications` regardless of success or failure. Never throws —
 * a notification problem must never surface as a booking failure to the
 * customer, since the booking already exists by the time this is called.
 */
export async function sendBookingNotifications(input: BookingNotificationInput): Promise<void> {
  try {
    const admin = createAdminClient();
    const adminEmail = await getAdminNotificationEmail(admin);

    const dateLine = input.requestedDate ? `Requested date: ${input.requestedDate}` : "Requested date: flexible / to be confirmed";
    const guestLine = `${input.adults} adult${input.adults === 1 ? "" : "s"}${
      input.children ? `, ${input.children} child${input.children === 1 ? "" : "ren"}` : ""
    }`;
    const priceLine = input.estimatedPrice != null ? `Estimated price: ${input.currency} ${input.estimatedPrice}` : null;

    const customerHtml = `
      <p>Hi ${escapeHtml(input.customerName)},</p>
      <p>We've received your booking request. Our team will review availability and follow up shortly — this is a request, not a confirmed booking yet.</p>
      <p><strong>Reference:</strong> ${escapeHtml(input.bookingReference)}<br/>
      <strong>Product:</strong> ${escapeHtml(input.productTitle)}<br/>
      ${dateLine}<br/>
      <strong>Guests:</strong> ${guestLine}</p>
      ${priceLine ? `<p>${priceLine}</p>` : ""}
      ${input.specialRequests ? `<p><strong>Your notes:</strong> ${escapeHtml(input.specialRequests)}</p>` : ""}
      <p>Questions in the meantime? WhatsApp us on +${WHATSAPP_NUMBER}.</p>
      <p>— ${SITE_NAME}</p>
    `;

    const adminHtml = `
      <p>New booking inquiry (${escapeHtml(input.source)}).</p>
      <p><strong>Reference:</strong> ${escapeHtml(input.bookingReference)}<br/>
      <strong>Product:</strong> ${escapeHtml(input.productTitle)}<br/>
      ${dateLine}<br/>
      <strong>Guests:</strong> ${guestLine}</p>
      ${priceLine ? `<p>${priceLine}</p>` : ""}
      <p><strong>Customer:</strong> ${escapeHtml(input.customerName)} — ${escapeHtml(input.customerEmail)}${
        input.customerPhone ? ` — ${escapeHtml(input.customerPhone)}` : ""
      }</p>
      ${input.specialRequests ? `<p><strong>Special requests:</strong> ${escapeHtml(input.specialRequests)}</p>` : ""}
      <p style="color:#888;font-size:12px">Booking ID: ${input.bookingId}</p>
    `;

    const telegramText = [
      `<b>New booking inquiry</b> (${escapeHtml(input.source)})`,
      `Ref: ${escapeHtml(input.bookingReference)}`,
      `Product: ${escapeHtml(input.productTitle)}`,
      dateLine,
      `Guests: ${guestLine}`,
      priceLine ?? "",
      `Customer: ${escapeHtml(input.customerName)} (${escapeHtml(input.customerEmail)}${
        input.customerPhone ? `, ${escapeHtml(input.customerPhone)}` : ""
      })`,
      input.specialRequests ? `Notes: ${escapeHtml(input.specialRequests)}` : "",
    ]
      .filter(Boolean)
      .join("\n");

    const [customerResult, adminResult, telegramResult] = await Promise.all([
      sendResendEmail(input.customerEmail, `Booking request received — ${input.bookingReference}`, customerHtml),
      sendResendEmail(adminEmail, `New booking inquiry — ${input.bookingReference}`, adminHtml),
      sendTelegramMessage(telegramText),
    ]);

    const nowIso = new Date().toISOString();
    const notificationRows: Array<Record<string, unknown>> = [
      {
        booking_id: input.bookingId,
        notification_type: "customer_confirmation",
        recipient_email: input.customerEmail,
        status: customerResult.ok ? "sent" : "failed",
        provider_message_id: customerResult.providerMessageId ?? null,
        error_message: customerResult.ok ? null : (customerResult.error ?? null),
        sent_at: customerResult.ok ? nowIso : null,
      },
      {
        booking_id: input.bookingId,
        notification_type: "admin_alert",
        recipient_email: adminEmail,
        status: adminResult.ok ? "sent" : "failed",
        provider_message_id: adminResult.providerMessageId ?? null,
        error_message: adminResult.ok ? null : (adminResult.error ?? null),
        sent_at: adminResult.ok ? nowIso : null,
      },
    ];

    // Telegram is only attempted (and only recorded) when it's actually
    // configured — an unconfigured channel that was never enabled isn't a
    // delivery failure worth logging, unlike email (which is always
    // expected to at least attempt to run).
    if (process.env.TELEGRAM_BOT_TOKEN && process.env.TELEGRAM_CHAT_ID) {
      notificationRows.push({
        booking_id: input.bookingId,
        notification_type: "admin_alert",
        // booking_notifications.recipient_email is `not null` and has no
        // Telegram-specific column — recording the chat id here (prefixed,
        // never a real email) keeps this row honest about what channel it
        // actually is rather than fabricating an email address.
        recipient_email: `telegram:${process.env.TELEGRAM_CHAT_ID}`,
        status: telegramResult.ok ? "sent" : "failed",
        provider_message_id: null,
        error_message: telegramResult.ok ? null : (telegramResult.error ?? null),
        sent_at: telegramResult.ok ? nowIso : null,
      });
    }

    // src/types/database.ts is a placeholder (`Tables: Record<string,
    // never>` — see its own header comment, same reason actions.ts casts
    // its .rpc() calls). That makes insert()/update() row arguments type
    // as `never` here; the mismatch is contained to exactly these two
    // calls via a narrow unknown-cast, same convention as actions.ts.
    const { error: insertError } = await admin.from("booking_notifications").insert(notificationRows as unknown as never[]);
    if (insertError) {
      console.error("[bookings] failed to record booking_notifications rows:", insertError.message);
    }

    const { error: updateError } = await admin
      .from("bookings")
      .update({ notification_status: customerResult.ok ? "sent" : "failed" } as unknown as never)
      .eq("id", input.bookingId);
    if (updateError) {
      console.error("[bookings] failed to update bookings.notification_status:", updateError.message);
    }
  } catch (err) {
    // Belt-and-braces: whatever goes wrong here, the booking itself was
    // already created successfully before this function was called. Only
    // the message is logged (not the raw error object), consistent with
    // the other log statements in this file — a thrown error from an
    // email/Telegram provider could otherwise echo request payload data
    // (customer name/email) into server logs.
    console.error("[bookings] sendBookingNotifications threw unexpectedly:", err instanceof Error ? err.message : String(err));
  }
}
