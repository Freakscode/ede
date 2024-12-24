import '../repositories/auth_repository.dart';

class LoginUseCase {
  final IAuthRepository repository;
  
  LoginUseCase(this.repository);
  
  Future<void> execute(String username, String password) {
    return repository.login(username, password);
  }
}