import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flow/providers/providers.dart';
import 'package:flow/models/activity.dart';
import 'package:flow/widgets/activityBloc.dart';
import 'package:flow/widgets/activityCaroussel.dart';
import 'package:flow/widgets/activityCarousselElement.dart';

class ActivityPage extends ConsumerWidget {
  const ActivityPage({super.key});

  // Petite fonction pour choisir l'icône selon la catégorie MongoDB
  Icon _getIconForCategory(String category) {
    switch (category.toLowerCase()) {
      case 'yoga':
        return const Icon(Icons.self_improvement, size: 50, color: Colors.white);
      case 'sport':
        return const Icon(Icons.fitness_center, size: 50, color: Colors.white);
      case 'respiration':
        return const Icon(Icons.air, size: 50, color: Colors.white);
      case 'méditation':
        return const Icon(Icons.spa, size: 50, color: Colors.white);
      default:
        return const Icon(Icons.play_circle_outline, size: 50, color: Colors.white);
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // On écoute le provider des activités
    final activitiesAsync = ref.watch(activitiesProvider);

    return Scaffold(
      backgroundColor: const Color.fromRGBO(249, 250, 248, 1),
      appBar: AppBar(
        backgroundColor: const Color.fromRGBO(249, 250, 248, 1),
        surfaceTintColor: const Color.fromRGBO(249, 250, 248, 1),
        title: const Text('Activités & Détente',
            style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold)),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 20.0),
            child: IconButton(
              icon: const Icon(Icons.search),
              onPressed: () {},
            ),
          ),
        ],
      ),
      body: SafeArea(
        child: activitiesAsync.when(
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (err, stack) => Center(child: Text('Erreur: $err')),
          data: (activities) {
            
            if (activities.isEmpty) {
              return const Center(child: Text("Aucune activité disponible"));
            }

            // On prend les 3 premières pour le carrousel (ou moins si y'en a pas assez)
            final carouselActivities = activities.take(3).toList();
            
            return SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: Column(
                  children: [
                    // CARROUSEL DYNAMIQUE
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
                    
                    // SECTION FAVORIS (Statique pour l'instant ou filtrée si tu veux)
                    Align(
                      alignment: AlignmentGeometry.centerLeft,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            'Vos favoris',
                            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                          ),
                          TextButton(
                              onPressed: () {},
                              child: const Text(
                                'Voir tout',
                                style: TextStyle(
                                    fontSize: 12,
                                    color: Color.fromRGBO(99, 102, 241, 1)),
                              ))
                        ],
                      ),
                    ),
                    const SizedBox(height: 10),
                    // Exemple : On affiche juste la première activité comme "Favori" pour l'exemple
                    // Plus tard, on filtrera avec activity.isFavorite venant de l'API
                    if (activities.isNotEmpty)
                      Activitybloc(
                        title: activities.first.titre,
                        description: activities.first.description,
                        imagePath: activities.first.imageUrl,
                      ),

                    const SizedBox(height: 20),
                    
                    // LISTE DE TOUTES LES ACTIVITÉS
                    const Align(
                        alignment: AlignmentGeometry.centerLeft,
                        child: Text(
                          'Toutes les Activités',
                          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                        )),
                    const SizedBox(height: 20),
                    
                    // Génération de la liste verticale
                    ...activities.map((activity) {
                      return Activitybloc(
                        title: activity.titre,
                        description: activity.description,
                        imagePath: activity.imageUrl,
                        onPressed: () {
                           // Navigation vers le détail de l'activité à faire plus tard
                           print("Click sur ${activity.titre}");
                        },
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