import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flow/providers/providers.dart';
import 'package:flow/models/activity.dart';
import 'package:flow/widgets/activityBloc.dart';
import 'package:flow/widgets/activityCaroussel.dart';
import 'package:flow/widgets/activityCarousselElement.dart';

class ActivityPage extends ConsumerWidget {
  const ActivityPage({super.key});

  Icon _getIconForCategory(String category) {
    switch (category.toLowerCase()) {
      case 'yoga':
        return const Icon(
          Icons.self_improvement,
          size: 50,
          color: Colors.white,
        );
      case 'sport':
        return const Icon(Icons.fitness_center, size: 50, color: Colors.white);
      case 'respiration':
        return const Icon(Icons.air, size: 50, color: Colors.white);
      case 'méditation':
        return const Icon(Icons.spa, size: 50, color: Colors.white);
      default:
        return const Icon(
          Icons.play_circle_outline,
          size: 50,
          color: Colors.white,
        );
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final activitiesAsync = ref.watch(activitiesProvider);
    final userState = ref.watch(authUserProvider);
    final user = userState.value;
    final List<String> favorisIds = user?.favorisIds ?? [];

    return Scaffold(
      backgroundColor: const Color.fromRGBO(249, 250, 248, 1),
      appBar: AppBar(
        backgroundColor: const Color.fromRGBO(249, 250, 248, 1),
        surfaceTintColor: const Color.fromRGBO(249, 250, 248, 1),
        title: const Text(
          'Activités & Détente',
          style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
        ),
      ),
      body: SafeArea(
        child: activitiesAsync.when(
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (err, stack) => Center(child: Text('Erreur: $err')),
          data: (activities) {
            if (activities.isEmpty) {
              return const Center(child: Text("Aucune activité"));
            }

            final carouselActivities = activities.take(3).toList();

            // CRÉATION DE LA LISTE FILTRÉE DES FAVORIS
            final favoriteList = activities
                .where((activity) => favorisIds.contains(activity.id))
                .toList();

            return SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: Column(
                  children: [
                    // --- CARROUSEL ---
                    ActivityCaroussel(
                      activities: carouselActivities.map((activity) {
                        return Activitycarousselelement(
                          name: activity.titre,
                          icon: _getIconForCategory(activity.categorie),
                          durating: '${activity.dureeMinutes} min',
                        );
                      }).toList(),
                    ),
                    const SizedBox(height: 20),

                    // --- SECTION FAVORIS (S'affiche seulement si la liste n'est pas vide) ---
                    if (favoriteList.isNotEmpty) ...[
                      const Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          'Activités favorites',
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                      // On affiche uniquement les favoris ici
                      ...favoriteList.map((activity) {
                        return Activitybloc(
                          title: activity.titre,
                          description: activity.description,
                          imagePath: activity.imageUrl,
                          isFavorite: true,
                          onFavoriteToggle: () {
                            ref
                                .read(authUserProvider.notifier)
                                .toggleFavorite(activity.id);
                          },
                          onPressed: () {},
                        );
                      }),
                      const SizedBox(height: 20),
                    ],

                    // --- SECTION TOUTES LES ACTIVITÉS ---
                    const Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        'Toutes les Activités',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),

                    // On affiche tout le reste
                    ...activities.map((activity) {
                      final isFav = favorisIds.contains(activity.id);
                      return Activitybloc(
                        title: activity.titre,
                        description: activity.description,
                        imagePath: activity.imageUrl,
                        isFavorite: isFav,
                        onFavoriteToggle: () {
                          ref
                              .read(authUserProvider.notifier)
                              .toggleFavorite(activity.id);
                        },
                        onPressed: () {},
                      );
                    }),

                    const SizedBox(height: 20),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
