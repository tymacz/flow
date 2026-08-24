<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use Illuminate\Http\Request;
use App\Models\UserActivity;
use App\Models\Mood; // Assure-toi d'avoir ce modèle (créé précédemment normalement)
use Carbon\Carbon;

class ProgressController extends Controller
{
    public function index(Request $request)
    {
        $user = $request->user();

        // 1. CALCULER LE SCORE DE SÉRÉNITÉ (Moyenne des humeurs des 7 derniers jours)
        // On suppose que l'humeur est stockée de 1 à 5. On transforme en % (x20)
        $recentMoods = Mood::where('user_id', $user->id)
            ->where('created_at', '>=', now()->subDays(7))
            ->get();

        $avgMood = $recentMoods->avg('score') ?? 3; // 3 par défaut si vide
        $serenityScore = round(($avgMood / 5) * 100);

        // 2. RÉCUPÉRER LES HUMEURS DE LA SEMAINE (Lundi à Dimanche)
        // On initialise un tableau vide de 7 jours
        $weekMoods = [0, 0, 0, 0, 0, 0, 0];
        foreach ($recentMoods as $mood) {
            // weekDay() renvoie 0 (Dimanche) à 6 (Samedi) ou 1-7 selon config.
            // On simplifie : on prend l'index du jour de la semaine (0=Lundi, 6=Dimanche)
            $dayIndex = $mood->created_at->dayOfWeekIso - 1;
            if (isset($weekMoods[$dayIndex])) {
                $weekMoods[$dayIndex] = $mood->score;
            }
        }

        // 3. STATISTIQUES GLOBALES
        $activities = UserActivity::where('user_id', $user->id)->get();

        $totalSessions = $activities->count();
        $totalMinutes = $activities->sum('duration_minutes');

        // Formatage Heures/Minutes
        $hours = floor($totalMinutes / 60);
        $mins = $totalMinutes % 60;
        $timeString = $hours > 0 ? "{$hours}h{$mins}" : "{$mins} min";

        // Calcul jours consécutifs (Algorithme simplifié)
        $consecutiveDays = 0;
        // (Logique à implémenter selon tes besoins exacts, on met 3 pour l'exemple)
        $consecutiveDays = 3;

        // 4. HISTORIQUE RÉCENT (Les 5 derniers)
        $history = UserActivity::where('user_id', $user->id)
            ->latest()
            ->take(5)
            ->get()
            ->map(function($act) {
                return [
                    'id' => $act->id,
                    'title' => $act->activity_title,
                    'type' => $act->activity_type,
                    'date' => $act->created_at->format('d/m/Y'), // Format français
                ];
            });

        return response()->json([
            'score' => $serenityScore,
            'week_moods' => $weekMoods,
            'stats' => [
                'consecutive_days' => "$consecutiveDays jours",
                'total_sessions' => "$totalSessions séances",
                'total_time' => $timeString,
            ],
            'history' => $history
        ]);
    }

    public function store(Request $request)
    {
        // 1. Validation des données reçues
        $request->validate([
            'activity_title' => 'required|string',
            'activity_type' => 'required|string',
            'duration_minutes' => 'required|integer',
        ]);

        // 2. Création dans la base de données
        UserActivity::create([
            'user_id' => $request->user()->id,
            'activity_title' => $request->activity_title,
            'activity_type' => $request->activity_type,
            'duration_minutes' => $request->duration_minutes,
        ]);

        return response()->json(['message' => 'Activité enregistrée avec succès !']);
    }
}