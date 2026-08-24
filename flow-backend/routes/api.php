<?php

use Illuminate\Support\Facades\Route;
use App\Http\Controllers\Api\ContentController;
use App\Http\Controllers\Api\MoodController;
use App\Http\Controllers\Api\AuthController;
use App\Http\Controllers\Api\ProgressController;

// Routes Publiques & Authentification
Route::post('/register', [AuthController::class, 'register']);
Route::post('/login', [AuthController::class, 'login']);

// --- CRUD ACTIVITÉS ---
Route::get('/activities', [ContentController::class, 'indexActivities']);
Route::get('/activities/{id}', [ContentController::class, 'showActivity']);
Route::post('/activities', [ContentController::class, 'storeActivity']);
Route::put('/activities/{id}', [ContentController::class, 'updateActivity']);
Route::delete('/activities/{id}', [ContentController::class, 'destroyActivity']);

// --- CRUD ARTICLES ---
Route::get('/articles', [ContentController::class, 'indexArticles']);
Route::get('/articles/{id}', [ContentController::class, 'showArticle']);
Route::post('/articles', [ContentController::class, 'storeArticle']);
Route::put('/articles/{id}', [ContentController::class, 'updateArticle']);
Route::delete('/articles/{id}', [ContentController::class, 'destroyArticle']);


// Routes Protégées (Nécessite d'être connecté sur l'app mobile)
Route::middleware('auth:sanctum')->group(function () {
    // Gestion Utilisateur
    Route::get('/user', [AuthController::class, 'me']);
    Route::put('/user', [AuthController::class, 'updateProfile']);
    Route::get('/progress', [ProgressController::class, 'index']);
    Route::delete('/user', [AuthController::class, 'destroy']);
        Route::get('/user/{id}', [AuthController::class, 'show']);       // Lire un utilisateur précis
        Route::put('/user/{id}', [AuthController::class, 'update']);     // Modifier un utilisateur précis
        Route::delete('/user/{id}', [AuthController::class, 'destroy']); // Supprimer un utilisateur précis



    // Contenu
    Route::post('/activites/{id}/favori', [ContentController::class, 'toggleFavorite']);
    Route::post('/activities/favori', [ContentController::class, 'indexFavorites']);

    // Humeur
    Route::post('/humeur', [MoodController::class, 'store']);
    Route::get('/humeur/historique', [MoodController::class, 'history']);
    Route::post('/activities/complete', [ProgressController::class, 'store']);
});
