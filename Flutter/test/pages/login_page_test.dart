import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
// Adapte cet import à la structure de ton projet
import 'package:flow/pages/login_page.dart';
import 'package:flow/providers/providers.dart';

// 1. Création d'un "Faux" Notifier pour court-circuiter l'appel API (Dio)
class FakeAuthNotifier extends AuthNotifier {
  FakeAuthNotifier(super.apiService);

  @override
  Future<void> checkAuthStatus() async {
    // On simule une vérification instantanée sans API
    state = const AsyncValue.data(null);
  }

  @override
  Future<bool> login(String email, String password) async {
    state = const AsyncValue.loading(); // Affiche le loader

    // Simule un délai de réflexion du réseau (1 seconde) sans utiliser Dio
    await Future.delayed(const Duration(seconds: 1));

    state = const AsyncValue.data(null);
    return false;
  }
}

void main() {
  group('LoginPage Widget Tests', () {
    testWidgets('Doit afficher tous les éléments de base correctement', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        ProviderScope(
          // 2. On injecte notre faux Notifier pour le test
          overrides: [
            authUserProvider.overrideWith(
              (ref) => FakeAuthNotifier(ref.read(apiServiceProvider)),
            ),
          ],
          child: const MaterialApp(home: LoginPage()),
        ),
      );

      // Assertions
      expect(find.text('Bienvenue sur Flow 👋'), findsOneWidget);
      expect(find.byType(TextField), findsNWidgets(2));
      expect(find.text('Email'), findsOneWidget);
      expect(find.text('Mot de passe'), findsOneWidget);
      expect(find.text('Se connecter'), findsOneWidget);
      expect(find.text("Pas encore de compte ? S'inscrire"), findsOneWidget);
    });

    testWidgets('Doit afficher le loader quand on clique sur Se connecter', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        ProviderScope(
          // On injecte également notre faux Notifier ici
          overrides: [
            authUserProvider.overrideWith(
              (ref) => FakeAuthNotifier(ref.read(apiServiceProvider)),
            ),
          ],
          child: const MaterialApp(home: LoginPage()),
        ),
      );

      final textFields = find.byType(TextField);
      await tester.enterText(textFields.at(0), 'test@flow.com');
      await tester.enterText(textFields.at(1), 'password123');

      final loginButton = find.text('Se connecter');
      await tester.tap(loginButton);

      // On rafraîchit l'interface pour voir le nouveau statut (Loading)
      await tester.pump();

      // Vérification que le loader tourne bien
      expect(find.byType(CircularProgressIndicator), findsOneWidget);

      // 3. TRÈS IMPORTANT : On avance le temps pour laisser le Future.delayed se terminer !
      // Cela évite l'erreur "A Timer is still pending"
      await tester.pumpAndSettle();
    });
  });
}
