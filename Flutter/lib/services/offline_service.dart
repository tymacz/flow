import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flow/services/api_service.dart'; // Ajuste l'import selon ton projet

class OfflineService {
  static const String _queueKey = 'offline_actions_queue';

  // ==========================================
  // NIVEAU 1 : LECTURE HORS LIGNE (CACHE)
  // ==========================================

  // Sauvegarder les données de l'API (ex: la liste des activités)
  Future<void> cacheData(String key, dynamic data) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(key, jsonEncode(data));
  }

  // Récupérer les données sauvegardées quand on n'a pas internet
  Future<dynamic> getCachedData(String key) async {
    final prefs = await SharedPreferences.getInstance();
    final String? cachedString = prefs.getString(key);
    if (cachedString != null) {
      return jsonDecode(cachedString);
    }
    return null;
  }

  // ==========================================
  // NIVEAU 3 : FILE D'ATTENTE (ÉCRITURE)
  // ==========================================

  // Ajouter une action (ex: "J'ai fini le yoga") à la file d'attente
  Future<void> enqueueAction(String url, Map<String, dynamic> data) async {
    final prefs = await SharedPreferences.getInstance();
    List<String> queue = prefs.getStringList(_queueKey) ?? [];

    // On sauvegarde l'URL de l'API et les données à envoyer
    final action = jsonEncode({'url': url, 'data': data});
    queue.add(action);

    await prefs.setStringList(_queueKey, queue);
    print("Action sauvegardée hors-ligne : $url");
  }

  // Envoyer toutes les actions en attente quand internet revient
  Future<void> syncQueue(ApiService apiService) async {
    final prefs = await SharedPreferences.getInstance();
    List<String> queue = prefs.getStringList(_queueKey) ?? [];

    if (queue.isEmpty) return; // Rien à synchroniser

    print("Synchronisation de ${queue.length} actions en attente...");

    List<String> remainingQueue = [];

    for (String actionStr in queue) {
      try {
        final action = jsonDecode(actionStr);
        // On tente d'envoyer la donnée au serveur
        await apiService.dio.post(action['url'], data: action['data']);
        print("Action synchronisée avec succès : ${action['url']}");
      } catch (e) {
        // Si ça rate encore, on la garde pour plus tard
        print("Échec de synchronisation, on garde en mémoire.");
        remainingQueue.add(actionStr);
      }
    }

    // On met à jour la file d'attente
    await prefs.setStringList(_queueKey, remainingQueue);
  }
}
