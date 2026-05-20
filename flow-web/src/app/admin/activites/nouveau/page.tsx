"use client";

import { useState } from "react";
import { useRouter } from "next/navigation";
import { zodResolver } from "@hookform/resolvers/zod";
import { useForm } from "react-hook-form";
import * as z from "zod";
import { ArrowLeft, Loader2, UploadCloud } from "lucide-react";
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

// 1. Schéma adapté pour une activité sportive
const activiteSchema = z.object({
  titre: z.string().min(3, "Le titre est trop court."),
  categorie: z.string().min(1, "Veuillez sélectionner une catégorie."),
  duree: z.coerce.number().min(1, "La durée doit être d'au moins 1 minute."), // coerce force la conversion string -> number
  statut: z.enum(["Actif", "Inactif"]),
  consignes: z.string().min(10, "Veuillez détailler les consignes de l'exercice."),
});

type ActiviteFormValues = z.infer<typeof activiteSchema>;

export default function NouvelleActivitePage() {
  const router = useRouter();
  const [isLoading, setIsLoading] = useState(false);

  const form = useForm<ActiviteFormValues>({
    resolver: zodResolver(activiteSchema),
    defaultValues: {
      titre: "",
      categorie: "",
      duree: 15,
      statut: "Inactif",
      consignes: "",
    },
  });

  async function onSubmit(data: ActiviteFormValues) {
    setIsLoading(true);
    try {
      // API Call ici
      await new Promise((resolve) => setTimeout(resolve, 1000));
      console.log("Activité créée :", data);
      
      router.push("/admin/activites");
      router.refresh();
    } catch (error) {
      console.error(error);
    } finally {
      setIsLoading(false);
    }
  }

  return (
    <div className="max-w-4xl space-y-6">
      <div className="flex items-center gap-4">
        <Button variant="ghost" size="icon" asChild>
          <Link href="/admin/activites">
            <ArrowLeft className="h-5 w-5" />
          </Link>
        </Button>
        <div>
          <h1 className="text-3xl font-bold tracking-tight">Nouvelle Activité</h1>
          <p className="text-muted-foreground">Paramétrez un nouvel exercice pour vos utilisateurs.</p>
        </div>
      </div>

      <div className="grid grid-cols-1 md:grid-cols-3 gap-6">
        {/* Colonne Principale (Formulaire) */}
        <div className="md:col-span-2 rounded-md border bg-background p-6">
          <Form {...form}>
            <form onSubmit={form.handleSubmit(onSubmit)} className="space-y-6">
              
              <FormField
                control={form.control}
                name="titre"
                render={({ field }) => (
                  <FormItem>
                    <FormLabel>Nom de l&apos;exercice</FormLabel>
                    <FormControl>
                      <Input placeholder="Ex: Gainage ventral dynamique" {...field} />
                    </FormControl>
                    <FormMessage />
                  </FormItem>
                )}
              />

              <div className="grid grid-cols-2 gap-4">
                <FormField
                  control={form.control}
                  name="categorie"
                  render={({ field }) => (
                    <FormItem>
                      <FormLabel>Catégorie</FormLabel>
                      <Select onValueChange={field.onChange} defaultValue={field.value}>
                        <FormControl>
                          <SelectTrigger>
                            <SelectValue placeholder="Choisir..." />
                          </SelectTrigger>
                        </FormControl>
                        <SelectContent>
                          <SelectItem value="HIIT">HIIT</SelectItem>
                          <SelectItem value="Force">Force</SelectItem>
                          <SelectItem value="Mobilité">Mobilité</SelectItem>
                          <SelectItem value="Récupération">Récupération</SelectItem>
                        </SelectContent>
                      </Select>
                      <FormMessage />
                    </FormItem>
                  )}
                />

                <FormField
                  control={form.control}
                  name="duree"
                  render={({ field }) => (
                    <FormItem>
                      <FormLabel>Durée (en minutes)</FormLabel>
                      <FormControl>
                        <Input type="number" min="1" {...field} />
                      </FormControl>
                      <FormMessage />
                    </FormItem>
                  )}
                />
              </div>

              <FormField
                control={form.control}
                name="statut"
                render={({ field }) => (
                  <FormItem>
                    <FormLabel>Statut</FormLabel>
                    <Select onValueChange={field.onChange} defaultValue={field.value}>
                      <FormControl>
                        <SelectTrigger>
                          <SelectValue placeholder="Statut de l'activité" />
                        </SelectTrigger>
                      </FormControl>
                      <SelectContent>
                        <SelectItem value="Actif">Actif (Visible)</SelectItem>
                        <SelectItem value="Inactif">Inactif (Caché)</SelectItem>
                      </SelectContent>
                    </Select>
                    <FormMessage />
                  </FormItem>
                )}
              />

              <FormField
                control={form.control}
                name="consignes"
                render={({ field }) => (
                  <FormItem>
                    <FormLabel>Consignes d&apos;exécution</FormLabel>
                    <FormControl>
                      <Textarea 
                        placeholder="Détaillez les mouvements, la posture à adopter et les erreurs à éviter..." 
                        className="min-h-[150px] resize-y" 
                        {...field} 
                      />
                    </FormControl>
                    <FormMessage />
                  </FormItem>
                )}
              />

              <div className="flex justify-end gap-4 pt-4 border-t border-border">
                <Button variant="outline" type="button" asChild>
                  <Link href="/admin/activites">Annuler</Link>
                </Button>
                <Button type="submit" disabled={isLoading}>
                  {isLoading && <Loader2 className="mr-2 h-4 w-4 animate-spin" />}
                  Créer l&apos;activité
                </Button>
              </div>
            </form>
          </Form>
        </div>

        {/* Colonne Latérale (Médias) - Maquette pour plus tard */}
        <div className="space-y-6">
          <div className="rounded-md border bg-background p-6">
            <h3 className="font-semibold mb-4 text-sm uppercase tracking-wider text-muted-foreground">Média associé</h3>
            <div className="border-2 border-dashed border-border rounded-lg p-8 flex flex-col items-center justify-center text-center gap-3 bg-muted/30 cursor-pointer hover:bg-muted/50 transition-colors">
              <UploadCloud className="h-10 w-10 text-muted-foreground" />
              <div className="space-y-1">
                <p className="text-sm font-medium">Cliquez pour uploader</p>
                <p className="text-xs text-muted-foreground">Vidéo (MP4) ou Image (JPG, PNG)</p>
              </div>
            </div>
          </div>
        </div>

      </div>
    </div>
  );
}