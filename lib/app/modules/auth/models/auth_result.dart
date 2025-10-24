import 'package:equatable/equatable.dart';
import 'user_model.dart';

/// Resultado de autenticación
/// Value Object que encapsula el resultado de una operación de login
class AuthResult extends Equatable {
  final bool success;
  final String message;
  final UserModel? user;
  final AuthErrorType? errorType;

  const AuthResult({
    required this.success,
    required this.message,
    this.user,
    this.errorType,
  });

  /// Crear resultado exitoso
  factory AuthResult.success({
    required String message,
    required UserModel user,
  }) {
    return AuthResult(
      success: true,
      message: message,
      user: user,
    );
  }

  /// Crear resultado fallido
  factory AuthResult.failure({
    required String message,
    AuthErrorType errorType = AuthErrorType.unknown,
  }) {
    return AuthResult(
      success: false,
      message: message,
      errorType: errorType,
    );
  }

  /// Lógica de negocio: ¿Es exitoso?
  bool get isFailure => !success;

  /// Lógica de negocio: ¿Es usuario DAGRD?
  bool get isDagrdUser => user?.isDagrdUser ?? false;

  /// Lógica de negocio: ¿Es usuario general?
  bool get isGeneralUser => user?.isDagrdUser == false;

  /// Lógica de negocio: ¿Tiene usuario?
  bool get hasUser => user != null;

  @override
  List<Object?> get props => [success, message, user, errorType];

  @override
  String toString() {
    return 'AuthResult(success: $success, message: $message, '
           'hasUser: $hasUser, isDagrdUser: $isDagrdUser, errorType: $errorType)';
  }
}

/// Tipos de errores de autenticación
enum AuthErrorType {
  invalidCredentials,
  userNotFound,
  networkError,
  serverError,
  unknown,
}

/// Extension para obtener mensajes de error en español
extension AuthErrorTypeExtension on AuthErrorType {
  String get message {
    switch (this) {
      case AuthErrorType.invalidCredentials:
        return 'Credenciales inválidas';
      case AuthErrorType.userNotFound:
        return 'Usuario no encontrado';
      case AuthErrorType.networkError:
        return 'Error de conexión';
      case AuthErrorType.serverError:
        return 'Error del servidor';
      case AuthErrorType.unknown:
        return 'Error desconocido';
    }
  }
}
