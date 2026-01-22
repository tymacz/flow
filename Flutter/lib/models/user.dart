class User {
  final String id;
  final String prenom;
  final String nom;
  final String email;

  User({required this.id, required this.prenom, required this.nom, required this.email});

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['_id'] ?? '',
      prenom: json['prenom'] ?? '',
      nom: json['nom'] ?? '',
      email: json['email'] ?? '',
    );
  }
}