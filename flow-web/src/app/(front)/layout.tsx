import { Topbar } from "@/components/layout/Topbar";

export default function RootLayout({
  children,
}: {
  children: React.ReactNode;
}) {
  return (
    <html lang="fr">
      <body>
        <Topbar />
        <main className="min-h-screen flex-1">
          {children}
        </main>
      </body>
    </html>
  );
}