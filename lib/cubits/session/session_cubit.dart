import 'dart:convert';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:news_app/models/user_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

abstract class SessionState {}

class SessionInitial extends SessionState {}

class SessionAuthenticated extends SessionState {
  final UserModel user;

  SessionAuthenticated(this.user);
}

class SessionUnauthenticated extends SessionState {}

class SessionCubit extends Cubit<SessionState> {
  SessionCubit() : super(SessionInitial());

  static const _sessionKey = "user_session";
  static const _sessionDurationInMinutes = 60;

  Future<void> checkSession() async {
    final prefs = await SharedPreferences.getInstance();
    final sessionJson = prefs.getString(_sessionKey);

    if (sessionJson == null) {
      emit(SessionUnauthenticated());
      return;
    }

    try {
      final sessionData = jsonDecode(sessionJson);
      final loginTime = DateTime.tryParse(sessionData['loginTime'] ?? '');
      final userData = sessionData['user'];

      if (userData == null || loginTime == null) {
        emit(SessionUnauthenticated());
        return;
      }

      final now = DateTime.now();
      final expired =
          now.difference(loginTime).inMinutes > _sessionDurationInMinutes;

      if (expired) {
        await clearSession();
      } else {
        final user = UserModel.fromJson(userData);
        emit(SessionAuthenticated(user));
      }
    } catch (e) {
      emit(SessionUnauthenticated());
    }
  }

  Future<void> setSession(UserModel user, {bool rememberMe = false}) async {
    final prefs = await SharedPreferences.getInstance();

    await prefs.setString("current_user_id", user.id);
    await prefs.setBool("remember_me", rememberMe);

    final sessionData = {
      "user": user.toJson(),
      "loginTime": DateTime.now().toIso8601String(),
    };
    await prefs.setString(_sessionKey, jsonEncode(sessionData));

    emit(SessionAuthenticated(user));
  }

  Future<void> clearSession() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove("current_user_id");
    await prefs.remove("remember_me");
    await prefs.remove(_sessionKey);
    emit(SessionUnauthenticated());
  }
}
