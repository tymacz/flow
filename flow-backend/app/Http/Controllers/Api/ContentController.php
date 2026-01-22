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

    // Ajouter / Retirer un favori (Le fameux Toggle)
    public function toggleFavorite(Request $request, $id)
    {
        $user = $request->user();

        // On récupère le tableau actuel ou un tableau vide
        $favoris = $user->favoris_ids ?? [];

        if (in_array($id, $favoris)) {
            // Si l'ID est déjà là, on l'enlève (array_diff)
            $user->pull('favoris_ids', $id);
            $message = 'Retiré des favoris';
        } else {
            // Sinon, on l'ajoute (push)
            $user->push('favoris_ids', $id);
            $message = 'Ajouté aux favoris';
        }

        // Pas besoin de $user->save() avec push/pull sur le driver Mongo récent,
        // mais si ça ne marche pas, décommente la ligne suivante :
        // $user->save();

        return response()->json([
            'message' => $message,
            'favoris' => $user->fresh()->favoris_ids // On renvoie la liste à jour
        ]);
    }
}