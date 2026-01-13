import 'package:flutter/material.dart';

class Activitybloc extends StatefulWidget {
  const Activitybloc({
    super.key, 
    required this.title, 
    required this.description, 
    required this.imagePath, 
    this.onPressed
  });
  
  final String title;
  final String description;
  final String imagePath;
  final VoidCallback? onPressed;

  @override
  _ActivityblocState createState() => _ActivityblocState();
}

class _ActivityblocState extends State<Activitybloc> {
  // 1. Variable pour gérer l'état du favori
  bool isFavorite = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.onPressed,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 10.0),
        padding: const EdgeInsets.all(15.0),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20.0),
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
            )
          ],
        ),
        // 2. Utilisation de Stack pour superposer les éléments
        child: Stack(
          children: [
            // Le contenu original (Image + Texte)
            Row(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(10.0),
                  child: Image.network(
                    widget.imagePath,
                    width: 80,
                    height: 80,
                    fit: BoxFit.cover,
                  ),
                ),
                const SizedBox(width: 15.0),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Petite astuce : Padding à droite pour éviter que le titre long ne passe sous le cœur
                      Padding(
                        padding: const EdgeInsets.only(right: 30.0), 
                        child: Text(
                          widget.title,
                          style: const TextStyle(
                            fontSize: 18.0,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      const SizedBox(height: 5.0),
                      Text(
                        widget.description,
                        style: const TextStyle(
                          fontSize: 14.0,
                          color: Colors.grey,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            
            // 3. Le bouton Cœur positionné en haut à droite
            Positioned(
              top: 0,
              right: 0,
              child: InkWell(
                onTap: () {
                  setState(() {
                    isFavorite = !isFavorite;
                  });
                },
                child: Icon(
                  isFavorite ? Icons.favorite : Icons.favorite_border,
                  color: isFavorite ? Colors.red : Colors.grey,
                  size: 24.0,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}