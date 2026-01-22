import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:dio/dio.dart';
import '../services/api_service.dart';
import '../models/user.dart';
import '../models/article.dart';

final apiServiceProvider = Provider<ApiService>((ref) => ApiService());

final authUserProvider = StateNotifierProvider<AuthNotifier, AsyncValue<User?>>((ref) {
  return AuthNotifier(ref.read(apiServiceProvider));
});

class AuthNotifier extends StateNotifier<AsyncValue<User?>> {
  final ApiService _apiService;

  AuthNotifier(this._apiService) : super(const AsyncValue.loading()) {
    checkAuthStatus();
  }

  // Vérifier si déjà connecté au démarrage
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
      final response = await _apiService.dio.post('/login', data: {
        'email': email,
        'password': password,
      });

      // 1. Sauvegarder le token
      final token = response.data['access_token'];
      await _apiService.storage.write(key: 'auth_token', value: token);

      // 2. Mettre à jour l'état avec le User reçu
      final user = User.fromJson(response.data['user']);
      state = AsyncValue.data(user);
      return true;
    } catch (e) {
      state = const AsyncValue.data(null); // Retour à l'état "pas connecté" en cas d'erreur
      return false;
    }
  }

  // Déconnexion
  Future<void> logout() async {
    try {
        // Optionnel: Prévenir le backend
       // await _apiService.dio.post('/logout'); 
    } catch (_) {}
    
    await _apiService.storage.delete(key: 'auth_token');
    state = const AsyncValue.data(null);
  }
}

final latestArticleProvider = FutureProvider<Article?>((ref) async {
  final apiService = ref.read(apiServiceProvider);
  try {
    // On récupère la liste des articles
    // Note: Assure-toi que ta route /articles est accessible (publique ou protégée)
    final response = await apiService.dio.get('/articles');
    final List data = response.data;
    
    if (data.isNotEmpty) {
      // On prend le dernier ou le premier de la liste
      return Article.fromJson(data.first);
    }
    return null;
  } catch (e) {
    return null; // En cas d'erreur ou pas d'articles
  }
});
