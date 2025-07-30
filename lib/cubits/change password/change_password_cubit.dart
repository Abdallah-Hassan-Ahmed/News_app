import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:news_app/cubits/change password/change_password_state.dart';
import 'package:news_app/services/local_auth_service.dart';

class ChangePasswordCubit extends Cubit<ChangePasswordState> {
  final LocalAuthService authService;

  ChangePasswordCubit(this.authService) : super(ChangePasswordInitial());

  static ChangePasswordCubit get(context) => BlocProvider.of(context);

  void changePassword({required String oldPassword, required String newPassword}) async {
    emit(ChangePasswordLoading());

    try {
      final currentUser = await authService.getCurrentUser();
      if (currentUser == null) {
        emit(ChangePasswordFailure(error: 'User not found'));
        return;
      }

      final isCorrect = await authService.verifyPassword(currentUser.email, oldPassword);

      if (!isCorrect) {
        emit(ChangePasswordFailure(error: 'Old password is incorrect'));
        return;
      }

      final success = await authService.changePassword(currentUser.email, newPassword);

      if (success) {
        emit(ChangePasswordSuccess());
      } else {
        emit(ChangePasswordFailure(error: 'Failed to change password'));
      }
    } catch (e) {
      emit(ChangePasswordFailure(error: e.toString()));
    }
  }
}
