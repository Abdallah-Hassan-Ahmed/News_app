import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:news_app/cubits/forget%20password/forget_password_state.dart';
import 'package:news_app/cubits/forget%20password/forgot_password_cubit.dart';
import 'package:news_app/views/auth%20view/login_screen.dart';
import '../../utils/widgets reuse/custom_text_form_field.dart';
import '../../utils/widgets reuse/custom_button.dart';
import '../../../utils/validation_utils.dart';

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color(0xFF4A148C),
              Color(0xFF7B1FA2),
              Color(0xFF9C27B0),
              Color(0xFFBA68C8),
              Color(0xFFE1BEE7),
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            stops: [0.0, 0.3, 0.6, 0.8, 1.0],
            tileMode: TileMode.clamp,
          ),
        ),
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(20),
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
                return Card(
                  elevation: 8,
                  color: const Color.fromARGB(255, 220, 219, 219),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(24),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Image.asset(
                            'assets/logo.png',
                            height: 100,
                            width: 100,
                          ),
                          const SizedBox(height: 20),
                          Text(
                            'Reset Your Password',
                            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                                  color: Colors.deepPurple,
                                  fontWeight: FontWeight.bold,
                                ),
                          ),
                          const SizedBox(height: 20),
                          if (state is ForgotPasswordInitial || state is ForgotPasswordError) ...[
                            CustomTextFormField(
                              label: "Enter your email",
                              controller: emailController,
                              keyboardType: TextInputType.emailAddress,
                              validator: ValidationUtils.validateEmail,
                            ),
                            const SizedBox(height: 20),
                            CustomButton(
                              text: "Next",
                              icon: Icons.navigate_next,
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
                              validator: (val) => val == null || val.isEmpty
                                  ? "Answer is required"
                                  : null,
                            ),
                            const SizedBox(height: 20),
                            CustomButton(
                              text: "Verify",
                              icon: Icons.verified_user,
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
                              validator: ValidationUtils.validatePassword,
                            ),
                            const SizedBox(height: 20),
                            CustomButton(
                              text: "Reset Password",
                              icon: Icons.lock_reset,
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
                    ),
                  ),
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}
