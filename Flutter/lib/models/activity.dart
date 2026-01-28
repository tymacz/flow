class Activity {
  final String id;
  final String titre;
  final String description;
  final int dureeMinutes;
  final String categorie;
  final String imageUrl;

  Activity({
    required this.id,
    required this.titre,
    required this.description,
    required this.dureeMinutes,
    required this.categorie,
    required this.imageUrl,
  });

  factory Activity.fromJson(Map<String, dynamic> json) {
    return Activity(
      id: json['_id'] ?? '',
      titre: json['titre'] ?? 'Activité',
      description: json['description'] ?? '',
      dureeMinutes: json['duree_minutes'] ?? 0,
      categorie: json['categorie'] ?? 'Divers',
      imageUrl: json['image_url'] ?? '', // Assure-toi que ton seeder a bien mis des URLs valides
    );
  }
}