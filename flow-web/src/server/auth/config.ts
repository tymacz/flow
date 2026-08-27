import { type DefaultSession, type NextAuthConfig } from "next-auth";
import CredentialsProvider from "next-auth/providers/credentials";

declare module "next-auth" {
  interface Session extends DefaultSession {
    user: {
      id: string;
      role?: string;
      prenom?: string;
      nom?: string;
      accessToken?: string; // <-- Ajout du type pour le Token
    } & DefaultSession["user"];
  }

  interface User {
    role?: string;
    prenom?: string;
    nom?: string;
    accessToken?: string; // <-- Ajout du type pour le Token
  }
}

export const authConfig = {
  pages: {
    signIn: "/login",
  },
  providers: [
    CredentialsProvider({
      name: "Connexion API",
      credentials: {
        email: { label: "Email", type: "email" },
        password: { label: "Mot de passe", type: "password" },
      },
      async authorize(credentials) {
        if (!credentials?.email ?? !credentials?.password) return null;

        try {
          const response = await fetch(
            `${process.env.NEXT_PUBLIC_API_URL}/api/login`,
            {
              method: "POST",
              headers: {
                "Content-Type": "application/json",
                Accept: "application/json",
              },
              body: JSON.stringify({
                email: credentials.email,
                password: credentials.password,
              }),
            },
          );

          if (!response.ok) return null;

          const apiData = await response.json();
          console.log("Réponse API Laravel :", apiData);
          const user = apiData.user ?? apiData;
          const token = apiData.token; // <-- Récupération du jeton envoyé par Laravel

          if (user) {
            return {
              id: user._id ?? user.id,
              name: `${user.prenom} ${user.nom}`,
              email: user.email,
              image: user.avatar_url,
              role: user.role,
              prenom: user.prenom,
              nom: user.nom,
              accessToken: token, // <-- On stocke le jeton dans NextAuth
            };
          }

          return null;
        } catch (error) {
          return null;
        }
      },
    }),
  ],
  callbacks: {
    async jwt({ token, user }) {
      if (user) {
        token.id = user.id;
        token.role = user.role;
        token.prenom = user.prenom;
        token.nom = user.nom;
        token.picture = user.image;
        token.accessToken = user.accessToken; // Passage au JWT interne
      }
      return token;
    },
    async session({ session, token }) {
      if (session.user) {
        session.user.id = token.id as string;
        session.user.role = token.role as string;
        session.user.prenom = token.prenom as string;
        session.user.nom = token.nom as string;
        session.user.accessToken = token.accessToken as string; // Rendu dispo pour le front
      }
      return session;
    },
  },
} satisfies NextAuthConfig;
