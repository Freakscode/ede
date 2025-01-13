// ignore_for_file: unused_local_variable, override_on_non_overriding_member, duplicate_import, unused_element

import 'dart:convert';
import 'package:crypto/crypto.dart';
import 'package:ede_final_app/config/security/security_config.dart';
import 'package:ede_final_app/data/datasources/remote_datasource.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'dart:developer' as developer;
import '../../domain/repositories/auth_repository.dart';
import 'package:dart_jsonwebtoken/dart_jsonwebtoken.dart';
import '../datasources/remote_datasource.dart';

class AuthRepository implements IAuthRepository {
  static const ACCESS_TOKEN_KEY = 'access_token';
  static const REFRESH_TOKEN_KEY = 'refresh_token';
  static const LAST_SYNC_KEY = 'last_sync';
  static const SIGNATURE_KEY = 'user_signature';
  
  final RemoteDatasource remoteDatasource;
  final _storage = const FlutterSecureStorage();
  
  AuthRepository({required this.remoteDatasource});
  
  String _encryptPassword(String password) {
    final bytes = utf8.encode(password);
    final digest = sha256.convert(bytes);
    return digest.toString();
  }

  Future<String?> getToken() async {
    return await _storage.read(key: ACCESS_TOKEN_KEY);
  }

  Future<void> deleteToken() async {
    await _storage.delete(key: ACCESS_TOKEN_KEY);
  }

  Future<void> saveSignature(String signaturePath) async {
    await _storage.write(key: SIGNATURE_KEY, value: signaturePath);
  }

  Future<String?> getSignature() async {
    return await _storage.read(key: SIGNATURE_KEY);
  }

  Future<void> deleteSignature() async {
    await _storage.delete(key: SIGNATURE_KEY);
  }

  @override
  Future<void> login(String cedula, String password) async {
    try {
      developer.log('Attempting login', name: 'AuthRepository');
      
      // Try online login first
      try {
        final result = await remoteDatasource.verifyCredentials(
          cedula: cedula,
          password: password,
        );

        if (result != null) {
          await _storage.write(key: ACCESS_TOKEN_KEY, value: result['access']);
          await _storage.write(key: REFRESH_TOKEN_KEY, value: result['refresh']);
          await _storage.write(
            key: LAST_SYNC_KEY, 
            value: DateTime.now().toIso8601String()
          );
          developer.log('Online login successful', name: 'AuthRepository');
          return;
        }
      } catch (e) {
        developer.log('Online login failed: $e', name: 'AuthRepository');
      }

      // Fallback to offline login
      final jwt = JWT(
        {
          'cedula': cedula,
          'exp': DateTime.now().add(const Duration(days: 30)).millisecondsSinceEpoch,
        },
        issuer: 'ede_final_app'
      );
      
      final offlineToken = jwt.sign(SecretKey(SecurityConfig.jwtSecretKey));
      await _storage.write(key: ACCESS_TOKEN_KEY, value: offlineToken);
      developer.log('Offline login successful', name: 'AuthRepository');

    } catch (e) {
      developer.log('Login failed: $e', name: 'AuthRepository');
      throw AuthException('Login failed: $e');
    }
  }

  Future<void> syncTokens() async {
    try {
      final lastSync = await _storage.read(key: LAST_SYNC_KEY);
      final accessToken = await _storage.read(key: ACCESS_TOKEN_KEY);
      
      // Only sync if we have a local token and haven't synced recently
      if (accessToken != null && 
          (lastSync == null || _shouldSync(DateTime.parse(lastSync)))) {
        
        final result = await remoteDatasource.refreshToken(accessToken);
        
        if (result != null) {
          await _storage.write(key: ACCESS_TOKEN_KEY, value: result['access']);
          await _storage.write(key: REFRESH_TOKEN_KEY, value: result['refresh']);
          await _storage.write(
            key: LAST_SYNC_KEY,
            value: DateTime.now().toIso8601String()
          );
          developer.log('Tokens synchronized', name: 'AuthRepository');
        }
      }
    } catch (e) {
      developer.log('Token sync failed: $e', name: 'AuthRepository');
    }
  }

  bool _shouldSync(DateTime lastSync) {
    final now = DateTime.now();
    return now.difference(lastSync).inHours >= 24; // Sync daily
  }

  @override
  Future<bool> hasToken() async {
    try {
      final token = await _storage.read(key: ACCESS_TOKEN_KEY);
      if (token == null) return false;
      
      // Try to verify token
      final jwt = JWT.verify(token, SecretKey(SecurityConfig.jwtSecretKey));
      return true;
    } catch (e) {
      // Token invalid/expired - try refresh
      try {
        final refreshToken = await _storage.read(key: REFRESH_TOKEN_KEY);
        if (refreshToken != null) {
          final result = await remoteDatasource.refreshToken(refreshToken);
          if (result != null) {
            await _storage.write(key: ACCESS_TOKEN_KEY, value: result['access']);
            return true;
          }
        }
      } catch (_) {
        // Refresh failed
      }
      
      await logout();
      return false;
    }
  }

  @override
  Future<void> logout() async {
    await _storage.delete(key: ACCESS_TOKEN_KEY);
    await _storage.delete(key: REFRESH_TOKEN_KEY);
    await _storage.delete(key: LAST_SYNC_KEY);
  }
}

class AuthException implements Exception {
  final String message;
  AuthException(this.message);
  
  @override
  String toString() => message;
}
