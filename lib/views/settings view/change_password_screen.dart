import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:news_app/cubits/change%20password/change_password_cubit.dart';
import 'package:news_app/cubits/change%20password/change_password_state.dart';
import 'package:news_app/services/local_auth_service.dart';
import 'package:news_app/views/home%20view/home_view.dart';
import 'package:news_app/utils/widgets%20reuse/custom_button.dart';
import 'package:news_app/utils/widgets%20reuse/password_form_field.dart';

class ChangePasswordScreen extends StatefulWidget {
  const ChangePasswordScreen({super.key});

  @override
  State<ChangePasswordScreen> createState() => _ChangePasswordScreenState();
}

class _ChangePasswordScreenState extends State<ChangePasswordScreen> {
  final formKey = GlobalKey<FormState>();

  final oldPasswordController = TextEditingController();
  final newPasswordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => ChangePasswordCubit(LocalAuthService()),
      child: BlocConsumer<ChangePasswordCubit, ChangePasswordState>(
        listener: (context, state) {
          if (state is ChangePasswordSuccess) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Password changed successfully')),
            );
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (_) => const HomeScreen()),
            );
          } else if (state is ChangePasswordFailure) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.error)),
            );
          }
        },
        builder: (context, state) {
          return Scaffold(
            body: Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [Color(0xFF8E2DE2), Color(0xFF4A00E0)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
              child: Center(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(20),
                  child: Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    elevation: 6,
                    color: Colors.white,
                    child: Padding(
                      padding: const EdgeInsets.all(24),
                      child: Form(
                        key: formKey,
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(Icons.lock_reset, size: 70, color: Colors.deepPurple),
                            const SizedBox(height: 10),
                            const Text(
                              "Change Password",
                              style: TextStyle(
                                fontSize: 22,
                                fontWeight: FontWeight.bold,
                                color: Colors.deepPurple,
                              ),
                            ),
                            const SizedBox(height: 30),

                            PasswordFormField(
                              controller: oldPasswordController,
                              label: "Old Password",
                              validator: (val) => val == null || val.isEmpty
                                  ? 'Please enter old password'
                                  : null,
                            ),

                            const SizedBox(height: 16),

                            PasswordFormField(
                              controller: newPasswordController,
                              label: "New Password",
                              validator: (val) {
                                if (val == null || val.isEmpty) {
                                  return 'Please enter new password';
                                } else if (val.length < 6) {
                                  return 'Password must be at least 6 characters';
                                }
                                return null;
                              },
                            ),

                            const SizedBox(height: 16),

                            PasswordFormField(
                              controller: confirmPasswordController,
                              label: "Confirm Password",
                              validator: (val) {
                                if (val != newPasswordController.text) {
                                  return 'Passwords do not match';
                                }
                                return null;
                              },
                            ),

                            const SizedBox(height: 30),

                            CustomButton(
                              text: "Change Password",
                              icon: Icons.save,
                              isLoading: state is ChangePasswordLoading,
                              onPressed: () {
                                if (formKey.currentState!.validate()) {
                                  ChangePasswordCubit.get(context).changePassword(
                                    oldPassword: oldPasswordController.text.trim(),
                                    newPassword: newPasswordController.text.trim(),
                                  );
                                }
                              },
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
