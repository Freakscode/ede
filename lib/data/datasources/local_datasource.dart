import 'package:ede_final_app/data/models/user_model.dart';
import 'package:sqflite/sqflite.dart';
import '../models/data_model.dart';
import 'dart:developer' as developer;

class LocalDataSource {
  final Database database;

  LocalDataSource(this.database) {
    developer.log('LocalDataSource initialized', name: 'LocalDB');
  }

  Future<void> insertData(DataModel data) async {
    await database.insert(
      'data',
      data.toJson(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<void> insertUser(UserModel user) async {
    try {
      developer.log('Inserting user ${user.userId}...', name: 'LocalDB');
      await database.insert(
        'users', // Asume que tu tabla local también se llama "users"
        {
          'user_id': user.userId,
          'nombre_completo': user.nombreCompleto,
          'dependencia': user.dependencia,
          'firma': user.firma,
          'created_at': user.createdAt.toIso8601String(),
          'isSynced': 0,
        },
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
      developer.log('User ${user.userId} inserted successfully', name: 'LocalDB');
    } catch (e) {
      developer.log('Failed to insert user: $e', name: 'LocalDB', error: e);
      rethrow;
    }
  }

  Future<List<UserModel>> getAllUsers() async {
    try {
      developer.log('Fetching all users from local DB...', name: 'LocalDB');
      final List<Map<String, dynamic>> maps = await database.query('users');
      developer.log('Found ${maps.length} users in local DB', name: 'LocalDB');
      return List.generate(maps.length, (i) => UserModel.fromRow(maps[i]));
    } catch (e) {
      developer.log('Failed to fetch users: $e', name: 'LocalDB', error: e);
      rethrow;
    }
  }

  Future<List<DataModel>> getAllData() async {
    final List<Map<String, dynamic>> maps = await database.query('data');
    developer.log('Local DB: fetched ${maps.length} data rows', name: 'LocalDataSource');
    return List.generate(maps.length, (i) => DataModel.fromJson(maps[i]));
  }

  Future<List<DataModel>> getUnsyncedData() async {
    final List<Map<String, dynamic>> maps = await database.query(
      'data',
      where: 'isSynced = ?',
      whereArgs: [0],
    );
    return List.generate(maps.length, (i) => DataModel.fromJson(maps[i]));
  }

  Future<List<UserModel>> getUnsyncedUsers() async {
    final List<Map<String, dynamic>> maps = await database.query(
      'users',
      where: 'isSynced = ?',
      whereArgs: [0],
    );
    return maps.map((row) => UserModel.fromRow(row)).toList();
  }

  Future<void> markUserAsSynced(int userId) async {
    await database.update(
      'users',
      {'isSynced': 1},
      where: 'user_id = ?',
      whereArgs: [userId],
    );
  }
}