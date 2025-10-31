import 'package:dio/dio.dart';
import '../../domain/entities/auth_result_entity.dart';
import '../models/login_request_model.dart';
import '../models/user_model.dart';

/// Interfaz para data source remoto de autenticación
abstract class AuthRemoteDataSource {
  /// Realizar login contra la API
  Future<AuthResultEntity> login(LoginRequestModel loginRequest);

  /// Realizar logout contra la API
  Future<void> logout();
}

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final Dio dio;

  AuthRemoteDataSourceImpl({required this.dio});

  @override
  Future<AuthResultEntity> login(LoginRequestModel loginRequest) async {
    try {
      final response = await dio.post(
        '/auth/login', // TODO: Configurar endpoint correcto
        data: {
          'cedula': loginRequest.cedula,
          'password': loginRequest.password,
        },
      );

      if (response.statusCode == 200) {
        final data = response.data;
        final userData = data['user'];
        
        final userModel = UserModel.fromApiResponse(userData);
        
        return AuthResultEntity.success(
          message: 'Login exitoso',
          user: userModel.toEntity(),
        );
      }
      
      return AuthResultEntity.failure(
        message: 'Error de autenticación',
        errorType: AuthErrorType.invalidCredentials,
      );
    } on DioException catch (e) {
      return AuthResultEntity.failure(
        message: e.response?.data['message'] ?? 'Error de conexión',
        errorType: _mapErrorType(e.type),
      );
    } catch (e) {
      return AuthResultEntity.failure(
        message: 'Error inesperado: $e',
        errorType: AuthErrorType.unknown,
      );
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
      print('Error during logout: ${e.message}');
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
