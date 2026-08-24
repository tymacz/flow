"use client";

import { useEffect, useState } from "react";
import Link from "next/link";
import { PlayCircle, BookOpen, Clock, User, Tag, Loader2, AlertCircle, ArrowRight } from "lucide-react";

import { Button } from "@/components/ui/button";
import { apiClient } from "@/lib/api-client";

interface Article {
  _id: string;
  id?: string;
  titre: string;
  auteur: string;
  contenu: string;
  image_url?: string;
  tags?: string[];
  date_publication?: string;
}

interface Activity {
  _id: string;
  id?: string;
  titre: string;
  categorie: string;
  duree_minutes: number;
  description: string;
  image_url?: string;
}

export default function PublicHomePage() {
  const [articles, setArticles] = useState<Article[]>([]);
  const [activities, setActivities] = useState<Activity[]>([]);
  const [isLoading, setIsLoading] = useState(true);
  const [error, setError] = useState<string | null>(null);

  useEffect(() => {
    async function loadHomeData() {
      try {
        setIsLoading(true);
        setError(null);

        // Récupération simultanée des articles et des activités depuis l'API Laravel
        const [articlesRes, activitiesRes] = await Promise.all([
          apiClient.get<any>("/articles"),
          apiClient.get<any>("/activities"),
        ]);

        // Extraction des données en prenant en compte une éventuelle encapsulation dans un objet "data" (pagination)
        const articlesList = articlesRes.data || articlesRes;
        const activitiesList = activitiesRes.data || activitiesRes;

        // On ne garde par exemple que les 3 ou 4 derniers éléments pour la page d'accueil
        setArticles(Array.isArray(articlesList) ? articlesList.slice(0, 3) : []);
        setActivities(Array.isArray(activitiesList) ? activitiesList.slice(0, 4) : []);
      } catch (err: any) {
        console.error("Erreur de chargement de la page d'accueil :", err);
        setError("Impossible de charger les contenus du catalogue pour le moment.");
      } finally {
        setIsLoading(false);
      }
    }

    void loadHomeData();
  }, []);

  return (
    <div className="space-y-16 pb-12">
      {/* SECTION HERO : Présentation principale de l'application */}
      <section className="relative overflow-hidden rounded-3xl bg-gradient-to-br from-primary/10 via-background to-muted border p-8 md:p-12 text-center md:text-left flex flex-col md:flex-row items-center justify-between gap-8">
        <div className="max-w-xl space-y-4">
          <span className="inline-flex items-center rounded-full bg-primary/10 px-3 py-1 text-xs font-semibold text-primary">
            Application Flow disponible
          </span>
          <h1 className="text-4xl md:text-5xl font-extrabold tracking-tight bg-gradient-to-r from-foreground to-foreground/70 bg-clip-text text-transparent">
            Trouvez votre équilibre, optimisez votre bien-être
          </h1>
          <p className="text-muted-foreground text-lg">
            Découvrez nos programmes de mobilité, nos entraînements guidés et nos articles d&apos;experts pour prendre soin de votre corps et de votre esprit au quotidien.
          </p>
          <div className="flex flex-wrap gap-4 justify-center md:justify-start pt-2">
            <Button asChild size="lg" className="gap-2">
              <a href="#activites">
                Commencer un exercice <ArrowRight className="h-4 w-4" />
              </a>
            </Button>
            <Button asChild size="lg" variant="outline">
              <Link href="/login">Espace Administration</Link>
            </Button>
          </div>
        </div>
        <div className="hidden md:block w-72 h-72 rounded-full bg-gradient-to-tr from-primary/20 to-primary/5 blur-2xl absolute -right-10 -top-10 -z-10" />
      </section>

      {/* BANNIÈRE D'ERREUR API */}
      {error && (
        <div className="flex items-center gap-3 rounded-xl bg-destructive/10 p-4 text-destructive max-w-4xl mx-auto">
          <AlertCircle className="h-5 w-5 shrink-0" />
          <p className="text-sm font-medium">{error}</p>
        </div>
      )}

      {/* ÉCRAN DE CHARGEMENT GLOBAL */}
      {isLoading ? (
        <div className="flex flex-col items-center justify-center py-20 space-y-4">
          <Loader2 className="h-8 w-8 animate-spin text-primary" />
          <p className="text-sm text-muted-foreground font-medium">Connexion à la base de données de Flow...</p>
        </div>
      ) : (
        <>
          {/* SECTION DES ACTIVITÉS & EXERCICES */}
          <section id="activites" className="space-y-6 scroll-mt-6">
            <div className="flex items-center justify-between">
              <div>
                <h2 className="text-2xl font-bold tracking-tight flex items-center gap-2">
                  <PlayCircle className="h-6 w-6 text-primary" />
                  Activités & Exercices à la une
                </h2>
                <p className="text-muted-foreground text-sm">
                  Séances vidéo et audio pour vos routines quotidiennes.
                </p>
              </div>
            </div>

            {activities.length === 0 ? (
              <div className="rounded-xl border border-dashed p-8 text-center text-muted-foreground bg-muted/20">
                Aucune activité disponible dans le catalogue pour le moment.
              </div>
            ) : (
              <div className="grid grid-cols-1 sm:grid-cols-2 lg:grid-cols-4 gap-6">
                {activities.map((activity) => {
                  const id = activity._id || activity.id;
                  return (
                    <div key={id} className="group relative rounded-xl border bg-background overflow-hidden shadow-sm hover:shadow-md transition-all flex flex-col">
                      <div className="aspect-video w-full bg-muted relative overflow-hidden">
                        {activity.image_url ? (
                          <img 
                            src={activity.image_url} 
                            alt={activity.titre}
                            className="object-cover w-full h-full group-hover:scale-105 transition-transform duration-300"
                          />
                        ) : (
                          <div className="w-full h-full flex items-center justify-center text-muted-foreground/30">
                            <PlayCircle className="h-12 w-12" />
                          </div>
                        )}
                        <span className="absolute top-2 right-2 rounded-md bg-background/90 backdrop-blur-sm px-2 py-0.5 text-xs font-semibold shadow-sm">
                          {activity.categorie}
                        </span>
                      </div>
                      <div className="p-4 space-y-2 flex-1 flex flex-col justify-between">
                        <div className="space-y-1">
                          <h3 className="font-bold text-base leading-tight group-hover:text-primary transition-colors line-clamp-1">
                            {activity.titre}
                          </h3>
                          <p className="text-muted-foreground text-xs line-clamp-2">
                            {activity.description}
                          </p>
                        </div>
                        <div className="flex items-center gap-1.5 text-muted-foreground text-xs font-medium pt-2 border-t">
                          <Clock className="h-3.5 w-3.5 text-primary" />
                          <span>{activity.duree_minutes} minutes</span>
                        </div>
                      </div>
                    </div>
                  );
                })}
              </div>
            )}
          </section>

          {/* SECTION DES ARTICLES DE BLOG */}
          <section className="space-y-6">
            <div>
              <h2 className="text-2xl font-bold tracking-tight flex items-center gap-2">
                <BookOpen className="h-6 w-6 text-primary" />
                Derniers articles conseils
              </h2>
              <p className="text-muted-foreground text-sm">
                Découvrez les dernières actualités santé, sport et récupération rédigées par nos experts.
              </p>
            </div>

            {articles.length === 0 ? (
              <div className="rounded-xl border border-dashed p-8 text-center text-muted-foreground bg-muted/20">
                Aucun article publié pour le moment.
              </div>
            ) : (
              <div className="grid grid-cols-1 md:grid-cols-3 gap-6">
                {articles.map((article) => {
                  const id = article._id || article.id;
                  return (
                    <article key={id} className="group rounded-xl border bg-background overflow-hidden shadow-sm hover:shadow-md transition-all flex flex-col justify-between">
                      <div className="p-5 space-y-4">
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
                        
                        <div className="space-y-2">
                          <h3 className="text-xl font-bold tracking-tight leading-snug group-hover:text-primary transition-colors line-clamp-2">
                            {article.titre}
                          </h3>
                          <p className="text-muted-foreground text-sm line-clamp-4 leading-relaxed">
                            {article.contenu}
                          </p>
                        </div>
                      </div>

                      <div className="p-5 bg-muted/30 border-t flex items-center justify-between text-xs text-muted-foreground">
                        <div className="flex items-center gap-1.5 font-medium">
                          <User className="h-3.5 w-3.5 text-primary" />
                          <span>Par {article.auteur}</span>
                        </div>
                        {article.date_publication && (
                          <span>
                            {new Date(article.date_publication).toLocaleDateString("fr-FR", {
                              day: "numeric",
                              month: "short",
                              year: "numeric"
                            })}
                          </span>
                        )}
                      </div>
                    </article>
                  );
                })}
              </div>
            )}
          </section>
        </>
      )}
    </div>
  );
}