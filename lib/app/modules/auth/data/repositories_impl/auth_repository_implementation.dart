import '../../domain/repositories/auth_repository_interface.dart';
import '../../domain/entities/user_entity.dart';
import '../../domain/entities/auth_result_entity.dart';
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
    // Primero intentar autenticación contra la API
    final loginResult = await _authRemoteDataSource.login(loginRequest);
    
    // Si el login fue exitoso, guardar datos localmente
    if (loginResult.result.isSuccess && loginResult.result.user != null) {
      if (loginResult.token != null) {
        await saveToken(loginResult.token!);
      }
      await saveUser(loginResult.result.user!);
    }
    
    return loginResult.result;
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