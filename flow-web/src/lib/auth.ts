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
      // 1. Toujours cibler le nom du conteneur Docker en serveur
      const res = await fetch("http://cesizen_backend:8000/api/login", {
        method: "POST",
        headers: {
          "Content-Type": "application/json",
          "Accept": "application/json",
        },
        // 2. Vérifier que les noms de clés correspondent à $request->validate() de Laravel
        body: JSON.stringify({
          email: credentials?.email,
          password: credentials?.password,
        }),
      });
  
      const data = await res.json();
  
      if (res.ok && data) {
        // 3. NextAuth attend un objet contenant au minimum un identifiant (id ou email)
        return data.user ?? data;
      }
  
      return null;
    }
    })
  ],
  session: { strategy: "jwt" },
  secret: process.env.NEXTAUTH_SECRET || "fallback_secret_for_build"
};
