// ✅ cubits/auth/forgot_password_cubit.dart
import 'package:collection/collection.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:news_app/services/local_auth_service.dart';
import 'package:news_app/models/user_model.dart';

abstract class ForgotPasswordState {}

class ForgotPasswordInitial extends ForgotPasswordState {}
class ForgotPasswordLoading extends ForgotPasswordState {}
class ForgotPasswordShowSecurityQuestion extends ForgotPasswordState {
  final String question;
  ForgotPasswordShowSecurityQuestion(this.question);
}
class ForgotPasswordSuccess extends ForgotPasswordState {}
class ForgotPasswordResetDone extends ForgotPasswordState {}
class ForgotPasswordError extends ForgotPasswordState {
  final String message;
  ForgotPasswordError(this.message);
}

class ForgotPasswordCubit extends Cubit<ForgotPasswordState> {
  final LocalAuthService _authService;
  UserModel? _targetUser;

  ForgotPasswordCubit(this._authService) : super(ForgotPasswordInitial());

  void verifyEmail(String email) async {
    emit(ForgotPasswordLoading());

    final users = await _authService.getUsers();
    final user = users.firstWhereOrNull((u) => u.email == email);

    if (user == null) {
      emit(ForgotPasswordError("Email not found"));
      return;
    }

    _targetUser = user;
    emit(ForgotPasswordShowSecurityQuestion(
      user.securityQuestion ?? "No security question found",
    ));
  }

  void verifySecurityAnswer(String answer) {
    if (_targetUser == null) {
      emit(ForgotPasswordError("Something went wrong"));
      return;
    }

    final correctAnswer = _targetUser!.securityAnswer?.trim().toLowerCase();
    if (answer.trim().toLowerCase() == correctAnswer) {
      emit(ForgotPasswordSuccess());
    } else {
      emit(ForgotPasswordError("Incorrect answer"));
    }
  }

  void resetPassword(String newPassword) async {
    if (_targetUser == null) {
      emit(ForgotPasswordError("Something went wrong"));
      return;
    }

    final result = await _authService.resetPassword(
      _targetUser!.email,
      newPassword,
    );

    if (result) {
      emit(ForgotPasswordResetDone());
    } else {
      emit(ForgotPasswordError("Failed to reset password"));
    }
  }
}
