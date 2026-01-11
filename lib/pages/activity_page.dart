import 'package:flow/widgets/activityBloc.dart';
import 'package:flow/widgets/activityCaroussel.dart';
import 'package:flow/widgets/activityCarousselElement.dart';
import 'package:flutter/material.dart';

class ActivityPage extends StatelessWidget {
  const ActivityPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromRGBO(249,250, 248, 1),
      appBar: AppBar(
        backgroundColor: Color.fromRGBO(249,250, 248, 1),
        surfaceTintColor: Color.fromRGBO(249,250, 248, 1),
        title: const Text('Activités & Détente',style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold)),
        actions: [
          Padding(
      padding: const EdgeInsets.only(right: 20.0),
      child: IconButton(
        icon: const Icon(Icons.search),
        onPressed: (){},
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
              children:[ 
                ActivityCaroussel(activities: [
                Activitycarousselelement(name: 'Cohérence cardiaque rapide', icon: Icon(Icons.air,size: 50,color: Colors.white,), durating: '5 min'),
                Activitycarousselelement(name: 'Méditation guidée', icon: Icon(Icons.self_improvement,size: 50,color: Colors.white,), durating: '10 min'),
                Activitycarousselelement(name: 'Exercice d\'étirement', icon: Icon(Icons.fitness_center,size: 50,color: Colors.white,), durating: '15 min'),
              ] ),
              SizedBox(height: 20,),
              Align(
                alignment: AlignmentGeometry.centerLeft,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Vos favoris',style: TextStyle(fontSize: 24,fontWeight: FontWeight.bold),
                    ),
                    TextButton(onPressed: (){}, child: Text('Voir tout',style: TextStyle(fontSize: 12,color: Color.fromRGBO(99, 102, 241, 1)),))
                  ],
                ),
              ),
              SizedBox(height: 10,),
              Activitybloc(title: 'Body scan', description: "Une méditation pour détendre chaque muscle du corps, des orteils jusqu'au sommet du crâne", imagePath: 'https://images.pexels.com/photos/2597205/pexels-photo-2597205.jpeg'),
              SizedBox(height: 5,),
              Activitybloc(title: 'Marche en conscience', description: "Marcher en se concentrant uniquement sur ses sens", imagePath: 'https://images.pexels.com/photos/951886/pexels-photo-951886.jpeg'),
              SizedBox(height: 20,),
              Align(
                alignment: AlignmentGeometry.centerLeft,
                child: 
                    Text(
                      'Toutes les Activités',style: TextStyle(fontSize: 24,fontWeight: FontWeight.bold),
                    )
              ),
              SizedBox(height: 20,),
              Activitybloc(title: 'Body scan', description: "Une méditation pour détendre chaque muscle du corps, des orteils jusqu'au sommet du crâne", imagePath: 'https://images.pexels.com/photos/2597205/pexels-photo-2597205.jpeg'),
              SizedBox(height: 5,),
              Activitybloc(title: 'Marche en conscience', description: "Marcher en se concentrant uniquement sur ses sens", imagePath: 'https://images.pexels.com/photos/951886/pexels-photo-951886.jpeg'),

            ]),
          ),
        ),
      ),
    );
  }
}