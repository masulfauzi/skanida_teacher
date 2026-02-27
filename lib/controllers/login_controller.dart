import 'package:flutter/material.dart';
import '../models/user_model.dart';
import '../services/auth_service.dart';

class LoginController {
  final AuthService _authService = AuthService();

  final TextEditingController usernameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  bool isLoading = false;
  String? errorMessage;

  /// Validate input fields
  String? _validate() {
    if (usernameController.text.trim().isEmpty) {
      return 'Username tidak boleh kosong';
    }
    if (passwordController.text.trim().isEmpty) {
      return 'Password tidak boleh kosong';
    }
    return null;
  }

  /// Perform login and return the result
  Future<LoginResult> login() async {
    errorMessage = null;

    final validationError = _validate();
    if (validationError != null) {
      errorMessage = validationError;
      return LoginResult(success: false, message: validationError);
    }

    isLoading = true;

    try {
      final result = await _authService.loginGuru(
        username: usernameController.text.trim(),
        password: passwordController.text.trim(),
      );

      isLoading = false;

      if (result['success'] == true) {
        final userData = result['user'];
        final token = result['token']?.toString();
        final user = UserModel.fromJson(
          userData is Map<String, dynamic> ? userData : {},
          token: token,
        );
        // Save login state, token, and user name
        await AuthService.saveLoginState(true, token: user.token, userName: user.name);
        return LoginResult(
          success: true,
          message: 'Login berhasil',
          user: user,
        );
      } else {
        final msg = result['message']?.toString() ?? 'Login gagal';
        errorMessage = msg;
        return LoginResult(success: false, message: msg);
      }
    } catch (e) {
      isLoading = false;
      errorMessage = 'Terjadi kesalahan: $e';
      return LoginResult(success: false, message: errorMessage!);
    }
  }

  void dispose() {
    usernameController.dispose();
    passwordController.dispose();
  }
}

class LoginResult {
  final bool success;
  final String message;
  final UserModel? user;

  LoginResult({required this.success, required this.message, this.user});
}
