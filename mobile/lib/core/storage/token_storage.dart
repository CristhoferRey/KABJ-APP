import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

class TokenStorage {
  static const _tokenKey = 'access_token';

  TokenStorage._internal();

  static final TokenStorage instance = TokenStorage._internal();

  final ValueNotifier<String?> tokenNotifier = ValueNotifier<String?>(null);

  Future<void> init() async {
    final prefs = await SharedPreferences.getInstance();
    tokenNotifier.value = prefs.getString(_tokenKey);
  }

  Future<String?> getToken() async {
    if (tokenNotifier.value != null) {
      return tokenNotifier.value;
    }
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString(_tokenKey);
    tokenNotifier.value = token;
    return token;
  }

  Future<void> saveToken(String token) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_tokenKey, token);
    tokenNotifier.value = token;
  }

  Future<void> clearToken() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_tokenKey);
    tokenNotifier.value = null;
  }
}
