"use client";

import { useEffect, useState } from "react";
import {
  BookOpen,
  AlertCircle,
  Search,
  User,
  Tag,
  Loader2,
} from "lucide-react";

import { Input } from "@/components/ui/input";
import { apiClient } from "@/lib/api-client";

interface Article {
  _id: string;
  id?: string;
  titre?: string;
  title?: string;
  auteur?: string;
  contenu?: string;
  image_url?: string;
  tags?: string[];
  date_publication?: string;
}

export default function ArticlesPage() {
  const [articles, setArticles] = useState<Article[]>([]);
  const [filteredArticles, setFilteredArticles] = useState<Article[]>([]);
  const [isLoading, setIsLoading] = useState(true);
  const [error, setError] = useState<string | null>(null);
  const [searchTerm, setSearchTerm] = useState("");

  // 1. Récupération des articles depuis l'API Laravel
  useEffect(() => {
    async function fetchArticles() {
      try {
        setIsLoading(true);
        const response = await apiClient.get<any>("/articles");
        const items = response.data ?? response;

        const dataArray = Array.isArray(items) ? items : [];
        setArticles(dataArray);
        setFilteredArticles(dataArray);
      } catch (err: any) {
        setError(err.message ?? "Impossible de charger les articles.");
      } finally {
        setIsLoading(false);
      }
    }
    void fetchArticles();
  }, []);

  // 2. Recherche en temps réel
  useEffect(() => {
    const filtered = articles.filter((article) => {
      const title = (article.titre ?? article.title ?? "").toLowerCase();
      return title.includes(searchTerm.toLowerCase());
    });
    setFilteredArticles(filtered);
  }, [searchTerm, articles]);

  return (
    <div className="space-y-10 pb-12">
      <section className="space-y-4 pt-6">
        <h1 className="text-4xl font-extrabold tracking-tight">Le Blog Flow</h1>
        <p className="text-muted-foreground max-w-2xl text-lg">
          Retrouvez nos conseils experts sur la nutrition, la récupération et le
          bien-être au quotidien.
        </p>
      </section>

      {/* Barre de recherche */}
      <div className="relative max-w-xl">
        <Search className="text-muted-foreground absolute top-1/2 left-3 h-5 w-5 -translate-y-1/2" />
        <Input
          type="search"
          placeholder="Rechercher un article..."
          className="bg-background border-muted-foreground/20 h-12 rounded-xl pl-10 text-base"
          value={searchTerm}
          onChange={(e) => setSearchTerm(e.target.value)}
        />
      </div>

      {error && (
        <div className="bg-destructive/10 text-destructive flex items-center gap-3 rounded-xl p-4">
          <AlertCircle className="h-5 w-5 shrink-0" />
          <p className="text-sm font-medium">{error}</p>
        </div>
      )}

      {isLoading ? (
        <div className="grid grid-cols-1 gap-6 md:grid-cols-2 lg:grid-cols-3">
          {[...Array(6)].map((_, i) => (
            <div
              key={i}
              className="bg-muted h-64 animate-pulse rounded-2xl"
            ></div>
          ))}
        </div>
      ) : (
        <>
          {filteredArticles.length === 0 ? (
            <div className="text-muted-foreground bg-muted/10 rounded-2xl border border-dashed p-12 text-center">
              <BookOpen className="mx-auto mb-4 h-12 w-12 opacity-20" />
              <p className="text-lg font-medium">Aucun article trouvé.</p>
            </div>
          ) : (
            <div className="grid grid-cols-1 gap-6 md:grid-cols-2 lg:grid-cols-3">
              {filteredArticles.map((article) => {
                const id = article._id ?? article.id;
                const displayTitle =
                  article.titre ?? article.title ?? "Sans titre";
                const displayAuteur = article.auteur ?? "Équipe Flow";
                const displayContenu =
                  article.contenu ??
                  "Aucun résumé disponible pour cet article.";

                return (
                  <article
                    key={id}
                    className="group bg-background flex flex-col overflow-hidden rounded-2xl border shadow-sm transition-all duration-300 hover:shadow-lg"
                  >
                    {/* Image */}
                    <div className="bg-muted aspect-video w-full overflow-hidden">
                      {article.image_url ? (
                        <img
                          src={article.image_url}
                          alt={displayTitle}
                          className="h-full w-full object-cover transition-transform duration-500 group-hover:scale-105"
                        />
                      ) : (
                        <div className="text-muted-foreground/30 flex h-full w-full items-center justify-center">
                          <BookOpen className="h-12 w-12" />
                        </div>
                      )}
                    </div>

                    {/* Contenu */}
                    <div className="flex flex-1 flex-col justify-between p-6">
                      <div className="space-y-4">
                        {/* Tags */}
                        {article.tags && article.tags.length > 0 && (
                          <div className="flex flex-wrap gap-1.5">
                            {article.tags.map((tag, idx) => (
                              <span
                                key={idx}
                                className="bg-secondary text-muted-foreground inline-flex items-center gap-1 rounded-full px-2.5 py-0.5 text-xs font-medium"
                              >
                                <Tag className="h-3 w-3" />
                                {tag}
                              </span>
                            ))}
                          </div>
                        )}

                        <h2 className="group-hover:text-primary line-clamp-2 text-xl leading-tight font-bold transition-colors">
                          {displayTitle}
                        </h2>
                        <p className="text-muted-foreground line-clamp-3 text-sm leading-relaxed">
                          {displayContenu}
                        </p>
                      </div>

                      {/* Footer */}
                      <div className="border-border/50 text-muted-foreground mt-4 flex items-center justify-between border-t pt-6 text-xs">
                        <div className="flex items-center gap-1.5 font-medium">
                          <User className="text-primary h-3.5 w-3.5" />
                          <span>{displayAuteur}</span>
                        </div>
                        {article.date_publication && (
                          <span>
                            {new Date(
                              article.date_publication,
                            ).toLocaleDateString("fr-FR", {
                              day: "numeric",
                              month: "short",
                            })}
                          </span>
                        )}
                      </div>
                    </div>
                  </article>
                );
              })}
            </div>
          )}
        </>
      )}
    </div>
  );
}
