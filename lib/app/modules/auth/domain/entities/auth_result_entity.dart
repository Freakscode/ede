import 'package:equatable/equatable.dart';
import 'user_entity.dart';

/// Tipos de errores de autenticación
enum AuthErrorType {
  invalidCredentials,
  networkError,
  serverError,
  unknown,
}

/// Entidad de resultado de autenticación en el dominio
class AuthResultEntity extends Equatable {
  final bool success;
  final String message;
  final UserEntity? user;
  final AuthErrorType? errorType;

  const AuthResultEntity({
    required this.success,
    required this.message,
    this.user,
    this.errorType,
  });

  /// Factory constructor para éxito
  factory AuthResultEntity.success({
    required String message,
    required UserEntity user,
  }) {
    return AuthResultEntity(
      success: true,
      message: message,
      user: user,
    );
  }

  /// Factory constructor para fallo
  factory AuthResultEntity.failure({
    required String message,
    required AuthErrorType errorType,
  }) {
    return AuthResultEntity(
      success: false,
      message: message,
      errorType: errorType,
    );
  }

  /// Lógica de negocio: ¿Tiene error?
  bool get hasError => !success;

  /// Lógica de negocio: ¿Es éxito?
  bool get isSuccess => success;

  @override
  List<Object?> get props => [success, message, user, errorType];

  @override
  String toString() => 'AuthResultEntity(success: $success, message: $message)';
}
