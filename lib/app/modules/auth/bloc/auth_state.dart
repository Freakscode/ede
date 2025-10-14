import 'package:equatable/equatable.dart';
import '../models/user_model.dart';
import '../models/auth_result.dart';

/// Estados del módulo de autenticación
abstract class AuthState extends Equatable {
  const AuthState();

  @override
  List<Object?> get props => [];
}

/// Estado inicial
class AuthInitial extends AuthState {
  const AuthInitial();

  @override
  String toString() => 'AuthInitial()';
}

/// Estado de carga durante login
class AuthLoading extends AuthState {
  const AuthLoading();

  @override
  String toString() => 'AuthLoading()';
}

/// Estado de autenticación exitosa
class AuthAuthenticated extends AuthState {
  final UserModel user;
  final String message;

  const AuthAuthenticated({
    required this.user,
    required this.message,
  });

  /// Lógica de negocio: ¿Es usuario DAGRD?
  bool get isDagrdUser => user.isDagrdUser;

  /// Lógica de negocio: ¿Es usuario general?
  bool get isGeneralUser => !user.isDagrdUser;

  /// Lógica de negocio: ¿Puede acceder a funciones DAGRD?
  bool get canAccessDagrdFeatures => user.canAccessDagrdFeatures;

  /// Lógica de negocio: ¿Puede acceder a funciones generales?
  bool get canAccessGeneralFeatures => user.canAccessGeneralFeatures;

  @override
  List<Object?> get props => [user, message];

  @override
  String toString() => 'AuthAuthenticated(user: ${user.nombre}, isDagrdUser: $isDagrdUser)';
}

/// Estado de no autenticado
class AuthUnauthenticated extends AuthState {
  final String? message;

  const AuthUnauthenticated({
    this.message,
  });

  @override
  List<Object?> get props => [message];

  @override
  String toString() => 'AuthUnauthenticated(message: $message)';
}

/// Estado de error
class AuthError extends AuthState {
  final String message;
  final AuthErrorType errorType;

  const AuthError({
    required this.message,
    required this.errorType,
  });

  @override
  List<Object?> get props => [message, errorType];

  @override
  String toString() => 'AuthError(message: $message, errorType: $errorType)';
}

/// Estado de verificación de permisos
class AuthPermissionChecked extends AuthState {
  final String feature;
  final bool hasPermission;
  final UserModel? user;

  const AuthPermissionChecked({
    required this.feature,
    required this.hasPermission,
    this.user,
  });

  @override
  List<Object?> get props => [feature, hasPermission, user];

  @override
  String toString() => 'AuthPermissionChecked(feature: $feature, hasPermission: $hasPermission)';
}
