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

        $user = User::where('email', $request->email)->first();

        if (!$user || !Hash::check($request->password, $user->password)) {
            return response()->json(['message' => 'Identifiants incorrects'], 401);
        }

        $token = $user->createToken('API Token')->plainTextToken;

        return response()->json([
            'user' => $user,
            'token' => $token
        ]);
    }

    public function show($id)
    {
        // Récupère l'utilisateur ou renvoie une erreur 404 s'il n'existe pas
        $user = \App\Models\User::findOrFail($id);

        return response()->json($user, 200);
    }

    // Connexion
    public function login(Request $request)
    {
        if (!Auth::attempt($request->only('email', 'password'))) {
            return response()->json(['message' => 'Identifiants invalides'], 401);
        }

        $user = User::where('email', $request->email)->first();

        if (!$user || !Hash::check($request->password, $user->password)) {
            return response()->json(['message' => 'Identifiants incorrects'], 401);
        }

        $token = $user->createToken('API Token')->plainTextToken;

        return response()->json([
            'user' => $user,
            'token' => $token
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
}
