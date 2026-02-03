<?php

use Illuminate\Support\Facades\Route;
use App\Http\Controllers\Api\ContentController;
use App\Http\Controllers\Api\MoodController;
use App\Http\Controllers\Api\AuthController;
use App\Http\Controllers\Api\ProgressController;

// Routes Publiques
Route::post('/register', [AuthController::class, 'register']);
Route::post('/login', [AuthController::class, 'login']);
Route::get('/activities', [ContentController::class, 'indexActivities']);
Route::get('/articles', [ContentController::class, 'indexArticles']);

// Routes Protégées (Nécessite d'être connecté)
Route::middleware('auth:sanctum')->group(function () {

    // Gestion Utilisateur
    Route::get('/user', [AuthController::class, 'me']);
    Route::put('/user', [AuthController::class, 'updateProfile']);
    Route::get('/progress', [ProgressController::class, 'index']);
    // Contenu

    Route::post('/activites/{id}/favori', [ContentController::class, 'toggleFavorite']);
    Route::post('/activities/favori', [ContentController::class, 'indexFavorites']);

    // Humeur
    Route::post('/humeur', [MoodController::class, 'store']); // Enregistrer l'humeur du jour
    Route::get('/humeur/historique', [MoodController::class, 'history']); // Pour le graphe hebdo

});
