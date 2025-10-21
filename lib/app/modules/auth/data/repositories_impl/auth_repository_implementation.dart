import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../../domain/repositories/auth_repository_interface.dart';
import '../../domain/entities/user_entity.dart';
import '../../domain/entities/auth_result_entity.dart';
import '../models/user_model.dart';
import '../models/login_request_model.dart';

/// Implementación del repositorio de autenticación
/// Maneja la persistencia local y las llamadas a la API
class AuthRepositoryImplementation implements AuthRepository {
  final SharedPreferences sharedPreferences;
  static const String _tokenKey = 'auth_token';
  static const String _userKey = 'auth_user';

  AuthRepositoryImplementation({
    required this.sharedPreferences,
  });

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
    return sharedPreferences.getString(_tokenKey);
  }

  @override
  Future<bool> isLoggedIn() async {
    final token = await getToken();
    final user = await getCurrentUser();
    final result = token != null && token.isNotEmpty && user != null;
    print('AuthRepository: isLoggedIn() - token: $token, user: $user, result: $result');
    return result;
  }

  @override
  Future<void> saveToken(String token) async {
    await sharedPreferences.setString(_tokenKey, token);
  }

  @override
  Future<UserEntity?> getCurrentUser() async {
    try {
      final userJson = sharedPreferences.getString(_userKey);
      print('AuthRepository: getCurrentUser() - userJson: $userJson');
      if (userJson != null) {
        final userMap = json.decode(userJson) as Map<String, dynamic>;
        print('AuthRepository: getCurrentUser() - userMap: $userMap');
        // Reconstruir usuario desde JSON guardado
        final userModel = UserModel.fromJson(userMap);
        final user = userModel.toEntity();
        print('AuthRepository: getCurrentUser() - user reconstruido: $user');
        return user;
      }
      print('AuthRepository: getCurrentUser() - userJson es null');
      return null;
    } catch (e) {
      print('AuthRepository: getCurrentUser() - error: $e');
      return null;
    }
  }

  @override
  Future<void> saveUser(UserEntity user) async {
    final userModel = UserModel.fromEntity(user);
    final userMap = userModel.toJson();
    await sharedPreferences.setString(_userKey, json.encode(userMap));
  }

  @override
  Future<void> clearAuthData() async {
    await sharedPreferences.remove(_tokenKey);
    await sharedPreferences.remove(_userKey);
  }
}