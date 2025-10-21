import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../../domain/repositories/auth_repository_interface.dart';
import '../../models/user_model.dart';
import '../../models/auth_result.dart';
import '../../models/login_request_model.dart';

/// Implementación del repositorio de autenticación
/// Maneja la persistencia local y las llamadas a la API
class AuthRepositoryImplementation implements AuthRepository {
  final SharedPreferences sharedPreferences;
  static const String _tokenKey = 'auth_token';
  static const String _userKey = 'auth_user';
  // static const String _apiUrl = 'https://sire.alcaldiabogota.gov.co/api/auth/login';

  AuthRepositoryImplementation({
    required this.sharedPreferences,
  });

  @override
  Future<AuthResult> login(LoginRequestModel loginRequest) async {
    try {
      // Simular delay de red
      await Future.delayed(const Duration(seconds: 1));
      
      // Simular validación de credenciales
      if (loginRequest.cedula.isEmpty || loginRequest.password.isEmpty) {
        return AuthResult.failure(
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
      await saveUser(selectedUser);
      
      return AuthResult.success(
        message: 'Login exitoso (modo simulación)',
        user: selectedUser,
      );
      
      // TODO: Cuando esté disponible el endpoint, descomentar el código de la API
      /*
      // Realizar llamada a la API
      final response = await http.post(
        Uri.parse(_apiUrl),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
        body: json.encode(loginRequest.toHttpJson()),
      );
      
      print('Respuesta API: ${response.statusCode}');
      
      if (response.statusCode == 200) {
        // Parsear respuesta
        final loginResponse = LoginResponseModel.fromJson(
          json.decode(response.body) as Map<String, dynamic>
        );
        
        if (loginResponse.isSuccess && loginResponse.data != null) {
          // Crear usuario desde la respuesta
          final userApi = loginResponse.data!.user;
          final user = UserModel.fromUserApiModel(userApi);
          
          // Guardar datos localmente
          await saveToken(loginResponse.data!.token);
          await saveUser(user);
          
          print('Login exitoso: ${user.nombre}');
          
          return AuthResult.success(
            message: loginResponse.message,
            user: user,
          );
        } else {
          return AuthResult.failure(
            message: loginResponse.message,
            errorType: AuthErrorType.invalidCredentials,
          );
        }
      } else {
        return AuthResult.failure(
          message: 'Error del servidor: ${response.statusCode}',
          errorType: AuthErrorType.serverError,
        );
      }
      */
    } catch (e) {
      return AuthResult.failure(
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
  Future<UserModel?> getCurrentUser() async {
    try {
      final userJson = sharedPreferences.getString(_userKey);
      print('AuthRepository: getCurrentUser() - userJson: $userJson');
      if (userJson != null) {
        final userMap = json.decode(userJson) as Map<String, dynamic>;
        print('AuthRepository: getCurrentUser() - userMap: $userMap');
        // Reconstruir usuario desde JSON guardado
        final user = UserModel(
          cedula: userMap['cedula'] ?? '',
          nombre: userMap['nombre'] ?? '',
          isDagrdUser: userMap['isDagrdUser'] ?? false,
          cargo: userMap['cargo'],
          dependencia: userMap['dependencia'],
          email: userMap['email'],
          telefono: userMap['telefono'],
        );
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
  Future<void> saveUser(UserModel user) async {
    final userMap = {
      'cedula': user.cedula,
      'nombre': user.nombre,
      'isDagrdUser': user.isDagrdUser,
      'cargo': user.cargo,
      'dependencia': user.dependencia,
      'email': user.email,
      'telefono': user.telefono,
    };
    await sharedPreferences.setString(_userKey, json.encode(userMap));
  }

  @override
  Future<void> clearAuthData() async {
    await sharedPreferences.remove(_tokenKey);
    await sharedPreferences.remove(_userKey);
  }
}
