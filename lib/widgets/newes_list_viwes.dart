import 'package:flutter/material.dart';
import 'package:news_app/models/article_model.dart';
import 'package:news_app/widgets/news_tile.dart';


class NewesListViwes extends StatelessWidget {
  final List<ArticleModel> articles;
  const NewesListViwes({super.key, required this.articles});

  @override
  Widget build(BuildContext context) {
    return SliverList(
      delegate: SliverChildBuilderDelegate(
        childCount: articles.length,
        (context, index) {
          return NewsTile(
            articleModel: articles[index],
          );
        },
      ),
    );
  }
}
