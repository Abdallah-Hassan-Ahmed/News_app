import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:news_app/cubits/session/session_cubit.dart';
import 'package:news_app/views/home%20view/home_view.dart';
import '../../utils/widgets reuse/custom_text_form_field.dart';
import '../../utils/widgets reuse/custom_button.dart';
import '../../models/user_model.dart';
import '../../cubits/auth/auth_cubit.dart';
import '../../cubits/auth/auth_state.dart';

class UpdateProfileScreen extends StatefulWidget {
  final UserModel user;

  const UpdateProfileScreen({super.key, required this.user});

  @override
  State<UpdateProfileScreen> createState() => _UpdateProfileScreenState();
}

class _UpdateProfileScreenState extends State<UpdateProfileScreen> {
  final _formKey = GlobalKey<FormState>();

  late TextEditingController firstNameController;
  late TextEditingController lastNameController;
  late TextEditingController emailController;
  late TextEditingController securityQuestionController;
  late TextEditingController securityAnswerController;

  @override
  void initState() {
    final user = widget.user;
    firstNameController = TextEditingController(text: user.firstName);
    lastNameController = TextEditingController(text: user.lastName);
    emailController = TextEditingController(text: user.email);
    securityQuestionController =
        TextEditingController(text: user.securityQuestion ?? '');
    securityAnswerController =
        TextEditingController(text: user.securityAnswer ?? '');
    super.initState();
  }

  @override
  void dispose() {
    firstNameController.dispose();
    lastNameController.dispose();
    emailController.dispose();
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
            colors: [Colors.deepPurple, Colors.purple],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: BlocBuilder<AuthCubit, AuthState>(
                builder: (context, state) {
                  return Form(
                    key: _formKey,
                    child: Container(
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black12,
                            blurRadius: 10,
                            offset: Offset(0, 4),
                          )
                        ],
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Text(
                            "Update Profile",
                            style: TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                              color: Colors.deepPurple,
                            ),
                          ),
                          const SizedBox(height: 20),

                          CustomTextFormField(
                            label: "First Name",
                            controller: firstNameController,
                          ),
                          const SizedBox(height: 10),
                          CustomTextFormField(
                            label: "Last Name",
                            controller: lastNameController,
                          ),
                          const SizedBox(height: 10),
                          CustomTextFormField(
                            label: "Email",
                            controller: emailController,
                            keyboardType: TextInputType.emailAddress,
                          ),
                          const SizedBox(height: 10),
                          CustomTextFormField(
                            label: "Security Question",
                            controller: securityQuestionController,
                          ),
                          const SizedBox(height: 10),
                          CustomTextFormField(
                            label: "Security Answer",
                            controller: securityAnswerController,
                          ),
                          const SizedBox(height: 20),

                          CustomButton(
                            text: "Save Changes",
                            isLoading: state is AuthLoading,
                            onPressed: () {
                              if (_formKey.currentState!.validate()) {
                                final updatedUser = widget.user.copyWith(
                                  firstName: firstNameController.text.trim(),
                                  lastName: lastNameController.text.trim(),
                                  email: emailController.text.trim(),
                                  securityQuestion: securityQuestionController.text.trim(),
                                  securityAnswer: securityAnswerController.text.trim(),
                                );

                                context.read<AuthCubit>().updateProfile(updatedUser);
                                context.read<SessionCubit>().updateUser(updatedUser);

                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                      content: Text("Profile updated successfully")),
                                );

                                Navigator.of(context).pushAndRemoveUntil(
                                  MaterialPageRoute(
                                      builder: (_) => const HomeScreen()),
                                  (route) => false,
                                );
                              }
                            },
                            color: Colors.deepPurple,
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
        ),
      ),
    );
  }
}
