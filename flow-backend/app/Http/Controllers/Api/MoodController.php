<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use App\Models\MoodLog;
use Illuminate\Http\Request;

class MoodController extends Controller
{
    // Enregistrer l'humeur du jour
    public function store(Request $request)
    {
        $validated = $request->validate([
            'emotion_id' => 'required|string', // L'ID Mongo de l'émotion
            'intensite' => 'required|integer|min:1|max:10',
            'note_personnelle' => 'nullable|string',
            // Optionnel : snapshot du nom/emoji pour éviter les jointures plus tard
            'snapshot_nom' => 'nullable|string',
            'snapshot_emoji' => 'nullable|string',
        ]);

        $moodLog = MoodLog::create([
            'utilisateur_id' => $request->user()->id, // Lien auto avec l'user connecté
            'emotion_id' => $validated['emotion_id'],
            'intensite' => $validated['intensite'],
            'note_personnelle' => $validated['note_personnelle'] ?? '',
            'date_heure' => now(), // Date actuelle gérée par Carbon

            // Si tu as décidé de stocker les snapshots (recommandé en NoSQL)
            'emotion_snapshot_nom' => $validated['snapshot_nom'] ?? null,
            'emotion_snapshot_emoji' => $validated['snapshot_emoji'] ?? null,
        ]);

        return response()->json($moodLog, 201);
    }

    // Récupérer l'historique
    public function history(Request $request)
    {
        $user = $request->user();

        // On récupère les logs de l'utilisateur, triés du plus récent au plus vieux
        $logs = MoodLog::where('utilisateur_id', $user->id)
            ->orderBy('date_heure', 'desc')
            ->limit(30) // Par exemple les 30 derniers jours
            ->get();

        return response()->json($logs);
    }
}