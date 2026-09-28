"use client";

import { useRouter } from "next/navigation";
import { useState, useTransition } from "react";

import { updateUserRole } from "@/lib/admin/users-actions";

export function UserRoleSelect({ userId, role, isSelf }: { userId: string; role: string; isSelf: boolean }) {
  const router = useRouter();
  const [value, setValue] = useState(role);
  const [isPending, startTransition] = useTransition();
  const [error, setError] = useState<string | null>(null);

  return (
    <div>
      <select
        value={value}
        disabled={isPending || (isSelf && value === "admin")}
        onChange={(e) => {
          const next = e.target.value;
          setError(null);
          startTransition(async () => {
            const result = await updateUserRole(userId, next);
            if (!result.ok) {
              setError(result.error ?? "Failed to update role.");
              return;
            }
            setValue(next);
            router.refresh();
          });
        }}
        className="rounded-xl border border-neutral-300 px-3 py-1.5 text-sm"
      >
        <option value="user">user</option>
        <option value="editor">editor</option>
        <option value="admin">admin</option>
      </select>
      {isSelf && <p className="mt-1 text-xs text-neutral-500">You can&rsquo;t remove your own admin access here.</p>}
      {error && <p className="mt-1 text-xs text-red-600">{error}</p>}
    </div>
  );
}
