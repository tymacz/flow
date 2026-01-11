
import 'package:flow/widgets/activityHomePageBloc.dart';
import 'package:flow/widgets/contentPreview.dart';
import 'package:flow/widgets/moodSelector.dart';
import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  final VoidCallback? onSettingsPressed;
  final VoidCallback? onPressedCatalogue;
  const HomePage({super.key, this.onSettingsPressed,this.onPressedCatalogue});

  @override
  Widget build(BuildContext context) {
    const prenom = 'Maxence';

    return Scaffold(
      backgroundColor: Color.fromRGBO(249,250, 248, 1),
      appBar: AppBar(
        backgroundColor: Color.fromRGBO(249,250, 248, 1),
        surfaceTintColor: Color.fromRGBO(249,250, 248, 1),
        leading: Padding(
    padding: const EdgeInsets.only(left: 20.0), // 20px de marge à gauche
    child: const Image(
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
              const Text(
                '$prenom 👋',
                style: TextStyle(
                  fontSize: 36,
                  fontWeight: FontWeight.bold,
                  color: Color.fromRGBO(56, 107, 246, 1),
                ),
              ),
              const SizedBox(height: 40),
              Moodselector(),
              const SizedBox(height: 40),
              const Text('Besoin de souffler ?', style: TextStyle(fontSize: 24,color: Colors.black),),
              const SizedBox(height: 20),
              Row(
              children: [
                Activityhomepagebloc(title: 'Cohérence cardiaque', icon: const Icon(Icons.air)),
                const SizedBox(width: 20),               
                 Activityhomepagebloc(title: "Catalogue d'activités", icon: const Icon(Icons.category_sharp), onPressed: onPressedCatalogue),
              ],
            ),
            SizedBox(height: 20),
            Text('Conseils du jour', style: TextStyle(fontSize: 24,color: Colors.black),),
            SizedBox(height: 20),
            ContentPreview(
              type: 'Article',
              title: 'Comprendre le stress chronique',
              description: 'Découvrez les mécanismes du stress chronique et comment le gérer au quotidien pour améliorer votre bien-être.',
            ),
            ],
          ),
          
        ),
      ),)
    );
  }
}