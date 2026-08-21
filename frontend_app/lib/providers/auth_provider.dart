import 'dart:async';

import 'package:flutter/foundation.dart';

import '../data/local/cache_warmup.dart';
import '../models/user.dart';
import '../services/api_client.dart';
import '../services/auth_service.dart';

class AuthProvider extends ChangeNotifier {
  AuthProvider({AuthService? authService})
      : _auth = authService ?? AuthService();

  final AuthService _auth;

  User? _user;
  bool _isLoading = true;
  String? _error;

  User? get user => _user;
  bool get isAuthenticated => _user != null;
  bool get isLoading => _isLoading;
  String? get error => _error;

  Future<void> bootstrap() async {
    _isLoading = true;
    notifyListeners();

    try {
      final token = await _auth.getSavedToken();
      if (token == null || token.isEmpty) {
        _user = null;
        return;
      }

      try {
        _user = await _auth.me();
      } catch (_) {
        _user = await _auth.getSavedUser();
        if (_user == null) {
          await _auth.clearSession();
        }
      }

      if (_user != null) {
        unawaited(warmLocalCaches());
      }
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<bool> login({
    required String email,
    required String password,
  }) async {
    _error = null;
    notifyListeners();

    try {
      final result = await _auth.login(email: email, password: password);
      _user = result.user;
      notifyListeners();
      unawaited(warmLocalCaches());
      return true;
    } on ApiException catch (e) {
      _error = e.message;
      notifyListeners();
      return false;
    } catch (_) {
      _error = 'Gagal login. Coba lagi.';
      notifyListeners();
      return false;
    }
  }

  Future<void> logout() async {
    await _auth.logout();
    _user = null;
    _error = null;
    notifyListeners();
  }
}
