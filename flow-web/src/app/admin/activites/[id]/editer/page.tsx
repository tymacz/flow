"use client";

import { useEffect, useState } from "react";
import { useRouter, useParams } from "next/navigation";
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
  FormField,
  FormItem,
  FormLabel,
  FormMessage,
} from "@/components/ui/form";

// On réutilise le schéma Zod des activités pour assurer la cohérence de validation
const activiteSchema = z.object({
  titre: z.string().min(3, "Le titre est trop court."),
  categorie: z.string().min(1, "Veuillez sélectionner une catégorie."),
  duree: z.coerce.number().min(1, "La durée doit être d'au moins 1 minute."),
  statut: z.enum(["Actif", "Inactif"]),
  consignes: z.string().min(10, "Veuillez détailler les consignes de l'exercice."),
});

type ActiviteFormValues = z.infer<typeof activiteSchema>;

export default function EditerActivitePage() {
  const router = useRouter();
  const params = useParams();
  const activiteId = params.id as string;

  const [isFetching, setIsFetching] = useState(true);
  const [isSubmitting, setIsSubmitting] = useState(false);

  // 1. Initialisation du formulaire avec des valeurs par défaut
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

  // 2. Récupération asynchrone des données de l'activité cible
  useEffect(() => {
    async function fetchActivite() {
      try {
        // ICI : Remplacer par ton appel API réel, par exemple :
        // const res = await fetch(`https://api.ton-backend.com/activites/${activiteId}`)
        // const data = await res.json()
        
        // Simulation d'attente de réponse de l'API
        await new Promise((resolve) => setTimeout(resolve, 800));
        
        const mockActiviteData = {
          titre: "Séance de Mobilité",
          categorie: "Récupération",
          duree: 15,
          statut: "Actif" as const,
          consignes: "Installez-vous confortablement sur un tapis de sol. Commencez par des rotations lentes de la tête, puis passez aux épaules. Maintenez chaque posture d'étirement pendant au moins 30 secondes en respirant profondément, sans jamais forcer sur l'articulation.",
        };

        // Remplissage dynamique des champs du formulaire
        form.reset(mockActiviteData);
      } catch (error) {
        console.error("Erreur lors du chargement de l'activité :", error);
      } {
        setIsFetching(false);
      }
    }

    if (activiteId) void fetchActivite();
  }, [activiteId, form]);

  // 3. Envoi des modifications à l'API (requête PUT ou PATCH)
  async function onSubmit(data: ActiviteFormValues) {
    setIsSubmitting(true);
    try {
      // ICI : Remplacer par la requête de mise à jour vers ton API, par exemple :
      // await fetch(`https://api.ton-backend.com/activites/${activiteId}`, { method: 'PUT', body: JSON.stringify(data) })
      
      await new Promise((resolve) => setTimeout(resolve, 1000));
      console.log(`Données de l'activité ${activiteId} mises à jour :`, data);

      router.push("/admin/activites");
      router.refresh();
    } catch (error) {
      console.error("Erreur lors de la modification :", error);
    } finally {
      setIsSubmitting(false);
    }
  }

  // Écran d'attente pendant la récupération des données de l'API
  if (isFetching) {
    return (
      <div className="flex flex-1 items-center justify-center h-[50vh]">
        <Loader2 className="h-8 w-8 animate-spin text-primary" />
        <span className="ml-2 text-muted-foreground text-sm font-medium">
          Chargement des paramètres de l&apos;exercice...
        </span>
      </div>
    );
  }

  return (
    <div className="max-w-4xl space-y-6">
      {/* En-tête de retour */}
      <div className="flex items-center gap-4">
        <Button variant="ghost" size="icon" asChild>
          <Link href="/admin/activites">
            <ArrowLeft className="h-5 w-5" />
          </Link>
        </Button>
        <div>
          <h1 className="text-3xl font-bold tracking-tight">Modifier l&apos;activité</h1>
          <p className="text-muted-foreground text-sm">ID : {activiteId}</p>
        </div>
      </div>

      {/* Grid asymétrique identique à la création */}
      <div className="grid grid-cols-1 md:grid-cols-3 gap-6">
        
        {/* Formulaire principal */}
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
                      <Input {...field} />
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
                      <Select onValueChange={field.onChange} value={field.value}>
                        <FormControl>
                          <SelectTrigger>
                            <SelectValue />
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
                    <Select onValueChange={field.onChange} value={field.value}>
                      <FormControl>
                        <SelectTrigger>
                          <SelectValue />
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
                      <Textarea className="min-h-[150px] resize-y" {...field} />
                    </FormControl>
                    <FormMessage />
                  </FormItem>
                )}
              />

              <div className="flex justify-end gap-4 pt-4 border-t border-border">
                <Button variant="outline" type="button" asChild>
                  <Link href="/admin/activites">Annuler</Link>
                </Button>
                <Button type="submit" disabled={isSubmitting}>
                  {isSubmitting && <Loader2 className="mr-2 h-4 w-4 animate-spin" />}
                  Enregistrer les modifications
                </Button>
              </div>
            </form>
          </Form>
        </div>

        {/* Bloc média latéral */}
        <div className="space-y-6">
          <div className="rounded-md border bg-background p-6">
            <h3 className="font-semibold mb-4 text-sm uppercase tracking-wider text-muted-foreground">
              Média associé
            </h3>
            <div className="border-2 border-dashed border-border rounded-lg p-8 flex flex-col items-center justify-center text-center gap-3 bg-muted/30 cursor-pointer hover:bg-muted/50 transition-colors">
              <UploadCloud className="h-10 w-10 text-muted-foreground" />
              <div className="space-y-1">
                <p className="text-sm font-medium">Modifier la vidéo ou l&apos;image</p>
                <p className="text-xs text-muted-foreground">Format MP4, JPG ou PNG</p>
              </div>
            </div>
          </div>
        </div>

      </div>
    </div>
  );
}