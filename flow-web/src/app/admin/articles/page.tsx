"use client";

import { useEffect, useState } from "react";
import Link from "next/link";
import { Plus, Search, MoreHorizontal, Pencil, Trash2, Loader2 } from "lucide-react";
import { apiClient } from "@/lib/api-client";
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

const initialArticles = [
  { id: "1", titre: "L'importance de la récupération active", statut: "Publié", date: "2026-05-18", vues: 1240 },
  { id: "2", titre: "Comment bien structurer sa semaine d'entraînement", statut: "Brouillon", date: "2026-05-19", vues: 0 },
  { id: "3", titre: "Nutrition : Que manger avant l'effort ?", statut: "Publié", date: "2026-05-20", vues: 85 },
];

interface Article {
  id: string;
  titre: string;
  statut: "Publié" | "Brouillon";
  date: string;
  vues: number;
}

export default function ArticlesCrudPage() {
  const [isDeleteDialogOpen, setIsDeleteDialogOpen] = useState(false);
  const [articleToDelete, setArticleToDelete] = useState<{ id: string; titre: string } | null>(null);
    const [isDeleting, setIsDeleting] = useState(false);
    const [articles, setArticles] = useState<Article[]>([]);
  const [isLoading, setIsLoading] = useState(true);
  const [error, setError] = useState<string | null>(null);
    useEffect(() => {
    async function loadArticles() {
      try {
        setIsLoading(true);
        const data = await apiClient.get<Article[]>("/articles");
        setArticles(data);
      } catch (err: any) {
        setError(err.message || "Impossible de récupérer les articles.");
      } finally {
        setIsLoading(false);
      }
    }

    void loadArticles();
  }, []);

  // Déclencheur d'ouverture de la modale
  const openDeleteModal = (id: string, titre: string) => {
    setArticleToDelete({ id, titre });
    setIsDeleteDialogOpen(true);
  };

  // Logique de suppression effective auprès de l'API
const handleDeleteConfirm = async () => {
    if (!articleToDelete) return;
    setIsDeleting(true);
    try {
      // Appel de suppression réel vers ton API
      await apiClient.delete(`/articles/${articleToDelete.id}`);
      
      setArticles(articles.filter((art) => art.id !== articleToDelete.id));
      setIsDeleteDialogOpen(false);
    } catch (err) {
      console.error("Erreur de suppression :", err);
    } finally {
      setIsDeleting(false);
      setArticleToDelete(null);
    }
  };

  if (isLoading) {
    return (
      <div className="flex items-center justify-center h-[40vh]">
        <Loader2 className="h-8 w-8 animate-spin text-primary" />
      </div>
    );
  }

  if (error) {
    return (
      <div className="p-4 rounded-md bg-destructive/10 text-destructive text-sm font-medium">
        {error}
      </div>
    );
  }

  return (
    <div className="space-y-6">
      <div className="flex flex-col gap-4 sm:flex-row sm:items-center sm:justify-between">
        <div>
          <h1 className="text-3xl font-bold tracking-tight">Articles</h1>
          <p className="text-muted-foreground">Gérez le contenu éditorial de l&apos;application Flow.</p>
        </div>
        <Button asChild className="gap-2">
          <Link href="/admin/articles/nouveau">
            <Plus className="h-4 w-4" />
            Créer un article
          </Link>
        </Button>
      </div>

      <div className="flex items-center gap-2">
        <div className="relative flex-1 max-w-sm">
          <Search className="absolute left-2.5 top-2.5 h-4 w-4 text-muted-foreground" />
          <Input type="search" placeholder="Rechercher un article..." className="pl-8 bg-background" />
        </div>
      </div>

      <div className="rounded-md border bg-background">
        <Table>
          <TableHeader>
            <TableRow>
              <TableHead>Titre</TableHead>
              <TableHead>Statut</TableHead>
              <TableHead>Date de création</TableHead>
              <TableHead className="text-right">Vues</TableHead>
              <TableHead className="w-[80px]"></TableHead>
            </TableRow>
          </TableHeader>
          <TableBody>
            {articles.map((article) => (
              <TableRow key={article.id}>
                <TableCell className="font-medium">{article.titre}</TableCell>
                <TableCell>
                  <span className={`inline-flex items-center rounded-full px-2.5 py-0.5 text-xs font-semibold ${
                    article.statut === "Publié" ? "bg-green-100 text-green-800" : "bg-yellow-100 text-yellow-800"
                  }`}>
                    {article.statut}
                  </span>
                </TableCell>
                <TableCell>{article.date}</TableCell>
                <TableCell className="text-right">{article.vues}</TableCell>
                <TableCell>
                  <DropdownMenu>
                    <DropdownMenuTrigger asChild>
                      <Button variant="ghost" className="h-8 w-8 p-0">
                        <MoreHorizontal className="h-4 w-4" />
                      </Button>
                    </DropdownMenuTrigger>
                    <DropdownMenuContent align="end">
                      <DropdownMenuItem asChild className="cursor-pointer">
                        {/* Redirection dynamique vers la page d'édition */}
                        <Link href={`/admin/articles/${article.id}/editer`} className="flex items-center gap-2">
                          <Pencil className="h-4 w-4" />
                          Modifier
                        </Link>
                      </DropdownMenuItem>
                      <DropdownMenuItem 
                        onClick={() => openDeleteModal(article.id, article.titre)}
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

      {/* COMPOSANT DE MODALE DE CONFIRMATION (SHADCN/UI) */}
      <AlertDialog open={isDeleteDialogOpen} onOpenChange={setIsDeleteDialogOpen}>
        <AlertDialogContent>
          <AlertDialogHeader>
            <AlertDialogTitle>Êtes-vous absolument sûr ?</AlertDialogTitle>
            <AlertDialogDescription>
              Cette action est irréversible. Cela supprimera définitivement l&apos;article{" "}
              <strong className="text-foreground">{articleToDelete?.titre}</strong> de la base de données 
              et le retirera de l&apos;application mobile Flow.
            </AlertDialogDescription>
          </AlertDialogHeader>
          <AlertDialogFooter>
            <AlertDialogCancel disabled={isDeleting}>Annuler</AlertDialogCancel>
            <AlertDialogAction 
              onClick={(e) => {
                e.preventDefault(); // Empêche la fermeture automatique pour laisser l'asynchrone tourner
                void handleDeleteConfirm();
              }}
              className="bg-destructive text-destructive-foreground hover:bg-destructive/90"
              disabled={isDeleting}
            >
              {isDeleting && <Loader2 className="mr-2 h-4 w-4 animate-spin" />}
              Confirmer la suppression
            </AlertDialogAction>
          </AlertDialogFooter>
        </AlertDialogContent>
      </AlertDialog>
    </div>
  );
}