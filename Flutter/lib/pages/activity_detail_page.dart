import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flow/models/activity.dart';
import 'package:flow/providers/providers.dart';

class ActivityDetailPage extends ConsumerWidget {
  final Activity activity;

  const ActivityDetailPage({super.key, required this.activity});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // On récupère l'état pour savoir si c'est favori
    final userState = ref.watch(authUserProvider);
    final user = userState.value;
    final isFav = user?.favorisIds.contains(activity.id) ?? false;

    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          CustomScrollView(
            physics: const BouncingScrollPhysics(),
            slivers: [
              // --- 1. IMAGE D'EN-TÊTE ---
              SliverAppBar(
                expandedHeight: 350.0, // Image bien grande
                pinned: true,
                backgroundColor: const Color.fromRGBO(99, 102, 241, 1),
                leading: IconButton(
                  icon: const CircleAvatar(
                    backgroundColor: Colors.white24,
                    child: Icon(Icons.arrow_back, color: Colors.white),
                  ),
                  onPressed: () => Navigator.pop(context),
                ),
                actions: [
                  // BOUTON FAVORI
                  Padding(
                    padding: const EdgeInsets.only(right: 16.0),
                    child: CircleAvatar(
                      backgroundColor: Colors.white,
                      child: IconButton(
                        icon: Icon(
                          isFav ? Icons.favorite : Icons.favorite_border,
                          color: isFav ? Colors.red : Colors.grey,
                        ),
                        onPressed: () {
                          ref
                              .read(authUserProvider.notifier)
                              .toggleFavorite(activity.id);
                        },
                      ),
                    ),
                  ),
                ],
                flexibleSpace: FlexibleSpaceBar(
                  background: Stack(
                    fit: StackFit.expand,
                    children: [
                      Image.network(
                        activity.imageUrl,
                        fit: BoxFit.cover,
                        errorBuilder: (c, e, s) =>
                            Container(color: Colors.grey),
                      ),
                      // Dégradé noir en bas de l'image pour lisibilité si besoin
                      const DecoratedBox(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [Colors.transparent, Colors.black26],
                            stops: [0.7, 1.0],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              // --- 2. CONTENU ---
              SliverToBoxAdapter(
                child: Container(
                  // Effet de carte arrondie qui remonte sur l'image
                  transform: Matrix4.translationValues(0, -20, 0),
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.vertical(
                      top: Radius.circular(30),
                    ),
                  ),
                  padding: const EdgeInsets.all(24.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Petite barre grise au centre (handle)
                      Center(
                        child: Container(
                          width: 40,
                          height: 4,
                          decoration: BoxDecoration(
                            color: Colors.grey.shade300,
                            borderRadius: BorderRadius.circular(2),
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),

                      // CATÉGORIE & DURÉE
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 6,
                            ),
                            decoration: BoxDecoration(
                              color: const Color.fromRGBO(
                                165,
                                243,
                                252,
                                1,
                              ), // Cyan clair
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Text(
                              activity.categorie.toUpperCase(),
                              style: const TextStyle(
                                color: Color.fromRGBO(56, 107, 246, 1),
                                fontWeight: FontWeight.bold,
                                fontSize: 12,
                              ),
                            ),
                          ),
                          const Spacer(),
                          const Icon(
                            Icons.timer_outlined,
                            color: Colors.grey,
                            size: 20,
                          ),
                          const SizedBox(width: 5),
                          Text(
                            "${activity.dureeMinutes} min",
                            style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              color: Colors.grey,
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 20),

                      // TITRE
                      Text(
                        activity.titre,
                        style: const TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                          height: 1.2,
                        ),
                      ),

                      const SizedBox(height: 30),

                      // DESCRIPTION / INSTRUCTIONS
                      const Text(
                        "Instructions",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        activity.description,
                        style: const TextStyle(
                          fontSize: 16,
                          height: 1.6,
                          color: Color(0xFF4B5563), // Gris foncé lecture
                        ),
                      ),

                      // Espace pour que le bouton flottant ne cache pas le texte à la fin
                      const SizedBox(height: 100),
                    ],
                  ),
                ),
              ),
            ],
          ),

          // --- 3. BOUTON FLOTTANT EN BAS ---
          Positioned(
            bottom: 30,
            left: 20,
            right: 20,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color.fromRGBO(99, 102, 241, 1),
                padding: const EdgeInsets.symmetric(vertical: 18),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                elevation: 5,
                shadowColor: const Color.fromRGBO(99, 102, 241, 0.4),
              ),
              onPressed: () async {
                try {
                  // 1. Appel au serveur
                  await ref
                      .read(authUserProvider.notifier)
                      .completeActivity(
                        activity.titre,
                        activity.categorie,
                        activity.dureeMinutes,
                      );

                  // 2. On rafraîchit la page "Progression" pour que le compteur s'incrémente
                  // (Optionnel mais recommandé pour que l'utilisateur voit son progrès direct)
                  // ignore: unused_result
                  ref.refresh(progressProvider);

                  // 3. Feedback visuel
                  if (context.mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text("Activité enregistrée ! Bravo 🎉"),
                        backgroundColor: Colors.green,
                      ),
                    );
                    Navigator.pop(context); // On revient en arrière
                  }
                } catch (e) {
                  if (context.mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text("Erreur de connexion"),
                        backgroundColor: Colors.red,
                      ),
                    );
                  }
                }
              },
              child: const Text(
                "Marquer comme terminé",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
