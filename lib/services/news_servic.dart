import 'package:dio/dio.dart';
import 'package:news_app/models/article_model.dart';

class NewsServic {
  final Dio dio;

  NewsServic(this.dio);

  Future<List<ArticleModel>> getNews({required String category}) async {
    try {
      final response = await dio.get(
        'https://newsapi.org/v2/top-headlines?country=us&apiKey=3c88955c487e4d9db668f011dd85e737&category=$category',
      );

      final jsonData = response.data;
      final List<dynamic> articles = jsonData['articles'];
      return articles.map((e) {
        final model = ArticleModel.fromJson(e);
        return model.copyWith(category: category);
      }).toList();
    } catch (e) {
      return [];
    }
  }
}
