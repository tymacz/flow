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
    console.log("1. Credentials transmis à authorize :", credentials);
  
    try {
      const res = await fetch("http://cesizen_backend:8000/api/login", {
        method: "POST",
        headers: {
          "Content-Type": "application/json",
          "Accept": "application/json",
        },
        body: JSON.stringify({
          email: credentials?.email,
          password: credentials?.password,
        }),
      });
  
      const data = await res.json();
      console.log("2. Statut HTTP Laravel :", res.status);
      console.log("3. Contenu réponse Laravel :", data);
  
      if (!res.ok || !data) {
        console.log("Échec : Laravel a renvoyé une erreur ou un payload vide");
        return null;
      }
  
      // Récupération de l'utilisateur (s'il est imbriqué dans data.user ou directement dans data)
      const user = data.user || data;
  
      // Exigence stricte Auth.js v5 : le champ 'id' doit exister et être une string
      return {
        id: String(user._id || user.id || "1"),
        name: user.name,
        email: user.email,
        token: data.access_token || data.token,
      };
    } catch (error) {
      console.error("Erreur réseau lors de l'appel à Laravel :", error);
      return null;
    }
  }
    })
  ],
  session: { strategy: "jwt" },
  secret: process.env.NEXTAUTH_SECRET || "fallback_secret_for_build"
};
