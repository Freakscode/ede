import 'package:equatable/equatable.dart';

/// Entidad de dominio para parámetros de login
/// Es independiente de la capa de datos
class LoginParams extends Equatable {
  final String cedula;
  final String password;

  const LoginParams({
    required this.cedula,
    required this.password,
  });

  /// Factory constructor desde credenciales
  factory LoginParams.fromCredentials({
    required String cedula,
    required String password,
  }) {
    return LoginParams(
      cedula: cedula,
      password: password,
    );
  }

  /// Validación básica
  bool get isValid => cedula.isNotEmpty && password.isNotEmpty;

  /// Validar longitud mínima de cédula
  bool get hasValidCedulaLength => cedula.length >= 6;

  @override
  List<Object> get props => [cedula, password];

  @override
  String toString() => 'LoginParams(cedula: $cedula)';
}

