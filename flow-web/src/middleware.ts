import { NextResponse } from "next/server";
import type { NextRequest } from "next/server";
import { getToken } from "next-auth/jwt";

export async function middleware(req: NextRequest) {
  // 1. On récupère le jeton de session chiffré dans les cookies
  const token = await getToken({ 
    req, 
    secret: process.env.NEXTAUTH_SECRET 
  });

  // 2. Si l'utilisateur tente d'accéder à l'administration
  if (req.nextUrl.pathname.startsWith("/admin")) {
    
    // S'il n'est pas connecté du tout
    if (!token) {
      return NextResponse.redirect(new URL("/login", req.url));
    }

    // Optionnel : Si tu veux bloquer les utilisateurs normaux (non-admin)
    if (token.role !== "ADMIN") {
        return NextResponse.redirect(new URL("/login?error=Accès+refusé", req.url));
    }
  }

  // 3. Dans tous les autres cas (pages publiques ou admin authentifié), on laisse passer
  return NextResponse.next();
}

// Définition des routes à intercepter
export const config = {
  matcher: ["/admin/:path*"],
};