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
  const categories = ["Toutes", "HIIT", "Force", "Mobilité", "Récupération", "Respiration"];

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
        setError(err.message || "Impossible de charger le catalogue d'exercices.");
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
      const matchesCategory = selectedCategory === "Toutes" || category === selectedCategory;
      
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
        <p className="text-lg text-muted-foreground max-w-2xl">
          Parcourez notre collection complète de séances vidéo et audio. Filtrez par objectif et trouvez la routine parfaite pour votre journée.
        </p>
      </section>

      {/* Barre de recherche et filtres */}
      <section className="flex flex-col sm:flex-row gap-4 items-center bg-muted/30 p-4 rounded-2xl border">
        <div className="relative flex-1 w-full">
          <Search className="absolute left-3 top-1/2 -translate-y-1/2 h-5 w-5 text-muted-foreground" />
          <Input
            type="search"
            placeholder="Rechercher un exercice (ex: Gainage...)"
            className="pl-10 h-12 bg-background border-muted-foreground/20 text-base rounded-xl"
            value={searchTerm}
            onChange={(e) => setSearchTerm(e.target.value)}
          />
        </div>
        <div className="w-full sm:w-64 flex items-center gap-2">
          <Filter className="h-5 w-5 text-muted-foreground hidden sm:block shrink-0" />
          <Select value={selectedCategory} onValueChange={setSelectedCategory}>
            <SelectTrigger className="h-12 bg-background rounded-xl border-muted-foreground/20 text-base">
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
        <div className="flex items-center gap-3 rounded-xl bg-destructive/10 p-4 text-destructive">
          <AlertCircle className="h-5 w-5 shrink-0" />
          <p className="text-sm font-medium">{error}</p>
        </div>
      )}

      {isLoading ? (
        <div className="grid grid-cols-1 sm:grid-cols-2 lg:grid-cols-4 gap-6">
          {/* Skeleton de chargement */}
          {[...Array(8)].map((_, i) => (
            <div key={i} className="aspect-[4/5] rounded-2xl bg-muted animate-pulse"></div>
          ))}
        </div>
      ) : (
        <>
          {filteredActivities.length === 0 && !error ? (
            <div className="rounded-2xl border border-dashed p-12 text-center text-muted-foreground bg-muted/10">
              <PlayCircle className="h-12 w-12 mx-auto mb-4 opacity-20" />
              <p className="text-lg font-medium">Aucun exercice ne correspond à vos critères.</p>
              <p className="text-sm mt-1">Essayez de modifier votre recherche ou votre catégorie.</p>
            </div>
          ) : (
            <div className="grid grid-cols-1 sm:grid-cols-2 lg:grid-cols-4 gap-6">
              {filteredActivities.map((activity) => {
                const id = activity._id ?? activity.id;
                const displayTitle = activity.titre ?? activity.title ?? "Sans titre";
                const displayDesc = activity.description ?? "";
                const displayCat = activity.categorie ?? activity.category ?? "Général";
                const displayTime = activity.duree_minutes ?? activity.duration ?? 0;

                return (
                  <div key={id} className="group relative rounded-2xl border bg-background overflow-hidden shadow-sm hover:shadow-lg transition-all duration-300 flex flex-col cursor-pointer">
                    <div className="aspect-[4/3] w-full bg-muted relative overflow-hidden">
                      {activity.image_url ? (
                        <img 
                          src={activity.image_url} 
                          alt={displayTitle}
                          className="object-cover w-full h-full group-hover:scale-105 transition-transform duration-500"
                        />
                      ) : (
                        <div className="w-full h-full flex flex-col items-center justify-center text-muted-foreground/30 bg-secondary/50">
                          <PlayCircle className="h-12 w-12 mb-2" />
                        </div>
                      )}
                      
                      {/* Badge catégorie flottant */}
                      <span className="absolute top-3 right-3 rounded-lg bg-background/95 backdrop-blur-md px-2.5 py-1 text-xs font-bold shadow-sm text-foreground">
                        {displayCat}
                      </span>

                      {/* Overlay Play au survol */}
                      <div className="absolute inset-0 bg-black/40 opacity-0 group-hover:opacity-100 transition-opacity duration-300 flex items-center justify-center">
                        <PlayCircle className="h-14 w-14 text-white drop-shadow-md" />
                      </div>
                    </div>
                    
                    <div className="p-5 space-y-3 flex-1 flex flex-col justify-between">
                      <div className="space-y-1.5">
                        <h3 className="font-bold text-lg leading-tight group-hover:text-primary transition-colors line-clamp-2">
                          {displayTitle}
                        </h3>
                        <p className="text-muted-foreground text-sm line-clamp-2">
                          {displayDesc}
                        </p>
                      </div>
                      <div className="flex items-center gap-1.5 text-muted-foreground text-sm font-semibold pt-3 border-t">
                        <Clock className="h-4 w-4 text-primary" />
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