"use client";

import { useState, useEffect } from "react";
import Link from "next/link";
import {
  Plus,
  MoreHorizontal,
  Pencil,
  Trash2,
  Loader2,
  PlayCircle,
  AlertCircle,
} from "lucide-react";

import { Button } from "@/components/ui/button";
import { apiClient } from "@/lib/api-client";
import {
  Table,
  TableBody,
  TableCell,
  TableHead,
  TableHeader,
  TableRow,
} from "@/components/ui/table";
import {
  DropdownMenu,
  DropdownMenuContent,
  DropdownMenuItem,
  DropdownMenuTrigger,
} from "@/components/ui/dropdown-menu";
import {
  AlertDialog,
  AlertDialogAction,
  AlertDialogCancel,
  AlertDialogContent,
  AlertDialogDescription,
  AlertDialogFooter,
  AlertDialogHeader,
  AlertDialogTitle,
} from "@/components/ui/alert-dialog";

interface Activity {
  _id: string;
  titre?: string;
  title?: string;
  categorie?: string;
  category?: string;
  duree_minutes?: number;
  duration?: number;
  statut?: string;
  status?: string;
}

export default function ActivitesCrudPage() {
  const [activites, setActivites] = useState<Activity[]>([]);
  const [isLoading, setIsLoading] = useState(true);
  const [apiError, setApiError] = useState<string | null>(null);

  const [isDeleteDialogOpen, setIsDeleteDialogOpen] = useState(false);
  const [activiteToDelete, setActiviteToDelete] = useState<{
    id: string;
    titre: string;
  } | null>(null);
  const [isDeleting, setIsDeleting] = useState(false);

  // CHARGEMENT DEPUIS LARAVEL
  useEffect(() => {
    async function fetchActivites() {
      try {
        // Attention au nom de ta route Laravel (activities ou activites)
        const response = await apiClient.get<any>("/activities");
        const items = response.data ?? response;
        setActivites(items);
      } catch (error: any) {
        setApiError(error.message ?? "Impossible de charger les activités.");
      } finally {
        setIsLoading(false);
      }
    }
    void fetchActivites();
  }, []);

  const openDeleteModal = (id: string, titre: string) => {
    setActiviteToDelete({ id, titre });
    setIsDeleteDialogOpen(true);
  };

  const handleDeleteConfirm = async () => {
    if (!activiteToDelete) return;
    setIsDeleting(true);
    try {
      // APPEL RÉEL DE SUPPRESSION
      await apiClient.delete(`/activities/${activiteToDelete.id}`);
      setActivites(activites.filter((act) => act._id !== activiteToDelete.id));
      setIsDeleteDialogOpen(false);
    } catch (error) {
      console.error(error);
    } finally {
      setIsDeleting(false);
      setActiviteToDelete(null);
    }
  };

  return (
    <div className="space-y-6">
      <div className="flex flex-col gap-4 sm:flex-row sm:items-center sm:justify-between">
        <div>
          <h1 className="text-3xl font-bold tracking-tight">
            Activités & Exercices
          </h1>
          <p className="text-muted-foreground">
            Gérez le catalogue des entraînements de Flow.
          </p>
        </div>
        <Button asChild className="gap-2">
          <Link href="/admin/activites/nouveau">
            <Plus className="h-4 w-4" />
            Nouvelle activité
          </Link>
        </Button>
      </div>

      {apiError && (
        <div className="bg-destructive/10 text-destructive flex items-center gap-2 rounded-md p-4">
          <AlertCircle className="h-5 w-5" />
          <p className="text-sm font-medium">{apiError}</p>
        </div>
      )}

      <div className="bg-background rounded-md border">
        <Table>
          <TableHeader>
            <TableRow>
              <TableHead>Titre</TableHead>
              <TableHead>Catégorie</TableHead>
              <TableHead>Durée</TableHead>
              <TableHead className="w-[80px]"></TableHead>
            </TableRow>
          </TableHeader>
          <TableBody>
            {isLoading ? (
              <TableRow>
                <TableCell colSpan={5} className="h-32 text-center">
                  <Loader2 className="text-muted-foreground mx-auto h-6 w-6 animate-spin" />
                </TableCell>
              </TableRow>
            ) : activites.length === 0 ? (
              <TableRow>
                <TableCell
                  colSpan={5}
                  className="text-muted-foreground h-32 text-center"
                >
                  Aucune activité trouvée.
                </TableCell>
              </TableRow>
            ) : (
              activites.map((activite) => {
                const displayTitle =
                  activite.titre ?? activite.title ?? "Sans titre";
                const displayCategory =
                  activite.categorie ?? activite.category ?? "Non classé";
                const displayDuration =
                  activite.duree_minutes ?? activite.duration ?? 0;
                const realId = activite._id ?? activite._id;

                return (
                  <TableRow key={realId}>
                    <TableCell className="flex items-center gap-3 font-medium">
                      <PlayCircle className="text-muted-foreground/50 h-8 w-8" />
                      {displayTitle}
                    </TableCell>
                    <TableCell>
                      <span className="bg-primary/10 text-primary inline-flex items-center rounded-full px-2.5 py-0.5 text-xs font-semibold">
                        {displayCategory}
                      </span>
                    </TableCell>
                    <TableCell className="text-muted-foreground font-medium">
                      {displayDuration} min
                    </TableCell>
                    <TableCell>
                      <DropdownMenu>
                        <DropdownMenuTrigger asChild>
                          <Button variant="ghost" className="h-8 w-8 p-0">
                            <MoreHorizontal className="h-4 w-4" />
                          </Button>
                        </DropdownMenuTrigger>
                        <DropdownMenuContent align="end">
                          <DropdownMenuItem asChild className="cursor-pointer">
                            <Link
                              href={`/admin/activites/${realId}/editer`}
                              className="flex items-center gap-2"
                            >
                              <Pencil className="h-4 w-4" />
                              Modifier
                            </Link>
                          </DropdownMenuItem>
                          <DropdownMenuItem
                            onClick={() =>
                              openDeleteModal(realId, displayTitle)
                            }
                            className="text-destructive focus:bg-destructive/10 focus:text-destructive flex cursor-pointer items-center gap-2"
                          >
                            <Trash2 className="h-4 w-4" />
                            Supprimer
                          </DropdownMenuItem>
                        </DropdownMenuContent>
                      </DropdownMenu>
                    </TableCell>
                  </TableRow>
                );
              })
            )}
          </TableBody>
        </Table>
      </div>

      <AlertDialog
        open={isDeleteDialogOpen}
        onOpenChange={setIsDeleteDialogOpen}
      >
        <AlertDialogContent>
          <AlertDialogHeader>
            <AlertDialogTitle>Supprimer cette activité ?</AlertDialogTitle>
            <AlertDialogDescription>
              L&apos;activité{" "}
              <strong className="text-foreground">
                {activiteToDelete?.titre}
              </strong>{" "}
              ne sera plus disponible dans l&apos;application mobile. Cette
              action est irréversible.
            </AlertDialogDescription>
          </AlertDialogHeader>
          <AlertDialogFooter>
            <AlertDialogCancel disabled={isDeleting}>Annuler</AlertDialogCancel>
            <AlertDialogAction
              onClick={(e) => {
                e.preventDefault();
                void handleDeleteConfirm();
              }}
              className="bg-destructive text-destructive-foreground hover:bg-destructive/90"
              disabled={isDeleting}
            >
              {isDeleting && <Loader2 className="mr-2 h-4 w-4 animate-spin" />}
              Supprimer
            </AlertDialogAction>
          </AlertDialogFooter>
        </AlertDialogContent>
      </AlertDialog>
    </div>
  );
}
