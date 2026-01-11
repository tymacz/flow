import 'package:flutter/material.dart';

class Moodselector extends StatefulWidget {

  const Moodselector({super.key});

  @override
  _MoodselectorState createState() => _MoodselectorState();
}

class _MoodselectorState extends State<Moodselector> {
  @override
  Widget build(BuildContext context) {
    return Container(
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
              );
  }
}