import 'package:flutter_test/flutter_test.dart';
// Adapte le chemin selon ton projet
import 'package:flow/models/activity.dart';

void main() {
  group('Activity Model Tests', () {
    test('fromJson doit créer une Activity valide avec toutes les données', () {
      final json = {
        '_id': 'act_123',
        'titre': 'Séance de HIIT',
        'description': 'Entraînement intense de 15 minutes',
        'duree_minutes': 15,
        'categorie': 'Cardio',
        'image_url': 'https://flow.com/image.jpg',
      };

      final activity = Activity.fromJson(json);

      expect(activity.id, 'act_123');
      expect(activity.titre, 'Séance de HIIT');
      expect(activity.description, 'Entraînement intense de 15 minutes');
      expect(activity.dureeMinutes, 15);
      expect(activity.categorie, 'Cardio');
      expect(activity.imageUrl, 'https://flow.com/image.jpg');
    });

    test('fromJson doit utiliser "id" si "_id" est absent', () {
      final json = {
        'id': 'act_456', // Utilisation de 'id' au lieu de '_id'
        'titre': 'Mobilité',
      };

      final activity = Activity.fromJson(json);

      expect(activity.id, 'act_456');
    });

    test(
      'fromJson doit appliquer les valeurs par défaut si les données manquent',
      () {
        final json = {
          '_id': 'act_789',
          // Tous les autres champs sont volontairement omis
        };

        final activity = Activity.fromJson(json);

        // Vérification des valeurs de secours (fallback) définies dans ton modèle
        expect(activity.id, 'act_789');
        expect(activity.titre, 'Activité');
        expect(activity.description, '');
        expect(activity.dureeMinutes, 0);
        expect(activity.categorie, 'Divers');
        expect(activity.imageUrl, '');
      },
    );
  });
}
