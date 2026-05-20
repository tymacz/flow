import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:flow/models/breathing_pattern.dart';

class BreathingSessionPage extends StatefulWidget {
  final BreathingPattern pattern;
  final bool voiceEnabled; // Le choix de l'utilisateur

  const BreathingSessionPage({
    super.key,
    required this.pattern,
    required this.voiceEnabled,
  });

  @override
  State<BreathingSessionPage> createState() => _BreathingSessionPageState();
}

class _BreathingSessionPageState extends State<BreathingSessionPage>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _sizeAnimation;

  final FlutterTts _flutterTts = FlutterTts();
  String _instructionText = "";
  Timer? _timer;
  bool _isActive = true;

  @override
  void initState() {
    super.initState();

    // Config de l'animation (Le cercle va de taille 150 à 300)
    _controller = AnimationController(vsync: this);
    _sizeAnimation = Tween<double>(
      begin: 150.0,
      end: 300.0,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));

  
    _initTts();

    _startCountdown();
  }

  Future<void> _initTts() async {
    if (widget.voiceEnabled) {
      await _flutterTts.setLanguage("fr-FR");
      await _flutterTts.setPitch(1.0);
      await _flutterTts.setSpeechRate(0.4); // Parle lentement pour être zen
    }
  }

  Future<void> _speak(String text) async {
    if (widget.voiceEnabled && _isActive) {
      await _flutterTts.speak(text);
    }
  }

  Future<void> _startCountdown() async {
    // On fait une boucle de 3 à 1
    for (int i = 3; i > 0; i--) {
      // Sécurité : Si l'utilisateur a quitté la page, on arrête tout
      if (!mounted) return;

      setState(() {
        _instructionText = "$i"; // Affiche le chiffre
      });

      // Optionnel : La voix dit le chiffre
      _speak("$i");

      // On attend 1 seconde
      await Future.delayed(const Duration(seconds: 1));
    }

    // Une fois fini, on lance l'exercice
    if (mounted) {
      _startCycle();
    }
  }

  // LA BOUCLE INFINIE DE RESPIRATION
  void _startCycle() async {
    if (!mounted || !_isActive) return;

    // 1. INSPIRATION
    setState(() => _instructionText = "Inspirez");
    _speak("Inspirez");
    // On lance l'animation vers le haut (grossit)
    _controller.duration = Duration(seconds: widget.pattern.inhaleSeconds);
    _controller.forward();
    await Future.delayed(Duration(seconds: widget.pattern.inhaleSeconds));

    if (!mounted || !_isActive) return;

    // 2. PAUSE (Poumons pleins)
    if (widget.pattern.holdAfterInhale > 0) {
      setState(() => _instructionText = "Bloquez");
      _speak("Bloquez");
      await Future.delayed(Duration(seconds: widget.pattern.holdAfterInhale));
    }

    if (!mounted || !_isActive) return;

    // 3. EXPIRATION
    setState(() => _instructionText = "Expirez");
    _speak("Expirez");
    // On lance l'animation vers le bas (rapetisse)
    _controller.duration = Duration(seconds: widget.pattern.exhaleSeconds);
    _controller.reverse();
    await Future.delayed(Duration(seconds: widget.pattern.exhaleSeconds));

    if (!mounted || !_isActive) return;

    // 4. PAUSE (Poumons vides)
    if (widget.pattern.holdAfterExhale > 0) {
      setState(() => _instructionText = "Bloquez");
      _speak("Bloquez");
      await Future.delayed(Duration(seconds: widget.pattern.holdAfterExhale));
    }

    // ON RECOMMENCE
    _startCycle();
  }

  @override
  void dispose() {
    _isActive = false; // Arrête la boucle logique
    _timer?.cancel();
    _controller.dispose();
    _flutterTts.stop();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromRGBO(249, 250, 248, 1),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.close, color: Colors.black, size: 30),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // TEXTE DU HAUT (Ne bougera plus)
            Text(
              widget.pattern.title,
              style: const TextStyle(fontSize: 22, color: Colors.grey),
            ),
            
            const SizedBox(height: 50), // Espace fixe
            
            // 👇 LA CORRECTION EST ICI
            // On crée une boite qui fait TOUJOURS 300x300 (la taille max)
            SizedBox(
              width: 300, 
              height: 300,
              child: Center( // On centre le rond animé dans cette boite fixe
                child: AnimatedBuilder(
                  animation: _sizeAnimation,
                  builder: (context, child) {
                    return Container(
                      width: _sizeAnimation.value,
                      height: _sizeAnimation.value,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        gradient: LinearGradient(
                          colors: [
                            const Color.fromRGBO(165, 243, 252, 1).withOpacity(0.8),
                            const Color.fromRGBO(99, 102, 241, 1).withOpacity(0.8),
                          ],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: const Color.fromRGBO(99, 102, 241, 0.3),
                            blurRadius: 30,
                            spreadRadius: 10,
                          )
                        ],
                      ),
                      child: Center(
                        child: Text(
                          _instructionText,
                          style: const TextStyle(
                            fontSize: 24, 
                            fontWeight: FontWeight.bold, 
                            color: Colors.white
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
            
            const SizedBox(height: 100), // Espace fixe
            
            // TEXTE DU BAS (Ne bougera plus)
            const Text(
              "Détendez-vous et suivez le rythme...",
              style: TextStyle(color: Colors.grey),
            )
          ],
        ),
      ),
    );
  }
}
