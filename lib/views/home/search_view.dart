import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:news_app/cubits/news/list_view_cubit.dart';
import 'package:news_app/models/article_model.dart';

// class ArticleSearchDelegate extends SearchDelegate<String> {
//   @override
//   List<Widget>? buildActions(BuildContext context) {
//     return [
//       IconButton(
//         icon: const Icon(Icons.clear),
//         onPressed: () {
//           query = '';
//         },
//       )
//     ];
//   }

//   @override
//   Widget? buildLeading(BuildContext context) {
//     return IconButton(
//       icon: const Icon(Icons.arrow_back),
//       onPressed: () {
//         close(context, '');
//       },
//     );
//   }

//   @override
//   Widget buildResults(BuildContext context) {
//     final articleList = context.read<ListVeiwCubit>().articleList;

//     final results = articleList.where((article) {
//       return article.title.toLowerCase().contains(query.toLowerCase()) ||
//              article.content.toLowerCase().contains(query.toLowerCase()) ||
//              (article.author?.toLowerCase().contains(query.toLowerCase()) ?? false);
//     }).toList();

//     if (results.isEmpty) {
//       return const Center(child: Text("No results found."));
//     }

//     return ListView.builder(
//       itemCount: results.length,
//       itemBuilder: (context, index) {
//         final article = results[index];
//         return ListTile(
//           title: Text(article.title),
//           subtitle: Text(article.author ?? 'No Author'),
//           onTap: () {
//             // Navigate to article details screen if exists
//           },
//         );
//       },
//     );
//   }

//   @override
//   Widget buildSuggestions(BuildContext context) {
//     final articleList = context.read<ListVeiwCubit>().articleList;

//     final suggestions = articleList.where((article) {
//       return article.title.toLowerCase().contains(query.toLowerCase()) ||
//              article.content.toLowerCase().contains(query.toLowerCase()) ||
//              (article.author?.toLowerCase().contains(query.toLowerCase()) ?? false);
//     }).toList();

//     return ListView.builder(
//       itemCount: suggestions.length,
//       itemBuilder: (context, index) {
//         final article = suggestions[index];
//         return ListTile(
//           title: Text(article.title),
//           subtitle: Text(article.author ?? 'No Author'),
//           onTap: () {
//             query = article.title;
//             showResults(context);
//           },
//         );
//       },
//     );
//   }
// }
