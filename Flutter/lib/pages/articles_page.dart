import 'package:flow/pages/articles_detail_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flow/providers/providers.dart';
import 'package:flow/models/article.dart';
import 'package:flow/widgets/articleCard.dart';

// ==========================================
// 1. PAGE LISTE : ARTICLES PAGE
// ==========================================
class ArticlesPage extends ConsumerWidget {
  const ArticlesPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final articlesAsync = ref.watch(articlesProvider);

    return Scaffold(
      backgroundColor: const Color.fromRGBO(
        249,
        250,
        248,
        1,
      ), // Ton fond habituel
      appBar: AppBar(
        backgroundColor: const Color.fromRGBO(249, 250, 248, 1),
        surfaceTintColor: const Color.fromRGBO(249, 250, 248, 1),
        title: const Text(
          'Articles',
          style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: articlesAsync.when(
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (err, stack) =>
                Center(child: Text("Oups, une erreur : $err")),
            data: (articles) {
              if (articles.isEmpty) {
                return const Center(
                  child: Text("Aucun article pour le moment."),
                );
              }

              return ListView.builder(
                physics: const BouncingScrollPhysics(),
                padding: const EdgeInsets.only(top: 10, bottom: 20),
                itemCount: articles.length,
                itemBuilder: (context, index) {
                  final article = articles[index];
                  return ArticleCard(
                    article: article,
                    onTap: () {
                      // Navigation vers la page de détail
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              ArticleDetailPage(article: article),
                        ),
                      );
                    },
                  );
                },
              );
            },
          ),
        ),
      ),
    );
  }
}

