import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:news_app/cubits/session/session_cubit.dart';
import 'package:news_app/main.dart';
import 'package:uuid/uuid.dart';
import '../../models/user_model.dart';
import '../../services/local_auth_service.dart';
import 'auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  final LocalAuthService _authService;

  AuthCubit(this._authService) : super(AuthInitial());

  void login(String email, String password, bool rememberMe) async {
    emit(AuthLoading());
    final user = await _authService.login(email, password);

    if (user != null) {
      final sessionCubit =
          BlocProvider.of<SessionCubit>(navigatorKey.currentContext!);
      await sessionCubit.setSession(user, rememberMe: rememberMe);
      emit(AuthSuccess(user));
    } else {
      emit(AuthError("Email or password is incorrect"));
    }
  }

  void register({
    required String firstName,
    required String lastName,
    required String email,
    required String password,
    required String securityQuestion,
    required String securityAnswer,
  }) async {
    emit(AuthLoading());

    final exists = await _authService.isUserExists(email);
    if (exists) {
      emit(AuthError("Email already exists"));
      return;
    }

    final id = const Uuid().v4();
    final newUser = UserModel(
      id: id,
      firstName: firstName,
      lastName: lastName,
      email: email,
      passwordHash: '',
      createdAt: DateTime.now(),
      securityQuestion: securityQuestion,
      securityAnswer: securityAnswer,
    );

    final savedUser = await _authService.register(newUser, password);
    emit(AuthSuccess(savedUser));
  }

  void updateProfile(UserModel updatedUser) async {
    emit(AuthLoading());
    final result = await _authService.updateUser(updatedUser);
    if (result != null) {
      final sessionCubit =
          BlocProvider.of<SessionCubit>(navigatorKey.currentContext!);
      sessionCubit.updateUser(result);
      emit(AuthSuccess(result));
    } else {
      emit(AuthError("Failed to update profile"));
    }
  }

  void logout() async {
    await _authService.logout();
    emit(AuthLoggedOut());
  }
}
