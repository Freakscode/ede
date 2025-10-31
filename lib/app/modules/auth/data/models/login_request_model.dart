/// Modelo de datos para request de login
class LoginRequestModel {
  final String email;
  final String password;

  const LoginRequestModel({
    required this.email,
    required this.password,
  });

  /// Factory constructor desde credenciales
  factory LoginRequestModel.fromCredentials({
    required String email,
    required String password,
  }) {
    return LoginRequestModel(
      email: email,
      password: password,
    );
  }

  /// Serialización para API
  Map<String, dynamic> toJson() {
    return {
      'email': email,
      'password': password,
    };
  }

  /// Deserialización desde API
  factory LoginRequestModel.fromJson(Map<String, dynamic> json) {
    return LoginRequestModel(
      email: json['email'] ?? '',
      password: json['password'] ?? '',
    );
  }

  /// Validación básica
  bool get isValid => email.isNotEmpty && password.isNotEmpty;

  @override
  String toString() => 'LoginRequestModel(email: $email)';
}
