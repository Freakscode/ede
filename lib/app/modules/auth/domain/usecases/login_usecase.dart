import '../repositories/auth_repository_interface.dart';
import '../../models/auth_result.dart';
import '../../models/login_request_model.dart';

/// Caso de uso para el login
/// Encapsula la lógica de negocio del proceso de autenticación
class LoginUseCase {
  final AuthRepository repository;
  
  LoginUseCase(this.repository);
  
  /// Ejecutar el proceso de login
  Future<AuthResult> execute(LoginRequestModel loginRequest) async {
    try {
      // Validaciones de negocio
      if (loginRequest.cedula.isEmpty) {
        return AuthResult.failure(
          message: 'La cédula es requerida',
          errorType: AuthErrorType.invalidCredentials,
        );
      }
      
      if (loginRequest.password.isEmpty) {
        return AuthResult.failure(
          message: 'La contraseña es requerida',
          errorType: AuthErrorType.invalidCredentials,
        );
      }
      
      // Llamar al repositorio
      final result = await repository.login(loginRequest);
      
      return result;
    } catch (e) {
      return AuthResult.failure(
        message: 'Error inesperado durante el login',
        errorType: AuthErrorType.unknown,
      );
    }
  }
  
  /// Ejecutar login con credenciales simples
  Future<AuthResult> executeWithCredentials(String cedula, String password) async {
    final loginRequest = LoginRequestModel.fromCredentials(
      cedula: cedula,
      password: password,
    );
    return execute(loginRequest);
  }
}