class BreathingPattern {
  final String title;
  final String description;
  final int inhaleSeconds; // Temps inspiration
  final int holdAfterInhale; // Temps de pause poumons pleins
  final int exhaleSeconds; // Temps expiration
  final int holdAfterExhale; // Temps de pause poumons vides

  const BreathingPattern({
    required this.title,
    required this.description,
    required this.inhaleSeconds,
    required this.holdAfterInhale,
    required this.exhaleSeconds,
    required this.holdAfterExhale,
  });
}

// Données en dur pour l'exemple
const List<BreathingPattern> patterns = [
  BreathingPattern(
    title: "Cohérence Cardiaque",
    description: "Équilibre et apaisement (5-5)",
    inhaleSeconds: 5,
    holdAfterInhale: 0,
    exhaleSeconds: 5,
    holdAfterExhale: 0,
  ),
  BreathingPattern(
    title: "Relaxation 4-7-8",
    description: "Idéal pour s'endormir",
    inhaleSeconds: 4,
    holdAfterInhale: 7,
    exhaleSeconds: 8,
    holdAfterExhale: 0,
  ),
  BreathingPattern(
    title: "Énergie (Carrée)",
    description: "Focus et concentration (4-4-4-4)",
    inhaleSeconds: 4,
    holdAfterInhale: 4,
    exhaleSeconds: 4,
    holdAfterExhale: 4,
  ),
];
