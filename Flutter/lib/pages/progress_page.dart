import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flow/providers/providers.dart';
import 'package:flow/widgets/gauge.dart';
import 'package:flow/widgets/historicLine.dart';
import 'package:flow/widgets/statSquare.dart';
import 'package:flow/widgets/weekMood.dart';

class ProgressPage extends ConsumerWidget {
  const ProgressPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // 1. On écoute le provider de progression
    final progressAsync = ref.watch(progressProvider);

    return Scaffold(
      backgroundColor: const Color.fromRGBO(249, 250, 248, 1),
      appBar: AppBar(
        backgroundColor: const Color.fromRGBO(249, 250, 248, 1),
        surfaceTintColor: const Color.fromRGBO(249, 250, 248, 1),
        title: const Text('Ma Progression',
            style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold)),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 20.0),
            child: IconButton(
              icon: const Icon(Icons.calendar_month),
              onPressed: () {},
            ),
          ),
        ],
      ),
      body: SafeArea(
        child: progressAsync.when(
          // CHARGEMENT
          loading: () => const Center(child: CircularProgressIndicator()),
          
          // ERREUR
          error: (err, stack) => Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text("Impossible de charger la progression"),
                ElevatedButton(
                  onPressed: () => ref.refresh(progressProvider),
                  child: const Text("Réessayer"),
                )
              ],
            ),
          ),

          // DONNÉES REÇUES
          data: (data) {
            return SingleChildScrollView(
              scrollDirection: Axis.vertical,
              physics: const BouncingScrollPhysics(),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: Column(
                  children: [
                    const SizedBox(height: 20),
                    
                    // --- JAUGE DE SÉRÉNITÉ ---
                    const Center(
                      child: Text(
                        'Score de sérénité',
                        style: TextStyle(fontSize: 18),
                      ),
                    ),
                    const SizedBox(height: 20),
                    GaugeCustom(score: data.score), // Score dynamique
                    
                    const SizedBox(height: 20),
                    
                    // --- GRAPHIQUE SEMAINE ---
                    WeekMood(dailyMoods: data.weekMoods), // Humeurs dynamiques
                    
                    const SizedBox(height: 20),
                    
                    // --- STATISTIQUES ---
                    const Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        'Vos Statistiques',
                        style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                      ),
                    ),
                    const SizedBox(height: 20),
                    
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      padding: const EdgeInsets.only(
                          left: 16.0, right: 16.0, top: 10.0, bottom: 30.0),
                      clipBehavior: Clip.none,
                      child: Row(
                        children: [
                          StatSquare(
                              logo: '🔥',
                              label: 'Consécutifs',
                              value: data.consecutiveDays),
                          const SizedBox(width: 16),
                          StatSquare(
                              logo: '✅',
                              label: 'Terminés',
                              value: data.totalSessions),
                          const SizedBox(width: 16),
                          StatSquare(
                              logo: '🕔',
                              label: 'Médités',
                              value: data.totalTime),
                        ],
                      ),
                    ),
                    
                    const SizedBox(height: 20),
                    
                    // --- HISTORIQUE ---
                    const Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        'Historique récent',
                        style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                      ),
                    ),
                    const SizedBox(height: 20),

                    // Liste dynamique de l'historique
                    if (data.history.isEmpty)
                      const Padding(
                        padding: EdgeInsets.all(20.0),
                        child: Text("Aucune activité récente. Lancez-vous !"),
                      )
                    else
                      ...data.history.map((item) => Column(
                            children: [
                              HistoricLine(
                                activiteType: item.type,
                                date: item.date,
                                activite: item.title,
                              ),
                              const SizedBox(height: 10),
                            ],
                          )),
                          
                    const SizedBox(height: 40),
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