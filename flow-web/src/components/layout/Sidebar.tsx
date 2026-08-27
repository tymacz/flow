"use client";

import Link from "next/link";
import { usePathname } from "next/navigation";
import { cn } from "@/lib/utils";
import { LayoutDashboard, Newspaper, Activity, ArrowLeft } from "lucide-react";

// Définition des routes d'administration
const adminLinks = [
  { name: "Tableau de bord", href: "/admin", icon: LayoutDashboard },
  { name: "Gestion Articles", href: "/admin/articles", icon: Newspaper },
  { name: "Gestion Activités", href: "/admin/activites", icon: Activity },
];

export function Sidebar() {
  const pathname = usePathname();

  return (
    <aside className="border-border bg-background sticky top-0 hidden h-screen w-64 flex-col border-r md:flex">
      {/* En-tête de la Sidebar */}
      <div className="border-border flex h-16 items-center border-b px-6">
        <Link
          href="/admin"
          className="text-primary flex items-center gap-2 font-bold"
        >
          <span className="text-2xl tracking-tight">Flow Admin</span>
        </Link>
      </div>

      {/* Liens de navigation */}
      <div className="flex-1 overflow-auto py-4">
        <nav className="grid items-start gap-2 px-4 text-sm font-medium">
          {adminLinks.map((link) => {
            const Icon = link.icon;
            // On vérifie si on est sur la route exacte OU sur une sous-route (ex: /admin/articles/creation)
            const isActive =
              pathname === link.href ?? pathname.startsWith(`${link.href}/`);

            return (
              <Link
                key={link.href}
                href={link.href}
                className={cn(
                  "hover:text-primary flex items-center gap-3 rounded-lg px-3 py-2.5 transition-all",
                  isActive
                    ? "bg-primary/10 text-primary font-semibold"
                    : "text-muted-foreground",
                )}
              >
                <Icon className="h-5 w-5" />
                {link.name}
              </Link>
            );
          })}
        </nav>
      </div>

      {/* Bouton de retour au site public */}
      <div className="border-border mt-auto border-t p-4">
        <Link
          href="/"
          className="text-muted-foreground hover:text-primary hover:bg-primary/10 flex items-center gap-3 rounded-lg px-3 py-2 text-sm font-medium transition-all"
        >
          <ArrowLeft className="h-5 w-5" />
          Retour au site
        </Link>
      </div>
    </aside>
  );
}
