"use client";

import Link from "next/link";
import { usePathname } from "next/navigation";
import { useSession, signOut } from "next-auth/react";
import { cn } from "@/lib/utils";
import { Avatar, AvatarFallback, AvatarImage } from "@/components/ui/avatar";
import { Button } from "@/components/ui/button";
import {
  DropdownMenu,
  DropdownMenuContent,
  DropdownMenuItem,
  DropdownMenuLabel,
  DropdownMenuSeparator,
  DropdownMenuTrigger,
} from "@/components/ui/dropdown-menu";

const navLinks = [
  { name: "Accueil", href: "/" },
  { name: "Exercices", href: "/exercices" },
  { name: "Articles", href: "/articles" },
  { name: "Progression", href: "/progression" },
  { name: "Support", href: "/tickets/new" },
];

export function Topbar() {
  const pathname = usePathname();
  // Récupération dynamique de l'utilisateur connecté via NextAuth
  const { data: session, status } = useSession();

  return (
    <header className="border-border/40 bg-background/95 supports-[backdrop-filter]:bg-background/60 sticky top-0 z-50 w-full border-b backdrop-blur">
      <div className="container mx-auto flex h-16 max-w-7xl items-center justify-between px-4 sm:px-6 lg:px-8">
        <div className="flex items-center gap-2">
          <Link href="/" className="flex items-center gap-2">
            <span className="text-primary text-2xl font-bold tracking-tight">
              Flow
            </span>
          </Link>
        </div>

        <nav className="hidden items-center gap-8 text-sm font-medium md:flex">
          {navLinks.map((link) => {
            const isActive = pathname === link.href;
            return (
              <Link
                key={link.href}
                href={link.href}
                className={cn(
                  "hover:text-primary transition-colors",
                  isActive ? "text-primary" : "text-muted-foreground",
                )}
              >
                {link.name}
              </Link>
            );
          })}
        </nav>

        <div className="flex items-center gap-4">
          {/* Pendant le chargement de la vérification de session */}
          {status === "loading" ? (
            <div className="bg-muted h-9 w-9 animate-pulse rounded-full" />
          ) : session?.user ? (
            // UTILISATEUR CONNECTÉ : Affichage du Menu Avatar
            <DropdownMenu>
              <DropdownMenuTrigger asChild>
                <button className="focus-visible:ring-ring focus-visible:ring-offset-background rounded-full transition-transform outline-none hover:scale-105 focus-visible:ring-2 focus-visible:ring-offset-2">
                  <Avatar className="border-border h-9 w-9 border">
                    {/* On passe l'URL de l'image Supabase récupérée de la BDD */}
                    <AvatarImage
                      src={session.user.image || ""}
                      alt={session.user.name || "Avatar"}
                    />
                    {/* Si pas d'image, on affiche la première lettre de son prénom */}
                    <AvatarFallback className="bg-primary/10 text-primary font-semibold uppercase">
                      {session.user.prenom?.charAt(0) ||
                        session.user.name?.charAt(0) ||
                        "U"}
                    </AvatarFallback>
                  </Avatar>
                </button>
              </DropdownMenuTrigger>
              <DropdownMenuContent align="end" className="w-56">
                <DropdownMenuLabel className="flex flex-col">
                  <span>{session.user.name}</span>
                  <span className="text-muted-foreground text-xs font-normal">
                    {session.user.email}
                  </span>
                </DropdownMenuLabel>
                <DropdownMenuSeparator />

                <DropdownMenuItem asChild className="cursor-pointer">
                  {/* Le bouton profil redirige vers la page /profil qui utilise les données de session */}
                  <Link href={`/profil/${session.user.id}`}>Mon Profil</Link>
                </DropdownMenuItem>

                {/* Le bouton Administration n'apparaît que s'il est ADMIN */}
                {session.user.role === "ADMIN" && (
                  <DropdownMenuItem asChild className="cursor-pointer">
                    <Link href="/admin">Administration</Link>
                  </DropdownMenuItem>
                )}

                <DropdownMenuSeparator />
                <DropdownMenuItem
                  onClick={() => signOut({ callbackUrl: "/" })}
                  className="text-destructive focus:bg-destructive/10 focus:text-destructive cursor-pointer"
                >
                  Déconnexion
                </DropdownMenuItem>
              </DropdownMenuContent>
            </DropdownMenu>
          ) : (
            // UTILISATEUR DÉCONNECTÉ : Bouton classique
            <Button asChild>
              <Link href="/login">Se connecter</Link>
            </Button>
          )}
        </div>
      </div>
    </header>
  );
}
