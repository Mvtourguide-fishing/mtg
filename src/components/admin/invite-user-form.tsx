"use client";

import { useRouter } from "next/navigation";
import { useState, useTransition } from "react";

import { Button } from "@/components/ui/button";
import { inviteStaffUser } from "@/lib/admin/users-actions";

export function InviteUserForm() {
  const router = useRouter();
  const [isPending, startTransition] = useTransition();
  const [error, setError] = useState<string | null>(null);
  const [success, setSuccess] = useState<string | null>(null);

  return (
    <form
      className="flex flex-wrap items-end gap-3"
      onSubmit={(e) => {
        e.preventDefault();
        setError(null);
        setSuccess(null);
        const data = new FormData(e.currentTarget);
        const email = String(data.get("email") ?? "");
        const role = String(data.get("role") ?? "editor");

        startTransition(async () => {
          const result = await inviteStaffUser(email, role);
          if (!result.ok) {
            setError(result.error ?? "Failed to invite.");
            return;
          }
          setSuccess(`Invited ${email}.`);
          (document.getElementById("invite-email") as HTMLInputElement | null)?.form?.reset();
          router.refresh();
        });
      }}
    >
      <label className="text-sm">
        <span className="mb-1 block font-medium text-neutral-700">Email</span>
        <input
          id="invite-email"
          name="email"
          type="email"
          required
          className="w-64 rounded-xl border border-neutral-300 px-3 py-2 text-sm focus:border-maldives-500 focus:outline-none focus-visible:ring-2 focus-visible:ring-maldives-500 focus-visible:ring-offset-1"
        />
      </label>
      <label className="text-sm">
        <span className="mb-1 block font-medium text-neutral-700">Role</span>
        <select name="role" defaultValue="editor" className="rounded-xl border border-neutral-300 px-3 py-2 text-sm">
          <option value="editor">editor</option>
          <option value="admin">admin</option>
        </select>
      </label>
      <Button type="submit" size="sm" disabled={isPending}>
        {isPending ? "Sending…" : "Send invite"}
      </Button>
      {error && <p className="w-full text-sm text-red-600">{error}</p>}
      {success && <p className="w-full text-sm text-maldives-600">{success}</p>}
    </form>
  );
}
