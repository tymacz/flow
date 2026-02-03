<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use App\Models\Activity;
use App\Models\Article;
use Illuminate\Http\Request;

class ContentController extends Controller
{
    // Lister les activités
    public function indexActivities()
    {
        // On retourne tout (on pourra ajouter ->limit(10) plus tard)
        return Activity::all();
    }

    // Lister les articles
    public function indexArticles()
    {
        return Article::all();
    }

    public function indexFavorites(Request $request)
    {
        $user = $request->user();

        // 1. On récupère la liste des IDs (ou un tableau vide si null)
        $favorisIds = $user->favoris_ids ?? [];

        // 2. On vérifie si la liste est vide pour éviter une requête inutile
        if (empty($favorisIds)) {
            return [];
        }

        // 3. On cherche toutes les activités dont l'ID est DANS ($whereIn) la liste
        // Note : Avec MongoDB, c'est souvent '_id', mais Eloquent mappe souvent 'id' automatiquement.
        // Si 'id' ne marche pas, essaie '_id'.
        $activities = Activity::whereIn('_id', $favorisIds)->get();

        return $activities;
    }

    // Ajouter / Retirer un favori (Le fameux Toggle)
    public function toggleFavorite(Request $request, $id)
    {
        $user = $request->user();

        // 1. On récupère le tableau existant (ou vide)
        // Le cast 'array' dans le modèle User s'occupe de la conversion
        $favoris = $user->favoris_ids ?? [];

        if (in_array($id, $favoris)) {
            // --- RETRAIT ---
            // On enlève l'ID du tableau
            $favoris = array_diff($favoris, [$id]);
            // On réindexe le tableau (0, 1, 2...) sinon Mongo stocke un objet {"0": "id", "2": "id"}
            $favoris = array_values($favoris);
            $message = 'Retiré des favoris';
        } else {
            // --- AJOUT ---
            // On ajoute l'ID à la fin
            $favoris[] = $id;
            // On s'assure qu'il est unique (juste au cas où)
            $favoris = array_unique($favoris);
            // On réindexe
            $favoris = array_values($favoris);
            $message = 'Ajouté aux favoris';
        }

        // 2. On assigne le nouveau tableau à l'utilisateur
        $user->favoris_ids = $favoris;

        // 3. On sauvegarde explicitement (C'est là que ça plantait avant)
        $user->save();

        return response()->json([
            'message' => $message,
            'favoris' => $user->favoris_ids
        ]);
    }
}