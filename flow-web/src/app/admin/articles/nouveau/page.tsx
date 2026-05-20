"use client";

import { useState } from "react";
import { useRouter } from "next/navigation";
import { zodResolver } from "@hookform/resolvers/zod";
import { useForm } from "react-hook-form";
import * as z from "zod";
import { ArrowLeft, Loader2 } from "lucide-react";
import Link from "next/link";

import { Button } from "@/components/ui/button";
import { Input } from "@/components/ui/input";
import { Textarea } from "@/components/ui/textarea";
import {
  Select,
  SelectContent,
  SelectItem,
  SelectTrigger,
  SelectValue,
} from "@/components/ui/select";
import {
  Form,
  FormControl,
  FormDescription,
  FormField,
  FormItem,
  FormLabel,
  FormMessage,
} from "@/components/ui/form";

// 1. Définition du schéma de validation avec Zod
const articleSchema = z.object({
  titre: z.string().min(5, {
    message: "Le titre doit contenir au moins 5 caractères.",
  }),
  contenu: z.string().min(20, {
    message: "Le contenu est trop court pour un article.",
  }),
  statut: z.enum(["Publié", "Brouillon"]),
});

// Inférer le type TypeScript à partir du schéma Zod
type ArticleFormValues = z.infer<typeof articleSchema>;

export default function NouvelArticlePage() {
  const router = useRouter();
  const [isLoading, setIsLoading] = useState(false);

  // 2. Initialisation du formulaire
  const form = useForm<ArticleFormValues>({
    resolver: zodResolver(articleSchema),
    defaultValues: {
      titre: "",
      contenu: "",
      statut: "Brouillon",
    },
  });

  // 3. Logique de soumission vers ton API
  async function onSubmit(data: ArticleFormValues) {
    setIsLoading(true);

    try {
      // Remplacer cette URL par l'endpoint réel de ton API
      /*
      const response = await fetch("https://api.ton-backend.com/articles", {
        method: "POST",
        headers: {
          "Content-Type": "application/json",
          // "Authorization": `Bearer ${token}` -> À ajouter avec NextAuth
        },
        body: JSON.stringify(data),
      });

      if (!response.ok) throw new Error("Erreur lors de la création");
      */

      // Simulation d'un délai réseau pour l'exemple
      await new Promise((resolve) => setTimeout(resolve, 1000));
      
      console.log("Données prêtes à être envoyées à l'API :", data);

      // Redirection vers la liste des articles après succès
      router.push("/admin/articles");
      router.refresh(); // Force le rafraîchissement des données de la liste
      
    } catch (error) {
      console.error("Erreur:", error);
      // Ici, on pourrait déclencher un composant "Toast" pour notifier l'erreur
    } finally {
      setIsLoading(false);
    }
  }

  return (
    <div className="max-w-3xl space-y-6">
      <div className="flex items-center gap-4">
        <Button variant="ghost" size="icon" asChild>
          <Link href="/admin/articles">
            <ArrowLeft className="h-5 w-5" />
          </Link>
        </Button>
        <div>
          <h1 className="text-3xl font-bold tracking-tight">Nouvel Article</h1>
          <p className="text-muted-foreground">
            Rédigez et paramétrez un nouvel article pour l&apos;application.
          </p>
        </div>
      </div>

      <div className="rounded-md border bg-background p-6">
        {/* 4. Le composant Formulaire de shadcn/ui */}
        <Form {...form}>
          <form onSubmit={form.handleSubmit(onSubmit)} className="space-y-8">
            
            <FormField
              control={form.control}
              name="titre"
              render={({ field }) => (
                <FormItem>
                  <FormLabel>Titre de l&apos;article</FormLabel>
                  <FormControl>
                    <Input placeholder="Ex: L'importance de la récupération..." {...field} />
                  </FormControl>
                  <FormMessage />
                </FormItem>
              )}
            />

            <FormField
              control={form.control}
              name="statut"
              render={({ field }) => (
                <FormItem>
                  <FormLabel>Statut de publication</FormLabel>
                  <Select onValueChange={field.onChange} defaultValue={field.value}>
                    <FormControl>
                      <SelectTrigger>
                        <SelectValue placeholder="Sélectionnez un statut" />
                      </SelectTrigger>
                    </FormControl>
                    <SelectContent>
                      <SelectItem value="Brouillon">Brouillon</SelectItem>
                      <SelectItem value="Publié">Publié</SelectItem>
                    </SelectContent>
                  </Select>
                  <FormDescription>
                    Les brouillons ne sont pas visibles sur l&apos;application mobile.
                  </FormDescription>
                  <FormMessage />
                </FormItem>
              )}
            />

            <FormField
              control={form.control}
              name="contenu"
              render={({ field }) => (
                <FormItem>
                  <FormLabel>Contenu</FormLabel>
                  <FormControl>
                    <Textarea
                      placeholder="Rédigez votre article ici..."
                      className="min-h-[300px] resize-y"
                      {...field}
                    />
                  </FormControl>
                  <FormMessage />
                </FormItem>
              )}
            />

            <div className="flex justify-end gap-4">
              <Button variant="outline" type="button" asChild>
                <Link href="/admin/articles">Annuler</Link>
              </Button>
              <Button type="submit" disabled={isLoading}>
                {isLoading && <Loader2 className="mr-2 h-4 w-4 animate-spin" />}
                Enregistrer l&apos;article
              </Button>
            </div>
          </form>
        </Form>
      </div>
    </div>
  );
}