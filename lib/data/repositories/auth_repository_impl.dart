import 'package:shared_preferences/shared_preferences.dart';
import '../../domain/repositories/repositories.dart';
import '../datasources/remote_api.dart';

class AuthRepositoryImpl implements AuthRepository {
  final RemoteApi remoteApi;
  final SharedPreferences sharedPreferences;

  static const String _tokenKey = 'auth_token';

  AuthRepositoryImpl({
    required this.remoteApi,
    required this.sharedPreferences,
  });

  @override
  Future<String> login(String username, String password) async {
    try {
      final response = await remoteApi.login(username, password);
      final token = response['token'] as String;
      
      // Store token locally
      await sharedPreferences.setString(_tokenKey, token);
      
      return token;
    } catch (e) {
      throw Exception('Login failed: $e');
    }
  }

  @override
  Future<void> logout() async {
    try {
      final token = await getStoredToken();
      if (token != null) {
        await remoteApi.logout(token);
      }
      // Clear local token
      await sharedPreferences.remove(_tokenKey);
    } catch (e) {
      // Still clear local token even if remote logout fails
      await sharedPreferences.remove(_tokenKey);
      throw Exception('Logout failed: $e');
    }
  }

  @override
  Future<String?> getStoredToken() async {
    return sharedPreferences.getString(_tokenKey);
  }

  @override
  Future<bool> isLoggedIn() async {
    final token = await getStoredToken();
    return token != null && token.isNotEmpty;
  }
}
