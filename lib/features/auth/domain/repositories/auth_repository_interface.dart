abstract class AuthRepository {
  Future<String> login(String username, String password);
  Future<void> logout();
  Future<String?> getToken();
  Future<bool> isLoggedIn();
  Future<void> saveToken(String token);
}
