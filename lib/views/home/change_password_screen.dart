import 'package:flutter/material.dart';
import '../../widgets/form/password_form_field.dart';
import '../../widgets/form/custom_button.dart';

class ChangePasswordScreen extends StatefulWidget {
  const ChangePasswordScreen({super.key});

  @override
  State<ChangePasswordScreen> createState() => _ChangePasswordScreenState();
}

class _ChangePasswordScreenState extends State<ChangePasswordScreen> {
  final _formKey = GlobalKey<FormState>();
  final oldPassController = TextEditingController();
  final newPassController = TextEditingController();
  final confirmPassController = TextEditingController();

  @override
  void dispose() {
    oldPassController.dispose();
    newPassController.dispose();
    confirmPassController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Change Password"),
        backgroundColor: Colors.deepPurple,
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              PasswordFormField(
                controller: oldPassController,
                label: "Current Password",
                validator: (val) =>
                    val == null || val.isEmpty ? "Required" : null,
              ),
              const SizedBox(height: 10),
              PasswordFormField(
                controller: newPassController,
                label: "New Password",
                validator: (val) =>
                    val == null || val.length < 6 ? "Too short" : null,
              ),
              const SizedBox(height: 10),
              PasswordFormField(
                controller: confirmPassController,
                label: "Confirm Password",
                validator: (val) => val != newPassController.text
                    ? "Passwords do not match"
                    : null,
              ),
              const SizedBox(height: 20),
              CustomButton(
                text: "Change Password",
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    // call changePassword method in cubit/service
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text("Password changed")),
                    );
                    Navigator.pop(context);
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
