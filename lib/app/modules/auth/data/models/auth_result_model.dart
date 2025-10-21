import '../../domain/entities/auth_result_entity.dart';
import 'user_model.dart';

/// Modelo de datos para resultado de autenticación
/// Mapea entre la capa de datos y el dominio
class AuthResultModel {
  final bool success;
  final String message;
  final UserModel? user;
  final AuthErrorType? errorType;

  const AuthResultModel({
    required this.success,
    required this.message,
    this.user,
    this.errorType,
  });

  /// Factory constructor para éxito
  factory AuthResultModel.success({
    required String message,
    required UserModel user,
  }) {
    return AuthResultModel(
      success: true,
      message: message,
      user: user,
    );
  }

  /// Factory constructor para fallo
  factory AuthResultModel.failure({
    required String message,
    required AuthErrorType errorType,
  }) {
    return AuthResultModel(
      success: false,
      message: message,
      errorType: errorType,
    );
  }

  /// Convertir a entidad del dominio
  AuthResultEntity toEntity() {
    return AuthResultEntity(
      success: success,
      message: message,
      user: user?.toEntity(),
      errorType: errorType,
    );
  }

  /// Crear desde entidad del dominio
  factory AuthResultModel.fromEntity(AuthResultEntity entity) {
    return AuthResultModel(
      success: entity.success,
      message: entity.message,
      user: entity.user != null ? UserModel.fromEntity(entity.user!) : null,
      errorType: entity.errorType,
    );
  }

  @override
  String toString() => 'AuthResultModel(success: $success, message: $message)';
}
