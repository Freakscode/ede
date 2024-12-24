// ignore_for_file: unused_local_variable, override_on_non_overriding_member

import 'dart:convert';
import 'package:crypto/crypto.dart';
import 'package:ede_final_app/data/datasources/remote_datasource.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../../domain/repositories/auth_repository.dart';

class AuthRepository implements IAuthRepository {
  final RemoteDatasource remoteDatasource;
  final _storage = const FlutterSecureStorage();
  
  AuthRepository({required this.remoteDatasource});
  
  String _encryptPassword(String password) {
    final bytes = utf8.encode(password);
    final digest = sha256.convert(bytes);
    return digest.toString();
  }

  @override
  Future<void> login(String cedula, String password) async {
    try {
      final encryptedPassword = _encryptPassword(password);
      final result = await remoteDatasource.verifyCredentials(
        cedula: cedula,
        passwordHash: encryptedPassword,
      );

      if (result != null) {
        final token = 'user_${result.userId}_token';
        await _storage.write(key: 'auth_token', value: token);
      } else {
        throw AuthException('Credenciales inválidas');
      }
    } catch (e) {
      throw AuthException('Error de autenticación: ${e.toString()}');
    }
  }

  @override
  Future<bool> hasToken() async {
    final token = await _storage.read(key: 'auth_token');
    return token != null;
  }

  @override
  Future<String?> getToken() async {
    return await _storage.read(key: 'auth_token');
  }

  @override
  Future<void> logout() async {
    await _storage.delete(key: 'auth_token');
  }
}

class AuthException implements Exception {
  final String message;
  AuthException(this.message);
  
  @override
  String toString() => message;
}
