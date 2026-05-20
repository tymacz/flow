"use client";

import { useEffect, useState } from "react";
import { useRouter, useParams } from "next/navigation";
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

// On réutilise exactement le même schéma Zod que pour la création
const articleSchema = z.object({
  titre: z.string().min(5, {
    message: "Le titre doit contenir au moins 5 caractères.",
  }),
  contenu: z.string().min(20, {
    message: "Le contenu est trop court pour un article.",
  }),
  statut: z.enum(["Publié", "Brouillon"]),
});

type ArticleFormValues = z.infer<typeof articleSchema>;

export default function EditerArticlePage() {
  const router = useRouter();
  const params = useParams();
  const articleId = params.id as string;

  const [isFetching, setIsFetching] = useState(true);
  const [isSubmitting, setIsSubmitting] = useState(false);

  // 1. Initialisation du formulaire vide
  const form = useForm<ArticleFormValues>({
    resolver: zodResolver(articleSchema),
    defaultValues: {
      titre: "",
      contenu: "",
      statut: "Brouillon",
    },
  });

  // 2. Simulation de la récupération des données de l'article via l'API
  useEffect(() => {
    async function fetchArticle() {
      try {
        // ICI : Remplacer par ton appel API réel, ex:
        // const res = await fetch(`https://api.ton-backend.com/articles/${articleId}`)
        // const data = await res.json()
        
        // Simulation de données reçues de l'API :
        await new Promise((resolve) => setTimeout(resolve, 800));
        const mockArticleData = {
          titre: "L'importance de la récupération active",
          contenu: "Voici le contenu complet et détaillé de l'article récupéré depuis l'API de l'application Flow. Il contient toutes les explications nécessaires pour les utilisateurs.",
          statut: "Publié" as const,
        };

        // On injecte les données de l'API dans le formulaire
        form.reset(mockArticleData);
      } catch (error) {
        console.error("Erreur de récupération :", error);
      } finally {
        setIsFetching(false);
      }
    }

    if (articleId) void fetchArticle();
  }, [articleId, form]);

  // 3. Soumission des modifications (PUT ou PATCH)
  async function onSubmit(data: ArticleFormValues) {
    setIsSubmitting(true);
    try {
      // ICI : Appel API pour mettre à jour l'article, ex:
      // await fetch(`https://api.ton-backend.com/articles/${articleId}`, { method: 'PUT', ... })
      
      await new Promise((resolve) => setTimeout(resolve, 1000));
      console.log(`Article ${articleId} mis à jour avec succès :`, data);

      router.push("/admin/articles");
      router.refresh();
    } catch (error) {
      console.error(error);
    } {
      setIsSubmitting(false);
    }
  }

  if (isFetching) {
    return (
      <div className="flex flex-1 items-center justify-center h-[50vh]">
        <Loader2 className="h-8 w-8 animate-spin text-primary" />
        <span className="ml-2 text-muted-foreground">Chargement de l&apos;article...</span>
      </div>
    );
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
          <h1 className="text-3xl font-bold tracking-tight">Modifier l&apos;article</h1>
          <p className="text-muted-foreground">ID : {articleId}</p>
        </div>
      </div>

      <div className="rounded-md border bg-background p-6">
        <Form {...form}>
          <form onSubmit={form.handleSubmit(onSubmit)} className="space-y-8">
            <FormField
              control={form.control}
              name="titre"
              render={({ field }) => (
                <FormItem>
                  <FormLabel>Titre de l&apos;article</FormLabel>
                  <FormControl>
                    <Input {...field} />
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
                  <Select onValueChange={field.onChange} value={field.value}>
                    <FormControl>
                      <SelectTrigger>
                        <SelectValue />
                      </SelectTrigger>
                    </FormControl>
                    <SelectContent>
                      <SelectItem value="Brouillon">Brouillon</SelectItem>
                      <SelectItem value="Publié">Publié</SelectItem>
                    </SelectContent>
                  </Select>
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
                    <Textarea className="min-h-[300px] resize-y" {...field} />
                  </FormControl>
                  <FormMessage />
                </FormItem>
              )}
            />

            <div className="flex justify-end gap-4">
              <Button variant="outline" type="button" asChild>
                <Link href="/admin/articles">Annuler</Link>
              </Button>
              <Button type="submit" disabled={isSubmitting}>
                {isSubmitting && <Loader2 className="mr-2 h-4 w-4 animate-spin" />}
                Enregistrer les modifications
              </Button>
            </div>
          </form>
        </Form>
      </div>
    </div>
  );
}