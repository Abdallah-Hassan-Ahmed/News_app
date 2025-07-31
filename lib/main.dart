import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:news_app/cubits/auth/auth_cubit.dart';
import 'package:news_app/cubits/bookmarks/bookmarks_cubit.dart';
import 'package:news_app/cubits/change%20password/change_password_cubit.dart';
import 'package:news_app/cubits/forget%20password/forgot_password_cubit.dart';
import 'package:news_app/cubits/news/list_view_cubit.dart';
import 'package:news_app/cubits/session/session_cubit.dart';
import 'package:news_app/cubits/session/session_state.dart';
import 'package:news_app/services/local_auth_service.dart';
import 'package:news_app/services/news_servic.dart';
import 'package:news_app/views/home%20view/home_view.dart';
import 'package:news_app/views/welcome/welcome_screen.dart';
import 'package:dio/dio.dart';

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

void main() {
  runApp(const NewsApp());
}

class NewsApp extends StatelessWidget {
  const NewsApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (_) => SessionCubit()..checkSession(),
        ),
        BlocProvider(
          create: (_) => AuthCubit(LocalAuthService()),
        ),
        BlocProvider(
          create: (_) => ForgotPasswordCubit(LocalAuthService()),
        ),
        BlocProvider(
          create: (_) => ListVeiwCubit(NewsServic(Dio())),
        ),
        BlocProvider(
          create: (_) => BookmarksCubit(),
        ),
        BlocProvider(
          create: (_) => ChangePasswordCubit(LocalAuthService()),
        ),
      ],
      child: MaterialApp(
        navigatorKey: navigatorKey,
        title: 'News App',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primarySwatch: Colors.deepPurple,
          visualDensity: VisualDensity.adaptivePlatformDensity,
          useMaterial3: true,
        ),
        home: BlocBuilder<SessionCubit, SessionState>(
          builder: (context, state) {
            if (state is SessionAuthenticated) {
              return const HomeScreen();
            }
            else if (state is SessionUnauthenticated) {
              return const SplashScreen();
            }
            else {
              return const Scaffold(
                body: Center(
                  child: CircularProgressIndicator(),
                ),
              );
            }
          },
        ),
      ),
    );
  }
  }