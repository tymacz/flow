import { Sidebar } from "@/components/layout/Sidebar";

export default function AdminLayout({
  children,
}: {
  children: React.ReactNode;
}) {
  return (
    <div className="bg-muted/10 flex min-h-screen w-full flex-col md:flex-row">
      <Sidebar />
      <main className="flex flex-1 flex-col p-4 lg:p-8">{children}</main>
    </div>
  );
}
