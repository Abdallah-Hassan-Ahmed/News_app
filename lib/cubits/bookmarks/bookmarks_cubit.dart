import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:news_app/models/article_model.dart';

class BookmarksCubit extends Cubit<List<ArticleModel>> {
  BookmarksCubit() : super([]);

  void toggleBookmark(ArticleModel article) {
    final exists = state.any((a) => a.url == article.url);
    if (exists) {
      emit(state.where((a) => a.url != article.url).toList());
    } else {
      emit([...state, article.copyWith(isBookmarked: true)]);
    }
  }

  bool isBookmarked(ArticleModel article) {
    return state.any((a) => a.url == article.url);
  }
}
