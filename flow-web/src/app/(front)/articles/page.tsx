"use client";

import { useEffect, useState } from "react";
import { BookOpen, AlertCircle, Search, User, Tag, Loader2 } from "lucide-react";

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
        <p className="text-lg text-muted-foreground max-w-2xl">
          Retrouvez nos conseils experts sur la nutrition, la récupération et le bien-être au quotidien.
        </p>
      </section>

      {/* Barre de recherche */}
      <div className="relative max-w-xl">
        <Search className="absolute left-3 top-1/2 -translate-y-1/2 h-5 w-5 text-muted-foreground" />
        <Input
          type="search"
          placeholder="Rechercher un article..."
          className="pl-10 h-12 bg-background border-muted-foreground/20 text-base rounded-xl"
          value={searchTerm}
          onChange={(e) => setSearchTerm(e.target.value)}
        />
      </div>

      {error && (
        <div className="flex items-center gap-3 rounded-xl bg-destructive/10 p-4 text-destructive">
          <AlertCircle className="h-5 w-5 shrink-0" />
          <p className="text-sm font-medium">{error}</p>
        </div>
      )}

      {isLoading ? (
        <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-6">
          {[...Array(6)].map((_, i) => (
            <div key={i} className="h-64 rounded-2xl bg-muted animate-pulse"></div>
          ))}
        </div>
      ) : (
        <>
          {filteredArticles.length === 0 ? (
            <div className="rounded-2xl border border-dashed p-12 text-center text-muted-foreground bg-muted/10">
              <BookOpen className="h-12 w-12 mx-auto mb-4 opacity-20" />
              <p className="text-lg font-medium">Aucun article trouvé.</p>
            </div>
          ) : (
            <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-6">
              {filteredArticles.map((article) => {
                const id = article._id ?? article.id;
                const displayTitle = article.titre ?? article.title ?? "Sans titre";
                const displayAuteur = article.auteur ?? "Équipe Flow";
                const displayContenu = article.contenu ?? "Aucun résumé disponible pour cet article.";
                
                return (
                  <article key={id} className="group flex flex-col rounded-2xl border bg-background overflow-hidden shadow-sm hover:shadow-lg transition-all duration-300">
                    {/* Image */}
                    <div className="aspect-video w-full bg-muted overflow-hidden">
                      {article.image_url ? (
                        <img 
                          src={article.image_url} 
                          alt={displayTitle}
                          className="object-cover w-full h-full group-hover:scale-105 transition-transform duration-500"
                        />
                      ) : (
                        <div className="w-full h-full flex items-center justify-center text-muted-foreground/30">
                          <BookOpen className="h-12 w-12" />
                        </div>
                      )}
                    </div>

                    {/* Contenu */}
                    <div className="p-6 flex-1 flex flex-col justify-between">
                      <div className="space-y-4">
                        {/* Tags */}
                        {article.tags && article.tags.length > 0 && (
                          <div className="flex flex-wrap gap-1.5">
                            {article.tags.map((tag, idx) => (
                              <span key={idx} className="inline-flex items-center gap-1 rounded-full bg-secondary px-2.5 py-0.5 text-xs font-medium text-muted-foreground">
                                <Tag className="h-3 w-3" />
                                {tag}
                              </span>
                            ))}
                          </div>
                        )}
                        
                        <h2 className="text-xl font-bold leading-tight group-hover:text-primary transition-colors line-clamp-2">
                          {displayTitle}
                        </h2>
                        <p className="text-muted-foreground text-sm line-clamp-3 leading-relaxed">
                          {displayContenu}
                        </p>
                      </div>

                      {/* Footer */}
                      <div className="flex items-center justify-between pt-6 mt-4 border-t border-border/50 text-xs text-muted-foreground">
                        <div className="flex items-center gap-1.5 font-medium">
                          <User className="h-3.5 w-3.5 text-primary" />
                          <span>{displayAuteur}</span>
                        </div>
                        {article.date_publication && (
                          <span>
                            {new Date(article.date_publication).toLocaleDateString("fr-FR", {
                              day: "numeric",
                              month: "short"
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