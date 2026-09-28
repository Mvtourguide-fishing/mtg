import { InviteUserForm } from "@/components/admin/invite-user-form";
import { UserRoleSelect } from "@/components/admin/user-role-select";
import { Badge } from "@/components/ui/badge";
import { requireAdmin } from "@/lib/admin/auth";
import { getUsersAdmin } from "@/lib/admin/users-repository";

const ROLE_TONE: Record<string, "neutral" | "maldives" | "aqua" | "outline"> = {
  user: "neutral",
  editor: "outline",
  admin: "maldives",
};

export default async function AdminUsersPage() {
  // requireStaff() already ran in the layout — this re-checks is_admin()
  // specifically, since this page (role management + auth.users emails
  // via the service-role client) is more sensitive than an ordinary staff
  // surface. Defense in depth: the AdminNav also only shows this link to
  // admins, but that's UI convenience, not the security boundary.
  const { userId } = await requireAdmin();
  const users = await getUsersAdmin();

  return (
    <div>
      <h1 className="text-2xl font-semibold text-ocean-900">Users ({users.length})</h1>
      <p className="mt-1 text-sm text-neutral-600">Only admins can see this page or change roles. New staff accounts start as &ldquo;editor&rdquo;.</p>

      <div className="mt-6 rounded-2xl border border-neutral-200 bg-white p-4">
        <h2 className="text-sm font-semibold uppercase tracking-wide text-neutral-500">Invite staff</h2>
        <div className="mt-3">
          <InviteUserForm />
        </div>
      </div>

      <div className="mt-6 overflow-x-auto rounded-2xl border border-neutral-200 bg-white">
        <table className="w-full min-w-[600px] text-left text-sm">
          <thead className="border-b border-neutral-200 bg-neutral-50 text-xs font-semibold uppercase tracking-wide text-neutral-500">
            <tr>
              <th className="px-4 py-3">Email</th>
              <th className="px-4 py-3">Name</th>
              <th className="px-4 py-3">Joined</th>
              <th className="px-4 py-3">Role</th>
            </tr>
          </thead>
          <tbody className="divide-y divide-neutral-100">
            {users.map((u) => (
              <tr key={u.id} className="hover:bg-neutral-50">
                <td className="px-4 py-3">{u.email ?? "—"}</td>
                <td className="px-4 py-3 text-neutral-600">{u.displayName ?? "—"}</td>
                <td className="px-4 py-3 text-neutral-500">{new Date(u.createdAt).toLocaleDateString()}</td>
                <td className="px-4 py-3">
                  <div className="flex items-center gap-2">
                    <Badge tone={ROLE_TONE[u.role]}>{u.role}</Badge>
                    <UserRoleSelect userId={u.id} role={u.role} isSelf={u.id === userId} />
                  </div>
                </td>
              </tr>
            ))}
          </tbody>
        </table>
      </div>
    </div>
  );
}
