"use client";

import { useState } from "react";
import Link from "next/link";
import { Plus, Search, MoreHorizontal, Pencil, Trash2, Loader2, PlayCircle } from "lucide-react";

import { Button } from "@/components/ui/button";
import { Input } from "@/components/ui/input";
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

// Fausses données pour les activités
const initialActivites = [
  { id: "1", titre: "Séance de Mobilité", categorie: "Récupération", duree: "15 min", statut: "Actif" },
  { id: "2", titre: "Cardio Haute Intensité", categorie: "HIIT", duree: "30 min", statut: "Actif" },
  { id: "3", titre: "Test d'effort (En cours de montage)", categorie: "Cardio", duree: "45 min", statut: "Inactif" },
];

export default function ActivitesCrudPage() {
  const [activites, setActivites] = useState(initialActivites);
  const [isDeleteDialogOpen, setIsDeleteDialogOpen] = useState(false);
  const [activiteToDelete, setActiviteToDelete] = useState<{ id: string; titre: string } | null>(null);
  const [isDeleting, setIsDeleting] = useState(false);

  const openDeleteModal = (id: string, titre: string) => {
    setActiviteToDelete({ id, titre });
    setIsDeleteDialogOpen(true);
  };

  const handleDeleteConfirm = async () => {
    if (!activiteToDelete) return;
    setIsDeleting(true);
    try {
      // Simulation d'appel API
      await new Promise((resolve) => setTimeout(resolve, 800));
      setActivites(activites.filter((act) => act.id !== activiteToDelete.id));
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
          <h1 className="text-3xl font-bold tracking-tight">Activités & Exercices</h1>
          <p className="text-muted-foreground">Gérez le catalogue des entraînements de Flow.</p>
        </div>
        <Button asChild className="gap-2">
          <Link href="/admin/activites/nouveau">
            <Plus className="h-4 w-4" />
            Nouvelle activité
          </Link>
        </Button>
      </div>

      <div className="flex items-center gap-2">
        <div className="relative flex-1 max-w-sm">
          <Search className="absolute left-2.5 top-2.5 h-4 w-4 text-muted-foreground" />
          <Input type="search" placeholder="Rechercher un exercice..." className="pl-8 bg-background" />
        </div>
      </div>

      <div className="rounded-md border bg-background">
        <Table>
          <TableHeader>
            <TableRow>
              <TableHead>Titre</TableHead>
              <TableHead>Catégorie</TableHead>
              <TableHead>Durée</TableHead>
              <TableHead>Statut</TableHead>
              <TableHead className="w-[80px]"></TableHead>
            </TableRow>
          </TableHeader>
          <TableBody>
            {activites.map((activite) => (
              <TableRow key={activite.id}>
                <TableCell className="font-medium flex items-center gap-3">
                  <PlayCircle className="h-8 w-8 text-muted-foreground/50" />
                  {activite.titre}
                </TableCell>
                <TableCell>
                  <span className="inline-flex items-center rounded-full bg-primary/10 px-2.5 py-0.5 text-xs font-semibold text-primary">
                    {activite.categorie}
                  </span>
                </TableCell>
                <TableCell className="text-muted-foreground font-medium">{activite.duree}</TableCell>
                <TableCell>
                  <span className={`inline-flex items-center rounded-full px-2.5 py-0.5 text-xs font-semibold ${
                    activite.statut === "Actif" ? "bg-green-100 text-green-800" : "bg-muted text-muted-foreground"
                  }`}>
                    {activite.statut}
                  </span>
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
                        <Link href={`/admin/activites/${activite.id}/editer`} className="flex items-center gap-2">
                          <Pencil className="h-4 w-4" />
                          Modifier
                        </Link>
                      </DropdownMenuItem>
                      <DropdownMenuItem 
                        onClick={() => openDeleteModal(activite.id, activite.titre)}
                        className="cursor-pointer text-destructive focus:bg-destructive/10 focus:text-destructive flex items-center gap-2"
                      >
                        <Trash2 className="h-4 w-4" />
                        Supprimer
                      </DropdownMenuItem>
                    </DropdownMenuContent>
                  </DropdownMenu>
                </TableCell>
              </TableRow>
            ))}
          </TableBody>
        </Table>
      </div>

      <AlertDialog open={isDeleteDialogOpen} onOpenChange={setIsDeleteDialogOpen}>
        <AlertDialogContent>
          <AlertDialogHeader>
            <AlertDialogTitle>Supprimer cette activité ?</AlertDialogTitle>
            <AlertDialogDescription>
              L&apos;activité <strong className="text-foreground">{activiteToDelete?.titre}</strong> ne sera plus disponible dans l&apos;application mobile. Cette action est irréversible.
            </AlertDialogDescription>
          </AlertDialogHeader>
          <AlertDialogFooter>
            <AlertDialogCancel disabled={isDeleting}>Annuler</AlertDialogCancel>
            <AlertDialogAction 
              onClick={(e) => { e.preventDefault(); void handleDeleteConfirm(); }}
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