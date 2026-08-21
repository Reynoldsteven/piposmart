import 'dart:convert';

import '../models/user.dart';
import 'api_client.dart';
import 'token_storage.dart';

class AuthService {
  AuthService({
    ApiClient? apiClient,
    TokenStorage? tokenStorage,
  })  : _api = apiClient ?? ApiClient(tokenStorage: tokenStorage),
        _storage = tokenStorage ?? TokenStorage();

  final ApiClient _api;
  final TokenStorage _storage;

  Future<LoginResult> login({
    required String email,
    required String password,
  }) async {
    final result = await _api.post<LoginResult>(
      '/auth/login',
      data: {
        'email': email.trim(),
        'password': password,
      },
      parser: (raw) => LoginResult.fromJson(raw as Map<String, dynamic>),
    );

    await _storage.saveToken(result.token);
    await _storage.saveUserJson(jsonEncode(result.user.toJson()));
    return result;
  }

  Future<User> me() {
    return _api.get<User>(
      '/auth/me',
      parser: (raw) => User.fromJson(raw as Map<String, dynamic>),
    );
  }

  Future<void> logout() async {
    try {
      await _api.delete('/auth/session');
    } catch (_) {
      // Client-side logout tetap jalan meski revoke gagal.
    } finally {
      await _storage.clear();
    }
  }

  Future<String?> getSavedToken() => _storage.readToken();

  Future<User?> getSavedUser() async {
    final raw = await _storage.readUserJson();
    if (raw == null || raw.isEmpty) return null;
    try {
      return User.fromJson(jsonDecode(raw) as Map<String, dynamic>);
    } catch (_) {
      return null;
    }
  }

  Future<void> clearSession() => _storage.clear();
}
