import '../models/user_model.dart';
import '../../models/auth_result.dart';

/// Servicio de autenticación (Legacy)
/// Mantiene compatibilidad con código existente
class AuthService {
  static final AuthService _instance = AuthService._internal();
  factory AuthService() => _instance;
  AuthService._internal();

  UserModel? _currentUser;
  
  UserModel? get currentUser => _currentUser;
  
  bool get isLoggedIn => _currentUser != null;
  
  bool get isDagrdUser => _currentUser?.isDagrdUser ?? false;

  Future<AuthResult> login(String cedula, String password) async {
    try {
      // Simular delay de red
      await Future.delayed(const Duration(seconds: 1));
      
      // Simular validación de credenciales
      if (cedula.trim().isEmpty || password.trim().isEmpty) {
        return AuthResult.failure(
          message: 'La cédula y contraseña son requeridas',
          errorType: AuthErrorType.invalidCredentials,
        );
      }
      
      // Obtener usuario DAGRD simulado
      final selectedUser = UserModel.getSimulatedDagrdUserByCedula(cedula);
      
      // Guardar usuario actual
      _currentUser = selectedUser;
      
      return AuthResult.success(
        message: 'Login exitoso (modo simulación)',
        user: selectedUser,
      );
      
    } catch (e) {
      return AuthResult.failure(
        message: 'Error inesperado durante el login simulado',
        errorType: AuthErrorType.unknown,
      );
    }
  }

  Future<void> logout() async {
    _currentUser = null;
  }

  bool canAccessDagrdFeatures() {
    return isDagrdUser;
  }

  bool canAccessGeneralFeatures() {
    return isLoggedIn;
  }

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

