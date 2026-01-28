class User {
  final String id;
  final String prenom;
  final String nom;
  final String email;
  final String? avatarUrl; 
  final Map<String, dynamic> preferences;

  User({
    required this.id, 
    required this.prenom, 
    required this.nom, 
    required this.email,
    this.avatarUrl,
    this.preferences = const {}, // Par défaut vide
  });

factory User.fromJson(Map<String, dynamic> json) {
    // CORRECTION PHP ARRAY VIDE : 
    // Parfois Laravel renvoie [] pour un tableau vide, ce qui fait planter Flutter qui veut {}
    var rawPrefs = json['preferences'];
    Map<String, dynamic> safePreferences = {};

    if (rawPrefs is Map<String, dynamic>) {
      safePreferences = rawPrefs;
    } 
    // Si c'est null ou une liste vide [], on garde {}
    
    return User(
      id: json['_id'] ?? '',
      prenom: json['prenom'] ?? '',
      nom: json['nom'] ?? '',
      email: json['email'] ?? '',
      avatarUrl: json['avatar_url'], // Peut être null, c'est ok
      preferences: safePreferences,  // Utilise notre version sécurisée
    );
}
}