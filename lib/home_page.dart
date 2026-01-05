import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {

    const prenom = 'Maxence';

    return Scaffold(
      appBar: AppBar(
        leading: const Image(image: AssetImage('assets/logo.png'),width: 500,),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () {
              // Action when settings icon is pressed
            },
          ),
        ],
        leadingWidth: 100,
      ),
      body:  SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          
          children: [
            Text('Bonjour,', style: TextStyle(fontSize: 36, fontWeight: FontWeight.bold)),
            Text('$prenom 👋', style: TextStyle(fontSize: 36, fontWeight: FontWeight.bold, color: Color.fromRGBO(56, 107, 246, 1)))] 
      ),
      ),
    );
  }
}