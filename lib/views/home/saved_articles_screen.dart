import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:news_app/cubits/bookmarks/bookmarks_cubit.dart';
import 'package:news_app/models/article_model.dart';
import 'package:news_app/widgets/news_tile.dart';

class SavedArticlesScreen extends StatelessWidget {
  const SavedArticlesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Saved Articles"),
        backgroundColor: Colors.deepPurple,
        foregroundColor: Colors.white,
      ),
      body: BlocBuilder<BookmarksCubit, List<ArticleModel>>(
        builder: (context, savedArticles) {
          if (savedArticles.isEmpty) {
            return const Center(child: Text("No saved articles yet."));
          }
          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: savedArticles.length,
            itemBuilder: (context, index) {
              return NewsTile(articleModel: savedArticles[index]);
            },
          );
        },
      ),
    );
  }
}
