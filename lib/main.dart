import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:news_app/cubits/bookmarks/bookmarks_cubit.dart';
import 'package:news_app/cubits/change%20password/change_password_cubit.dart';
import 'package:news_app/cubits/news/list_view_cubit.dart';
import 'package:news_app/services/news_servic.dart';
import 'views/session_check_screen.dart';
import 'cubits/auth/auth_cubit.dart';
import 'cubits/forget password/forgot_password_cubit.dart';
import 'cubits/session/session_cubit.dart';
import 'services/local_auth_service.dart';

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
        BlocProvider<AuthCubit>(
          create: (_) => AuthCubit(LocalAuthService()),
        ),
        BlocProvider<ForgotPasswordCubit>(
          create: (_) => ForgotPasswordCubit(LocalAuthService()),
        ),
        BlocProvider<SessionCubit>(
          create: (_) => SessionCubit(),
        ),
        BlocProvider<ListVeiwCubit>(
          create: (_) => ListVeiwCubit(NewsServic(Dio())),
        ),
        BlocProvider<BookmarksCubit>(
  create: (_) => BookmarksCubit(),
),
//  BlocProvider<ChangePasswordCubit>(
//   create: (_) => ChangePasswordCubit(),
// ),
      ],
      child: MaterialApp(
        navigatorKey: navigatorKey,
        title: 'News App',
        debugShowCheckedModeBanner: false,
        home: const SessionCheckScreen(),
      ),
    );
  }
}
