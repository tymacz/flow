class Article {
  final String id;
  final String titre;
  final String description; // Correspond au champ 'contenu' ou 'description'
  final String type; // Correspond aux tags ou catégorie

  Article({required this.id, required this.titre, required this.description, required this.type});

  factory Article.fromJson(Map<String, dynamic> json) {
    // On prend le premier tag comme "type" ou 'Article' par défaut
    String typeStr = 'Article';
    if (json['tags'] != null && (json['tags'] as List).isNotEmpty) {
      typeStr = json['tags'][0];
    }

    return Article(
      id: json['_id'] ?? '',
      titre: json['titre'] ?? 'Sans titre',
      description: json['contenu'] ?? '', // On mappe 'contenu' vers description
      type: typeStr,
    );
  }
}