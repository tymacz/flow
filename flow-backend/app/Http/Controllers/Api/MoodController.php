<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use Illuminate\Http\Request;
use App\Models\Mood;
use App\Models\MoodLog;

class MoodController extends Controller
{
    public function store(Request $request)
    {
        // 1. Vérification : A-t-il déjà voté aujourd'hui ?
        // On cherche une humeur créée entre 00:00 et 23:59 aujourd'hui
        $alreadyVoted = Mood::where('user_id', $request->user()->id)
            ->where('created_at', '>=', now()->startOfDay())
            ->where('created_at', '<=', now()->endOfDay())
            ->exists();

        if ($alreadyVoted) {
            return response()->json(['message' => 'Vous avez déjà noté votre humeur aujourd\'hui.'], 409); // 409 = Conflict
        }

        // 2. Validation (Code existant)
        $request->validate([
            'score' => 'required|integer|min:1|max:5',
            'main_emotion' => 'required|string',
            'sub_emotion' => 'nullable|string',
        ]);

        // 3. Création (Code existant)
        Mood::create([
            'user_id' => $request->user()->id,
            'score' => $request->score,
            'main_emotion' => $request->main_emotion,
            'sub_emotion' => $request->sub_emotion,
            'created_at' => now(),
        ]);

        return response()->json(['message' => 'Humeur enregistrée !']);
    }

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

