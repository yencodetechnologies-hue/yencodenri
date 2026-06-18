import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';

class StorageService {
  static const _tokenKey = 'auth_token';
  static const _roleKey = 'user_role';
  final _secure = const FlutterSecureStorage();

  Future<void> saveToken(String token) => _secure.write(key: _tokenKey, value: token);
  Future<String?> getToken() => _secure.read(key: _tokenKey);
  Future<void> clearToken() => _secure.delete(key: _tokenKey);

  Future<void> saveRole(String role) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_roleKey, role);
  }

  Future<String?> getRole() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_roleKey);
  }

  Future<void> clearAll() async {
    await clearToken();
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_roleKey);
  }
}
