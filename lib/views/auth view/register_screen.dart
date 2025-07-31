import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:news_app/views/auth%20view/login_screen.dart';
import '../../../cubits/auth/auth_cubit.dart';
import '../../../cubits/auth/auth_state.dart';
import '../../utils/widgets reuse/custom_text_form_field.dart';
import '../../utils/widgets reuse/password_form_field.dart';
import '../../utils/widgets reuse/custom_button.dart';
import '../../../utils/validation_utils.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  final firstNameController = TextEditingController();
  final lastNameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();
  final securityQuestionController = TextEditingController();
  final securityAnswerController = TextEditingController();

  bool agreedToTerms = false;

  @override
  void dispose() {
    firstNameController.dispose();
    lastNameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    securityQuestionController.dispose();
    securityAnswerController.dispose();
    super.dispose();
  }

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
          ),
        ),
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: BlocConsumer<AuthCubit, AuthState>(
              listener: (context, state) {
                if (state is AuthError) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text(state.message)),
                  );
                } else if (state is AuthSuccess) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text("Registration successful")),
                  );
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (_) => const LoginScreen()),
                  );
                }
              },
              builder: (context, state) {
                return Card(
                  color: const Color.fromARGB(255, 220, 219, 219),
                  elevation: 8,
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
                          const SizedBox(height: 24),
                          Text(
                            'Create Account',
                            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                                  color: Colors.deepPurple,
                                  fontWeight: FontWeight.bold,
                                ),
                          ),
                          const SizedBox(height: 16),
                          CustomTextFormField(
                            label: "First Name",
                            controller: firstNameController,
                            validator: ValidationUtils.validateName,
                          ),
                          const SizedBox(height: 10),
                          CustomTextFormField(
                            label: "Last Name",
                            controller: lastNameController,
                            validator: ValidationUtils.validateName,
                          ),
                          const SizedBox(height: 10),
                          CustomTextFormField(
                            label: "Email",
                            controller: emailController,
                            keyboardType: TextInputType.emailAddress,
                            validator: ValidationUtils.validateEmail,
                          ),
                          const SizedBox(height: 10),
                          PasswordFormField(
                            controller: passwordController,
                            label: "Password",
                            validator: ValidationUtils.validatePassword,
                          ),
                          const SizedBox(height: 10),
                          PasswordFormField(
                            controller: confirmPasswordController,
                            label: "Confirm Password",
                            validator: (val) => ValidationUtils.validateConfirmPassword(
                              val,
                              passwordController.text,
                            ),
                          ),
                          const SizedBox(height: 10),
                          CustomTextFormField(
                            label: "Security Question",
                            controller: securityQuestionController,
                            validator: (val) =>
                                val == null || val.isEmpty ? "Security question is required" : null,
                          ),
                          const SizedBox(height: 10),
                          CustomTextFormField(
                            label: "Security Answer",
                            controller: securityAnswerController,
                            validator: (val) =>
                                val == null || val.isEmpty ? "Answer is required" : null,
                          ),
                          const SizedBox(height: 10),
                          Row(
                            children: [
                              Checkbox(
                                value: agreedToTerms,
                                onChanged: (val) =>
                                    setState(() => agreedToTerms = val ?? false),
                              ),
                              const Expanded(
                                child: Text("I agree to the Terms & Conditions"),
                              ),
                            ],
                          ),
                          if (!agreedToTerms)
                            const Padding(
                              padding: EdgeInsets.only(left: 8.0),
                              child: Text(
                                "You must accept the terms to register",
                                style: TextStyle(color: Colors.red),
                              ),
                            ),
                          const SizedBox(height: 20),
                          CustomButton(
                            text: "Register",
                            icon: Icons.app_registration,
                            isLoading: state is AuthLoading,
                            onPressed: () {
                              if (_formKey.currentState!.validate() && agreedToTerms) {
                                context.read<AuthCubit>().register(
                                      firstName: firstNameController.text.trim(),
                                      lastName: lastNameController.text.trim(),
                                      email: emailController.text.trim(),
                                      password: passwordController.text.trim(),
                                      securityQuestion: securityQuestionController.text.trim(),
                                      securityAnswer: securityAnswerController.text.trim(),
                                    );
                              }
                            },
                            color: Colors.deepPurple,
                          ),
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
