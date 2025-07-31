import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:news_app/widgets/home/news_title.dart';
import '../../../cubits/news/list_view_cubit.dart';

class ArticleSearchDelegate extends SearchDelegate<String> {
  @override
  List<Widget>? buildActions(BuildContext context) => [
        IconButton(
          icon: const Icon(Icons.clear),
          onPressed: () => query = '',
        ),
      ];

  @override
  Widget? buildLeading(BuildContext context) => IconButton(
        icon: const Icon(Icons.arrow_back),
        onPressed: () => close(context, ''),
      );

  @override
  Widget buildResults(BuildContext context) {
    final articleList = context.read<ListVeiwCubit>().articleList;

    final results = articleList.where((article) {
      final q = query.toLowerCase();
      return article.title.toLowerCase().contains(q) ||
          article.description.toLowerCase().contains(q) ||
          article.content.toLowerCase().contains(q) ||
          (article.author?.toLowerCase().contains(q) ?? false) ||
          article.source.toLowerCase().contains(q) ||
          article.category.toLowerCase().contains(q) ||
          article.publishedAt.toLocal().toString().toLowerCase().contains(q);
    }).toList();

    if (results.isEmpty) return const Center(child: Text("No results found."));

    return ListView.builder(
      itemCount: results.length,
      itemBuilder: (context, index) {
        final article = results[index];
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
          child: NewsTile(articleModel: article),
        );
      },
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    final articleList = context.read<ListVeiwCubit>().articleList;

    final suggestions = articleList.where((article) {
      final q = query.toLowerCase();
      return article.title.toLowerCase().contains(q) ||
          article.description.toLowerCase().contains(q) ||
          article.content.toLowerCase().contains(q) ||
          (article.author?.toLowerCase().contains(q) ?? false) ||
          article.source.toLowerCase().contains(q) ||
          article.category.toLowerCase().contains(q) ||
          article.publishedAt.toLocal().toString().toLowerCase().contains(q);
    }).toList();

    return ListView.builder(
      itemCount: suggestions.length,
      itemBuilder: (context, index) {
        final article = suggestions[index];
        return GestureDetector(
          onTap: () {
            query = article.title;
            showResults(context);
          },
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
            child: NewsTile(articleModel: article),
          ),
        );
      },
    );
  }
}
