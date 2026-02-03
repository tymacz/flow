import 'package:flutter/material.dart';

class WeekMood extends StatelessWidget {
  final List<int> dailyMoods;
  const WeekMood({Key? key, required this.dailyMoods}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    String trendText = 'Pas assez de données';
    Color trendColor = const Color.fromRGBO(99, 102, 241, 1);
    IconData trendIcon = Icons.bar_chart;
    int currentDayIndex = DateTime.now().weekday - 1;

    // Calcul de la tendance (inchangé)
    List<double> filledMoods = dailyMoods
        .take(currentDayIndex + 1)
        .where((val) => val > 0)
        .map((e) => e.toDouble())
        .toList();

    if (filledMoods.length >= 2) {
      int midPoint = (filledMoods.length / 2).floor();
      List<double> firstHalf = filledMoods.sublist(0, midPoint);
      List<double> secondHalf = filledMoods.sublist(midPoint);

      double getAvg(List<double> list) =>
          list.reduce((a, b) => a + b) / list.length;

      double startAvg = getAvg(firstHalf);
      double recentAvg = getAvg(secondHalf);

      if (recentAvg > startAvg + 0.1) {
        trendText = "En hausse";
        trendColor = const Color.fromRGBO(16, 185, 129, 1);
        trendIcon = Icons.trending_up;
      } else if (recentAvg < startAvg - 0.1) {
        trendText = "En baisse";
        trendColor = const Color.fromRGBO(244, 63, 94, 1);
        trendIcon = Icons.trending_down;
      } else {
        trendText = "Stable";
        trendColor = const Color.fromRGBO(99, 102, 241, 1);
        trendIcon = Icons.trending_flat;
      }
    } else if (filledMoods.isNotEmpty) {
      trendText = "Début de suivi";
    }

    return Container(
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20.0),
        boxShadow: const [
          BoxShadow(
            color: Color.fromRGBO(50, 50, 93, 0.25),
            blurRadius: 27,
            spreadRadius: -5,
            offset: Offset(0, 13),
          ),
          BoxShadow(
            color: Color.fromRGBO(0, 0, 0, 0.3),
            blurRadius: 16,
            spreadRadius: -8,
            offset: Offset(0, 8),
          )
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // --- EN-TÊTE CORRIGÉ ---
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // 1. Flexible permet au titre de rétrécir si besoin
              const Flexible(
                child: Text(
                  'Humeur de la semaine',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  overflow: TextOverflow.ellipsis, // Coupe proprement si trop long
                ),
              ),
              const SizedBox(width: 8), // Espace de sécurité
              Row(
                mainAxisSize: MainAxisSize.min, // Important pour ne pas prendre toute la place
                children: [
                  Icon(
                    trendIcon,
                    color: trendColor,
                    size: 20, // Taille fixe pour éviter les surprises
                  ),
                  const SizedBox(width: 4),
                  // 2. Flexible ici aussi au cas où "En hausse" soit traduit par un texte long
                  Flexible(
                    child: Text(
                      trendText,
                      style: TextStyle(
                        color: trendColor,
                        fontWeight: FontWeight.bold,
                        fontSize: 12,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            ],
          ),

          const SizedBox(height: 16.0),

          // --- GRAPHIQUE CORRIGÉ ---
          Row(
            // On enlève mainAxisAlignment: spaceBetween car on utilise Expanded
            children: List.generate(7, (index) {
              double moodValue = dailyMoods[index].toDouble();
              bool isFutureDay = index > currentDayIndex;
              bool isMissing = !isFutureDay && dailyMoods[index] == 0;

              if (isFutureDay && dailyMoods[index] == 0) {
                moodValue = 0.5;
              }

              Color barColor;
              if (isFutureDay) {
                barColor = const Color.fromRGBO(99, 102, 241, 0.2);
              } else if (isMissing) {
                barColor = const Color.fromRGBO(209, 213, 219, 1);
              } else {
                barColor = const Color.fromRGBO(99, 102, 241, 1);
              }

              const double heightMultiplier = 15.0;
              final double targetHeight = moodValue * heightMultiplier;

              // 3. Expanded force chaque jour à prendre exactement 1/7 de la largeur
              return Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    SizedBox(
                      height: 80.0,
                      // width: 20.0, // On laisse la largeur s'adapter ou on met une max width
                      child: Align(
                        alignment: Alignment.bottomCenter,
                        child: TweenAnimationBuilder<double>(
                          tween: Tween<double>(begin: 0, end: targetHeight),
                          duration:
                              Duration(milliseconds: 1000 + (index * 100)),
                          curve: Curves.easeOutBack,
                          builder: (context, animatedHeight, child) {
                            return Container(
                              width: 12.0, // Barre un peu plus fine pour éviter que ça se touche
                              height: animatedHeight,
                              decoration: BoxDecoration(
                                color: barColor,
                                borderRadius: BorderRadius.circular(6.0),
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                    const SizedBox(height: 8.0),
                    // 4. FittedBox empêche le texte de dépasser ou d'être coupé
                    FittedBox(
                      fit: BoxFit.scaleDown, // Réduit la taille de police si nécessaire
                      child: Text(
                        ['Lun', 'Mar', 'Mer', 'Jeu', 'Ven', 'Sam', 'Dim'][index],
                        style: TextStyle(
                          fontSize: 12, // Taille de base réduite (14 -> 12)
                          fontWeight:
                              isFutureDay ? FontWeight.normal : FontWeight.bold,
                          color: isFutureDay ? Colors.grey : Colors.black,
                        ),
                      ),
                    ),
                  ],
                ),
              );
            }),
          )
        ],
      ),
    );
  }
}