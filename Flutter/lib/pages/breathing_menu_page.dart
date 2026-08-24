import 'package:flutter/material.dart';
import 'package:flow/models/breathing_pattern.dart';
import 'package:flow/pages/breathing_session_page.dart';
import 'package:flow/widgets/switch.dart'; // Ton switch existant

class RespirationMenuPage extends StatefulWidget {
  const RespirationMenuPage({super.key});

  @override
  State<RespirationMenuPage> createState() => _RespirationMenuPageState();
}

class _RespirationMenuPageState extends State<RespirationMenuPage> {
  bool _voiceEnabled = true; // Par défaut, la voix est active

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromRGBO(249, 250, 248, 1),
      appBar: AppBar(
        title: const Text(
          "Respiration",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: const Color.fromRGBO(249, 250, 248, 1),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // --- OPTION VOIX ---
              Container(
                padding: const EdgeInsets.all(15),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Row(
                      children: [
                        Icon(
                          Icons.record_voice_over,
                          color: Color.fromRGBO(99, 102, 241, 1),
                        ),
                        SizedBox(width: 10),
                        Text(
                          "Guide Vocal",
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    SwitchCustom(
                      value: _voiceEnabled,
                      onChanged: (val) => setState(() => _voiceEnabled = val),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 30),
              const Text(
                "Choisissez votre rythme",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 15),

              // --- LISTE DES EXERCICES ---
              Expanded(
                child: ListView.builder(
                  physics: const BouncingScrollPhysics(),
                  itemCount: patterns.length,
                  itemBuilder: (context, index) {
                    final pattern = patterns[index];
                    return GestureDetector(
                      onTap: () {
                        // Lancer la session
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => BreathingSessionPage(
                              pattern: pattern,
                              voiceEnabled: _voiceEnabled,
                            ),
                          ),
                        );
                      },
                      child: Container(
                        margin: const EdgeInsets.only(bottom: 15),
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(20),
                          boxShadow: const [
                            BoxShadow(
                              color: Colors.black12,
                              blurRadius: 10,
                              offset: Offset(0, 5),
                            ),
                          ],
                        ),
                        child: Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                color: const Color.fromRGBO(165, 243, 252, 0.3),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: const Icon(
                                Icons.air,
                                color: Color.fromRGBO(56, 107, 246, 1),
                                size: 30,
                              ),
                            ),
                            const SizedBox(width: 15),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    pattern.title,
                                    style: const TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  const SizedBox(height: 5),
                                  Text(
                                    pattern.description,
                                    style: const TextStyle(color: Colors.grey),
                                  ),
                                ],
                              ),
                            ),
                            const Icon(
                              Icons.arrow_forward_ios,
                              size: 16,
                              color: Colors.grey,
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
