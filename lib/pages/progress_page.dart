import 'package:flow/widgets/gauge.dart';
import 'package:flutter/material.dart';
import 'package:girix_code_gauge/girix_code_gauge.dart';

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
              ],
            ),
          ),
        ),
    )
    );
  }
}