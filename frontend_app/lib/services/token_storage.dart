import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class TokenStorage {
  TokenStorage({FlutterSecureStorage? storage})
      : _storage = storage ?? const FlutterSecureStorage();

  static const _tokenKey = 'auth_token';
  static const _userKey = 'auth_user';

  /// Shared in-memory cache across all TokenStorage instances.
  static String? _memToken;
  static bool _tokenReady = false;
  static String? _memUserJson;
  static bool _userReady = false;

  final FlutterSecureStorage _storage;

  Future<void> saveToken(String token) async {
    _memToken = token;
    _tokenReady = true;
    await _storage.write(key: _tokenKey, value: token);
  }

  Future<String?> readToken() async {
    if (_tokenReady) return _memToken;
    _memToken = await _storage.read(key: _tokenKey);
    _tokenReady = true;
    return _memToken;
  }

  Future<void> saveUserJson(String json) async {
    _memUserJson = json;
    _userReady = true;
    await _storage.write(key: _userKey, value: json);
  }

  Future<String?> readUserJson() async {
    if (_userReady) return _memUserJson;
    _memUserJson = await _storage.read(key: _userKey);
    _userReady = true;
    return _memUserJson;
  }

  Future<void> clear() async {
    _memToken = null;
    _tokenReady = true;
    _memUserJson = null;
    _userReady = true;
    await _storage.delete(key: _tokenKey);
    await _storage.delete(key: _userKey);
  }
}
