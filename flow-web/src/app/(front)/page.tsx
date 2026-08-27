"use client";

import { useEffect, useState } from "react";
import Link from "next/link";
import {
  PlayCircle,
  BookOpen,
  Clock,
  User,
  Tag,
  Loader2,
  AlertCircle,
  ArrowRight,
} from "lucide-react";

import { Button } from "@/components/ui/button";
import { apiClient } from "@/lib/api-client";
import Image from "next/image";

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
        const articlesList = articlesRes.data ?? articlesRes;
        const activitiesList = activitiesRes.data ?? activitiesRes;

        // On ne garde par exemple que les 3 ou 4 derniers éléments pour la page d'accueil
        setArticles(
          Array.isArray(articlesList) ? articlesList.slice(0, 3) : [],
        );
        setActivities(
          Array.isArray(activitiesList) ? activitiesList.slice(0, 4) : [],
        );
      } catch (err: any) {
        console.error("Erreur de chargement de la page d'accueil :", err);
        setError(
          "Impossible de charger les contenus du catalogue pour le moment.",
        );
      } finally {
        setIsLoading(false);
      }
    }

    void loadHomeData();
  }, []);

  return (
    <div className="space-y-16 pb-12">
      {/* SECTION HERO : Présentation principale de l'application */}
      <section className="from-primary/10 via-background to-muted relative flex flex-col items-center justify-between gap-8 overflow-hidden rounded-3xl border bg-gradient-to-br p-8 text-center md:flex-row md:p-12 md:text-left">
        <div className="max-w-xl space-y-4">
          <span className="bg-primary/10 text-primary inline-flex items-center rounded-full px-3 py-1 text-xs font-semibold">
            Application Flow disponible
          </span>
          <h1 className="from-foreground to-foreground/70 bg-gradient-to-r bg-clip-text text-4xl font-extrabold tracking-tight text-transparent md:text-5xl">
            Trouvez votre équilibre, optimisez votre bien-être
          </h1>
          <p className="text-muted-foreground text-lg">
            Découvrez nos programmes de mobilité, nos entraînements guidés et
            nos articles d&apos;experts pour prendre soin de votre corps et de
            votre esprit au quotidien.
          </p>
          <div className="flex flex-wrap justify-center gap-4 pt-2 md:justify-start">
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
        <div className="from-primary/20 to-primary/5 absolute -top-10 -right-10 -z-10 hidden h-72 w-72 rounded-full bg-gradient-to-tr blur-2xl md:block" />
      </section>

      {/* BANNIÈRE D'ERREUR API */}
      {error && (
        <div className="bg-destructive/10 text-destructive mx-auto flex max-w-4xl items-center gap-3 rounded-xl p-4">
          <AlertCircle className="h-5 w-5 shrink-0" />
          <p className="text-sm font-medium">{error}</p>
        </div>
      )}

      {/* ÉCRAN DE CHARGEMENT GLOBAL */}
      {isLoading ? (
        <div className="flex flex-col items-center justify-center space-y-4 py-20">
          <Loader2 className="text-primary h-8 w-8 animate-spin" />
          <p className="text-muted-foreground text-sm font-medium">
            Connexion à la base de données de Flow...
          </p>
        </div>
      ) : (
        <>
          {/* SECTION DES ACTIVITÉS & EXERCICES */}
          <section id="activites" className="scroll-mt-6 space-y-6">
            <div className="flex items-center justify-between">
              <div>
                <h2 className="flex items-center gap-2 text-2xl font-bold tracking-tight">
                  <PlayCircle className="text-primary h-6 w-6" />
                  Activités & Exercices à la une
                </h2>
                <p className="text-muted-foreground text-sm">
                  Séances vidéo et audio pour vos routines quotidiennes.
                </p>
              </div>
            </div>

            {activities.length === 0 ? (
              <div className="text-muted-foreground bg-muted/20 rounded-xl border border-dashed p-8 text-center">
                Aucune activité disponible dans le catalogue pour le moment.
              </div>
            ) : (
              <div className="grid grid-cols-1 gap-6 sm:grid-cols-2 lg:grid-cols-4">
                {activities.map((activity) => {
                  const id = activity._id ?? activity.id;
                  return (
                    <div
                      key={id}
                      className="group bg-background relative flex flex-col overflow-hidden rounded-xl border shadow-sm transition-all hover:shadow-md"
                    >
                      <div className="bg-muted relative aspect-video w-full overflow-hidden">
                        {activity.image_url ? (
                          <Image
                            src={activity.image_url}
                            alt={activity.titre}
                            className="h-full w-full object-cover transition-transform duration-300 group-hover:scale-105"
                          />
                        ) : (
                          <div className="text-muted-foreground/30 flex h-full w-full items-center justify-center">
                            <PlayCircle className="h-12 w-12" />
                          </div>
                        )}
                        <span className="bg-background/90 absolute top-2 right-2 rounded-md px-2 py-0.5 text-xs font-semibold shadow-sm backdrop-blur-sm">
                          {activity.categorie}
                        </span>
                      </div>
                      <div className="flex flex-1 flex-col justify-between space-y-2 p-4">
                        <div className="space-y-1">
                          <h3 className="group-hover:text-primary line-clamp-1 text-base leading-tight font-bold transition-colors">
                            {activity.titre}
                          </h3>
                          <p className="text-muted-foreground line-clamp-2 text-xs">
                            {activity.description}
                          </p>
                        </div>
                        <div className="text-muted-foreground flex items-center gap-1.5 border-t pt-2 text-xs font-medium">
                          <Clock className="text-primary h-3.5 w-3.5" />
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
              <h2 className="flex items-center gap-2 text-2xl font-bold tracking-tight">
                <BookOpen className="text-primary h-6 w-6" />
                Derniers articles conseils
              </h2>
              <p className="text-muted-foreground text-sm">
                Découvrez les dernières actualités santé, sport et récupération
                rédigées par nos experts.
              </p>
            </div>

            {articles.length === 0 ? (
              <div className="text-muted-foreground bg-muted/20 rounded-xl border border-dashed p-8 text-center">
                Aucun article publié pour le moment.
              </div>
            ) : (
              <div className="grid grid-cols-1 gap-6 md:grid-cols-3">
                {articles.map((article) => {
                  const id = article._id ?? article.id;
                  return (
                    <article
                      key={id}
                      className="group bg-background flex flex-col justify-between overflow-hidden rounded-xl border shadow-sm transition-all hover:shadow-md"
                    >
                      <div className="space-y-4 p-5">
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

                        <div className="space-y-2">
                          <h3 className="group-hover:text-primary line-clamp-2 text-xl leading-snug font-bold tracking-tight transition-colors">
                            {article.titre}
                          </h3>
                          <p className="text-muted-foreground line-clamp-4 text-sm leading-relaxed">
                            {article.contenu}
                          </p>
                        </div>
                      </div>

                      <div className="bg-muted/30 text-muted-foreground flex items-center justify-between border-t p-5 text-xs">
                        <div className="flex items-center gap-1.5 font-medium">
                          <User className="text-primary h-3.5 w-3.5" />
                          <span>Par {article.auteur}</span>
                        </div>
                        {article.date_publication && (
                          <span>
                            {new Date(
                              article.date_publication,
                            ).toLocaleDateString("fr-FR", {
                              day: "numeric",
                              month: "short",
                              year: "numeric",
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
