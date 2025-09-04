import 'dart:convert';
import 'package:caja_herramientas/env/environment.dart';
import 'package:http/http.dart' as http;
import 'dart:developer' as developer;

class RemoteDatasource {
  final String baseUrl;
  final http.Client client;
  // Auth credentials
  final String username = Environment.userBackend;
  final String password = Environment.passwordBackend;

  RemoteDatasource._({
    required this.baseUrl,
    required this.client,
  });

  String get _authHeader =>
      'Basic ${base64Encode(utf8.encode('$username:$password'))}';

  static Future<RemoteDatasource> create() async {
    // Update baseUrl to point to your Django API
    const baseUrl = 'http://192.168.1.139:8000/api/v1';
    final client = http.Client();
    developer.log('RemoteDataSource initialized with baseUrl: $baseUrl', name: 'API');
    return RemoteDatasource._(baseUrl: baseUrl, client: client);
  }

  Future<Map<String, dynamic>?> verifyCredentials({
    required String cedula,
    required String password,
  }) async {
    final url = Uri.parse('$baseUrl/auth/login/');
    final requestBody = {
      'cedula': cedula,
      'password': password,
    };

    try {
      developer.log(
        'Sending POST to $url with body: ${jsonEncode(requestBody)}',
        name: 'RemoteDatasource'
      );
      final response = await client.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(requestBody),
      );

      developer.log(
        'Response status: ${response.statusCode}, body: ${response.body}',
        name: 'RemoteDatasource'
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return data;
      } else {
        return null;
      }
    } catch (e, stacktrace) {
      developer.log(
        'Error during verifyCredentials',
        name: 'RemoteDatasource',
        error: e,
        stackTrace: stacktrace
      );
      throw DatabaseException('Error de autenticación: $e');
    }
  }

  Future<List<Map<String, dynamic>>> fetchById(String id) async {
    try {
      final response = await client.get(
        Uri.parse('$baseUrl/users/$id'),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body) as List;
        return data.map((item) => item as Map<String, dynamic>).toList();
      } else {
        return [];
      }
    } catch (e) {
      throw DatabaseException('Error al obtener datos: $e');
    }
  }

  Future<List<Map<String, dynamic>>> fetchAllData() async {
    try {
      final response = await client.get(Uri.parse('$baseUrl/v1/data/'));
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body) as List;
        return data.map((e) => e as Map<String, dynamic>).toList();
      } else {
        return [];
      }
    } catch (e) {
      throw DatabaseException('Error al obtener datos: $e');
    }
  }

  Future<List<Map<String, dynamic>>> fetchAllUsers() async {
    try {
      developer.log('Fetching users from: $baseUrl/v1/users/', name: 'API');
      
      final response = await client.get(
        Uri.parse('$baseUrl/v1/users/'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': _authHeader,
        },
      );

      developer.log('Response status: ${response.statusCode}', name: 'API');

      switch (response.statusCode) {
        case 200:
          final data = jsonDecode(response.body) as List;
          return data.map((e) => e as Map<String, dynamic>).toList();
        case 401:
        case 403:
          throw DatabaseException('Authentication failed');
        default:
          throw DatabaseException(
            'Server error: ${response.statusCode}\nBody: ${response.body}'
          );
      }
    } catch (e, stackTrace) {
      developer.log(
        'Failed to fetch users', 
        name: 'API',
        error: e,
        stackTrace: stackTrace
      );
      rethrow;
    }
  }

  Future<void> createUser(Map<String, dynamic> userData) async {
    try {
      final response = await client.post(
        Uri.parse('$baseUrl/v1/users/'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(userData),
      );
      if (response.statusCode != 201) {
        throw DatabaseException('Error al crear usuario: ${response.statusCode}');
      }
    } catch (e) {
      throw DatabaseException('Error de red al crear usuario: $e');
    }
  }

  Future<Map<String, dynamic>?> refreshToken(String token) async {
    try {
      final response = await client.post(
        Uri.parse('$baseUrl/auth/token/refresh/'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      }
      return null;
    } catch (e) {
      developer.log('Token refresh failed: $e', name: 'API');
      throw DatabaseException('Token refresh failed: $e');
    }
  }
}

class DatabaseException implements Exception {
  final String message;
  DatabaseException(this.message);

  @override
  String toString() => message;
}
