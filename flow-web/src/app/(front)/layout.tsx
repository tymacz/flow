import { Topbar } from "@/components/layout/Topbar";
import SessionProvider from "@/components/providers/SessionProvider";

export default function RootLayout({
  children,
}: {
  children: React.ReactNode;
}) {
  return (
    <html lang="fr">
      <body>
        <SessionProvider>
          <Topbar />
          <main className="min-h-screen flex-1">{children}</main>
        </SessionProvider>
      </body>
    </html>
  );
}
