"use client";

import { useEffect, useState } from "react";
import { PlayCircle, Clock, AlertCircle, Search, Filter } from "lucide-react";

import { Input } from "@/components/ui/input";
import {
  Select,
  SelectContent,
  SelectItem,
  SelectTrigger,
  SelectValue,
} from "@/components/ui/select";
import { apiClient } from "@/lib/api-client";

interface Activity {
  _id: string;
  id?: string;
  titre?: string;
  title?: string;
  categorie?: string;
  category?: string;
  duree_minutes?: number;
  duration?: number;
  description?: string;
  image_url?: string;
}

export default function ExercicesPage() {
  const [activities, setActivities] = useState<Activity[]>([]);
  const [filteredActivities, setFilteredActivities] = useState<Activity[]>([]);
  const [isLoading, setIsLoading] = useState(true);
  const [error, setError] = useState<string | null>(null);

  // États pour les filtres
  const [searchTerm, setSearchTerm] = useState("");
  const [selectedCategory, setSelectedCategory] = useState("Toutes");

  // Liste des catégories disponibles (tu peux l'adapter selon celles de ta BDD)
  const categories = [
    "Toutes",
    "HIIT",
    "Force",
    "Mobilité",
    "Récupération",
    "Respiration",
  ];

  // 1. Récupération des données depuis Laravel
  useEffect(() => {
    async function fetchActivities() {
      try {
        setIsLoading(true);
        const response = await apiClient.get<any>("/activities");
        const items = response.data || response;

        // On s'assure d'avoir un tableau
        const dataArray = Array.isArray(items) ? items : [];
        setActivities(dataArray);
        setFilteredActivities(dataArray);
      } catch (err: any) {
        setError(
          err.message || "Impossible de charger le catalogue d'exercices.",
        );
      } finally {
        setIsLoading(false);
      }
    }
    void fetchActivities();
  }, []);

  // 2. Logique de filtrage en temps réel
  useEffect(() => {
    const filtered = activities.filter((activity) => {
      const title = (activity.titre ?? activity.title ?? "").toLowerCase();
      const category = activity.categorie ?? activity.category ?? "";

      const matchesSearch = title.includes(searchTerm.toLowerCase());
      const matchesCategory =
        selectedCategory === "Toutes" || category === selectedCategory;

      return matchesSearch && matchesCategory;
    });

    setFilteredActivities(filtered);
  }, [searchTerm, selectedCategory, activities]);

  return (
    <div className="space-y-10 pb-12">
      {/* En-tête de la page */}
      <section className="space-y-4 pt-6">
        <h1 className="text-4xl font-extrabold tracking-tight">
          Catalogue d&apos;exercices
        </h1>
        <p className="text-muted-foreground max-w-2xl text-lg">
          Parcourez notre collection complète de séances vidéo et audio. Filtrez
          par objectif et trouvez la routine parfaite pour votre journée.
        </p>
      </section>

      {/* Barre de recherche et filtres */}
      <section className="bg-muted/30 flex flex-col items-center gap-4 rounded-2xl border p-4 sm:flex-row">
        <div className="relative w-full flex-1">
          <Search className="text-muted-foreground absolute top-1/2 left-3 h-5 w-5 -translate-y-1/2" />
          <Input
            type="search"
            placeholder="Rechercher un exercice (ex: Gainage...)"
            className="bg-background border-muted-foreground/20 h-12 rounded-xl pl-10 text-base"
            value={searchTerm}
            onChange={(e) => setSearchTerm(e.target.value)}
          />
        </div>
        <div className="flex w-full items-center gap-2 sm:w-64">
          <Filter className="text-muted-foreground hidden h-5 w-5 shrink-0 sm:block" />
          <Select value={selectedCategory} onValueChange={setSelectedCategory}>
            <SelectTrigger className="bg-background border-muted-foreground/20 h-12 rounded-xl text-base">
              <SelectValue placeholder="Catégorie" />
            </SelectTrigger>
            <SelectContent>
              {categories.map((cat) => (
                <SelectItem key={cat} value={cat}>
                  {cat}
                </SelectItem>
              ))}
            </SelectContent>
          </Select>
        </div>
      </section>

      {/* Gestion des erreurs et du chargement */}
      {error && (
        <div className="bg-destructive/10 text-destructive flex items-center gap-3 rounded-xl p-4">
          <AlertCircle className="h-5 w-5 shrink-0" />
          <p className="text-sm font-medium">{error}</p>
        </div>
      )}

      {isLoading ? (
        <div className="grid grid-cols-1 gap-6 sm:grid-cols-2 lg:grid-cols-4">
          {/* Skeleton de chargement */}
          {[...Array(8)].map((_, i) => (
            <div
              key={i}
              className="bg-muted aspect-[4/5] animate-pulse rounded-2xl"
            ></div>
          ))}
        </div>
      ) : (
        <>
          {filteredActivities.length === 0 && !error ? (
            <div className="text-muted-foreground bg-muted/10 rounded-2xl border border-dashed p-12 text-center">
              <PlayCircle className="mx-auto mb-4 h-12 w-12 opacity-20" />
              <p className="text-lg font-medium">
                Aucun exercice ne correspond à vos critères.
              </p>
              <p className="mt-1 text-sm">
                Essayez de modifier votre recherche ou votre catégorie.
              </p>
            </div>
          ) : (
            <div className="grid grid-cols-1 gap-6 sm:grid-cols-2 lg:grid-cols-4">
              {filteredActivities.map((activity) => {
                const id = activity._id ?? activity.id;
                const displayTitle =
                  activity.titre ?? activity.title ?? "Sans titre";
                const displayDesc = activity.description ?? "";
                const displayCat =
                  activity.categorie ?? activity.category ?? "Général";
                const displayTime =
                  activity.duree_minutes ?? activity.duration ?? 0;

                return (
                  <div
                    key={id}
                    className="group bg-background relative flex cursor-pointer flex-col overflow-hidden rounded-2xl border shadow-sm transition-all duration-300 hover:shadow-lg"
                  >
                    <div className="bg-muted relative aspect-[4/3] w-full overflow-hidden">
                      {activity.image_url ? (
                        <img
                          src={activity.image_url}
                          alt={displayTitle}
                          className="h-full w-full object-cover transition-transform duration-500 group-hover:scale-105"
                        />
                      ) : (
                        <div className="text-muted-foreground/30 bg-secondary/50 flex h-full w-full flex-col items-center justify-center">
                          <PlayCircle className="mb-2 h-12 w-12" />
                        </div>
                      )}

                      {/* Badge catégorie flottant */}
                      <span className="bg-background/95 text-foreground absolute top-3 right-3 rounded-lg px-2.5 py-1 text-xs font-bold shadow-sm backdrop-blur-md">
                        {displayCat}
                      </span>

                      {/* Overlay Play au survol */}
                      <div className="absolute inset-0 flex items-center justify-center bg-black/40 opacity-0 transition-opacity duration-300 group-hover:opacity-100">
                        <PlayCircle className="h-14 w-14 text-white drop-shadow-md" />
                      </div>
                    </div>

                    <div className="flex flex-1 flex-col justify-between space-y-3 p-5">
                      <div className="space-y-1.5">
                        <h3 className="group-hover:text-primary line-clamp-2 text-lg leading-tight font-bold transition-colors">
                          {displayTitle}
                        </h3>
                        <p className="text-muted-foreground line-clamp-2 text-sm">
                          {displayDesc}
                        </p>
                      </div>
                      <div className="text-muted-foreground flex items-center gap-1.5 border-t pt-3 text-sm font-semibold">
                        <Clock className="text-primary h-4 w-4" />
                        <span>{displayTime} min</span>
                      </div>
                    </div>
                  </div>
                );
              })}
            </div>
          )}
        </>
      )}
    </div>
  );
}
