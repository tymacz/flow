import type NextAuthOptions from "next-auth";
import CredentialsProvider from "next-auth/providers/credentials";

export const authOptions: typeof NextAuthOptions = {
  pages: {
    signIn: "/login",
  },
  session: {
    strategy: "jwt",
  },
  providers: [
    CredentialsProvider({
      name: "Connexion API",
      credentials: {
        email: { label: "Email", type: "email", placeholder: "admin@flow.com" },
        password: { label: "Mot de passe", type: "password" }
        },
async authorize(credentials) {
  if (!credentials?.email || !credentials?.password) return null;

  try {
    const response = await fetch(`${process.env.NEXT_PUBLIC_API_URL}/login`, {
      method: "POST",
      headers: { "Content-Type": "application/json" },
      body: JSON.stringify({
        email: credentials.email,
        password: credentials.password,
      }),
    });

    const user = await response.json();

    // Si la réponse est positive et que l'utilisateur a les droits d'admin
    if (response.ok && user && user.role === "ADMIN") {
      return {
        id: user.id,
        name: user.name,
        email: user.email,
        role: user.role,
      };
    }
    
    return null;
  } catch (error) {
    console.error("Erreur de connexion à l'API externe :", error);
    return null;
  }
}
    })
    ],
  debug: true,
  callbacks: {
    // Ce callback permet d'ajouter des données de l'API (comme le rôle) dans le token NextAuth
    async jwt({ token, user }) {
      if (user) {
        token.role = (user as any).role;
      }
      return token;
    },
    // Ce callback expose ces données à l'interface client (Next.js)
    async session({ session, token }) {
      if (session.user) {
        (session.user as any).role = token.role;
      }
      return session;
    }
  }
};