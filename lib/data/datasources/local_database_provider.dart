import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart' as p;

class LocalDatabaseProvider {
  static const _databaseName = 'ede_app.db';
  static const _databaseVersion = 1;

  static Future<Database> open() async {
    final dbPath = await getDatabasesPath();
    final path = p.join(dbPath, _databaseName);

    return openDatabase(
      path,
      version: _databaseVersion,
      onCreate: (db, version) async {
        // Example table for users
        await db.execute('''
          CREATE TABLE IF NOT EXISTS users (
            user_id INTEGER PRIMARY KEY,
            nombre_completo TEXT,
            dependencia TEXT,
            cedula TEXT UNIQUE NOT NULL,
            firma TEXT,
            created_at TEXT
          )
        ''');
      },
    );
  }
}