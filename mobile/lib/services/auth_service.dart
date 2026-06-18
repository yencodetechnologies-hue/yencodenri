import '../core/api/api_client.dart';
import 'storage_service.dart';

class AuthService {
  final ApiClient _api = ApiClient();
  final StorageService _storage = StorageService();

  Future<Map<String, dynamic>> register(Map<String, dynamic> data) async {
    return _api.post('/auth/register', data, auth: false);
  }

  Future<Map<String, dynamic>> sendOtp(String identifier, String purpose) async {
    return _api.post('/auth/send-otp', {'identifier': identifier, 'purpose': purpose}, auth: false);
  }

  Future<Map<String, dynamic>> verifyOtp(String identifier, String code, String purpose) async {
    final res = await _api.post('/auth/verify-otp', {
      'identifier': identifier,
      'code': code,
      'purpose': purpose,
    }, auth: false);
    if (res['data']?['token'] != null) {
      await _storage.saveToken(res['data']['token']);
      await _storage.saveRole(res['data']['user']?['role'] ?? 'user');
    }
    return res;
  }

  Future<Map<String, dynamic>> login(String identifier, String password) async {
    final res = await _api.post('/auth/login', {
      'identifier': identifier,
      'password': password,
    }, auth: false);
    await _storage.saveToken(res['data']['token']);
    await _storage.saveRole(res['data']['user']?['role'] ?? 'user');
    return res;
  }

  Future<Map<String, dynamic>> adminLogin(String email, String password) async {
    final res = await _api.post('/admin/login', {'email': email, 'password': password}, auth: false);
    await _storage.saveToken(res['data']['token']);
    await _storage.saveRole('admin');
    return res;
  }

  Future<Map<String, dynamic>> forgotPassword(String identifier) async {
    return _api.post('/auth/forgot-password', {'identifier': identifier}, auth: false);
  }

  Future<Map<String, dynamic>> resetPassword(Map<String, dynamic> data) async {
    return _api.post('/auth/reset-password', data, auth: false);
  }

  Future<void> logout() => _storage.clearAll();
}
