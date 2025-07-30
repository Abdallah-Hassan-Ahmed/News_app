import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:news_app/cubits/forget%20password/forgot_password_cubit.dart';
import 'package:news_app/views/login_screen.dart';
import '../../widgets/form/custom_text_form_field.dart';
import '../../widgets/form/custom_button.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final emailController = TextEditingController();
  final answerController = TextEditingController();
  final newPasswordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  bool showNewPassword = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Forgot Password"),
        backgroundColor: Colors.deepPurple,
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: BlocConsumer<ForgotPasswordCubit, ForgotPasswordState>(
          listener: (context, state) {
            if (state is ForgotPasswordError) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(state.message)),
              );
            } else if (state is ForgotPasswordResetDone) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text("Password reset successful")),
              );
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (_) => const LoginScreen()),
                (route) => false,
              );
            }
          },
          builder: (context, state) {
            return Form(
              key: _formKey,
              child: ListView(
                children: [
                  if (state is ForgotPasswordInitial || state is ForgotPasswordError) ...[
                    CustomTextFormField(
                      label: "Enter your email",
                      controller: emailController,
                      validator: (val) =>
                          val == null || val.isEmpty ? "Email is required" : null,
                    ),
                    const SizedBox(height: 20),
                    CustomButton(
                      text: "Next",
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          context.read<ForgotPasswordCubit>().verifyEmail(
                                emailController.text.trim(),
                              );
                        }
                      },
                      color: Colors.deepPurple,
                    ),
                  ] else if (state is ForgotPasswordShowSecurityQuestion) ...[
                    Text(
                      state.question,
                      style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                    ),
                    const SizedBox(height: 10),
                    CustomTextFormField(
                      label: "Your Answer",
                      controller: answerController,
                      validator: (val) =>
                          val == null || val.isEmpty ? "Answer is required" : null,
                    ),
                    const SizedBox(height: 20),
                    CustomButton(
                      text: "Verify",
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          context.read<ForgotPasswordCubit>().verifySecurityAnswer(
                                answerController.text.trim(),
                              );
                        }
                      },
                      color: Colors.deepPurple,
                    ),
                  ] else if (state is ForgotPasswordSuccess) ...[
                    CustomTextFormField(
                      label: "New Password",
                      controller: newPasswordController,
                      obscureText: true,
                      validator: (val) =>
                          val == null || val.length < 6 ? "Password too short" : null,
                    ),
                    const SizedBox(height: 20),
                    CustomButton(
                      text: "Reset Password",
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          context.read<ForgotPasswordCubit>().resetPassword(
                                newPasswordController.text.trim(),
                              );
                        }
                      },
                      color: Colors.deepPurple,
                    ),
                  ],
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
