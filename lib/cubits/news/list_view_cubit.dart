import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:news_app/models/article_model.dart';
import 'package:news_app/services/news_servic.dart';

part 'list_view_state.dart';

class ListVeiwCubit extends Cubit<ListVeiwState> {
  final NewsServic newsServic;

  ListVeiwCubit(this.newsServic) : super(ListVeiwInitial());

  List<ArticleModel> articleList = [];

  void getNews({required String category}) async {
    emit(ListVeiwLoding());
    try {
      articleList = await newsServic.getNews(category: category);
      emit(ListVeiwSaccess(articleList));
    } catch (_) {
      emit(ListVeiwFailure());
    }
  }
}