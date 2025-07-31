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