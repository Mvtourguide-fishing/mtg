import type { Metadata } from "next";
import { redirect } from "next/navigation";

import { LoginForm } from "@/components/admin/login-form";
import { createClient } from "@/lib/supabase/server";

export const metadata: Metadata = {
  title: "Admin Sign In | MTG",
  robots: { index: false, follow: false },
};

export default async function AdminLoginPage() {
  // Already signed in and staff? Skip straight to the dashboard rather
  // than showing a pointless login form. Not staff, or not signed in at
  // all: fall through and show the form either way — no point leaking
  // which case it is.
  const supabase = await createClient();
  const {
    data: { user },
  } = await supabase.auth.getUser();
  if (user) {
    const { data: isStaffResult } = await supabase.rpc("is_staff" as unknown as never);
    if (isStaffResult) redirect("/admin");
  }

  return (
    <main className="flex min-h-screen items-center justify-center bg-sand-50 px-4">
      <div className="w-full max-w-sm rounded-2xl border border-neutral-200 bg-white p-8 shadow-sm">
        <h1 className="text-xl font-semibold text-ocean-900">MTG Admin</h1>
        <p className="mt-1 text-sm text-neutral-600">Sign in with your staff account.</p>
        <div className="mt-6">
          <LoginForm />
        </div>
      </div>
    </main>
  );
}
