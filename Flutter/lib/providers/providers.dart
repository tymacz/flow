import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../services/api_service.dart';
import '../models/user.dart';
import '../models/article.dart';
import '../models/activity.dart';
import '../models/progress_data.dart';

// 1. Provider du Service API
final apiServiceProvider = Provider<ApiService>((ref) => ApiService());

// 2. Provider de l'Utilisateur (Authentification)
final authUserProvider = StateNotifierProvider<AuthNotifier, AsyncValue<User?>>(
  (ref) {
    return AuthNotifier(ref.read(apiServiceProvider));
  },
);

// 3. Provider du "Dernier Article"
final latestArticleProvider = FutureProvider<Article?>((ref) async {
  final apiService = ref.read(apiServiceProvider);
  try {
    final response = await apiService.dio.get('/articles');
    final List data = response.data;
    if (data.isNotEmpty) {
      return Article.fromJson(data.first);
    }
    return null;
  } catch (e) {
    return null;
  }
});

final articlesProvider = FutureProvider.autoDispose<List<Article>>((ref) async {
  final apiService = ref.read(apiServiceProvider);
  final response = await apiService.dio.get('/articles');
  // On transforme la liste JSON en liste d'objets Article
  return (response.data as List).map((e) => Article.fromJson(e)).toList();
});

// 4. Provider des Activités
final activitiesProvider = FutureProvider.autoDispose((ref) async {
  final apiService = ref.read(apiServiceProvider);
  final response = await apiService.dio.get('/activities');
  return (response.data as List)
      .map((e) => Activity.fromJson(e))
      .toList(); // Assure-toi d'importer Activity si besoin
  // Note: Si Activity n'est pas importé ici, ajoute l'import en haut ou remplace par dynamic temporairement
});

// --- LA CLASSE AUTH NOTIFIER ---
class AuthNotifier extends StateNotifier<AsyncValue<User?>> {
  final ApiService _apiService; // C'est ici qu'il est défini

  AuthNotifier(this._apiService) : super(const AsyncValue.loading()) {
    checkAuthStatus();
  }

  Future<List> activitiesFavoris(ref) async {
    final apiService = ref.read(apiServiceProvider);
    final response = await apiService.dio.get('/activities/favori');
    return (response.data as List).map((e) => Activity.fromJson(e)).toList();
  }

  // Vérifier si connecté
  Future<void> checkAuthStatus() async {
    try {
      final token = await _apiService.storage.read(key: 'auth_token');
      if (token == null) {
        state = const AsyncValue.data(null);
        return;
      }
      final response = await _apiService.dio.get('/user');
      state = AsyncValue.data(User.fromJson(response.data));
    } catch (e) {
      await logout();
    }
  }

  // Connexion
  Future<bool> login(String email, String password) async {
    state = const AsyncValue.loading();
    try {
      final response = await _apiService.dio.post(
        '/login',
        data: {'email': email, 'password': password},
      );

      final token = response.data['access_token'];
      await _apiService.storage.write(key: 'auth_token', value: token);

      final user = User.fromJson(response.data['user']);
      state = AsyncValue.data(user);
      return true;
    } catch (e) {
      state = const AsyncValue.data(null);
      return false;
    }
  }

  // Déconnexion
  Future<void> logout() async {
    await _apiService.storage.delete(key: 'auth_token');
    state = const AsyncValue.data(null);
  }

  // 👇 LA MÉTHODE UPDATE DOIT ÊTRE ICI (AVANT LA DERNIÈRE ACCOLADE)
  Future<void> updateUser({
    String? prenom, // <--- Ajouté
    String? nom, // <--- Ajouté
    String? avatarUrl,
    Map<String, dynamic>? preferences,
  }) async {
    try {
      final Map<String, dynamic> data = {};

      // On ajoute les champs seulement s'ils sont modifiés
      if (prenom != null) data['prenom'] = prenom;
      if (nom != null) data['nom'] = nom;
      if (avatarUrl != null) data['avatar_url'] = avatarUrl;

      if (preferences != null) {
        final currentPrefs = state.value?.preferences ?? {};
        data['preferences'] = {...currentPrefs, ...preferences};
      }

      // Si aucune donnée à changer, on arrête là
      if (data.isEmpty) return;

      // Appel API
      final response = await _apiService.dio.put('/user', data: data);

      // Mise à jour locale immédiate
      state = AsyncValue.data(User.fromJson(response.data['user']));
    } catch (e) {
      print("Erreur update user: $e");
      // Tu peux relancer l'erreur pour la gérer dans l'UI si tu veux
      rethrow;
    }
  }
  // Dans AuthNotifier...

  Future<void> toggleFavorite(String activityId) async {
    final currentUser = state.value;
    if (currentUser == null) return;

    try {
      // 1. Mise à jour Optimiste (UI change tout de suite)
      List<String> newFavoris = List.from(currentUser.favorisIds);

      if (newFavoris.contains(activityId)) {
        newFavoris.remove(activityId);
      } else {
        newFavoris.add(activityId);
      }

      state = AsyncValue.data(currentUser.copyWith(favorisIds: newFavoris));

      // 2. Envoi au serveur
      await _apiService.dio.post('/activites/$activityId/favori');
    } catch (e) {
      print("Erreur favoris API: $e");
      checkAuthStatus();
    }
  }
}

final progressProvider = FutureProvider.autoDispose<ProgressData>((ref) async {
  final apiService = ref.read(apiServiceProvider);
  final response = await apiService.dio.get('/progress');
  return ProgressData.fromJson(response.data);
});
