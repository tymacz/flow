import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flow/providers/providers.dart';

class Moodselector extends ConsumerStatefulWidget {
  const Moodselector({super.key});

  @override
  ConsumerState<Moodselector> createState() => _MoodselectorState();
}

class _MoodselectorState extends ConsumerState<Moodselector> {
  // Dictionnaire des émotions (Niveau 1 -> Niveau 2)
  final Map<String, List<String>> _emotionsTree = {
    'Heureux 😊': ['Excité', 'Serein', 'Fier', 'Reconnaissant'],
    'Neutre 😐': ['Calme', 'Indifférent', 'Fatigué', 'Pensif'],
    'Triste 😞': ['Seul', 'Déçu', 'Blessé', 'Mélancolique'],
    'Stressé 😫': ['Débordé', 'Anxieux', 'Irrité', 'Paniqué'],
    'En colère 😡': ['Frustré', 'Jaloux', 'Agacé', 'Furieux'],
  };

  // Fonction pour ouvrir la Pop-up (Modal)
  void _showMoodWizard(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true, // Permet de prendre plus de hauteur
      backgroundColor: const Color.fromRGBO(249, 250, 248, 1),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(25.0)),
      ),
      builder: (context) => _MoodWizardForm(
        emotionsTree: _emotionsTree,
        onSave: (int score, String main, String sub) async {
          // Appel au Provider pour sauvegarder
          await ref.read(authUserProvider.notifier).saveMood(score, main, sub);

          // Petit feedback et fermeture
          if (context.mounted) {
            Navigator.pop(context); // Ferme la modal
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text("Humeur enregistrée !"),
                backgroundColor: Colors.green,
              ),
            );
            // On rafraîchit la page de progression pour voir le changement dans le graphique
            // ignore: unused_result
            ref.refresh(progressProvider);
          }
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final progressAsync = ref.watch(progressProvider);
    
    bool hasVotedToday = false;
    
    progressAsync.whenData((data) {
      // On calcule l'index d'aujourd'hui (0 = Lundi, 6 = Dimanche)
      int todayIndex = DateTime.now().weekday - 1;
      // Si la valeur est > 0, c'est qu'on a déjà une note
      if (data.weekMoods[todayIndex] > 0) {
        hasVotedToday = true;
      }
    });
    return Container(
      height: 180, // Un peu plus compact
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        boxShadow: const [
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
          ),
        ],
        color: Colors.white,
      ),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Text(
                hasVotedToday 
                    ? 'Humeur enregistrée !' 
                    : 'Comment vous sentez-vous aujourd\'hui ?',
                style: const TextStyle(fontSize: 20, color: Colors.black, fontWeight: FontWeight.w600),
                textAlign: TextAlign.center,
              ),
            ),
            const SizedBox(height: 20),
            
            // 2. On change le bouton selon l'état
            hasVotedToday
            ? Container(
                padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                decoration: BoxDecoration(
                  color: Colors.green.shade100,
                  borderRadius: BorderRadius.circular(30)
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: const [
                    Icon(Icons.check_circle, color: Colors.green),
                    SizedBox(width: 10),
                    Text("À demain 👋", style: TextStyle(color: Colors.green, fontWeight: FontWeight.bold))
                  ],
                ),
              )
            : ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color.fromRGBO(56, 107, 246, 1),
                padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
              ),
              onPressed: () => _showMoodWizard(context),
              child: const Text(
                'Noter mon humeur',
                style: TextStyle(fontSize: 16, color: Colors.white),
              ),
            ),
      ]),
    ));
  }
}

// --- WIDGET INTERNE : LE FORMULAIRE EN ÉTAPES (WIZARD) ---
class _MoodWizardForm extends StatefulWidget {
  final Map<String, List<String>> emotionsTree;
  final Function(int, String, String) onSave;

  const _MoodWizardForm({required this.emotionsTree, required this.onSave});

  @override
  State<_MoodWizardForm> createState() => _MoodWizardFormState();
}

class _MoodWizardFormState extends State<_MoodWizardForm> {
  int _step = 1; // Étape actuelle (1, 2 ou 3)
  String? _selectedMain;
  String? _selectedSub;
  double _score = 3.0; // Note par défaut (Neutre)

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        mainAxisSize: MainAxisSize.min, // S'adapte au contenu
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Barre de "Poignée" pour fermer
          Center(
            child: Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
          const SizedBox(height: 20),

          // --- ÉTAPE 1 : ÉMOTION PRINCIPALE ---
          if (_step == 1) ...[
            const Text(
              "Quelle émotion domine ?",
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),
            Wrap(
              spacing: 10,
              runSpacing: 10,
              alignment: WrapAlignment.center,
              children: widget.emotionsTree.keys.map((emotion) {
                return ActionChip(
                  label: Text(emotion, style: const TextStyle(fontSize: 16)),
                  backgroundColor: Colors.white,
                  elevation: 2,
                  padding: const EdgeInsets.all(12),
                  onPressed: () {
                    setState(() {
                      _selectedMain = emotion;
                      _step = 2; // On passe à l'étape suivante
                    });
                  },
                );
              }).toList(),
            ),
          ]
          // --- ÉTAPE 2 : PRÉCISION ---
          else if (_step == 2) ...[
            Row(
              children: [
                IconButton(
                  icon: const Icon(Icons.arrow_back),
                  onPressed: () => setState(() => _step = 1),
                ),
                Expanded(
                  child: Text(
                    "Plus précisément $_selectedMain...",
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                const SizedBox(width: 40), // Pour équilibrer le titre
              ],
            ),
            const SizedBox(height: 20),
            Wrap(
              spacing: 10,
              runSpacing: 10,
              alignment: WrapAlignment.center,
              children: widget.emotionsTree[_selectedMain]!.map((subEmotion) {
                return ActionChip(
                  label: Text(subEmotion, style: const TextStyle(fontSize: 16)),
                  backgroundColor: Colors.white,
                  elevation: 2,
                  padding: const EdgeInsets.all(12),
                  onPressed: () {
                    setState(() {
                      _selectedSub = subEmotion;
                      _step = 3; // On passe à la notation
                    });
                  },
                );
              }).toList(),
            ),
          ]
          // --- ÉTAPE 3 : NOTATION (1 à 5) ---
          else if (_step == 3) ...[
            Row(
              children: [
                IconButton(
                  icon: const Icon(Icons.arrow_back),
                  onPressed: () => setState(() => _step = 2),
                ),
                const Expanded(
                  child: Text(
                    "Notez votre journée",
                    style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                    textAlign: TextAlign.center,
                  ),
                ),
                const SizedBox(width: 40),
              ],
            ),
            const SizedBox(height: 30),

            // Affichage de la note en gros
            Center(
              child: Text(
                "${_score.toInt()}/5",
                style: const TextStyle(
                  fontSize: 40,
                  fontWeight: FontWeight.bold,
                  color: Color.fromRGBO(56, 107, 246, 1),
                ),
              ),
            ),

            Slider(
              value: _score,
              min: 1,
              max: 5,
              divisions: 4,
              activeColor: const Color.fromRGBO(56, 107, 246, 1),
              label: _score.toInt().toString(),
              onChanged: (val) => setState(() => _score = val),
            ),

            const Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [Text("Mauvaise"), Text("Excellente")],
            ),

            const SizedBox(height: 30),

            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color.fromRGBO(56, 107, 246, 1),
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
              ),
              onPressed: () {
                // On retire l'emoji du titre principal pour l'enregistrement (optionnel)
                String cleanMain = _selectedMain!.split(' ')[0];
                widget.onSave(_score.toInt(), cleanMain, _selectedSub!);
              },
              child: const Text(
                "Valider",
                style: TextStyle(fontSize: 18, color: Colors.white),
              ),
            ),
          ],

          const SizedBox(
            height: 40,
          ), // Marge bas pour les téléphones sans boutons physiques
        ],
      ),
    );
  }
}
