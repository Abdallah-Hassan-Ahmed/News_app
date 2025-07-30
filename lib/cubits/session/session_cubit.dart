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
  static const _sessionDurationInMinutes = 1440; // يوم واحد

  void checkSession() async {
    final prefs = await SharedPreferences.getInstance();
    final sessionJson = prefs.getString(_sessionKey);

    if (sessionJson == null) {
      print("🚫 No session data found");
      emit(SessionUnauthenticated());
      return;
    }

    try {
      final sessionData = jsonDecode(sessionJson);
      final userData = sessionData['user'];
      final loginTimeStr = sessionData['loginTime'];

      if (userData == null || loginTimeStr == null) {
        print("❌ userData or loginTime is missing");
        emit(SessionUnauthenticated());
        return;
      }

      final loginTime = DateTime.parse(loginTimeStr);
      final now = DateTime.now();

      final difference = now.difference(loginTime).inMinutes;
      print("🕒 Session age: $difference minutes");

      if (difference > _sessionDurationInMinutes) {
        print("⏰ Session expired");
        emit(SessionUnauthenticated());
      } else {
        final user = UserModel.fromJson(userData);
        emit(SessionAuthenticated(user));
      }
    } catch (e) {
      print("❌ Error reading session: $e");
      emit(SessionUnauthenticated());
    }
  }

  void updateUser(UserModel updatedUser) async {
    final prefs = await SharedPreferences.getInstance();

    final sessionJson = prefs.getString(_sessionKey);
    if (sessionJson == null) {
      print("🚫 sessionJson is null");
      emit(SessionUnauthenticated());
      return;
    }

    try {
      final sessionData = jsonDecode(sessionJson);
      final loginTime = sessionData['loginTime'];

      print("📢 Updating session user...");
      print("🔸 Login time: $loginTime");
      print("🔸 Updated user: ${updatedUser.toJson()}");

      if (loginTime == null) {
        print("❌ loginTime is null");
        emit(SessionUnauthenticated());
        return;
      }

      final updatedSession = {
        "user": updatedUser.toJson(),
        "loginTime": loginTime,
      };

      await prefs.setString(_sessionKey, jsonEncode(updatedSession));

      print("✅ Session updated successfully");
      emit(SessionAuthenticated(updatedUser));
    } catch (e) {
      print("❌ Error updating session: $e");
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
