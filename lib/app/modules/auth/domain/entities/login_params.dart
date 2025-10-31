import 'package:equatable/equatable.dart';

/// Entidad de dominio para parámetros de login
/// Es independiente de la capa de datos
class LoginParams extends Equatable {
  final String email;
  final String password;

  const LoginParams({
    required this.email,
    required this.password,
  });

  /// Factory constructor desde credenciales
  factory LoginParams.fromCredentials({
    required String email,
    required String password,
  }) {
    return LoginParams(
      email: email,
      password: password,
    );
  }

  /// Validación básica
  bool get isValid => email.isNotEmpty && password.isNotEmpty;

  /// Validar formato de email
  bool get hasValidEmailFormat {
    final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    return emailRegex.hasMatch(email);
  }

  @override
  List<Object> get props => [email, password];

  @override
  String toString() => 'LoginParams(email: $email)';
}

