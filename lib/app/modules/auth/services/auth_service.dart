import '../interfaces/auth_interface.dart';
import '../models/user_model.dart';
import '../models/auth_result.dart';

/// Servicio de autenticación
/// Implementación concreta de AuthInterface
class AuthService implements AuthInterface {
  static final AuthService _instance = AuthService._internal();
  factory AuthService() => _instance;
  AuthService._internal();

  UserModel? _currentUser;
  
  @override
  UserModel? get currentUser {
    print('=== DEBUG AUTH SERVICE - currentUser ===');
    print('_currentUser: $_currentUser');
    return _currentUser;
  }
  
  @override
  bool get isLoggedIn {
    final result = _currentUser != null;
    print('=== DEBUG AUTH SERVICE - isLoggedIn ===');
    print('_currentUser: $_currentUser');
    print('isLoggedIn: $result');
    return result;
  }
  
  @override
  bool get isDagrdUser => _currentUser?.isDagrdUser ?? false;

  @override
  Future<AuthResult> login(String cedula, String password) async {
    try {
      // TEMPORAL: Siempre loguear como usuario DAGRD
      print('=== LOGIN TEMPORAL - USUARIO DAGRD ===');
      print('Cédula ingresada: ${cedula.trim()}');
      print('Contraseña ingresada: ${password.trim()}');
      
      // Simular delay de red
      await Future.delayed(const Duration(seconds: 1));
      
      // Obtener el primer usuario DAGRD disponible
      final dagrdUser = UserModel.simulatedUsers.firstWhere(
        (user) => user.isDagrdUser,
        orElse: () => UserModel.simulatedUsers.first, // Fallback al primer usuario
      );
      
      print('Usuario asignado: ${dagrdUser.nombre}, isDagrdUser: ${dagrdUser.isDagrdUser}');
      
      // Login exitoso como DAGRD
      _currentUser = dagrdUser;
      
      return AuthResult.success(
        message: 'Login exitoso como usuario DAGRD',
        user: dagrdUser,
      );
      
    } catch (e) {
      print('Error en login temporal: $e');
      return AuthResult.failure(
        message: 'Error inesperado durante el login',
        errorType: AuthErrorType.unknown,
      );
    }
  }

  @override
  Future<void> logout() async {
    _currentUser = null;
  }

  @override
  bool canAccessDagrdFeatures() {
    return isDagrdUser;
  }

  @override
  bool canAccessGeneralFeatures() {
    return isLoggedIn;
  }

  /// Método adicional: Verificar permisos específicos
  bool canAccessFeature(String feature) {
    if (!isLoggedIn) return false;
    
    switch (feature.toLowerCase()) {
      case 'risk_analysis':
      case 'evaluation':
      case 'data_registration':
        return canAccessDagrdFeatures();
      case 'view_reports':
      case 'basic_info':
        return canAccessGeneralFeatures();
      default:
        return false;
    }
  }

  /// Método adicional: Obtener información del usuario para debugging
  Map<String, dynamic> getUserInfo() {
    if (_currentUser == null) {
      return {'loggedIn': false};
    }
    
    return {
      'loggedIn': true,
      'cedula': _currentUser!.cedula,
      'nombre': _currentUser!.nombre,
      'isDagrdUser': _currentUser!.isDagrdUser,
      'cargo': _currentUser!.cargo,
      'dependencia': _currentUser!.dependencia,
      'canAccessDagrdFeatures': canAccessDagrdFeatures(),
      'canAccessGeneralFeatures': canAccessGeneralFeatures(),
    };
  }
}