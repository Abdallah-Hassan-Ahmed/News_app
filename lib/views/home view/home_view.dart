import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:news_app/cubits/session/session_cubit.dart';
import 'package:news_app/cubits/session/session_state.dart';
import 'package:news_app/models/user_model.dart';
import 'package:news_app/views/home%20view/notifications_page.dart';
import 'package:news_app/widgets/home/categories_list.dart';
import 'package:news_app/widgets/home/news_list_builder.dart';
import 'package:news_app/widgets/home/custom_drawer.dart';
import 'package:news_app/widgets/home/article_search_delegate.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  Future<void> _refreshNews() async {
    setState(() {});
  }

  String _getGreeting() {
    final hour = DateTime.now().hour;
    if (hour < 12) return 'Good Morning';
    if (hour < 18) return 'Good Afternoon';
    return 'Good Evening';
  }

  @override
  Widget build(BuildContext context) {
    final sessionState = context.watch<SessionCubit>().state;
    final UserModel? user = sessionState is SessionAuthenticated
        ? sessionState.user
        : null;

    return Scaffold(
      drawer: CustomDrawer(user: user),
      body: RefreshIndicator(
        onRefresh: _refreshNews,
        child: CustomScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          slivers: [
            SliverAppBar(
              pinned: true,
              floating: true,
              backgroundColor: Colors.white,
              elevation: 2,
              leading: Builder(
                builder: (context) => IconButton(
                  icon: const Icon(Icons.menu, color: Colors.deepPurple),
                  onPressed: () => Scaffold.of(context).openDrawer(),
                ),
              ),
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
                  const SizedBox(width: 12),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        _getGreeting(),
                        style: const TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.w300,
                          color: Colors.black87,
                        ),
                      ),
                      if (user != null)
                        Text(
                          '${user.firstName} ${user.lastName}',
                          style: const TextStyle(
                            fontSize: 14,
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
                  icon: const Icon(Icons.notifications_none, color: Colors.deepPurple),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const NotificationsPage()),
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
              ],
            ),
            const SliverToBoxAdapter(child: SizedBox(height: 20)),
            const SliverToBoxAdapter(child: CategoriesList()),
            const SliverToBoxAdapter(child: SizedBox(height: 12)),
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
