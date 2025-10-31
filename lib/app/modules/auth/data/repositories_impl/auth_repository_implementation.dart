import '../../domain/repositories/auth_repository_interface.dart';
import '../../domain/entities/user_entity.dart';
import '../../domain/entities/auth_result_entity.dart';
import '../models/user_model.dart';
import '../models/login_request_model.dart';
import '../datasources/auth_local_data_source.dart';
import '../datasources/auth_remote_data_source.dart';

/// Implementación del repositorio de autenticación
/// Maneja la persistencia local y las llamadas a la API
class AuthRepositoryImplementation implements IAuthRepository {
  final AuthLocalDataSource _authLocalDataSource;
  final AuthRemoteDataSource _authRemoteDataSource;

  AuthRepositoryImplementation({
    required AuthLocalDataSource authLocalDataSource,
    required AuthRemoteDataSource authRemoteDataSource,
  }) : _authLocalDataSource = authLocalDataSource,
       _authRemoteDataSource = authRemoteDataSource;

  @override
  Future<AuthResultEntity> login(LoginRequestModel loginRequest) async {
    try {
      // Simular delay de red
      await Future.delayed(const Duration(seconds: 1));
      
      // Simular validación de credenciales
      if (loginRequest.cedula.isEmpty || loginRequest.password.isEmpty) {
        return AuthResultEntity.failure(
          message: 'La cédula y contraseña son requeridas',
          errorType: AuthErrorType.invalidCredentials,
        );
      }
      
      // Obtener usuario DAGRD simulado usando los nuevos métodos helper
      final selectedUser = UserModel.getSimulatedDagrdUserByCedula(loginRequest.cedula);
      
      // Generar token simulado
      final simulatedToken = 'simulated_token_${DateTime.now().millisecondsSinceEpoch}';
      
      // Guardar datos localmente
      await saveToken(simulatedToken);
      await saveUser(selectedUser.toEntity());
      
      return AuthResultEntity.success(
        message: 'Login exitoso (modo simulación)',
        user: selectedUser.toEntity(),
      );
    } catch (e) {
      return AuthResultEntity.failure(
        message: 'Error inesperado durante el login simulado',
        errorType: AuthErrorType.unknown,
      );
    }
  }

  @override
  Future<void> logout() async {
    await clearAuthData();
  }

  @override
  Future<String?> getToken() async {
    return await _authLocalDataSource.getToken();
  }

  @override
  Future<bool> isLoggedIn() async {
    return await _authLocalDataSource.isLoggedIn();
  }

  @override
  Future<void> saveToken(String token) async {
    await _authLocalDataSource.saveToken(token);
  }

  @override
  Future<UserEntity?> getCurrentUser() async {
    return await _authLocalDataSource.getCurrentUser();
  }

  @override
  Future<void> saveUser(UserEntity user) async {
    await _authLocalDataSource.saveUser(user);
  }

  @override
  Future<void> clearAuthData() async {
    await _authLocalDataSource.clearAuthData();
  }
}