abstract class IAuthRepository {
  Future<bool> hasToken();
  Future<void> login(String username, String password);
  Future<void> logout();
}