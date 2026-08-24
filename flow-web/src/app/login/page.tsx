"use client";

import { useState } from "react";
import { useRouter, useSearchParams } from "next/navigation";
import { signIn } from "next-auth/react";
import { useForm } from "react-hook-form";
import { zodResolver } from "@hookform/resolvers/zod";
import * as z from "zod";
import { Loader2, Lock } from "lucide-react";
import Link from "next/link";
import {Suspense} from 'react';

import { Button } from "@/components/ui/button";
import { Input } from "@/components/ui/input";
import {
  Card,
  CardContent,
  CardDescription,
  CardFooter,
  CardHeader,
  CardTitle,
} from "@/components/ui/card";
import {
  Form,
  FormControl,
  FormField,
  FormItem,
  FormLabel,
  FormMessage,
} from "@/components/ui/form";

// Schéma de validation strict avec Zod
const loginSchema = z.object({
  email: z.string().email("Veuillez entrer un email valide."),
  password: z.string().min(1, "Le mot de passe est requis."),
});

type LoginFormValues = z.infer<typeof loginSchema>;

export default function LoginPage() {
  const router = useRouter();
  const searchParams = useSearchParams();
  const [isLoading, setIsLoading] = useState(false);
  const [authError, setAuthError] = useState<string | null>(null);
  const callbackError = searchParams.get("error");

  const form = useForm<LoginFormValues>({
    resolver: zodResolver(loginSchema),
    defaultValues: {
      email: "",
      password: "",
    },
  });

  async function onSubmit(data: LoginFormValues) {
    setIsLoading(true);
    setAuthError(null);

    try {
      const result = await signIn("credentials", {
        email: data.email,
        password: data.password,
        redirect: false,
      });

      if (result?.error) {
        setAuthError("Identifiants incorrects ou privilèges insuffisants.");
      } else {
        router.push("/");
        router.refresh();
      }
    } catch (error) {
        console.error("Erreur lors de la tentative de connexion :", error);
      setAuthError("Une erreur réseau est survenue lors de la communication avec l'API.");
    } finally {
      setIsLoading(false);
    }
  }

  return (
    <Suspense fallback={<div className="flex min-h-screen items-center justify-center">Chargement...</div>}>
    <div className="flex min-h-screen items-center justify-center bg-muted/40 px-4 py-12 sm:px-6 lg:px-8">
      <Card className="w-full max-w-md shadow-md">
        <CardHeader className="space-y-1 text-center">
          <div className="flex justify-center mb-2">
            <div className="rounded-full bg-primary/10 p-3 text-primary">
              <Lock className="h-6 w-6" />
            </div>
          </div>
          <CardTitle className="text-2xl font-bold tracking-tight">
            Connexion à Flow Admin
          </CardTitle>
          <CardDescription>
            Saisissez vos accès pour administrer l&apos;application.
          </CardDescription>
        </CardHeader>
        <CardContent>
          {(authError ?? callbackError) && (
            <div className="mb-4 rounded-md bg-destructive/10 p-3 text-sm font-medium text-destructive">
              {authError ?? "Une authentification valide est requise pour accéder à cette zone."}
            </div>
          )}

          <Form {...form}>
            <form onSubmit={form.handleSubmit(onSubmit)} className="space-y-4">
              <FormField
                control={form.control}
                name="email"
                render={({ field }) => (
                  <FormItem>
                    <FormLabel>Adresse email</FormLabel>
                    <FormControl>
                      <Input
                        type="email"
                        placeholder="admin@flow.com"
                        autoComplete="email"
                        {...field}
                      />
                    </FormControl>
                    <FormMessage />
                  </FormItem>
                )}
              />

              <FormField
                control={form.control}
                name="password"
                render={({ field }) => (
                  <FormItem>
                    <FormLabel>Mot de passe</FormLabel>
                    <FormControl>
                      <Input 
                        type="password" 
                        placeholder="••••••••" 
                        autoComplete="current-password"
                        {...field} 
                      />
                    </FormControl>
                    <FormMessage />
                  </FormItem>
                )}
              />

              <Button type="submit" className="w-full" disabled={isLoading}>
                {isLoading && <Loader2 className="mr-2 h-4 w-4 animate-spin" />}
                Se connecter
              </Button>
            </form>
          </Form>
        </CardContent>
        <CardFooter className="flex justify-center border-t border-border pt-4">
          <Link href="/inscription" className="text-sm text-muted-foreground hover:text-primary transition-colors">
            s&apos;inscrire
          </Link>
          <Link href="/" className="text-sm text-muted-foreground hover:text-primary transition-colors">
            Retour à l&apos;accueil public
          </Link>
        </CardFooter>
      </Card>
    </div>
      </Suspense>
  );
}
