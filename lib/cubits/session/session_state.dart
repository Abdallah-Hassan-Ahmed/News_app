import 'package:news_app/models/user_model.dart';

abstract class SessionState {}

class SessionInitial extends SessionState {}

class SessionAuthenticated extends SessionState {
  final UserModel user;

  SessionAuthenticated(this.user);
}

class SessionUnauthenticated extends SessionState {}
