import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flow/providers/providers.dart';
import 'package:flow/models/user.dart';

class EditProfilePage extends ConsumerStatefulWidget {
  final User user; // On reçoit l'utilisateur actuel pour pré-remplir

  const EditProfilePage({super.key, required this.user});

  @override
  ConsumerState<EditProfilePage> createState() => _EditProfilePageState();
}

class _EditProfilePageState extends ConsumerState<EditProfilePage> {
  // Contrôleurs pour les champs de texte
  late TextEditingController _prenomCtrl;
  late TextEditingController _nomCtrl;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    // On initialise avec les valeurs actuelles
    _prenomCtrl = TextEditingController(text: widget.user.prenom);
    _nomCtrl = TextEditingController(text: widget.user.nom);
  }

  @override
  void dispose() {
    _prenomCtrl.dispose();
    _nomCtrl.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    setState(() => _isLoading = true);

    try {
      // Appel au provider pour sauvegarder
      await ref.read(authUserProvider.notifier).updateUser(
        prenom: _prenomCtrl.text.trim(),
        nom: _nomCtrl.text.trim(),
      );

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Profil mis à jour avec succès !')),
        );
        Navigator.pop(context); // On ferme la page
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Erreur lors de la mise à jour'), backgroundColor: Colors.red),
        );
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromRGBO(249, 250, 248, 1),
      appBar: AppBar(
        title: const Text("Modifier mon profil", style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: const Color.fromRGBO(249, 250, 248, 1),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text("Prénom", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              TextField(
                controller: _prenomCtrl,
                decoration: InputDecoration(
                  hintText: "Votre prénom",
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                  filled: true,
                  fillColor: Colors.white,
                ),
              ),
              const SizedBox(height: 20),
              
              const Text("Nom", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              TextField(
                controller: _nomCtrl,
                decoration: InputDecoration(
                  hintText: "Votre nom",
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                  filled: true,
                  fillColor: Colors.white,
                ),
              ),
              
              const Spacer(),
              
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color.fromRGBO(99, 102, 241, 1),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(25),
                    ),
                  ),
                  onPressed: _isLoading ? null : _save,
                  child: _isLoading 
                    ? const CircularProgressIndicator(color: Colors.white)
                    : const Text("Enregistrer", style: TextStyle(color: Colors.white, fontSize: 18)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}