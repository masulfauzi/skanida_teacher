import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class AuthService {
  static const String _baseUrl = 'https://apps.smkn2semarang.sch.id/api';
  static const _keyLoggedIn = 'logged_in';
  static const _keyToken = 'token';
  static const _keyUserName = 'user_name';
  static const _keyIdGuru = 'id_guru';
  static SharedPreferences? _prefs;

  static Future<void> init() async {
    _prefs ??= await SharedPreferences.getInstance();
  }

  static Future<bool> isLoggedIn() async {
    await init();
    return _prefs?.getBool(_keyLoggedIn) ?? false;
  }

  static Future<String?> getToken() async {
    await init();
    return _prefs?.getString(_keyToken);
  }

  static Future<void> saveLoginState(
    bool loggedIn, {
    String? token,
    String? username,
    String? id_guru,
  }) async {
    await init();
    await _prefs?.setBool(_keyLoggedIn, loggedIn);
    if (token != null) {
      await _prefs?.setString(_keyToken, token);
    }
    if (username != null) {
      await _prefs?.setString(_keyUserName, username);
    }
    if (id_guru != null) {
      await _prefs?.setString(_keyIdGuru, id_guru);
    }
  }

  static Future<String?> getUserName() async {
    await init();
    return _prefs?.getString(_keyUserName);
  }

  static Future<String?> getIdGuru() async {
    await init();
    return _prefs?.getString(_keyIdGuru);
  }

  // Keep legacy static method for backward compatibility
  static Future<void> login() async {
    await saveLoginState(true);
  }

  static Future<void> logout() async {
    await init();
    await _prefs?.setBool(_keyLoggedIn, false);
    await _prefs?.remove(_keyToken);
    await _prefs?.remove(_keyUserName);
    await _prefs?.remove(_keyIdGuru);
  }

  /// POST to /loginguru endpoint
  Future<Map<String, dynamic>> loginGuru({
    required String username,
    required String password,
  }) async {
    final url = Uri.parse('$_baseUrl/login-guru');

    try {
      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
        body: jsonEncode({'username': username, 'password': password}),
      );

      final body = jsonDecode(response.body);

      if (response.statusCode == 200) {
        return {
          'success': true,
          'user': body['user'] ?? {},
          'token': body['token'],
          'message': body['message'] ?? 'Login berhasil',
        };
      } else {
        return {
          'success': false,
          'message': body['message'] ?? 'Login gagal (${response.statusCode})',
        };
      }
    } catch (e) {
      return {
        'success': false,
        'message': 'Tidak dapat terhubung ke server: $e',
      };
    }
  }

  /// GET guru profile
  Future<Map<String, dynamic>> getProfilGuru({
    required String token,
    required String id_guru,
  }) async {
    final url = Uri.parse('$_baseUrl/guru/profil?id_guru=$id_guru');

    try {
      final response = await http.get(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      debugPrint('=== PROFIL DEBUG ===');
      debugPrint('URL: $url');
      debugPrint('Status Code: ${response.statusCode}');
      debugPrint('Response Body: ${response.body}');
      debugPrint('====================');

      final body = jsonDecode(response.body);

      if (response.statusCode == 200) {
        return {
          'success': true,
          'data': body['data'] ?? body['user'] ?? body,
          'message': body['message'] ?? 'Berhasil',
        };
      } else {
        return {
          'success': false,
          'message':
              body['message'] ?? 'Gagal memuat profil (${response.statusCode})',
        };
      }
    } catch (e) {
      return {
        'success': false,
        'message': 'Tidak dapat terhubung ke server: $e',
      };
    }
  }
}
