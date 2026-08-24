<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use App\Models\Activity;
use App\Models\Article;
use Illuminate\Http\Request;

class ContentController extends Controller
{
    // ==========================================
    // GESTION DES ACTIVITÉS
    // ==========================================

    public function indexActivities()
    {
        return Activity::all();
    }

    public function showActivity($id)
    {
        return Activity::findOrFail($id);
    }

    public function storeActivity(Request $request)
    {
        // Enregistre toutes les données envoyées par Next.js
        $activity = Activity::create($request->all());
        return response()->json($activity, 201);
    }

    public function updateActivity(Request $request, $id)
    {
        $activity = Activity::findOrFail($id);
        $activity->update($request->all());
        return response()->json($activity, 200);
    }

    public function destroyActivity($id)
    {
        Activity::destroy($id);
        return response()->json(['message' => 'Activité supprimée avec succès'], 200);
    }


    // ==========================================
    // GESTION DES ARTICLES
    // ==========================================

    public function indexArticles()
    {
        return Article::all();
    }

    public function showArticle($id)
    {
        return Article::findOrFail($id);
    }

    public function storeArticle(Request $request)
    {
        $article = Article::create($request->all());
        return response()->json($article, 201);
    }

    public function updateArticle(Request $request, $id)
    {
        $article = Article::findOrFail($id);
        $article->update($request->all());
        return response()->json($article, 200);
    }

    public function destroyArticle($id)
    {
        Article::destroy($id);
        return response()->json(['message' => 'Article supprimé avec succès'], 200);
    }

    // ==========================================
    // FAVORIS (Mobile)
    // ==========================================

    public function indexFavorites(Request $request)
    {
        $user = $request->user();
        $favorisIds = $user->favoris_ids ?? [];

        if (empty($favorisIds)) {
            return [];
        }

        return Activity::whereIn('_id', $favorisIds)->get();
    }

    public function toggleFavorite(Request $request, $id)
    {
        $user = $request->user();
        $favoris = $user->favoris_ids ?? [];

        if (in_array($id, $favoris)) {
            $favoris = array_diff($favoris, [$id]);
            $favoris = array_values($favoris);
            $message = 'Retiré des favoris';
        } else {
            $favoris[] = $id;
            $favoris = array_unique($favoris);
            $favoris = array_values($favoris);
            $message = 'Ajouté aux favoris';
        }

        $user->favoris_ids = $favoris;
        $user->save();

        return response()->json([
            'message' => $message,
            'favoris' => $user->favoris_ids
        ]);
    }
}
