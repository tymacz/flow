import { AuthOptions } from "next-auth";
import CredentialsProvider from "next-auth/providers/credentials";

export const authOptions: AuthOptions = {
  providers: [
    CredentialsProvider({
      name: "Credentials",
      credentials: {
        email: { label: "Email", type: "text" },
        password: { label: "Password", type: "password" }
      },
  async authorize(credentials) {
    if (!credentials?.email || !credentials?.password) return null;
    const apiBase = process.env.NEXT_PUBLIC_API_URL || "http://cesizen_backend:8000/api";

    // S'assurer qu'il n'y a pas de double slash à l'assemblage
    const loginUrl = apiBase.endsWith("/") ? `${apiBase}login` : `${apiBase}/login`;
    const res = await fetch(loginUrl, {
      method: 'POST',
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json', // Indispensable pour que Laravel renvoie du JSON et non du HTML
      },
      body: JSON.stringify({
        email: credentials.email,
        password: credentials.password,
      }),
    });
  
    // Si Laravel renvoie un code d'erreur (401, 422, 500)
    if (!res.ok) {
      const errorData = await res.json().catch(() => null);
      console.error('Erreur API Laravel :', res.status, errorData);
      return null; // Déclenche CredentialsSignin de façon propre sans crasher la route
    }
  
    const user = await res.json();
    return user || null;
  }
    })
  ],
  session: { strategy: "jwt" },
  secret: process.env.NEXTAUTH_SECRET || "fallback_secret_for_build"
};
