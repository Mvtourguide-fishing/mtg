#!/usr/bin/env node
// Task 15 (Admin/CMS): create or promote the very first MTG admin account.
//
// This is a genuine chicken-and-egg problem, not a shortcut: the admin
// panel's /admin/users page lets an *existing* admin invite/promote staff,
// but before this script runs there is no admin (and no login UI existed
// at all before this task — confirmed by audit). Something has to create
// account #1 outside the app, using the service-role key, which is exactly
// the kind of operation src/lib/supabase/admin.ts's createAdminClient() is
// reserved for. This script never runs inside the app or ships to the
// browser — it's a one-off operational tool, run locally by the site
// owner, the same way the very first migrations seeded content directly.
//
// It does NOT touch profiles.role through RLS/the app (which would be
// blocked by prevent_profile_role_self_escalation() for a non-admin
// caller anyway) — it uses the service-role client, which bypasses RLS
// entirely, exactly the same way this script's sibling
// scripts/upload-legacy-media.mjs uses it to bypass Storage's RLS.
//
// Requires NEXT_PUBLIC_SUPABASE_URL and SUPABASE_SERVICE_ROLE_KEY (from
// .env.local or the real environment) AND real network access to the
// Supabase project — this sandbox cannot reach it (see this session's
// other reports); run this from a machine that can.
//
// Usage:
//   node scripts/bootstrap-admin.mjs you@example.com "TempPassword123!"
//
// If the email already has an auth account, this only promotes its
// existing profiles row to role='admin' — it never resets a password.

import { existsSync, readFileSync } from "node:fs";
import path from "node:path";
import { fileURLToPath } from "node:url";

const ROOT = path.dirname(path.dirname(fileURLToPath(import.meta.url)));

/** Same hand-rolled loader as scripts/upload-legacy-media.mjs — a plain
 * KEY=VALUE reader, not a dotenv dependency, for this one dev script. */
function loadEnvLocal() {
  const envPath = path.join(ROOT, ".env.local");
  if (!existsSync(envPath)) return;
  for (const line of readFileSync(envPath, "utf8").split("\n")) {
    const trimmed = line.trim();
    if (!trimmed || trimmed.startsWith("#")) continue;
    const eq = trimmed.indexOf("=");
    if (eq === -1) continue;
    const key = trimmed.slice(0, eq).trim();
    const value = trimmed.slice(eq + 1).trim();
    if (!(key in process.env)) process.env[key] = value;
  }
}

async function main() {
  const [, , email, password] = process.argv;
  if (!email || !password) {
    console.error('Usage: node scripts/bootstrap-admin.mjs <email> "<password>"');
    process.exit(1);
  }
  if (password.length < 8) {
    console.error("Password must be at least 8 characters (Supabase Auth's own minimum).");
    process.exit(1);
  }

  loadEnvLocal();
  const url = process.env.NEXT_PUBLIC_SUPABASE_URL;
  const serviceRoleKey = process.env.SUPABASE_SERVICE_ROLE_KEY;
  if (!url || !serviceRoleKey) {
    console.error("Set NEXT_PUBLIC_SUPABASE_URL and SUPABASE_SERVICE_ROLE_KEY (in .env.local or the environment).");
    process.exit(1);
  }

  const { createClient } = await import("@supabase/supabase-js");
  const admin = createClient(url, serviceRoleKey, { auth: { autoRefreshToken: false, persistSession: false } });

  let userId;
  const { data: created, error: createError } = await admin.auth.admin.createUser({
    email,
    password,
    email_confirm: true, // no email-sending configured for auth flows yet — skip the confirmation step
  });

  if (created?.user) {
    userId = created.user.id;
    console.log(`Created auth user ${email} (${userId}).`);
  } else if (createError?.message?.toLowerCase().includes("already been registered") || createError?.message?.toLowerCase().includes("already registered")) {
    // Existing user — look them up instead of resetting their password.
    let page = 1;
    while (!userId) {
      const { data: listed, error: listError } = await admin.auth.admin.listUsers({ page, perPage: 200 });
      if (listError) {
        console.error(`Failed to look up existing user: ${listError.message}`);
        process.exit(1);
      }
      const found = listed.users.find((u) => u.email?.toLowerCase() === email.toLowerCase());
      if (found) {
        userId = found.id;
        break;
      }
      if (listed.users.length < 200) break; // exhausted all pages, not found
      page += 1;
    }
    if (!userId) {
      console.error(`Auth said "${email}" is already registered, but it wasn't found while listing users. Aborting.`);
      process.exit(1);
    }
    console.log(`User ${email} already exists (${userId}) — leaving their password unchanged.`);
  } else {
    console.error(`Failed to create auth user: ${createError?.message ?? "unknown error"}`);
    process.exit(1);
  }

  // profiles row is auto-created by the handle_new_auth_user() trigger on
  // auth.users insert; for an existing user it's already there. Either
  // way, promote it directly — service role bypasses RLS and the
  // prevent_profile_role_self_escalation() trigger both, which is correct
  // here since there is no admin yet to grant this through the app.
  const { error: updateError } = await admin.from("profiles").update({ role: "admin" }).eq("id", userId);
  if (updateError) {
    console.error(`Failed to set role='admin': ${updateError.message}`);
    process.exit(1);
  }

  console.log(`${email} is now an admin. Sign in at /admin/login.`);
}

main();
