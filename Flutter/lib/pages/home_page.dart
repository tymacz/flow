import 'package:flow/pages/articles_detail_page.dart';
import 'package:flow/pages/breathing_menu_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flow/widgets/activityHomePageBloc.dart';
import 'package:flow/widgets/contentPreview.dart';
import 'package:flow/widgets/moodSelector.dart';
import '../providers/providers.dart';
import 'package:flow/widgets/switch.dart';
import 'package:flow/widgets/settingSliderLine.dart'; // Si tu l'as
import 'package:flow/widgets/settingRedirectionLine.dart';

// On change StatelessWidget en ConsumerWidget
class HomePage extends ConsumerWidget {
  final VoidCallback? onSettingsPressed;
  final VoidCallback? onPressedCatalogue;

  const HomePage({super.key, this.onSettingsPressed, this.onPressedCatalogue});

  void showAccessibilitySettings(BuildContext context, WidgetRef ref) {
    // On récupère l'état actuel pour afficher les bonnes valeurs
    final userState = ref.read(authUserProvider);
    final user = userState.value;

    if (user == null) return;

    // Valeurs actuelles
    final prefs = user.preferences;
    final bool highContrast = prefs['high_contrast'] ?? false;
    final bool reducedAnimations = prefs['reduced_animations'] ?? false;
    // final double textSize = (prefs['text_size'] ?? 1).toDouble();

    showModalBottomSheet(
      context: context,
      isScrollControlled:
          true, // Permet à la modal de prendre la taille nécessaire
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(25.0)),
      ),
      builder: (context) {
        // On utilise StatefulBuilder pour que les switchs bougent visuellement
        // même si le provider met quelques millisecondes à répondre
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setModalState) {
            return Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                mainAxisSize: MainAxisSize.min, // S'adapte au contenu
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Petite barre de "drag"
                  Center(
                    child: Container(
                      width: 40,
                      height: 4,
                      decoration: BoxDecoration(
                        color: Colors.grey[300],
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),

                  const Text(
                    "Accessibilité & Affichage",
                    style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 10),
                  const Text(
                    "Personnalisez votre expérience visuelle",
                    style: TextStyle(color: Colors.grey),
                  ),
                  const SizedBox(height: 30),

                  // --- Slider Taille Texte ---
                  // (J'utilise un widget standard si ton Settingsliderline n'est pas dispo ici)
                  const Text(
                    "Taille du texte",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  Slider(
                    value: (prefs['text_size'] ?? 1).toDouble(),
                    min: 1,
                    max: 3,
                    divisions: 2,
                    activeColor: const Color.fromRGBO(99, 102, 241, 1),
                    onChanged: (val) {
                      setModalState(() {}); // Met à jour la modal
                      ref
                          .read(authUserProvider.notifier)
                          .updateUser(preferences: {'text_size': val});
                    },
                  ),

                  const SizedBox(height: 20),

                  // --- Switch Contraste ---
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Row(
                        children: [
                          Icon(Icons.contrast, color: Colors.black54),
                          SizedBox(width: 15),
                          Text(
                            "Contraste Élevé",
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                      SwitchCustom(
                        value: highContrast,
                        onChanged: (val) {
                          setModalState(() {});
                          ref
                              .read(authUserProvider.notifier)
                              .updateUser(preferences: {'high_contrast': val});
                          // On ferme la modal ou pas ? Mieux vaut laisser ouvert pour d'autres réglages
                        },
                      ),
                    ],
                  ),

                  const SizedBox(height: 20),

                  // --- Switch Animations ---
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Row(
                        children: [
                          Icon(Icons.animation, color: Colors.black54),
                          SizedBox(width: 15),
                          Text(
                            "Animations Réduites",
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                      SwitchCustom(
                        value: reducedAnimations,
                        onChanged: (val) {
                          setModalState(() {});
                          ref
                              .read(authUserProvider.notifier)
                              .updateUser(
                                preferences: {'reduced_animations': val},
                              );
                        },
                      ),
                    ],
                  ),

                  const SizedBox(height: 40),

                  // Bouton Fermer
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color.fromRGBO(99, 102, 241, 1),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                        padding: const EdgeInsets.symmetric(vertical: 15),
                      ),
                      onPressed: () => Navigator.pop(context),
                      child: const Text(
                        "Terminé",
                        style: TextStyle(color: Colors.white, fontSize: 16),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                ],
              ),
            );
          },
        );
      },
    );
  }

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
          child: Image(image: AssetImage('assets/logo.png')),
        ),
        leadingWidth: 100,
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 20.0),
            child: IconButton(
              icon: const Icon(Icons.accessibility),
              onPressed: () {
                showAccessibilitySettings(context, ref);
              },
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
                    String displayName = user != null
                        ? '${user.prenom} 👋'
                        : 'Citoyen 👋';

                    return Text(
                      displayName, // Affiche "Invité" ou le prénom
                      style: const TextStyle(
                        fontSize: 36,
                        fontWeight: FontWeight.bold,
                        color: Color.fromRGBO(56, 107, 246, 1),
                      ),
                    );
                  },
                  loading: () =>
                      const CircularProgressIndicator(), // Montre que ça charge
                  error: (err, stack) => Text(
                    'Erreur: $err',
                  ), // Affiche l'erreur si connexion impossible
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
                    Activityhomepagebloc(
                      title: 'Cohérence cardiaque',
                      icon: const Icon(Icons.air),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => RespirationMenuPage(),
                          ),
                        );
                      },
                    ),
                    const SizedBox(width: 20),
                    Activityhomepagebloc(
                      title: "Catalogue d'activités",
                      icon: const Icon(Icons.category_sharp),
                      onPressed: onPressedCatalogue,
                    ),
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
                      ontap: () {
                        // Navigation vers la page de détail
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                ArticleDetailPage(article: article),
                          ),
                        );
                      },
                    );
                  },
                  loading: () =>
                      const Center(child: CircularProgressIndicator()),
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
