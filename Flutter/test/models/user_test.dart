import 'package:flutter_test/flutter_test.dart';
import 'package:flow/models/user.dart';

void main() {
  group('User Model Tests', () {
    test(
      'fromJson doit créer un User valide à partir de données JSON complètes',
      () {
        final json = {
          '_id': '12345',
          'prenom': 'Maxence',
          'nom': 'Flow',
          'email': 'maxence@flow.com',
          'avatar_url': 'https://image.com/avatar.png',
          'preferences': {'theme': 'dark', 'notifications': true},
          'favoris_ids': ['fav1', 'fav2'],
        };

        final user = User.fromJson(json);

        expect(user.id, '12345');
        expect(user.prenom, 'Maxence');
        expect(user.email, 'maxence@flow.com');
        expect(user.avatarUrl, 'https://image.com/avatar.png');
        expect(user.preferences['theme'], 'dark');
        expect(user.favorisIds.length, 2);
        expect(user.favorisIds.contains('fav1'), true);
      },
    );

    test(
      'fromJson doit gérer les données manquantes ou nulles en toute sécurité',
      () {
        final json = {
          '_id': '67890',
          'prenom': 'Admin',
          // nom, email, avatar_url, preferences et favoris_ids sont manquants ou nulls
          'preferences': null,
          'favoris_ids': 'ceci_n_est_pas_une_liste', // Test de sécurité de type
        };

        final user = User.fromJson(json);

        expect(user.id, '67890');
        expect(user.prenom, 'Admin');
        expect(user.nom, ''); // Valeur par défaut
        expect(user.email, ''); // Valeur par défaut
        expect(user.avatarUrl, isNull);
        expect(user.preferences, isEmpty); // La sécurisation doit renvoyer {}
        expect(user.favorisIds, isEmpty); // La sécurisation doit renvoyer []
      },
    );

    test('copyWith doit mettre à jour uniquement les champs spécifiés', () {
      final initialUser = User(
        id: '1',
        prenom: 'John',
        nom: 'Doe',
        email: 'john@doe.com',
      );

      final updatedUser = initialUser.copyWith(
        prenom: 'Jane',
        favorisIds: ['id1'],
      );

      // Ces champs doivent être modifiés
      expect(updatedUser.prenom, 'Jane');
      expect(updatedUser.favorisIds, ['id1']);

      // Ces champs doivent rester identiques
      expect(updatedUser.nom, 'Doe');
      expect(updatedUser.email, 'john@doe.com');
      expect(updatedUser.id, '1');
    });
  });
}
