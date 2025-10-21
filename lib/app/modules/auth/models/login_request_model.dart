import 'package:equatable/equatable.dart';

/// Modelo para la petición de login a la API
class LoginRequestModel extends Equatable {
  final String cedula;
  final String password;

  const LoginRequestModel({
    required this.cedula,
    required this.password,
  });

  /// Factory method: Crear desde datos de entrada
  factory LoginRequestModel.fromCredentials({
    required String cedula,
    required String password,
  }) {
    return LoginRequestModel(
      cedula: cedula.trim(),
      password: password.trim(),
    );
  }

  /// Convertir a JSON para la API
  Map<String, dynamic> toJson() {
    return {
      'cedula': cedula,
      'password': password,
    };
  }

  /// Convertir a JSON para HTTP request
  Map<String, String> toHttpJson() {
    return {
      'cedula': cedula,
      'password': password,
    };
  }

  @override
  List<Object?> get props => [cedula, password];

  @override
  String toString() {
    return 'LoginRequestModel(cedula: $cedula, password: [HIDDEN])';
  }
}
