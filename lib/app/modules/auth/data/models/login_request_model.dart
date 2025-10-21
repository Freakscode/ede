/// Modelo de datos para request de login
class LoginRequestModel {
  final String cedula;
  final String password;

  const LoginRequestModel({
    required this.cedula,
    required this.password,
  });

  /// Factory constructor desde credenciales
  factory LoginRequestModel.fromCredentials({
    required String cedula,
    required String password,
  }) {
    return LoginRequestModel(
      cedula: cedula,
      password: password,
    );
  }

  /// Serialización para API
  Map<String, dynamic> toJson() {
    return {
      'cedula': cedula,
      'password': password,
    };
  }

  /// Deserialización desde API
  factory LoginRequestModel.fromJson(Map<String, dynamic> json) {
    return LoginRequestModel(
      cedula: json['cedula'] ?? '',
      password: json['password'] ?? '',
    );
  }

  /// Validación básica
  bool get isValid => cedula.isNotEmpty && password.isNotEmpty;

  @override
  String toString() => 'LoginRequestModel(cedula: $cedula)';
}
