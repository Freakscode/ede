import 'package:equatable/equatable.dart';

/// Eventos base para el módulo de autenticación
abstract class AuthEvent extends Equatable {
  const AuthEvent();

  @override
  List<Object?> get props => [];
}

/// Evento para realizar login
class AuthLoginRequested extends AuthEvent {
  final String email;
  final String password;

  const AuthLoginRequested({
    required this.email,
    required this.password,
  });

  @override
  List<Object?> get props => [email, password];

  @override
  String toString() => 'AuthLoginRequested(email: $email)';
}

/// Evento para cerrar sesión
class AuthLogoutRequested extends AuthEvent {
  const AuthLogoutRequested();

  @override
  String toString() => 'AuthLogoutRequested()';
}

/// Evento para verificar estado de autenticación
class AuthStatusCheckRequested extends AuthEvent {
  const AuthStatusCheckRequested();

  @override
  String toString() => 'AuthStatusCheckRequested()';
}

/// Evento para limpiar errores
class AuthErrorCleared extends AuthEvent {
  const AuthErrorCleared();

  @override
  String toString() => 'AuthErrorCleared()';
}

/// Evento para verificar permisos de funcionalidad
class AuthPermissionCheckRequested extends AuthEvent {
  final String feature;

  const AuthPermissionCheckRequested({
    required this.feature,
  });

  @override
  List<Object?> get props => [feature];

  @override
  String toString() => 'AuthPermissionCheckRequested(feature: $feature)';
}
