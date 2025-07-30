// ✅ services/local_auth_service.dart
import 'dart:convert';
import 'package:collection/collection.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:crypto/crypto.dart';
import '../models/user_model.dart';

class LocalAuthService {
  static const String usersKey = 'users_list';
  static const String currentUserKey = 'current_user_id';

  Future<List<UserModel>> _getUsers() async {
    final prefs = await SharedPreferences.getInstance();
    final usersJson = prefs.getString(usersKey);
    if (usersJson == null) return [];
    final List<dynamic> decoded = jsonDecode(usersJson);
    return decoded.map((e) => UserModel.fromJson(e)).toList();
  }

  // ✅ Public getter to expose user list outside
  Future<List<UserModel>> getUsers() => _getUsers();

  Future<void> _saveUsers(List<UserModel> users) async {
    final prefs = await SharedPreferences.getInstance();
    final encoded = jsonEncode(users.map((e) => e.toJson()).toList());
    await prefs.setString(usersKey, encoded);
  }

  String _hashPassword(String password, String salt) {
    final bytes = utf8.encode(password + salt);
    final hash = sha256.convert(bytes);
    return hash.toString();
  }

  Future<bool> isUserExists(String email) async {
    final users = await _getUsers();
    return users.any((u) => u.email == email);
  }

  Future<UserModel?> login(String email, String password) async {
    final users = await _getUsers();
    final user = users.firstWhereOrNull((u) => u.email == email);

    if (user == null) return null;

    final hashed = _hashPassword(password, user.id);
    if (hashed == user.passwordHash) {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(currentUserKey, user.id);
      return user;
    }

    return null;
  }

  Future<UserModel> register(UserModel user, String password) async {
    final users = await _getUsers();
    final hashedPassword = _hashPassword(password, user.id);
    final newUser = user.copyWith(passwordHash: hashedPassword);
    users.add(newUser);
    await _saveUsers(users);
    return newUser;
  }

  Future<UserModel?> updateUser(UserModel updatedUser) async {
  final users = await _getUsers();
  final index = users.indexWhere((u) => u.id == updatedUser.id);
  if (index == -1) return null;

  users[index] = updatedUser;
  await _saveUsers(users);
  return updatedUser;
}


  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(currentUserKey);
  }

  Future<bool> resetPassword(String email, String newPassword) async {
    final users = await _getUsers();
    final index = users.indexWhere((u) => u.email == email);
    if (index == -1) return false;

    final user = users[index];
    final hashed = _hashPassword(newPassword, user.id);
    users[index] = user.copyWith(passwordHash: hashed);

    await _saveUsers(users);
    return true;
  }

  Future<bool> verifyPassword(String email, String password) async {
  final users = await _getUsers();
  final user = users.firstWhereOrNull((u) => u.email == email);
  if (user == null) return false;

  final hashed = _hashPassword(password, user.id);
  return hashed == user.passwordHash;
}

Future<bool> changePassword(String email, String newPassword) async {
  final users = await _getUsers();
  final index = users.indexWhere((u) => u.email == email);
  if (index == -1) return false;

  final user = users[index];
  final hashed = _hashPassword(newPassword, user.id);
  users[index] = user.copyWith(passwordHash: hashed);

  await _saveUsers(users);
  return true;
}
 Future<UserModel?> getCurrentUser() async {
  final prefs = await SharedPreferences.getInstance();
  final userId = prefs.getString(currentUserKey);
  if (userId == null) return null;

  final users = await _getUsers();
  return users.firstWhereOrNull((u) => u.id == userId);
}

}