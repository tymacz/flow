"use client";

import { useState, useEffect } from "react";
import Link from "next/link";
import {
  Plus,
  Search,
  MoreHorizontal,
  Pencil,
  Trash2,
  Loader2,
  AlertCircle,
} from "lucide-react";

import { Button } from "@/components/ui/button";
import { Input } from "@/components/ui/input";
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

// Interface basée sur la structure probable de ton API
interface Article {
  _id: string;
  titre?: string;
  title?: string; // Au cas où Laravel renvoie 'title' au lieu de 'titre'
  auteur?: string;
  status?: string;
  created_at: string;
  vues?: number;
}

export default function ArticlesCrudPage() {
  const [articles, setArticles] = useState<Article[]>([]);
  const [isLoading, setIsLoading] = useState(true);
  const [apiError, setApiError] = useState<string | null>(null);

  const [isDeleteDialogOpen, setIsDeleteDialogOpen] = useState(false);
  const [articleToDelete, setArticleToDelete] = useState<{
    id: string;
    titre: string;
  } | null>(null);
  const [isDeleting, setIsDeleting] = useState(false);

  useEffect(() => {
    async function fetchArticles() {
      try {
        const response = await apiClient.get<any>("/articles");
        // Laravel encapsule souvent les listes dans "data" s'il y a une pagination
        const items = response.data ?? response;
        setArticles(items);
      } catch (error: any) {
        setApiError(error.message ?? "Impossible de charger les articles.");
      } finally {
        setIsLoading(false);
      }
    }
    void fetchArticles();
  }, []);

  const openDeleteModal = (id: string, titre: string) => {
    setArticleToDelete({ id, titre });
    setIsDeleteDialogOpen(true);
  };

  const handleDeleteConfirm = async () => {
    if (!articleToDelete) return;
    setIsDeleting(true);
    try {
      // APPEL RÉEL DE SUPPRESSION
      await apiClient.delete(`/articles/${articleToDelete.id}`);
      setArticles(articles.filter((art) => art._id !== articleToDelete.id));
      setIsDeleteDialogOpen(false);
    } catch (error) {
      console.error("Erreur lors de la suppression :", error);
    } finally {
      setIsDeleting(false);
      setArticleToDelete(null);
    }
  };

  return (
    <div className="space-y-6">
      <div className="flex flex-col gap-4 sm:flex-row sm:items-center sm:justify-between">
        <div>
          <h1 className="text-3xl font-bold tracking-tight">Articles</h1>
          <p className="text-muted-foreground">
            Gérez le contenu éditorial de l&apos;application Flow.
          </p>
        </div>
        <Button asChild className="gap-2">
          <Link href="/admin/articles/nouveau">
            <Plus className="h-4 w-4" />
            Créer un article
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
              <TableHead>Auteur</TableHead>
              <TableHead>Date</TableHead>
              <TableHead className="w-[80px]"></TableHead>
            </TableRow>
          </TableHeader>
          <TableBody>
            {isLoading ? (
              <TableRow>
                <TableCell colSpan={4} className="h-32 text-center">
                  <Loader2 className="text-muted-foreground mx-auto h-6 w-6 animate-spin" />
                </TableCell>
              </TableRow>
            ) : articles.length === 0 ? (
              <TableRow>
                <TableCell
                  colSpan={4}
                  className="text-muted-foreground h-32 text-center"
                >
                  Aucun article trouvé.
                </TableCell>
              </TableRow>
            ) : (
              articles.map((article) => {
                const displayTitle =
                  article.titre ?? article.title ?? "Sans titre";
                const displayAuthor =
                  article.auteur ?? article.author ?? "Inconnu";
                const realId = article._id ?? article.id;
                return (
                  <TableRow key={realId}>
                    <TableCell className="font-medium">
                      {displayTitle}
                    </TableCell>
                    <TableCell>{displayAuthor}</TableCell>
                    <TableCell>
                      {new Date(article.created_at).toLocaleDateString("fr-FR")}
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
                              href={`/admin/articles/${realId}/editer`}
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

      {/* Modale de suppression */}
      <AlertDialog
        open={isDeleteDialogOpen}
        onOpenChange={setIsDeleteDialogOpen}
      >
        <AlertDialogContent>
          <AlertDialogHeader>
            <AlertDialogTitle>Êtes-vous absolument sûr ?</AlertDialogTitle>
            <AlertDialogDescription>
              Cette action supprimera définitivement l&apos;article{" "}
              <strong className="text-foreground">
                {articleToDelete?.titre}
              </strong>{" "}
              de la base de données.
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
