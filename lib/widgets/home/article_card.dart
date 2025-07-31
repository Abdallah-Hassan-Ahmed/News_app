import 'package:flutter/material.dart';
import 'package:news_app/models/article_model.dart';

class ArticleCard extends StatelessWidget {
  final ArticleModel article;

  const ArticleCard({Key? key, required this.article}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(article.title),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (article.imageUrl != null)
              Image.network(article.imageUrl!),
            const SizedBox(height: 12),
            Text('Author: ${article.author ?? 'Unknown'}', style: TextStyle(fontWeight: FontWeight.bold)),
            Text('Source: ${article.source}'),
            Text('Published: ${article.publishedAt.toLocal()}'),
            Text('Category: ${article.category}'),
            const SizedBox(height: 12),
            Text(article.description, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            const SizedBox(height: 12),
            Text(article.content),
            const SizedBox(height: 16),
            Text('URL: ${article.url}', style: const TextStyle(color: Colors.blue)),
            const SizedBox(height: 16),
            Row(
              children: [
                Icon(article.isBookmarked ? Icons.bookmark : Icons.bookmark_border),
                const SizedBox(width: 8),
                Text(article.isBookmarked ? 'Bookmarked' : 'Not Bookmarked')
              ],
            )
          ],
        ),
      ),
    );
  }
}
