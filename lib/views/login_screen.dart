import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:news_app/views/forgot_password_screen.dart';
import 'package:news_app/views/home/home_view.dart';
import 'package:news_app/views/register_screen.dart';
import '../../cubits/auth/auth_cubit.dart';
import '../../cubits/auth/auth_state.dart';
import '../../widgets/form/custom_text_form_field.dart';
import '../../widgets/form/password_form_field.dart';
import '../../widgets/form/custom_button.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  bool rememberMe = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      appBar: AppBar(
        title: const Text("Login"),
        backgroundColor: Colors.deepPurple,
        foregroundColor: Colors.white,
        elevation: 1,
      ),
      body: Center(
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
                  const SnackBar(content: Text("Login successful")),
                );
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (_) => const HomeScreen()),
                );
              }
            },
            builder: (context, state) {
              return Form(
                key: _formKey,
                child: Column(
                  children: [
                    const Icon(Icons.account_circle_rounded,
                        size: 80, color: Colors.deepPurple),
                    const SizedBox(height: 20),
                    CustomTextFormField(
                      label: "Email",
                      controller: emailController,
                      keyboardType: TextInputType.emailAddress,
                      validator: (val) => val != null && val.contains("@")
                          ? null
                          : "Invalid email",
                    ),
                    const SizedBox(height: 16),
                    PasswordFormField(
                      controller: passwordController,
                      validator: (val) => val != null && val.isNotEmpty
                          ? null
                          : "Password is required",
                    ),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        Checkbox(
                          value: rememberMe,
                          onChanged: (val) =>
                              setState(() => rememberMe = val ?? false),
                        ),
                        const Text("Remember Me"),
                      ],
                    ),
                    const SizedBox(height: 16),
                    CustomButton(
                      text: "Login",
                      icon: Icons.login,
                      isLoading: state is AuthLoading,
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          context.read<AuthCubit>().login(
                                emailController.text.trim(),
                                passwordController.text.trim(),
                                rememberMe,
                              );
                        }
                      },
                    ),
                    const SizedBox(height: 20),
                    TextButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (_) => const ForgotPasswordScreen()),
                        );
                      },
                      child: const Text("Forgot Password?"),
                    ),
                    TextButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (_) => const RegisterScreen()),
                        );
                      },
                      child: const Text("Create New Account"),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
