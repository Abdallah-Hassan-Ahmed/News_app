import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:news_app/cubits/auth/auth_cubit.dart';
import 'package:news_app/cubits/news/list_view_cubit.dart';
import 'package:news_app/cubits/session/session_cubit.dart';
import 'package:news_app/models/user_model.dart';
import 'package:news_app/views/home/notifications_page.dart';
import 'package:news_app/views/login_screen.dart';
import 'package:news_app/views/settings/settings_screen.dart';
import 'package:news_app/widgets/categories_list_view.dart';
import 'package:news_app/widgets/news_list_view_builder.dart';
import 'package:news_app/widgets/news_tile.dart';

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
    return 'Good Evening 🌙';
  }

  @override
  Widget build(BuildContext context) {
    final sessionState = context.watch<SessionCubit>().state;
    final UserModel? user = sessionState is SessionAuthenticated
        ? sessionState.user
        : null;

    return Scaffold(
      drawer: _buildDrawer(context, user),
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
            const SliverToBoxAdapter(child: CategoriesListView()),
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

  Widget _buildDrawer(BuildContext context, UserModel? user) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          UserAccountsDrawerHeader(
            decoration: const BoxDecoration(color: Colors.deepPurple),
            accountName: Text(
              user != null ? '${user.firstName} ${user.lastName}' : 'Guest',
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            accountEmail: Text(user?.email ?? ''),
            currentAccountPicture: CircleAvatar(
              backgroundImage: user?.profileImage != null
                  ? (user!.profileImage!.startsWith('http')
                      ? NetworkImage(user.profileImage!)
                      : FileImage(File(user.profileImage!)) as ImageProvider)
                  : null,
              child: user?.profileImage == null
                  ? const Icon(Icons.person, size: 30, color: Colors.white)
                  : null,
            ),
          ),
          ListTile(
            leading: const Icon(Icons.settings, color: Colors.deepPurple),
            title: const Text('Settings'),
            onTap: () {
              Navigator.pop(context);
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const SettingsScreen()),
              );
            },
          ),
          // ListTile(
          //   leading: const Icon(Icons.language, color: Colors.deepPurple),
          //   title: const Text('Change Language'),
          //   onTap: () {
          //     Navigator.pop(context);
          //     ScaffoldMessenger.of(context).showSnackBar(
          //       const SnackBar(content: Text("Change Language Pressed")),
          //     );
          //   },
          // ),
          ListTile(
            leading: const Icon(Icons.logout, color: Colors.deepPurple),
            title: const Text('Log Out'),
            trailing: const Icon(Icons.arrow_forward_ios, size: 16, color: Colors.deepPurple),
            onTap: () {
              showDialog(
                context: context,
                builder: (ctx) => AlertDialog(
                  title: const Text("Confirm Logout"),
                  content: const Text("Are you sure you want to logout?"),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(ctx),
                      child: const Text("Cancel"),
                    ),
                    TextButton(
                      onPressed: () {
                        Navigator.pop(ctx);
                        context.read<AuthCubit>().logout();
                        Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(builder: (_) => const LoginScreen()),
                          (route) => false,
                        );
                      },
                      child: const Text("Yes"),
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}

class ArticleSearchDelegate extends SearchDelegate<String> {
  @override
  List<Widget>? buildActions(BuildContext context) => [
        IconButton(
          icon: const Icon(Icons.clear),
          onPressed: () => query = '',
        ),
      ];

  @override
  Widget? buildLeading(BuildContext context) => IconButton(
        icon: const Icon(Icons.arrow_back),
        onPressed: () => close(context, ''),
      );

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

    if (results.isEmpty) return const Center(child: Text("No results found."));

    return ListView.builder(
      itemCount: results.length,
      itemBuilder: (context, index) {
        final article = results[index];
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
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
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
            child: NewsTile(articleModel: article),
          ),
        );
      },
    );
  }
}