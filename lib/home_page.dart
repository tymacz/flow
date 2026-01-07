import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    const prenom = 'Maxence';

    return Scaffold(
      backgroundColor: Color.fromRGBO(249,250, 248, 1),
      appBar: AppBar(
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
        icon: const Icon(Icons.settings),
        onPressed: () {},
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
              Container(
                height: 250,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                 boxShadow: [
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
  ] ,
                  color: Colors.white
                ), 
                child: Center(
                  child:Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      const SizedBox(height: 20),
                      const Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20.0),
                        child: Text(
                          'Comment vous sentez-vous aujourd\'hui ?',
                          style: TextStyle(fontSize: 24, color: Colors.black,),
                          textAlign: TextAlign.center,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          TextButton(child: const Text('😊', style: TextStyle(fontSize: 40, color: Colors.white),), onPressed: () {},),
                          const SizedBox(width: 20),
                          TextButton(child: const Text('😐', style: TextStyle(fontSize: 40, color: Colors.white),), onPressed: () {},),
                          const SizedBox(width: 20),
                          TextButton(child: const Text('😞', style: TextStyle(fontSize: 40, color: Colors.white),), onPressed: () {},),
                        
                        ],
                      ),
                      const SizedBox(height: 10),
                      TextButton(
                        style: TextButton.styleFrom(
                          backgroundColor: Color.fromRGBO(56, 107, 246, 1),
                        ),
                        onPressed: () {print('Emotion choisie');},
                        child: const Text(
                          'Choisissez une émotion',
                          style: TextStyle(fontSize: 16, color: Colors.white),
                        ),
                      ),
                    ],
                ),
              )
              ),
              const SizedBox(height: 40),
              const Text('Besoin de souffler ?', style: TextStyle(fontSize: 24,color: Colors.black),),
              const SizedBox(height: 20),
              Row(
              children: [
                
                Expanded( 
                  child: Container(
                    decoration: BoxDecoration(
                      color: const Color.fromRGBO(165, 243, 252, 1),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Column(
                        children: [
                          
                          Align(
                            alignment: Alignment.topLeft,
                            child: Container(
                              width: 40,
                              height: 40,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(50),
                              ),
                              child: const Icon(Icons.air),
                            ),
                          ),
                          const SizedBox(height: 10),
                          
                          const Text(
                            'Cohérence cardiaque',
                            textAlign: TextAlign.left, 
                            style: TextStyle(fontSize: 18),
                            
                          )
                        ],
                      ),
                    ),
                  ),
                ),
                
                const SizedBox(width: 20), 

                
                Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                      color: const Color.fromRGBO(165, 243, 252, 1),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Column(
                        children: [
                          
                          Align(
                            alignment: Alignment.topLeft,
                            child: Container(
                              width: 40,
                              height: 40,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(50),
                              ),
                              child: const Icon(Icons.category_sharp),
                            ),
                          ),
                          const SizedBox(height: 10),
                          
                          const Text(
                            "Catalogue d'activités",
                            textAlign: TextAlign.left,
                            style: TextStyle( fontSize: 18),
                          )
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 20),
            Text('Conseils du jour', style: TextStyle(fontSize: 24,color: Colors.black),),
            SizedBox(height: 20),
            Container(
              height: 250,
              width: double.infinity,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  color: Colors.white,
                 boxShadow: [
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
  ] ,),
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Article',
                     style: TextStyle(fontSize: 18,color: Colors.blue),
                     textAlign: TextAlign.left,
                  ),
                  SizedBox(height: 10),
                  Text('Comprendre le stress chronique', style: TextStyle(fontSize: 18,color: Colors.black),),
                ],
              ),
            ),)
            ],
          ),
          
        ),
      ),)
    );
  }
}