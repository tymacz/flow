import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flow/widgets/activityHomePageBloc.dart';
import 'package:flow/widgets/contentPreview.dart';
import 'package:flow/widgets/moodSelector.dart';
import '../providers/providers.dart'; // Importe tes providers ici

// On change StatelessWidget en ConsumerWidget
class HomePage extends ConsumerWidget {
  final VoidCallback? onSettingsPressed;
  final VoidCallback? onPressedCatalogue;
  
  const HomePage({super.key, this.onSettingsPressed, this.onPressedCatalogue});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // 1. On écoute le User
    final userState = ref.watch(authUserProvider);
    
    // 2. On écoute l'article
    final articleAsync = ref.watch(latestArticleProvider);

    return Scaffold(
      backgroundColor: const Color.fromRGBO(249, 250, 248, 1),
      appBar: AppBar(
        backgroundColor: const Color.fromRGBO(249, 250, 248, 1),
        surfaceTintColor: const Color.fromRGBO(249, 250, 248, 1),
        leading: const Padding(
          padding: EdgeInsets.only(left: 20.0),
          child: Image(
            image: AssetImage('assets/logo.png'),
          ),
        ),
        leadingWidth: 100,
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 20.0),
            child: IconButton(
              icon: const Icon(Icons.accessibility),
              onPressed: onSettingsPressed,
            ),
          ),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 20),
                const Text(
                  'Bonjour,',
                  style: TextStyle(fontSize: 36, fontWeight: FontWeight.bold),
                ),
                // GESTION DU PRÉNOM DYNAMIQUE
                userState.when(
                  data: (user) {
                    String displayName = user != null ? '${user.prenom} 👋' : 'Citoyen';
                    
                    return Text(
                      displayName, // Affiche "Invité" ou le prénom
                      style: const TextStyle(
                        fontSize: 36,
                        fontWeight: FontWeight.bold,
                        color: Color.fromRGBO(56, 107, 246, 1),
                      ),
                    );
                  },
                  loading: () => const CircularProgressIndicator(), // Montre que ça charge
                  error: (err, stack) => Text('Erreur: $err'), // Affiche l'erreur si connexion impossible
                ),
                
                const SizedBox(height: 40),
                const Moodselector(),
                const SizedBox(height: 40),
                const Text(
                  'Besoin de souffler ?',
                  style: TextStyle(fontSize: 24, color: Colors.black),
                ),
                const SizedBox(height: 20),
                Row(
                  children: [
                    const Activityhomepagebloc(
                        title: 'Cohérence cardiaque', icon: Icon(Icons.air)),
                    const SizedBox(width: 20),
                    Activityhomepagebloc(
                        title: "Catalogue d'activités",
                        icon: const Icon(Icons.category_sharp),
                        onPressed: onPressedCatalogue),
                  ],
                ),
                const SizedBox(height: 20),
                const Text(
                  'Conseils du jour',
                  style: TextStyle(fontSize: 24, color: Colors.black),
                ),
                const SizedBox(height: 20),
                
                // GESTION DE L'ARTICLE DYNAMIQUE
                articleAsync.when(
                  data: (article) {
                    if (article == null) {
                      return const Text("Aucun conseil pour le moment.");
                    }
                    return ContentPreview(
                      type: article.type,
                      title: article.titre,
                      // On limite la description pour la preview
                      description: article.description.length > 80 
                          ? '${article.description.substring(0, 80)}...' 
                          : article.description,
                    );
                  },
                  loading: () => const Center(child: CircularProgressIndicator()),
                  error: (err, stack) => Text('Erreur: $err'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}