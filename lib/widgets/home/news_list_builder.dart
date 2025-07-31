import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:news_app/cubits/news/list_view_cubit.dart';
import 'package:news_app/widgets/home/newes_list.dart';

class NewsListViewBuilder extends StatefulWidget {
  final String category;

  const NewsListViewBuilder({super.key, required this.category});

  @override
  State<NewsListViewBuilder> createState() => _NewsListViewBuilderState();
}

class _NewsListViewBuilderState extends State<NewsListViewBuilder> {
  @override
  void initState() {
    super.initState();
    context.read<ListVeiwCubit>().getNews(category: widget.category);
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ListVeiwCubit, ListVeiwState>(
      builder: (context, state) {
        if (state is ListVeiwLoding) {
          return const SliverToBoxAdapter(
            child: Center(child: CircularProgressIndicator()),
          );
        } else if (state is ListVeiwSaccess) {
          return NewesList(articles: state.articles);
        } else if (state is ListVeiwFailure) {
          return const SliverToBoxAdapter(
            child: Center(child: Text('❌ Failed to load news. Please try again.')),
          );
        } else {
          return const SliverToBoxAdapter(
            child: Center(child: Text('Nothing to show')),
          );
        }
      },
    );
  }
}
