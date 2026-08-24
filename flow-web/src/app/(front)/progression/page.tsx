"use client";

import { useEffect, useState } from "react";
import { Loader2, AlertCircle, LineChart, Calendar, Target, Smile, Activity } from "lucide-react";
import { apiClient } from "@/lib/api-client";
import { Card, CardContent, CardHeader, CardTitle } from "@/components/ui/card";
import { Table, TableBody, TableCell, TableHead, TableHeader, TableRow } from "@/components/ui/table";

interface MoodEntry {
  id: number;
  mood_value: number;
  note: string;
  created_at: string;
}

interface ActivityEntry {
  id: number;
  titre: string;
  duree: number;
  created_at: string;
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
        const [moodRes, activityRes] = await Promise.all([
          apiClient.get<any>("/humeur/historique"),
          apiClient.get<any>("/progress"),
        ]);

        // SÉCURITÉ : On vérifie si Laravel a encapsulé le tableau dans "data"
        // Si c'est un tableau on le prend direct, sinon on cherche .data, sinon on met un tableau vide []
        const moodArray = Array.isArray(moodRes) ? moodRes : (moodRes?.data || []);
        const activityArray = Array.isArray(activityRes) ? activityRes : (activityRes?.data || []);

        setMoodHistory(moodArray);
        setActivityHistory(activityArray);
      } catch (err: any) {
        setError("Impossible de récupérer vos données de progression.");
      } finally {
        setIsLoading(false);
      }
    }
    void fetchUserStats();
  }, []);

  if (isLoading) {
    return (
      <div className="flex h-[60vh] items-center justify-center">
        <Loader2 className="h-8 w-8 animate-spin text-primary" />
      </div>
    );
  }

  return (
    <div className="space-y-8 pb-12 pt-6">
      <div className="space-y-2">
        <h1 className="text-3xl font-bold tracking-tight">Mon Espace Progression</h1>
        <p className="text-muted-foreground">Retrouvez vos activités passées et l&apos;évolution de votre humeur.</p>
      </div>

      {error && (
        <div className="flex items-center gap-3 rounded-xl bg-destructive/10 p-4 text-destructive">
          <AlertCircle className="h-5 w-5" />
          <p className="text-sm font-medium">{error}</p>
        </div>
      )}

      {/* Cartes de Stats Rapides */}
      <div className="grid grid-cols-1 md:grid-cols-3 gap-6">
        <Card>
          <CardHeader className="flex flex-row items-center justify-between pb-2">
            <CardTitle className="text-sm font-medium">Total Activités</CardTitle>
            <Activity className="h-4 w-4 text-primary" />
          </CardHeader>
          <CardContent>
            <div className="text-2xl font-bold">{activityHistory.length}</div>
          </CardContent>
        </Card>
        <Card>
          <CardHeader className="flex flex-row items-center justify-between pb-2">
            <CardTitle className="text-sm font-medium">Dernière Humeur</CardTitle>
            <Smile className="h-4 w-4 text-primary" />
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
            <Target className="h-4 w-4 text-primary" />
          </CardHeader>
          <CardContent>
            <div className="text-2xl font-bold">
              {/* Le reduce fonctionnera toujours maintenant car on est sûr à 100% que c'est un tableau */}
              {activityHistory.reduce((acc, curr) => acc + (curr.duree || 0), 0)} min
            </div>
          </CardContent>
        </Card>
      </div>

      {/* Sections Détails */}
      <div className="grid grid-cols-1 lg:grid-cols-2 gap-8">
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
               <p className="text-sm text-muted-foreground text-center py-4">Aucune activité enregistrée.</p>
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
                    <TableRow key={act.id || index}>
                      <TableCell className="font-medium">{act.titre || "Séance sans titre"}</TableCell>
                      <TableCell>{act.duree || 0} min</TableCell>
                      <TableCell>{act.created_at ? new Date(act.created_at).toLocaleDateString("fr-FR") : "-"}</TableCell>
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
               <p className="text-sm text-muted-foreground text-center py-4">Aucune humeur enregistrée.</p>
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
                    <TableRow key={mood.id || index}>
                      <TableCell>
                          <span className="text-lg">
                              {mood.mood_value >= 4 ? "😊" : mood.mood_value >= 3 ? "😐" : "😞"}
                          </span>
                      </TableCell>
                      <TableCell>{mood.note || "Pas de commentaire"}</TableCell>
                      <TableCell>{mood.created_at ? new Date(mood.created_at).toLocaleDateString("fr-FR") : "-"}</TableCell>
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