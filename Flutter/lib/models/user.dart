class User {
  final String id;
  final String prenom;
  final String nom;
  final String email;
  final String? avatarUrl;
  final Map<String, dynamic> preferences;
  final List<String> favorisIds; // <--- Champ essentiel

  User({
    required this.id,
    required this.prenom,
    required this.nom,
    required this.email,
    this.avatarUrl,
    this.preferences = const {},
    this.favorisIds = const [],
  });

  factory User.fromJson(Map<String, dynamic> json) {
    // Sécurisation des préférences
    var rawPrefs = json['preferences'];
    Map<String, dynamic> safePreferences = {};
    if (rawPrefs is Map<String, dynamic>) {
      safePreferences = rawPrefs;
    }

    // Sécurisation des favoris (Conversion en List<String>)
    var rawFavs = json['favoris_ids'];
    List<String> safeFavs = [];
    if (rawFavs is List) {
      safeFavs = rawFavs.map((e) => e.toString()).toList();
    }

    return User(
      id: json['_id'] ?? '',
      prenom: json['prenom'] ?? '',
      nom: json['nom'] ?? '',
      email: json['email'] ?? '',
      avatarUrl: json['avatar_url'],
      preferences: safePreferences,
      favorisIds: safeFavs,
    );
  }

  // Permet de mettre à jour l'utilisateur sans recharger toute l'API
  User copyWith({
    String? id,
    String? prenom,
    String? nom,
    String? email,
    String? avatarUrl,
    Map<String, dynamic>? preferences,
    List<String>? favorisIds,
  }) {
    return User(
      id: id ?? this.id,
      prenom: prenom ?? this.prenom,
      nom: nom ?? this.nom,
      email: email ?? this.email,
      avatarUrl: avatarUrl ?? this.avatarUrl,
      preferences: preferences ?? this.preferences,
      favorisIds: favorisIds ?? this.favorisIds,
    );
  }
}
