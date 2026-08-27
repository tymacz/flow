"use client";

import { useState } from "react";
import { useRouter } from "next/navigation";
import { zodResolver } from "@hookform/resolvers/zod";
import { useForm } from "react-hook-form";
import * as z from "zod";
import { ArrowLeft, Loader2, AlertCircle } from "lucide-react";
import Link from "next/link";

import { Button } from "@/components/ui/button";
import { Input } from "@/components/ui/input";
import { Textarea } from "@/components/ui/textarea";
import { apiClient } from "@/lib/api-client";
import {
  Form,
  FormControl,
  FormField,
  FormItem,
  FormLabel,
  FormMessage,
} from "@/components/ui/form";

const articleSchema = z.object({
  titre: z.string().min(3, "Le titre est requis."),
  auteur: z.string().min(2, "L'auteur est requis."),
  contenu: z.string().min(10, "Le contenu est trop court."),
  image_url: z.string().optional(),
  tags: z.string().optional(), // On le gère en string dans le form, on le coupera en array à l'envoi
});

type ArticleFormValues = z.infer<typeof articleSchema>;

export default function NouvelArticlePage() {
  const router = useRouter();
  const [isLoading, setIsLoading] = useState(false);
  const [apiError, setApiError] = useState<string | null>(null);

  const form = useForm<ArticleFormValues>({
    resolver: zodResolver(articleSchema),
    defaultValues: {
      titre: "",
      auteur: "",
      contenu: "",
      image_url: "",
      tags: "",
    },
  });

  async function onSubmit(data: ArticleFormValues) {
    setIsLoading(true);
    setApiError(null);

    try {
      const payload = {
        titre: data.titre,
        auteur: data.auteur,
        contenu: data.contenu,
        image_url: data.image_url,
        // Conversion de "sport, santé" en ["sport", "santé"]
        tags: data.tags ? data.tags.split(",").map((t) => t.trim()) : [],
        date_publication: new Date().toISOString(), // Ajout automatique de la date
      };

      await apiClient.post("/articles", payload);
      router.push("/admin/articles");
      router.refresh();
    } catch (error: any) {
      setApiError(error.message ?? "Erreur lors de la création.");
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
            Rédigez un article pour le blog.
          </p>
        </div>
      </div>

      {apiError && (
        <div className="bg-destructive/10 text-destructive flex items-center gap-2 rounded-md p-4">
          <AlertCircle className="h-5 w-5" />
          <p className="text-sm font-medium">{apiError}</p>
        </div>
      )}

      <div className="bg-background rounded-md border p-6">
        <Form {...form}>
          <form
            onSubmit={() => voidform.handleSubmit(onSubmit)}
            className="space-y-6"
          >
            <div className="grid grid-cols-2 gap-4">
              <FormField
                control={form.control}
                name="titre"
                render={({ field }) => (
                  <FormItem>
                    <FormLabel>Titre</FormLabel>
                    <FormControl>
                      <Input {...field} />
                    </FormControl>
                    <FormMessage />
                  </FormItem>
                )}
              />
              <FormField
                control={form.control}
                name="auteur"
                render={({ field }) => (
                  <FormItem>
                    <FormLabel>Auteur</FormLabel>
                    <FormControl>
                      <Input placeholder="John Doe" {...field} />
                    </FormControl>
                    <FormMessage />
                  </FormItem>
                )}
              />
            </div>

            <FormField
              control={form.control}
              name="image_url"
              render={({ field }) => (
                <FormItem>
                  <FormLabel>URL de l&apos;image de couverture</FormLabel>
                  <FormControl>
                    <Input placeholder="https://..." {...field} />
                  </FormControl>
                  <FormMessage />
                </FormItem>
              )}
            />

            <FormField
              control={form.control}
              name="tags"
              render={({ field }) => (
                <FormItem>
                  <FormLabel>Tags (séparés par des virgules)</FormLabel>
                  <FormControl>
                    <Input
                      placeholder="nutrition, sport, mental..."
                      {...field}
                    />
                  </FormControl>
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
              <Button type="submit" disabled={isLoading}>
                {isLoading && <Loader2 className="mr-2 h-4 w-4 animate-spin" />}{" "}
                Enregistrer
              </Button>
            </div>
          </form>
        </Form>
      </div>
    </div>
  );
}
