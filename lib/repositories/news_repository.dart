import 'package:dio/dio.dart';
import 'package:news_app/models/article_model.dart';

class NewsRepository {
  final Dio dio;

  NewsRepository(this.dio);

  Future<List<ArticleModel>> getNews({required String category}) async {
    try {
      final response = await dio.get(
        'https://newsapi.org/v2/top-headlines',
        queryParameters: {
          'country': 'us',
          'apiKey': '3c88955c487e4d9db668f011dd85e737',
          'category': category,
        },
      );

      final articles = response.data['articles'] as List;
      return articles.map((e) {
        return ArticleModel.fromJson(e)..category = category;
      }).toList();
    } catch (_) {
      return [];
    }
  }
}
