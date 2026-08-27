import { auth } from "@/server/auth";
import { NextResponse } from "next/server";

export default auth((req) => {
  const isLoggedIn = !!req.auth;
  const { nextUrl } = req;

  if (nextUrl.pathname.startsWith("/admin")) {
    if (!isLoggedIn) {
      return NextResponse.redirect(new URL("/login", nextUrl));
    }

    if (req.auth?.user?.role !== "ADMIN")
      return NextResponse.redirect(
        new URL("/login?error=Accès refusé", nextUrl),
      );
  }

  return NextResponse.next();
});

export const config = {
  matcher: ["/admin/:path*"],
};
