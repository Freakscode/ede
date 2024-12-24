import 'package:ede_final_app/data/models/user_model.dart';
import 'package:sqflite/sqflite.dart';
import '../models/data_model.dart';

class LocalDataSource {
  final Database database;

  LocalDataSource(this.database);

  Future<void> insertData(DataModel data) async {
    await database.insert(
      'data',
      data.toJson(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<void> insertUser(UserModel user) async {
    await database.insert(
      'users', // Asume que tu tabla local también se llama "users"
      {
        'user_id': user.userId,
        'nombre_completo': user.nombreCompleto,
        'dependencia': user.dependencia,
        'firma': user.firma,
        'created_at': user.createdAt.toIso8601String(),
      },
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<List<DataModel>> getAllData() async {
    final List<Map<String, dynamic>> maps = await database.query('data');
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
}