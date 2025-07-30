part of 'list_view_cubit.dart';

abstract class ListVeiwState {}

final class ListVeiwInitial extends ListVeiwState {}

final class ListVeiwLoding extends ListVeiwState {}

class ListVeiwSaccess extends ListVeiwState {
  final List<ArticleModel> articles; 
  ListVeiwSaccess(this.articles);    
}
final class ListVeiwFailure extends ListVeiwState {}
