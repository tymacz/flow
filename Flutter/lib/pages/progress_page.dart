import 'package:flow/widgets/gauge.dart';
import 'package:flow/widgets/historicLine.dart';
import 'package:flow/widgets/statSquare.dart';
import 'package:flutter/material.dart';
import 'package:girix_code_gauge/girix_code_gauge.dart';
import '../widgets/weekMood.dart';

class ProgressPage extends StatelessWidget {
  const ProgressPage({Key? key}) : super(key: key);

  final double score = 83;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromRGBO(249,250, 248, 1),
      appBar: AppBar(
        backgroundColor: Color.fromRGBO(249,250, 248, 1),
        surfaceTintColor: Color.fromRGBO(249,250, 248, 1),
        title: const Text('Ma Progression',style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold)),
        actions: [
          Padding(
      padding: const EdgeInsets.only(right: 20.0),
      child: IconButton(
        icon: const Icon(Icons.calendar_month),
        onPressed: (){},
      ),
    ),
        ],
      ),
      body: SafeArea(child: 
        SingleChildScrollView(
          scrollDirection: Axis.vertical,
          physics: const BouncingScrollPhysics(),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: Column(
              children: [
                const SizedBox(height: 20,),
                Center(
                  child: Text(
                    'Score de sérénité',
                    style: TextStyle(fontSize: 18,),
                  ),
                ),
                const SizedBox(height: 20,),
                GaugeCustom(score: score),
                const SizedBox(height: 20,),
                WeekMood(dailyMoods: [3,3,3,3,5,5,5]),
                const SizedBox(height: 20,),
                Align(
                  alignment: Alignment.centerLeft,
                  child: const Text(
                    'Vos Statistiques',
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                ),
                const SizedBox(height: 20,),
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal, 
                  padding: const EdgeInsets.only(left: 16.0,right: 16.0, top: 10.0, bottom: 30.0),
                  clipBehavior: Clip.none,
                  child: 
                    Row(
                      children: const [
                        StatSquare(logo: '🔥', label: 'Consécutifs', value: '5 jours'),
                        SizedBox(width: 16), // Espace entre les éléments
                        StatSquare(logo: '✅', label: 'Terminés', value: '12 séances'),
                        SizedBox(width: 16), // Espace entre les éléments
                        StatSquare(logo: '🕔', label: 'Médités', value: '2h30'),
                      ],
                    ),
                ),
                const SizedBox(height: 20,),
                Align(
                  alignment: Alignment.centerLeft,
                  child: const Text(
                    'Historique récent',
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                ),
                const SizedBox(height: 20,),
                HistoricLine(activiteType: 'Méditation', date: '12/06/2024', activite: 'Séance de pleine conscience'),
                const SizedBox(height: 10,),
                HistoricLine(activiteType: 'Exercice', date: '11/06/2024', activite: 'Yoga du matin'),
              ],
            ),
          ),
        ),
    )
    );
  }
}