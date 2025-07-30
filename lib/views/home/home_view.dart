import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:news_app/cubits/news/list_view_cubit.dart';
import 'package:news_app/cubits/session/session_cubit.dart';
import 'package:news_app/models/user_model.dart';
import 'package:news_app/views/home/notifications_page.dart';
import 'package:news_app/widgets/categories_list_view.dart';
import 'package:news_app/widgets/news_list_view_builder.dart';
import 'package:news_app/widgets/news_tile.dart';
import '../settings/settings_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  Future<void> _refreshNews() async {
    setState(() {
      // يمكن لاحقًا تنفيذ منطق التحديث هنا
    });
  }

  String _getGreeting() {
    final hour = DateTime.now().hour;
    if (hour < 12) {
      return 'Good Morning';
    } else if (hour < 18) {
      return 'Good Afternoon';
    } else {
      return 'Good Evening 🌙';
    }
  }

  @override
  Widget build(BuildContext context) {
    final sessionState = context.watch<SessionCubit>().state;
    final UserModel? user = sessionState is SessionAuthenticated
        ? sessionState.user
        : null;

    return Scaffold(
      body: RefreshIndicator(
        onRefresh: _refreshNews,
        child: CustomScrollView(
          physics:
              const AlwaysScrollableScrollPhysics(), // مهم ليدعم السحب حتى لو مفيش Scroll
          slivers: [
            SliverAppBar(
              pinned: true,
              floating: true,
              snap: false,
              backgroundColor: Colors.white,
              foregroundColor: Colors.black,
              elevation: 1,
              automaticallyImplyLeading: false,
              title: Row(
                children: [
                  CircleAvatar(
                    radius: 22,
                    backgroundImage: user?.profileImage != null
                        ? (user!.profileImage!.startsWith('http')
                              ? NetworkImage(user.profileImage!)
                              : FileImage(File(user.profileImage!))
                                    as ImageProvider)
                        : null,
                    child: user?.profileImage == null
                        ? const Icon(Icons.person, size: 18)
                        : null,
                  ),
                  const SizedBox(width: 8),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        _getGreeting(),
                        style: const TextStyle(
                          fontSize: 8,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                      if (user != null)
                        Text(
                          '${user.firstName} ${user.lastName}',
                          style: const TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.bold,
                            color: Colors.deepPurple,
                          ),
                        ),
                    ],
                  ),
                ],
              ),
              actions: [
                IconButton(
                  icon: const Icon(
                    Icons.notifications,
                    color: Colors.deepPurple,
                  ),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const NotificationsPage(),
                      ),
                    );
                  },
                ),
                IconButton(
                  icon: const Icon(Icons.search, color: Colors.deepPurple),
                  onPressed: () {
                    showSearch(
                      context: context,
                      delegate: ArticleSearchDelegate(),
                    );
                  },
                ),
                IconButton(
                  icon: const Icon(Icons.settings, color: Colors.deepPurple),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const SettingsScreen()),
                    );
                  },
                ),
              ],
            ),
            const SliverToBoxAdapter(child: SizedBox(height: 24)),
            const SliverToBoxAdapter(child: CategoriesListView()),
            const SliverToBoxAdapter(child: SizedBox(height: 16)),
const SliverPadding(
  padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
  sliver: NewsListViewBuilder(category: 'general'),
),
          ],
        ),
      ),
    );
  }
}

class ArticleSearchDelegate extends SearchDelegate<String> {
  @override
  List<Widget>? buildActions(BuildContext context) {
    return [
      IconButton(
        icon: const Icon(Icons.clear),
        onPressed: () {
          query = '';
        },
      ),
    ];
  }

  @override
  Widget? buildLeading(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.arrow_back),
      onPressed: () {
        close(context, '');
      },
    );
  }

  @override
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

    if (results.isEmpty) {
      return const Center(child: Text("No results found."));
    }

    return ListView.builder(
      itemCount: results.length,
      itemBuilder: (context, index) {
        final article = results[index];
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
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
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: NewsTile(articleModel: article),
          ),
        );
      },
    );
  }
}
