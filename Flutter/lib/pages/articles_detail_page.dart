import 'package:flutter/material.dart';
import 'package:flow/models/article.dart';


class ArticleDetailPage extends StatelessWidget {
  final Article article;

  const ArticleDetailPage({super.key, required this.article});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white, // Fond blanc pour la lecture c'est mieux
      body: CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: [
          // Header flexible avec l'image
          SliverAppBar(
            expandedHeight: 300.0,
            floating: false,
            pinned: true,
            backgroundColor: const Color.fromRGBO(99, 102, 241, 1),
            flexibleSpace: FlexibleSpaceBar(
              background: Image.network(
                article.imageUrl ?? 'https://images.unsplash.com/photo-1506126613408-eca07ce68773?auto=format&fit=crop&w=800&q=80',
                fit: BoxFit.cover,
                errorBuilder: (c, e, s) => Container(color: Colors.grey),
              ),
            ),
            // Bouton retour personnalisé
            leading: IconButton(
              icon: const CircleAvatar(
                backgroundColor: Colors.white,
                child: Icon(Icons.arrow_back, color: Colors.black),
              ),
              onPressed: () => Navigator.pop(context),
            ),
          ),

          // Contenu de l'article
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Tags
                  if (article.tags != null)
                    Wrap(
                      spacing: 8,
                      children: article.tags!
                          .map(
                            (tag) => Chip(
                              label: Text(tag.toString()),
                              backgroundColor: const Color.fromRGBO(
                                249,
                                250,
                                248,
                                1,
                              ),
                              labelStyle: const TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          )
                          .toList(),
                    ),

                  const SizedBox(height: 10),

                  // Gros Titre
                  Text(
                    article.titre,
                    style: const TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      height: 1.2,
                    ),
                  ),

                  const SizedBox(height: 10),

                  // Métadonnées
                  Row(
                    children: [
                      CircleAvatar(
                        radius: 15,
                        backgroundColor: Colors.grey.shade200,
                        child: const Icon(
                          Icons.person,
                          size: 18,
                          color: Colors.grey,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        "Par ${article.auteur ?? 'L\'équipe Flow'}",
                        style: TextStyle(
                          color: Colors.grey.shade600,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const Spacer(),
                      const Icon(
                        Icons.calendar_today,
                        size: 16,
                        color: Colors.grey,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        "12 Oct", // Tu pourras formater article.datePublication ici
                        style: TextStyle(color: Colors.grey.shade600),
                      ),
                    ],
                  ),

                  const Divider(height: 40),

                  // Le contenu texte
                  Text(
                    article.description,
                    style: const TextStyle(
                      fontSize: 18,
                      height: 1.6, // Meilleure lisibilité
                      color: Color(0xFF374151), // Gris foncé doux pour les yeux
                    ),
                  ),

                  const SizedBox(height: 50),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
