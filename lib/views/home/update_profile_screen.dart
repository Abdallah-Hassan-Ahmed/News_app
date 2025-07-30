import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:news_app/views/home/home_view.dart';
import '../../widgets/form/custom_text_form_field.dart';
import '../../widgets/form/custom_button.dart';
import '../../widgets/form/date_picker_form_field.dart';
import '../../widgets/form/profile_image_picker.dart';
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
  late TextEditingController phoneController;
  late TextEditingController securityQuestionController;
  late TextEditingController securityAnswerController;

  DateTime? birthDate;
  String? profileImage;

  @override
  void initState() {
    final user = widget.user;
    firstNameController = TextEditingController(text: user.firstName);
    lastNameController = TextEditingController(text: user.lastName);
    emailController = TextEditingController(text: user.email);
    phoneController = TextEditingController(text: user.phoneNumber ?? '');
    securityQuestionController =
        TextEditingController(text: user.securityQuestion ?? '');
    securityAnswerController =
        TextEditingController(text: user.securityAnswer ?? '');
    birthDate = user.dateOfBirth;
    profileImage = user.profileImage;
    super.initState();
  }

  @override
  void dispose() {
    firstNameController.dispose();
    lastNameController.dispose();
    emailController.dispose();
    phoneController.dispose();
    securityQuestionController.dispose();
    securityAnswerController.dispose();
    super.dispose();
  }

  void _pickProfileImage() async {
    final picked = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (picked != null) {
      setState(() {
        profileImage = picked.path;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Update Profile"),
        backgroundColor: Colors.deepPurple,
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: BlocBuilder<AuthCubit, AuthState>(
          builder: (context, state) {
            return Form(
              key: _formKey,
              child: ListView(
                children: [
                  ProfileImagePicker(
                    imagePath: profileImage,
                    onTap: _pickProfileImage,
                  ),
                  const SizedBox(height: 10),
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
                    label: "Phone Number",
                    controller: phoneController,
                    keyboardType: TextInputType.phone,
                  ),
                  const SizedBox(height: 10),
                  DatePickerFormField(
                    initialDate: birthDate,
                    label: "Date of Birth",
                    onDateSelected: (date) => setState(() => birthDate = date),
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
      phoneNumber: phoneController.text.trim(),
      dateOfBirth: birthDate,
      profileImage: profileImage,
      securityQuestion: securityQuestionController.text.trim(),
      securityAnswer: securityAnswerController.text.trim(),
    );

    context.read<AuthCubit>().updateProfile(updatedUser);

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Profile updated successfully")),
    );

  Navigator.pushReplacement(
  context,
  MaterialPageRoute(builder: (context) => const HomeScreen()),
);

  }
},

                    color: Colors.deepPurple,
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
