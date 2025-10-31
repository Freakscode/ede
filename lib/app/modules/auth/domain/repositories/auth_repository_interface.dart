import '../entities/user_entity.dart';
import '../entities/auth_result_entity.dart';
import '../entities/login_params.dart';

/// Interfaz del repositorio de autenticación
abstract class IAuthRepository {
  /// Realizar login
  Future<AuthResultEntity> login(LoginParams loginParams);

  /// Cerrar sesión
  Future<void> logout();

  /// Obtener token actual
  Future<String?> getToken();

  /// Verificar si está logueado
  Future<bool> isLoggedIn();

  /// Guardar token
  Future<void> saveToken(String token);

  /// Obtener usuario actual
  Future<UserEntity?> getCurrentUser();

  /// Guardar usuario
  Future<void> saveUser(UserEntity user);

  /// Limpiar datos de autenticación
  Future<void> clearAuthData();
}