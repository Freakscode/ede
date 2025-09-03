import 'package:shared_preferences/shared_preferences.dart';
import '../../domain/repositories/auth_repository.dart';

class AuthRepositoryImplementation implements AuthRepository {
  final SharedPreferences sharedPreferences;
  static const String _tokenKey = 'auth_token';

  AuthRepositoryImplementation({
    required this.sharedPreferences,
  });

  @override
  Future<String> login(String username, String password) async {
    // TODO: Implement actual login with remote API
    const fakeToken = 'fake_token_123';
    await saveToken(fakeToken);
    return fakeToken;
  }

  @override
  Future<void> logout() async {
    await sharedPreferences.remove(_tokenKey);
  }

  @override
  Future<String?> getToken() async {
    return sharedPreferences.getString(_tokenKey);
  }

  @override
  Future<bool> isLoggedIn() async {
    final token = await getToken();
    return token != null && token.isNotEmpty;
  }

  @override
  Future<void> saveToken(String token) async {
    await sharedPreferences.setString(_tokenKey, token);
  }
}
