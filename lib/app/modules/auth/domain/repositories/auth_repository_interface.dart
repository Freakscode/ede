import '../../models/user_model.dart';
import '../../models/auth_result.dart';
import '../../models/login_request_model.dart';

/// Interfaz del repositorio de autenticación
/// Define los contratos para las operaciones de autenticación
abstract class AuthRepository {
  /// Realizar login con credenciales
  Future<AuthResult> login(LoginRequestModel loginRequest);
  
  /// Cerrar sesión del usuario
  Future<void> logout();
  
  /// Obtener token de autenticación
  Future<String?> getToken();
  
  /// Verificar si el usuario está autenticado
  Future<bool> isLoggedIn();
  
  /// Guardar token de autenticación
  Future<void> saveToken(String token);
  
  /// Obtener usuario actual
  Future<UserModel?> getCurrentUser();
  
  /// Guardar información del usuario
  Future<void> saveUser(UserModel user);
  
  /// Limpiar datos de autenticación
  Future<void> clearAuthData();
}
