"use client";

import { useEffect, useState } from "react";
import { useRouter, useParams } from "next/navigation";
import { zodResolver } from "@hookform/resolvers/zod";
import { useForm } from "react-hook-form";
import * as z from "zod";
import { ArrowLeft, Loader2, AlertCircle } from "lucide-react";
import Link from "next/link";

import { Button } from "@/components/ui/button";
import { Input } from "@/components/ui/input";
import { Textarea } from "@/components/ui/textarea";
import { apiClient } from "@/lib/api-client";
import { Form, FormControl, FormField, FormItem, FormLabel, FormMessage } from "@/components/ui/form";

const articleSchema = z.object({
  titre: z.string().min(3, "Le titre est requis."),
  auteur: z.string().min(2, "L'auteur est requis."),
  contenu: z.string().min(10, "Le contenu est trop court."),
  image_url: z.string().optional(),
  tags: z.string().optional(),
});

type ArticleFormValues = z.infer<typeof articleSchema>;

export default function EditerArticlePage() {
  const router = useRouter();
  const params = useParams();
  const articleId = params.id as string;

  const [isFetching, setIsFetching] = useState(true);
  const [isSubmitting, setIsSubmitting] = useState(false);
  const [apiError, setApiError] = useState<string | null>(null);

  const form = useForm<ArticleFormValues>({
    resolver: zodResolver(articleSchema),
    defaultValues: { titre: "", auteur: "", contenu: "", image_url: "", tags: "" },
  });

  useEffect(() => {
    async function loadArticle() {
      try {
        const data = await apiClient.get<any>(`/articles/${articleId}`);
        const item = data.data || data;
        form.reset({
          titre: item.titre || "",
          auteur: item.auteur || "",
          contenu: item.contenu || "",
          image_url: item.image_url || "",
          tags: Array.isArray(item.tags) ? item.tags.join(', ') : (item.tags || ""),
        });
      } catch (error: any) {
        setApiError(error.message || "Impossible de charger l'article.");
      } finally {
        setIsFetching(false);
      }
    }
    if (articleId) void loadArticle();
  }, [articleId, form]);

  async function onSubmit(data: ArticleFormValues) {
    setIsSubmitting(true);
    setApiError(null);
    try {
      const payload = {
        titre: data.titre,
        auteur: data.auteur,
        contenu: data.contenu,
        image_url: data.image_url,
        tags: data.tags ? data.tags.split(',').map(t => t.trim()) : [],
      };
      await apiClient.put(`/articles/${articleId}`, payload);
      router.push("/admin/articles");
      router.refresh();
    } catch (error: any) {
      setApiError(error.message || "Erreur de mise à jour.");
    } finally {
      setIsSubmitting(false);
    }
  }

  if (isFetching) return <div className="flex h-[50vh] items-center justify-center"><Loader2 className="h-8 w-8 animate-spin" /></div>;

  return (
    <div className="max-w-3xl space-y-6">
      <div className="flex items-center gap-4">
        <Button variant="ghost" size="icon" asChild><Link href="/admin/articles"><ArrowLeft className="h-5 w-5" /></Link></Button>
        <h1 className="text-3xl font-bold">Modifier l&apos;article</h1>
      </div>
      
      {apiError && <div className="rounded-md bg-destructive/10 p-4 text-destructive">{apiError}</div>}

      <div className="rounded-md border bg-background p-6">
        <Form {...form}>
          <form onSubmit={form.handleSubmit(onSubmit)} className="space-y-6">
            <div className="grid grid-cols-2 gap-4">
              <FormField control={form.control} name="titre" render={({ field }) => (<FormItem><FormLabel>Titre</FormLabel><FormControl><Input {...field} /></FormControl></FormItem>)} />
              <FormField control={form.control} name="auteur" render={({ field }) => (<FormItem><FormLabel>Auteur</FormLabel><FormControl><Input {...field} /></FormControl></FormItem>)} />
            </div>
            <FormField control={form.control} name="image_url" render={({ field }) => (<FormItem><FormLabel>URL de l&apos;image</FormLabel><FormControl><Input {...field} /></FormControl></FormItem>)} />
            <FormField control={form.control} name="tags" render={({ field }) => (<FormItem><FormLabel>Tags (séparés par des virgules)</FormLabel><FormControl><Input {...field} /></FormControl></FormItem>)} />
            <FormField control={form.control} name="contenu" render={({ field }) => (<FormItem><FormLabel>Contenu</FormLabel><FormControl><Textarea className="min-h-[300px]" {...field} /></FormControl></FormItem>)} />
            <div className="flex justify-end gap-4">
              <Button variant="outline" type="button" asChild><Link href="/admin/articles">Annuler</Link></Button>
              <Button type="submit" disabled={isSubmitting}>{isSubmitting && <Loader2 className="mr-2 h-4 w-4 animate-spin" />} Modifier</Button>
            </div>
          </form>
        </Form>
      </div>
    </div>
  );
}