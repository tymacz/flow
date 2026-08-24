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
import { Select, SelectContent, SelectItem, SelectTrigger, SelectValue } from "@/components/ui/select";
import { Form, FormControl, FormField, FormItem, FormLabel, FormMessage } from "@/components/ui/form";

const activiteSchema = z.object({
  titre: z.string().min(3, "Titre requis."),
  categorie: z.string().min(1, "Catégorie requise."),
  duree_minutes: z.coerce.number().min(1, "Durée invalide."),
  description: z.string().min(5, "Description requise."),
  image_url: z.string().optional(),
});

type ActiviteFormValues = z.infer<typeof activiteSchema>;

export default function EditerActivitePage() {
  const router = useRouter();
  const params = useParams();
  const activiteId = params.id as string;

  const [isFetching, setIsFetching] = useState(true);
  const [isSubmitting, setIsSubmitting] = useState(false);
  const [apiError, setApiError] = useState<string | null>(null);

  const form = useForm<ActiviteFormValues>({
    resolver: zodResolver(activiteSchema),
    defaultValues: { titre: "", categorie: "", duree_minutes: 15, description: "", image_url: "" },
  });

  useEffect(() => {
    async function loadActivite() {
      try {
        const data = await apiClient.get<any>(`/activities/${activiteId}`);
        const item = data.data || data;
        form.reset({
          titre: item.titre || "",
          categorie: item.categorie || "",
          duree_minutes: item.duree_minutes || 15,
          description: item.description || "",
          image_url: item.image_url || "",
        });
      } catch (error: any) {
        setApiError(error.message || "Impossible de charger l&apos;activité.");
      } finally {
        setIsFetching(false);
      }
    }
    if (activiteId) void loadActivite();
  }, [activiteId, form]);

  async function onSubmit(data: ActiviteFormValues) {
    setIsSubmitting(true);
    setApiError(null);
    try {
      await apiClient.put(`/activities/${activiteId}`, data);
      router.push("/admin/activites");
      router.refresh();
    } catch (error: any) {
      setApiError(error.message || "Erreur lors de la modification.");
    } finally {
      setIsSubmitting(false);
    }
  }

  if (isFetching) return <div className="flex h-[50vh] items-center justify-center"><Loader2 className="h-8 w-8 animate-spin" /></div>;

  return (
    <div className="max-w-3xl space-y-6">
      <div className="flex items-center gap-4">
        <Button variant="ghost" size="icon" asChild><Link href="/admin/activites"><ArrowLeft className="h-5 w-5" /></Link></Button>
        <h1 className="text-3xl font-bold">Modifier l&apos;activité</h1>
      </div>

      {apiError && <div className="rounded-md bg-destructive/10 p-4 text-destructive">{apiError}</div>}

      <div className="rounded-md border bg-background p-6">
        <Form {...form}>
          <form onSubmit={form.handleSubmit(onSubmit)} className="space-y-6">
            <FormField control={form.control} name="titre" render={({ field }) => (<FormItem><FormLabel>Nom</FormLabel><FormControl><Input {...field} /></FormControl></FormItem>)} />
            
            <div className="grid grid-cols-2 gap-4">
              <FormField control={form.control} name="categorie" render={({ field }) => (
                <FormItem>
                  <FormLabel>Catégorie</FormLabel>
                  <Select onValueChange={field.onChange} value={field.value}>
                    <FormControl><SelectTrigger><SelectValue /></SelectTrigger></FormControl>
                    <SelectContent>
                      <SelectItem value="HIIT">HIIT</SelectItem>
                      <SelectItem value="Force">Force</SelectItem>
                      <SelectItem value="Mobilité">Mobilité</SelectItem>
                      <SelectItem value="Respiration">Respiration</SelectItem>
                    </SelectContent>
                  </Select>
                </FormItem>
              )} />
              <FormField control={form.control} name="duree_minutes" render={({ field }) => (<FormItem><FormLabel>Durée (min)</FormLabel><FormControl><Input type="number" {...field} /></FormControl></FormItem>)} />
            </div>

            <FormField control={form.control} name="image_url" render={({ field }) => (<FormItem><FormLabel>URL de l&apos;image / miniature</FormLabel><FormControl><Input {...field} /></FormControl></FormItem>)} />
            <FormField control={form.control} name="description" render={({ field }) => (<FormItem><FormLabel>Description détaillée</FormLabel><FormControl><Textarea className="min-h-[150px]" {...field} /></FormControl></FormItem>)} />

            <div className="flex justify-end gap-4">
              <Button variant="outline" type="button" asChild><Link href="/admin/activites">Annuler</Link></Button>
              <Button type="submit" disabled={isSubmitting}>{isSubmitting && <Loader2 className="mr-2 h-4 w-4 animate-spin" />} Modifier</Button>
            </div>
          </form>
        </Form>
      </div>
    </div>
  );
}