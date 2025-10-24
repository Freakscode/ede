import 'package:equatable/equatable.dart';
import 'user_api_model.dart';

/// Modelo para la respuesta completa de la API de login
class LoginResponseModel extends Equatable {
  final bool success;
  final String message;
  final LoginDataModel? data;
  final String timestamp;
  final String? error;
  final int? statusCode;

  const LoginResponseModel({
    required this.success,
    required this.message,
    this.data,
    required this.timestamp,
    this.error,
    this.statusCode,
  });

  /// Factory method: Crear desde JSON de la API
  factory LoginResponseModel.fromJson(Map<String, dynamic> json) {
    return LoginResponseModel(
      success: json['success'] as bool,
      message: json['message'] as String,
      data: json['data'] != null 
          ? LoginDataModel.fromJson(json['data'] as Map<String, dynamic>)
          : null,
      timestamp: json['timestamp'] as String,
      error: json['error'] as String?,
    );
  }

  /// Factory method: Crear respuesta de error
  factory LoginResponseModel.error({
    required String message,
    String? error,
    int? statusCode,
  }) {
    return LoginResponseModel(
      success: false,
      message: message,
      data: null,
      timestamp: DateTime.now().toIso8601String(),
      error: error,
      statusCode: statusCode,
    );
  }

  /// Convertir a JSON
  Map<String, dynamic> toJson() {
    return {
      'success': success,
      'message': message,
      'data': data?.toJson(),
      'timestamp': timestamp,
      'error': error,
      'statusCode': statusCode,
    };
  }

  /// Verificar si la respuesta es exitosa
  bool get isSuccess => success && data != null;

  /// Verificar si hay error
  bool get hasError => !success || error != null;

  /// Obtener mensaje de error
  String get errorMessage => error ?? message;

  @override
  List<Object?> get props => [
        success,
        message,
        data,
        timestamp,
        error,
        statusCode,
      ];

  @override
  String toString() {
    return 'LoginResponseModel(success: $success, message: $message, hasData: ${data != null})';
  }
}

/// Modelo para los datos de la respuesta de login
class LoginDataModel extends Equatable {
  final String token;
  final String tokenType;
  final UserApiModel user;
  final String connectionStatus;

  const LoginDataModel({
    required this.token,
    required this.tokenType,
    required this.user,
    required this.connectionStatus,
  });

  /// Factory method: Crear desde JSON de la API
  factory LoginDataModel.fromJson(Map<String, dynamic> json) {
    return LoginDataModel(
      token: json['token'] as String,
      tokenType: json['token_type'] as String,
      user: UserApiModel.fromJson(json['user'] as Map<String, dynamic>),
      connectionStatus: json['connection_status'] as String,
    );
  }

  /// Convertir a JSON
  Map<String, dynamic> toJson() {
    return {
      'token': token,
      'token_type': tokenType,
      'user': user.toJson(),
      'connection_status': connectionStatus,
    };
  }

  /// Verificar si la conexión fue exitosa
  bool get isConnectionSuccess => connectionStatus == 'success';

  /// Obtener token completo con tipo
  String get fullToken => '$tokenType $token';

  @override
  List<Object?> get props => [
        token,
        tokenType,
        user,
        connectionStatus,
      ];

  @override
  String toString() {
    return 'LoginDataModel(tokenType: $tokenType, user: ${user.nombreCompleto}, connectionStatus: $connectionStatus)';
  }
}
