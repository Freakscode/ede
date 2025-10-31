import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:caja_herramientas/app/core/http/api.dart';
import '../../domain/entities/auth_result_entity.dart';
import '../models/login_request_model.dart';
import '../models/user_model.dart';

/// Resultado temporal para manejar token desde la API
class LoginResult {
  final AuthResultEntity result;
  final String? token;

  LoginResult({
    required this.result,
    this.token,
  });
}

/// Interfaz para data source remoto de autenticación
abstract class AuthRemoteDataSource {
  /// Realizar login contra la API
  Future<LoginResult> login(LoginRequestModel loginRequest);

  /// Realizar logout contra la API
  Future<void> logout();
}

class AuthRemoteDataSourceImpl extends ApiProvider implements AuthRemoteDataSource {
  AuthRemoteDataSourceImpl();

  @override
  Future<LoginResult> login(LoginRequestModel loginRequest) async {
    try {
      final response = await dio.post(
        '/auth/login',
        data: {
          'cedula': loginRequest.cedula,
          'password': loginRequest.password,
        },
      );

      if (response.statusCode == 200) {
        final responseData = response.data;
        
        // La respuesta tiene la estructura: { success, message, data: { token, user } }
        final data = responseData['data'] ?? responseData;
        final userData = data['user'] ?? {};
        final token = data['token'] as String?;
        
        final userModel = UserModel.fromApiResponse(userData);
        
        final result = AuthResultEntity.success(
          message: responseData['message'] ?? 'Login exitoso',
          user: userModel.toEntity(),
        );
        
        return LoginResult(result: result, token: token);
      }
      
      final result = AuthResultEntity.failure(
        message: 'Error de autenticación',
        errorType: AuthErrorType.invalidCredentials,
      );
      
      return LoginResult(result: result);
    } on DioException catch (e) {
      final result = AuthResultEntity.failure(
        message: e.response?.data['message'] ?? 'Error de conexión',
        errorType: _mapErrorType(e.type),
      );
      
      return LoginResult(result: result);
    } catch (e) {
      final result = AuthResultEntity.failure(
        message: 'Error inesperado: $e',
        errorType: AuthErrorType.unknown,
      );
      
      return LoginResult(result: result);
    }
  }

  @override
  Future<void> logout() async {
    try {
      await dio.post(
        '/auth/logout', // TODO: Configurar endpoint correcto
      );
    } on DioException catch (e) {
      // Log error but don't throw - logout should succeed even if API fails
      log('Error during logout: ${e.message}', name: 'AuthRemoteDataSource');
    }
  }

  /// Mapear error de Dio a AuthErrorType
  AuthErrorType _mapErrorType(DioExceptionType type) {
    switch (type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        return AuthErrorType.networkError;
      case DioExceptionType.badResponse:
        return AuthErrorType.invalidCredentials;
      default:
        return AuthErrorType.unknown;
    }
  }
}
