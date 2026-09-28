"use client";

import { useRouter } from "next/navigation";
import { useState, useTransition } from "react";

import { Button } from "@/components/ui/button";
import { createClient } from "@/lib/supabase/client";

/**
 * The only sign-in UI anywhere in this codebase (Task 15 audit confirmed:
 * no login form existed before this — the public site is entirely
 * guest-only). Intentionally has no "sign up" link: new staff accounts are
 * created by an existing admin via /admin/users' invite action (or, for the
 * very first admin, scripts/bootstrap-admin.mjs) — never self-service,
 * since anyone who could sign themselves up could try to reach admin pages.
 * Signing up grants no admin access on its own regardless (a fresh
 * `profiles` row defaults to role='user', which is_staff() rejects), but
 * not offering the option at all keeps the intent clear.
 */
export function LoginForm() {
  const router = useRouter();
  const [isPending, startTransition] = useTransition();
  const [error, setError] = useState<string | null>(null);

  return (
    <form
      className="space-y-4"
      onSubmit={(event) => {
        event.preventDefault();
        setError(null);
        const data = new FormData(event.currentTarget);
        const email = String(data.get("email") ?? "").trim();
        const password = String(data.get("password") ?? "");

        startTransition(async () => {
          const supabase = createClient();
          const { error: signInError } = await supabase.auth.signInWithPassword({ email, password });
          if (signInError) {
            setError("Incorrect email or password.");
            return;
          }
          router.replace("/admin");
          router.refresh();
        });
      }}
    >
      <label className="block text-sm">
        <span className="mb-1 block font-medium text-neutral-700">Email</span>
        <input
          name="email"
          type="email"
          required
          autoComplete="email"
          className="min-touch-target w-full rounded-xl border border-neutral-300 px-3 py-2 text-sm focus:border-maldives-500 focus:outline-none focus-visible:ring-2 focus-visible:ring-maldives-500 focus-visible:ring-offset-1"
        />
      </label>

      <label className="block text-sm">
        <span className="mb-1 block font-medium text-neutral-700">Password</span>
        <input
          name="password"
          type="password"
          required
          autoComplete="current-password"
          className="min-touch-target w-full rounded-xl border border-neutral-300 px-3 py-2 text-sm focus:border-maldives-500 focus:outline-none focus-visible:ring-2 focus-visible:ring-maldives-500 focus-visible:ring-offset-1"
        />
      </label>

      {error && (
        <p role="alert" className="text-sm text-red-600">
          {error}
        </p>
      )}

      <Button type="submit" disabled={isPending} className="w-full justify-center">
        {isPending ? "Signing in…" : "Sign in"}
      </Button>
    </form>
  );
}
