import '../entities/user_entity.dart';
import '../entities/auth_result_entity.dart';
import '../../data/models/login_request_model.dart';

/// Interfaz del repositorio de autenticación
abstract class AuthRepository {
  /// Realizar login
  Future<AuthResultEntity> login(LoginRequestModel loginRequest);

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