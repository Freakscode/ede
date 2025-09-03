import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../data/models/evaluacion_model.dart';

class LocalDatabase {
  final Database database;

  LocalDatabase(this.database);

  static Future<Database> initDatabase() async {
    final databasesPath = await getDatabasesPath();
    final path = join(databasesPath, 'ede_database.db');

    return await openDatabase(
      path,
      version: 1,
      onCreate: (Database db, int version) async {
        await db.execute('''
          CREATE TABLE evaluaciones (
            id TEXT PRIMARY KEY,
            data TEXT NOT NULL,
            synced INTEGER DEFAULT 0,
            created_at TEXT NOT NULL,
            updated_at TEXT NOT NULL
          )
        ''');
        
        await db.execute('''
          CREATE TABLE users (
            id TEXT PRIMARY KEY,
            username TEXT NOT NULL,
            token TEXT,
            created_at TEXT NOT NULL
          )
        ''');
      },
    );
  }

  // Evaluaciones methods
  Future<void> insertEvaluacion(EvaluacionModel evaluacion) async {
    await database.insert(
      'evaluaciones',
      evaluacion.toJson(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<List<EvaluacionModel>> getAllEvaluaciones() async {
    final List<Map<String, dynamic>> maps = await database.query('evaluaciones');
    return List.generate(maps.length, (i) {
      return EvaluacionModel.fromJson(maps[i]);
    });
  }

  Future<List<EvaluacionModel>> getUnsyncedEvaluaciones() async {
    final List<Map<String, dynamic>> maps = await database.query(
      'evaluaciones',
      where: 'synced = ?',
      whereArgs: [0],
    );
    return List.generate(maps.length, (i) {
      return EvaluacionModel.fromJson(maps[i]);
    });
  }

  Future<void> markEvaluacionAsSynced(String id) async {
    await database.update(
      'evaluaciones',
      {'synced': 1, 'updated_at': DateTime.now().toIso8601String()},
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<void> deleteEvaluacion(String id) async {
    await database.delete(
      'evaluaciones',
      where: 'id = ?',
      whereArgs: [id],
    );
  }
}
