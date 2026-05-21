import 'package:flutter_test/flutter_test.dart';
// Adapte le chemin selon ton projet
import 'package:flow/models/article.dart';

void main() {
  group('Article Model Tests', () {
    test('fromJson parse correctement un article complet', () {
      final json = {
        '_id': 'art_001',
        'titre': 'L\'importance de la récupération',
        'auteur': 'Coach Flow',
        'contenu': 'Le sommeil et les étirements sont vitaux...',
        'tags': ['Santé', 'Sommeil', 'Mobilité'], // Tableau de strings
        'image_url': 'https://flow.com/article.jpg',
      };

      final article = Article.fromJson(json);

      expect(article.id, 'art_001');
      expect(article.titre, 'L\'importance de la récupération');
      // On vérifie que la liste des tags a bien été convertie
      expect(article.tags, isA<List<String>>());
      expect(article.tags?.length, 3);
      expect(article.tags?.contains('Sommeil'), isTrue);
    });

    test('fromJson gère un article sans tags ni image', () {
      final json = {
        'id': 'art_002',
        'titre': 'Article minimaliste',
        'contenu': 'Texte court',
        // Pas de tags, pas d'image, pas d'auteur
      };

      final article = Article.fromJson(json);

      expect(article.id, 'art_002');
      // On vérifie que ton modèle gère gracieusement le manque de données
      expect(
        article.tags,
        isEmpty,
      ); // ou isNull selon la façon dont tu l'as codé
      expect(article.imageUrl, isEmpty); // ou isNull
    });
  });
}
