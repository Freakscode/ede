import '../models/user_model.dart';
import '../models/auth_result.dart';

/// Interface para autenticación
/// Sigue el principio de inversión de dependencias (DIP)
abstract class AuthInterface {
  /// Realizar login con cédula y contraseña
  Future<AuthResult> login(String cedula, String password);
  
  /// Cerrar sesión
  Future<void> logout();
  
  /// Obtener usuario actual
  UserModel? get currentUser;
  
  /// Verificar si hay usuario logueado
  bool get isLoggedIn;
  
  /// Verificar si el usuario actual es DAGRD
  bool get isDagrdUser;
  
  /// Verificar si puede acceder a funcionalidades DAGRD
  bool canAccessDagrdFeatures();
  
  /// Verificar si puede acceder a funcionalidades generales
  bool canAccessGeneralFeatures();
  
  /// Verificar permisos específicos de funcionalidad
  bool canAccessFeature(String feature);
  
  /// Obtener información del usuario actual
  Map<String, dynamic> getUserInfo();
}
