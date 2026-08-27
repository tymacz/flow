import { AuthOptions } from "next-auth";
import CredentialsProvider from "next-auth/providers/credentials";

export const authOptions: AuthOptions = {
  providers: [
    CredentialsProvider({
      name: "Credentials",
      credentials: {
        email: { label: "Email", type: "text" },
        password: { label: "Password", type: "password" },
      },
      async authorize(credentials) {
        if (!credentials?.email ?? !credentials?.password) return null;

        // L'URL serveur pointe vers le service Docker 'backend' (port 8000)
        const apiBase =
          process.env.INTERNAL_API_URL ?? "http://backend:8000/api";
        const loginUrl = `${apiBase.replace(/\/$/, "")}/login`;

        const res = await fetch(loginUrl, {
          method: "POST",
          headers: {
            "Content-Type": "application/json",
            Accept: "application/json",
          },
          body: JSON.stringify({
            email: credentials.email,
            password: credentials.password,
          }),
        });

        if (!res.ok) {
          const errorData = await res.json().catch(() => null);
          console.error("Erreur API Laravel :", res.status, errorData);
          return null;
        }

        const data = await res.json();

        // Auth.js exige un objet avec un champ 'id' (string) à la racine
        return {
          id: String(data.user._id ?? data.user.id),
          name: data.user.name,
          email: data.user.email,
          accessToken: data.access_token,
        };
      },
    }),
  ],
  session: { strategy: "jwt" },
  secret: process.env.NEXTAUTH_SECRET ?? "fallback_secret_for_build",
};
