class Article {
  final String id;
  final String titre;
  final String description;
  final String auteur; // Correspond au champ 'contenu' ou 'description'
  final String type;
  final String imageUrl;
  final List<dynamic> tags; // Correspond aux tags ou catégorie

  Article({
    required this.id,
    required this.titre,
    required this.description,
    required this.auteur,
    required this.type,
    required this.imageUrl,
    required this.tags,
  });

  factory Article.fromJson(Map<String, dynamic> json) {
    // On prend le premier tag comme "type" ou 'Article' par défaut
    String typeStr = 'Article';
    if (json['tags'] != null && (json['tags'] as List).isNotEmpty) {
      typeStr = json['tags'][0];
    }

    return Article(
      id: json['_id'] ?? '',
      titre: json['titre'] ?? 'Sans titre',
      description: json['contenu'] ?? '',
      auteur: json['auteur'] ?? '', // On mappe 'contenu' vers description
      type: typeStr,
      imageUrl: json['image_url'] ?? '',
      tags: json['tags']

    );
  }
}
