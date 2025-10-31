import 'dart:convert';
import 'package:hive/hive.dart';
import 'package:caja_herramientas/app/core/database/database_config.dart';
import '../../domain/entities/user_entity.dart';
import '../models/user_model.dart';

/// Interfaz para data source local de autenticación
abstract class AuthLocalDataSource {
  /// Obtener token guardado
  Future<String?> getToken();

  /// Guardar token
  Future<void> saveToken(String token);

  /// Obtener usuario actual
  Future<UserEntity?> getCurrentUser();

  /// Guardar usuario
  Future<void> saveUser(UserEntity user);

  /// Verificar si está logueado
  Future<bool> isLoggedIn();

  /// Limpiar todos los datos de autenticación
  Future<void> clearAuthData();
}

class AuthLocalDataSourceImpl implements AuthLocalDataSource {
  static const String _tokenKey = 'auth_token';
  static const String _userKey = 'auth_user';
  
  Box get _box => Hive.box(DatabaseConfig.authStorageBox);

  @override
  Future<String?> getToken() async {
    return _box.get(_tokenKey);
  }

  @override
  Future<void> saveToken(String token) async {
    await _box.put(_tokenKey, token);
  }

  @override
  Future<UserEntity?> getCurrentUser() async {
    try {
      final userJson = _box.get(_userKey);
      if (userJson != null) {
        final userMap = json.decode(userJson) as Map<String, dynamic>;
        final userModel = UserModel.fromJson(userMap);
        return userModel.toEntity();
      }
      return null;
    } catch (e) {
      return null;
    }
  }

  @override
  Future<void> saveUser(UserEntity user) async {
    final userModel = UserModel.fromEntity(user);
    await _box.put(_userKey, json.encode(userModel.toJson()));
  }

  @override
  Future<bool> isLoggedIn() async {
    final token = await getToken();
    final user = await getCurrentUser();
    return token != null && token.isNotEmpty && user != null;
  }

  @override
  Future<void> clearAuthData() async {
    await _box.delete(_tokenKey);
    await _box.delete(_userKey);
  }
}
