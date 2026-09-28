/**
 * Pure constant/type, deliberately with no "server-only" import and no
 * Supabase client import — src/lib/admin/dashboard.ts (which needs a
 * Supabase client to compute counts) is server-only, but this value is
 * also needed by a Client Component (booking-status-form.tsx's status
 * dropdown) and by server actions. Importing it from dashboard.ts would
 * pull `server-only` into the client bundle, which Next.js correctly
 * refuses to build.
 */
export const BOOKING_STATUSES = ["new", "contacted", "pending", "confirmed", "cancelled", "completed"] as const;
export type BookingStatus = (typeof BOOKING_STATUSES)[number];
