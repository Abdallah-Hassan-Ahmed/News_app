// utils/validation_utils.dart
class ValidationUtils {
  static String? validateEmail(String? value) {
    if (value == null || value.isEmpty) return "Email is required";
    if (!value.contains("@") || !value.contains(".")) return "Invalid email format";
    return null;
  }

  static String? validatePassword(String? value) {
    if (value == null || value.isEmpty) return "Password is required";
    if (value.length < 8) return "Password must be at least 8 characters";
    if (!RegExp(r'[A-Z]').hasMatch(value)) return "Must contain uppercase";
    if (!RegExp(r'[a-z]').hasMatch(value)) return "Must contain lowercase";
    if (!RegExp(r'\d').hasMatch(value)) return "Must contain a number";
    if (!RegExp(r'[!@#$%^&*(),.?":{}|<>]').hasMatch(value)) return "Must contain special character";
    return null;
  }

  static String? validateName(String? value) {
    if (value == null || value.isEmpty) return "This field is required";
    if (!RegExp(r'^[a-zA-Z]{2,}$').hasMatch(value)) return "Invalid name";
    return null;
  }

  static String? validateConfirmPassword(String? value, String password) {
    if (value == null || value.isEmpty) return "Confirm password is required";
    if (value != password) return "Passwords do not match";
    return null;
  }

  static String? validatePhone(String? value) {
    if (value == null || value.isEmpty) return null; // optional
    if (!RegExp(r'^\+?[0-9]{7,15}$').hasMatch(value)) return "Invalid phone number";
    return null;
  }
}
