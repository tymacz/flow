<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use App\Models\User;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Hash;
use Illuminate\Support\Facades\Auth;

class AuthController extends Controller
{
    // Inscription
    public function register(Request $request)
    {
        $validated = $request->validate([
            'prenom' => 'required|string|max:255',
            'nom' => 'required|string|max:255',
            'email' => 'required|string|email|max:255|unique:utilisateurs', // 'utilisateurs' est ta collection
            'password' => 'required|string|min:6',
        ]);

        $user = User::create([
            'prenom' => $validated['prenom'],
            'nom' => $validated['nom'],
            'email' => $validated['email'],
            'password' => Hash::make($validated['password']),
            'role' => 'USER',
            'favoris_ids' => [], // On initialise le tableau vide
        ]);

        // Création du token d'accès (Sanctum)
        $token = $user->createToken('auth_token')->plainTextToken;

        return response()->json([
            'message' => 'Utilisateur créé avec succès',
            'user' => $user,
            'access_token' => $token,
            'token_type' => 'Bearer',
        ], 201);
    }

    // Connexion
    public function login(Request $request)
    {
        Log::info('Login Request Data:', $request->all());
        if (!Auth::attempt($request->only('email', 'password'))) {
            return response()->json(['message' => 'Identifiants invalides'], 401);
        }

        $user = User::where('email', $request['email'])->firstOrFail();
        $token = $user->createToken('auth_token')->plainTextToken;

        return response()->json([
            'message' => 'Connexion réussie',
            'access_token' => $token,
            'token_type' => 'Bearer',
            'user' => $user
        ]);
    }

    public function updateProfile(Request $request)
{
    $user = $request->user(); // Récupère l'utilisateur connecté via le token

    // On valide les données reçues
    $validated = $request->validate([
        'prenom' => 'nullable|string',
        'nom' => 'nullable|string',
        'avatar_url' => 'nullable|url', // Doit être une URL valide (Supabase)
        'preferences' => 'nullable|array', // Doit être un tableau JSON
    ]);

    // On met à jour uniquement ce qui est envoyé
    $user->update($validated);

    return response()->json([
        'message' => 'Profil mis à jour',
        'user' => $user
    ]);
}

    // Récupérer son propre profil (Route /user)
    public function me(Request $request)
    {
        return $request->user();
    }


    public function toggleFavorite(Request $request, string $activityId)
{
    $user = $request->user();

    // On s'assure que c'est bien un tableau (par défaut [] si null)
    $favoris = $user->favoris_ids ?? [];

    if (in_array($activityId, $favoris)) {
        $favoris = array_values(array_diff($favoris, [$activityId]));
    } else {
        $favoris[] = $activityId;
    }

    // On sauvegarde
    $user->update(['favoris_ids' => $favoris]);

    return response()->json([
        'message' => 'Favoris mis à jour',
        'favoris' => $favoris
    ]);
}

    // ==========================================
    // GESTION DU PROFIL UTILISATEUR (CRUD)
    // ==========================================

    /**
     * Récupérer les informations d'un utilisateur spécifique
     */
    public function show($id)
    {
        // Récupère l'utilisateur ou renvoie une erreur 404 s'il n'existe pas
        $user = \App\Models\User::findOrFail($id);

        return response()->json($user, 200);
    }

    /**
     * Mettre à jour le profil (nom, email, préférences)
     */
    public function update(Request $request, $id)
    {
        $user = \App\Models\User::findOrFail($id);

        $data = $request->all();

        // Le front-end envoie les préférences sous forme d'objet/tableau.
        // On s'assure de les convertir en chaîne JSON avant de les sauvegarder en base.
        if (isset($data['preferences']) && is_array($data['preferences'])) {
            $data['preferences'] = json_encode($data['preferences']);
        }

        $user->update($data);

        return response()->json([
            'message' => 'Profil mis à jour avec succès',
            'user' => $user
        ], 200);
    }

    /**
     * Supprimer un compte utilisateur
     */
    public function destroy($id)
    {
        \App\Models\User::destroy($id);

        return response()->json([
            'message' => 'Compte supprimé avec succès'
        ], 200);
    }
}
