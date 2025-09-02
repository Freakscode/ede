import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/evaluacion_model.dart';
import '../../env/environment.dart';

class RemoteApi {
  final http.Client client;
  final String baseUrl;

  RemoteApi({http.Client? client}) 
    : client = client ?? http.Client(),
      baseUrl = Environment.apiUrl;

  // Headers comunes para las peticiones
  Map<String, String> get _headers => {
    'Content-Type': 'application/json',
    'Accept': 'application/json',
  };

  Map<String, String> _headersWithAuth(String token) => {
    ..._headers,
    'Authorization': 'Bearer $token',
  };

  // Auth methods
  Future<Map<String, dynamic>> login(String username, String password) async {
    final response = await client.post(
      Uri.parse('$baseUrl/auth/login'),
      headers: _headers,
      body: json.encode({
        'username': username,
        'password': password,
      }),
    );

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Login failed: ${response.statusCode}');
    }
  }

  Future<void> logout(String token) async {
    final response = await client.post(
      Uri.parse('$baseUrl/auth/logout'),
      headers: _headersWithAuth(token),
    );

    if (response.statusCode != 200) {
      throw Exception('Logout failed: ${response.statusCode}');
    }
  }

  // Evaluaciones methods
  Future<List<EvaluacionModel>> getEvaluaciones(String token) async {
    final response = await client.get(
      Uri.parse('$baseUrl/evaluaciones'),
      headers: _headersWithAuth(token),
    );

    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      return data.map((json) => EvaluacionModel.fromJson(json)).toList();
    } else {
      throw Exception('Failed to get evaluaciones: ${response.statusCode}');
    }
  }

  Future<EvaluacionModel> createEvaluacion(String token, EvaluacionModel evaluacion) async {
    final response = await client.post(
      Uri.parse('$baseUrl/evaluaciones'),
      headers: _headersWithAuth(token),
      body: json.encode(evaluacion.toJson()),
    );

    if (response.statusCode == 201) {
      return EvaluacionModel.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to create evaluacion: ${response.statusCode}');
    }
  }

  Future<EvaluacionModel> updateEvaluacion(String token, EvaluacionModel evaluacion) async {
    final response = await client.put(
      Uri.parse('$baseUrl/evaluaciones/${evaluacion.id}'),
      headers: _headersWithAuth(token),
      body: json.encode(evaluacion.toJson()),
    );

    if (response.statusCode == 200) {
      return EvaluacionModel.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to update evaluacion: ${response.statusCode}');
    }
  }

  Future<void> deleteEvaluacion(String token, String id) async {
    final response = await client.delete(
      Uri.parse('$baseUrl/evaluaciones/$id'),
      headers: _headersWithAuth(token),
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to delete evaluacion: ${response.statusCode}');
    }
  }

  // Sync methods
  Future<List<EvaluacionModel>> syncEvaluaciones(String token, List<EvaluacionModel> evaluaciones) async {
    final response = await client.post(
      Uri.parse('$baseUrl/evaluaciones/sync'),
      headers: _headersWithAuth(token),
      body: json.encode({
        'evaluaciones': evaluaciones.map((e) => e.toJson()).toList(),
      }),
    );

    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      return data.map((json) => EvaluacionModel.fromJson(json)).toList();
    } else {
      throw Exception('Failed to sync evaluaciones: ${response.statusCode}');
    }
  }
}
