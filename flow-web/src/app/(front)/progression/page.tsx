"use client";

import { useEffect, useState } from "react";
import {
  Loader2,
  AlertCircle,
  LineChart,
  Target,
  Smile,
  Activity,
} from "lucide-react";
import { apiClient } from "@/lib/api-client";
import { Card, CardContent, CardHeader, CardTitle } from "@/components/ui/card";
import {
  Table,
  TableBody,
  TableCell,
  TableHead,
  TableHeader,
  TableRow,
} from "@/components/ui/table";

interface MoodEntry {
  id: number;
  mood_value: number;
  note: string;
  created_at: string;
}

interface ActivityEntry {
  id: number;
  title: string;
  duration_minutes: number;
  date: string;
}

export default function ProgressionPage() {
  const [moodHistory, setMoodHistory] = useState<MoodEntry[]>([]);
  const [activityHistory, setActivityHistory] = useState<ActivityEntry[]>([]);
  const [isLoading, setIsLoading] = useState(true);
  const [error, setError] = useState<string | null>(null);

  useEffect(() => {
    async function fetchUserStats() {
      try {
        setIsLoading(true);
        setError(null);

        const [moodRes, activityRes] = await Promise.all([
          apiClient.get<any>("/humeur/historique"),
          apiClient.get<any>("/progress"),
        ]);

        // Pour l'humeur : Laravel renvoie maintenant le tableau directement
        setMoodHistory(moodRes ?? []);

        // Pour les activités : Laravel renvoie un objet avec "stats", "score", et "history"
        // On va cibler directement activityRes.history
        setActivityHistory(activityRes?.history ?? []);
      } catch (err: any) {
        console.error("Détail de l'erreur API :", err);
        // Affiche le message d'erreur réel reçu du serveur ou de l'API
        setError(err.message ?? "Erreur inconnue lors du chargement.");
      } finally {
        setIsLoading(false);
      }
    }
    void fetchUserStats();
  }, []);

  if (isLoading) {
    return (
      <div className="flex h-[60vh] items-center justify-center">
        <Loader2 className="text-primary h-8 w-8 animate-spin" />
      </div>
    );
  }

  return (
    <div className="space-y-8 pt-6 pb-12">
      <div className="space-y-2">
        <h1 className="text-3xl font-bold tracking-tight">
          Mon Espace Progression
        </h1>
        <p className="text-muted-foreground">
          Retrouvez vos activités passées et l&apos;évolution de votre humeur.
        </p>
      </div>

      {error && (
        <div className="bg-destructive/10 text-destructive flex items-center gap-3 rounded-xl p-4">
          <AlertCircle className="h-5 w-5" />
          <p className="text-sm font-medium">{error}</p>
        </div>
      )}

      {/* Cartes de Stats Rapides */}
      <div className="grid grid-cols-1 gap-6 md:grid-cols-3">
        <Card>
          <CardHeader className="flex flex-row items-center justify-between pb-2">
            <CardTitle className="text-sm font-medium">
              Total Activités
            </CardTitle>
            <Activity className="text-primary h-4 w-4" />
          </CardHeader>
          <CardContent>
            <div className="text-2xl font-bold">{activityHistory.length}</div>
          </CardContent>
        </Card>
        <Card>
          <CardHeader className="flex flex-row items-center justify-between pb-2">
            <CardTitle className="text-sm font-medium">
              Dernière Humeur
            </CardTitle>
            <Smile className="text-primary h-4 w-4" />
          </CardHeader>
          <CardContent>
            <div className="text-2xl font-bold">
              {moodHistory.length > 0 ? moodHistory[0]?.mood_value : "-"} / 5
            </div>
          </CardContent>
        </Card>
        <Card>
          <CardHeader className="flex flex-row items-center justify-between pb-2">
            <CardTitle className="text-sm font-medium">Temps Total</CardTitle>
            <Target className="text-primary h-4 w-4" />
          </CardHeader>
          <CardContent>
            <div className="text-2xl font-bold">
              {/* Le reduce fonctionnera toujours maintenant car on est sûr à 100% que c'est un tableau */}
              {activityHistory.reduce(
                (acc, curr) => acc + (curr.duration_minutes ?? 0),
                0,
              )}{" "}
              min
            </div>
          </CardContent>
        </Card>
      </div>

      {/* Sections Détails */}
      <div className="grid grid-cols-1 gap-8 lg:grid-cols-2">
        {/* Historique Activités */}
        <Card>
          <CardHeader>
            <CardTitle className="flex items-center gap-2">
              <Activity className="h-5 w-5" />
              Historique des séances
            </CardTitle>
          </CardHeader>
          <CardContent>
            {activityHistory.length === 0 ? (
              <p className="text-muted-foreground py-4 text-center text-sm">
                Aucune activité enregistrée.
              </p>
            ) : (
              <Table>
                <TableHeader>
                  <TableRow>
                    <TableHead>Activité</TableHead>
                    <TableHead>Durée</TableHead>
                    <TableHead>Date</TableHead>
                  </TableRow>
                </TableHeader>
                <TableBody>
                  {activityHistory.slice(0, 5).map((act, index) => (
                    <TableRow key={act.id ?? index}>
                      <TableCell className="font-medium">
                        {act.title ?? "Séance sans titre"}
                      </TableCell>
                      <TableCell>{act.duration_minutes ?? 0} min</TableCell>
                      <TableCell>{act.date ?? "-"}</TableCell>
                    </TableRow>
                  ))}
                </TableBody>
              </Table>
            )}
          </CardContent>
        </Card>

        {/* Suivi Humeur */}
        <Card>
          <CardHeader>
            <CardTitle className="flex items-center gap-2">
              <LineChart className="h-5 w-5" />
              Historique humeur
            </CardTitle>
          </CardHeader>
          <CardContent>
            {moodHistory.length === 0 ? (
              <p className="text-muted-foreground py-4 text-center text-sm">
                Aucune humeur enregistrée.
              </p>
            ) : (
              <Table>
                <TableHeader>
                  <TableRow>
                    <TableHead>Humeur</TableHead>
                    <TableHead>Note</TableHead>
                    <TableHead>Date</TableHead>
                  </TableRow>
                </TableHeader>
                <TableBody>
                  {moodHistory.slice(0, 5).map((mood, index) => (
                    <TableRow key={mood.id ?? index}>
                      <TableCell>
                        <span className="text-lg">
                          {mood.mood_value >= 4
                            ? "😊"
                            : mood.mood_value >= 3
                              ? "😐"
                              : "😞"}
                        </span>
                      </TableCell>
                      <TableCell>{mood.note ?? "Pas de commentaire"}</TableCell>
                      <TableCell>
                        {mood.created_at
                          ? new Date(mood.created_at).toLocaleDateString(
                              "fr-FR",
                            )
                          : "-"}
                      </TableCell>
                    </TableRow>
                  ))}
                </TableBody>
              </Table>
            )}
          </CardContent>
        </Card>
      </div>
    </div>
  );
}
