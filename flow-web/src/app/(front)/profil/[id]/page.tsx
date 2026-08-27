"use client";

import { useEffect, useState } from "react";
import { useRouter, useParams } from "next/navigation";
import { zodResolver } from "@hookform/resolvers/zod";
import { useForm } from "react-hook-form";
import * as z from "zod";
import { Loader2, AlertCircle, Trash2, User, Settings } from "lucide-react";

import { Button } from "@/components/ui/button";
import { Input } from "@/components/ui/input";
import { Card, CardContent, CardHeader, CardTitle } from "@/components/ui/card";
import {
  Form,
  FormControl,
  FormField,
  FormItem,
  FormLabel,
} from "@/components/ui/form";
import { Switch } from "@/components/ui/switch";
import { apiClient } from "@/lib/api-client";
import {
  AlertDialog,
  AlertDialogAction,
  AlertDialogCancel,
  AlertDialogContent,
  AlertDialogDescription,
  AlertDialogFooter,
  AlertDialogHeader,
  AlertDialogTitle,
  AlertDialogTrigger,
} from "@/components/ui/alert-dialog";

const profileSchema = z.object({
  prenom: z.string().min(2, "Prénom requis."),
  nom: z.string().min(2, "Nom requis."),
  email: z.string().email("Email invalide."),
  notifications: z.boolean(),
  high_contrast: z.boolean(),
  reduced_anim: z.boolean(),
  text_size: z.coerce.number().min(1).max(5),
});

type ProfileFormValues = z.infer<typeof profileSchema>;

export default function ProfilDynamiquePage() {
  const router = useRouter();
  const params = useParams();

  // Extraction de l'ID depuis l'URL dynamique profil/[id]
  const userId = params.id as string;

  const [isLoading, setIsLoading] = useState(true);
  const [isSaving, setIsSaving] = useState(false);
  const [apiError, setApiError] = useState<string | null>(null);

  const form = useForm<ProfileFormValues>({
    resolver: zodResolver(profileSchema),
    defaultValues: {
      prenom: "",
      nom: "",
      email: "",
      notifications: true,
      high_contrast: false,
      reduced_anim: false,
      text_size: 3,
    },
  });

  // Chargement des informations de l'utilisateur spécifique
  useEffect(() => {
    async function loadUser() {
      if (!userId) return;
      try {
        setIsLoading(true);
        setApiError(null);

        // Appel ciblé vers Laravel avec l'identifiant de la route
        const user = await apiClient.get<any>(`/user/${userId}`);

        const prefs =
          typeof user.preferences === "string"
            ? JSON.parse(user.preferences)
            : (user.preferences ?? {});

        form.reset({
          prenom: user.prenom ?? "",
          nom: user.nom ?? "",
          email: user.email ?? "",
          notifications: prefs.notifications ?? true,
          high_contrast: prefs.high_contrast ?? false,
          reduced_anim: prefs.reduced_anim ?? false,
          text_size: prefs.text_size ?? 3,
        });
      } catch (err: any) {
        setApiError(
          err.message ?? "Impossible de charger les informations de ce profil.",
        );
      } finally {
        setIsLoading(false);
      }
    }

    void loadUser();
  }, [userId, form]);

  // Envoi des modifications pour cet utilisateur
  async function onSubmit(data: ProfileFormValues) {
    setIsSaving(true);
    setApiError(null);
    try {
      await apiClient.put(`/user/${userId}`, {
        prenom: data.prenom,
        nom: data.nom,
        email: data.email,
        preferences: {
          notifications: data.notifications,
          high_contrast: data.high_contrast,
          reduced_anim: data.reduced_anim,
          text_size: data.text_size,
        },
      });
      router.refresh();
    } catch (err: any) {
      setApiError(err.message ?? "Erreur lors de la mise à jour du profil.");
    } finally {
      setIsSaving(false);
    }
  }

  // Suppression du compte ciblé
  async function handleDeleteAccount() {
    try {
      await apiClient.delete(`/user/${userId}`);
      router.push("/");
    } catch (err: any) {
      setApiError(err.message ?? "Erreur lors de la suppression du compte.");
    }
  }

  if (isLoading) {
    return (
      <div className="flex h-[50vh] items-center justify-center">
        <Loader2 className="text-primary h-8 w-8 animate-spin" />
      </div>
    );
  }

  return (
    <div className="mx-auto max-w-2xl space-y-8 pt-10">
      <div>
        <h1 className="text-3xl font-bold tracking-tight">
          Profil Utilisateur
        </h1>
        <p className="text-muted-foreground text-sm">Identifiant : {userId}</p>
      </div>

      {apiError && (
        <div className="bg-destructive/10 text-destructive flex items-center gap-2 rounded-md p-4">
          <AlertCircle className="h-4 w-4 shrink-0" />
          <p className="text-sm font-medium">{apiError}</p>
        </div>
      )}

      <Form {...form}>
        <form
          onSubmit={() => void form.handleSubmit(onSubmit)}
          className="space-y-6"
        >
          <Card>
            <CardHeader>
              <CardTitle className="flex items-center gap-2">
                <User className="text-primary h-5 w-5" /> Informations
                Personnelles
              </CardTitle>
            </CardHeader>
            <CardContent className="space-y-4">
              <div className="grid grid-cols-2 gap-4">
                <FormField
                  control={form.control}
                  name="prenom"
                  render={({ field }) => (
                    <FormItem>
                      <FormLabel>Prénom</FormLabel>
                      <FormControl>
                        <Input {...field} />
                      </FormControl>
                    </FormItem>
                  )}
                />
                <FormField
                  control={form.control}
                  name="nom"
                  render={({ field }) => (
                    <FormItem>
                      <FormLabel>Nom</FormLabel>
                      <FormControl>
                        <Input {...field} />
                      </FormControl>
                    </FormItem>
                  )}
                />
              </div>
              <FormField
                control={form.control}
                name="email"
                render={({ field }) => (
                  <FormItem>
                    <FormLabel>Adresse Email</FormLabel>
                    <FormControl>
                      <Input {...field} />
                    </FormControl>
                  </FormItem>
                )}
              />
            </CardContent>
          </Card>

          <Card>
            <CardHeader>
              <CardTitle className="flex items-center gap-2">
                <Settings className="text-primary h-5 w-5" /> Préférences
                d&apos;accessibilité
              </CardTitle>
            </CardHeader>
            <CardContent className="space-y-4">
              <FormField
                control={form.control}
                name="notifications"
                render={({ field }) => (
                  <div className="flex items-center justify-between border-b py-2">
                    <FormLabel className="cursor-pointer">
                      Activer les notifications
                    </FormLabel>
                    <Switch
                      checked={field.value}
                      onCheckedChange={field.onChange}
                    />
                  </div>
                )}
              />
              <FormField
                control={form.control}
                name="high_contrast"
                render={({ field }) => (
                  <div className="flex items-center justify-between border-b py-2">
                    <FormLabel className="cursor-pointer">
                      Mode contraste élevé
                    </FormLabel>
                    <Switch
                      checked={field.value}
                      onCheckedChange={field.onChange}
                    />
                  </div>
                )}
              />
              <FormField
                control={form.control}
                name="reduced_anim"
                render={({ field }) => (
                  <div className="flex items-center justify-between py-2">
                    <FormLabel className="cursor-pointer">
                      Animations réduites
                    </FormLabel>
                    <Switch
                      checked={field.value}
                      onCheckedChange={field.onChange}
                    />
                  </div>
                )}
              />
            </CardContent>
          </Card>

          <div className="flex items-center justify-between pt-4">
            <AlertDialog>
              <AlertDialogTrigger asChild>
                <Button variant="destructive" className="gap-2">
                  <Trash2 className="h-4 w-4" /> Supprimer le compte
                </Button>
              </AlertDialogTrigger>
              <AlertDialogContent>
                <AlertDialogHeader>
                  <AlertDialogTitle>
                    Êtes-vous absolument sûr ?
                  </AlertDialogTitle>
                  <AlertDialogDescription>
                    Cette action supprimera définitivement le compte utilisateur
                    associé de la base de données de l&apos;application Flow.
                  </AlertDialogDescription>
                </AlertDialogHeader>
                <AlertDialogFooter>
                  <AlertDialogCancel>Annuler</AlertDialogCancel>
                  <AlertDialogAction
                    onClick={handleDeleteAccount}
                    className="bg-destructive hover:bg-destructive/90"
                  >
                    Confirmer la suppression
                  </AlertDialogAction>
                </AlertDialogFooter>
              </AlertDialogContent>
            </AlertDialog>

            <Button type="submit" disabled={isSaving}>
              {isSaving && <Loader2 className="mr-2 h-4 w-4 animate-spin" />}
              Sauvegarder les modifications
            </Button>
          </div>
        </form>
      </Form>
    </div>
  );
}
