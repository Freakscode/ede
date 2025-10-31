import 'dart:developer';

import 'package:dio/dio.dart';

class AppInterceptors extends Interceptor {
  // final LocalAuthService _localAuthService = LocalAuthService();

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) async {
    List noRequiresAuthentication = ['/auth/login', '/auth/forgot-password'];

    options.headers.addAll({});

    int requiresToken = noRequiresAuthentication.indexWhere(
      (endpoint) => RegExp(endpoint, multiLine: true).hasMatch(options.path),
    );

    if (requiresToken == -1) {
      // Token quemado para pruebas
      const hardcodedToken = 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZCI6MTQ1LCJ1aWQiOiJ4c1NTS3UwOXNKYW9QdVJFcUNEYWphSkVTVGJwZDNhWjRJVUQiLCJpZEVtcHJlc2EiOjIsImF1dGhvcml6ZWQiOjEsInJvbCI6IkFkbWluaXN0cmFkb3IiLCJpYXQiOjE3NTMxOTc3MDksImV4cCI6MTc1MzI4NDEwOX0.VVdkTtZt_e-8Y1So_xgxBeSQfK8kj3drP2PErYBk-EM';
      options.headers.addAll({"Authorization": "Bearer $hardcodedToken"});
      // --- Para uso futuro: autenticación dinámica ---
      /*
      try {
        final token = await _localAuthService.getToken();
        if (token != null && token.isNotEmpty) {
          options.headers.addAll({"Authorization": "Bearer $token"});
        }
      } catch (_) {}
      */
    }

    super.onRequest(options, handler);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    String errorDescription = "";

    switch (err.type) {
      case DioExceptionType.cancel:
        errorDescription = "La solicitud al servidor API fue cancelada.";
        break;
      case DioExceptionType.connectionTimeout:
        errorDescription =
            "Tiempo de conexión agotado. Estamos trabajando para restablecer el servicio.";
        break;
      case DioExceptionType.unknown:
        errorDescription =
            "Parece que no estás conectado a Internet. Verifica tu conexión.";
        break;
      case DioExceptionType.receiveTimeout:
        errorDescription =
            "Tiempo de espera agotado al recibir datos del servidor API.";
        break;
      case DioExceptionType.badResponse:
        int? statusCode = err.response?.statusCode;
        String? responseCode = err.response?.data['code'];
        if (statusCode == 504) {
          errorDescription =
              "Tenemos problemas para comunicarnos con nuestras bases de datos. Inténtalo más tarde.";
        } else if (statusCode == 401) {
          errorDescription = _handleUnauthorized(responseCode);
        } else {
          errorDescription =
              "Respuesta no válida del servidor con código de estado: $statusCode.";
        }
        break;
      case DioExceptionType.sendTimeout:
        errorDescription =
            "Tiempo de espera agotado al enviar datos al servidor API.";
        break;
      case DioExceptionType.badCertificate:
        errorDescription =
            "Error de certificado SSL. Por favor, verifica la configuración de seguridad.";
        break;
      case DioExceptionType.connectionError:
        errorDescription =
            "Error de conexión. No se pudo establecer una conexión con el servidor.";
        break;
    }

    if (errorDescription.isNotEmpty) {
      log('Error: $errorDescription', name: "OnError Dio");
    }

    super.onError(err, handler);
  }

  String _handleUnauthorized(String? code) {
    const invalidCustomer = "INVALID_CUSTOMER";
    const loginInvalid = "LOGIN_INVALID";
    const invalidUserProfile = "INVALID_USER_PROFILE";

    if (code != invalidCustomer &&
        code != loginInvalid &&
        code != invalidUserProfile) {
      // callClearSession();
      return "Sesión no autorizada o expirada. Por favor, vuelve a iniciar sesión.";
    }

    return "Acceso no autorizado. Por favor, revisa tus credenciales.";
  }
}