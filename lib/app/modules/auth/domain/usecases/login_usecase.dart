import '../entities/auth_result_entity.dart';
import '../repositories/auth_repository_interface.dart';
import '../../data/models/login_request_model.dart';

/// Caso de uso para login
class LoginUseCase {
  final AuthRepository _authRepository;

  LoginUseCase(this._authRepository);

  /// Ejecutar login
  Future<AuthResultEntity> execute(LoginRequestModel loginRequest) async {
    // Validaciones de negocio
    if (loginRequest.cedula.isEmpty) {
      return AuthResultEntity.failure(
        message: 'La cédula es requerida',
        errorType: AuthErrorType.invalidCredentials,
      );
    }

    if (loginRequest.password.isEmpty) {
      return AuthResultEntity.failure(
        message: 'La contraseña es requerida',
        errorType: AuthErrorType.invalidCredentials,
      );
    }

    if (loginRequest.cedula.length < 6) {
      return AuthResultEntity.failure(
        message: 'La cédula debe tener al menos 6 caracteres',
        errorType: AuthErrorType.invalidCredentials,
      );
    }

    // Delegar al repositorio
    return await _authRepository.login(loginRequest);
  }

  /// Ejecutar login con credenciales directas
  Future<AuthResultEntity> executeWithCredentials({
    required String cedula,
    required String password,
  }) async {
    final loginRequest = LoginRequestModel.fromCredentials(
      cedula: cedula,
      password: password,
    );
    return await execute(loginRequest);
  }
}