import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart' as p;
import 'dart:developer' as developer;

class LocalDatabaseProvider {
  static const _databaseName = 'caja_herramientas.db';
  static const _databaseVersion = 1;

  static Future<Database> open() async {
    try {
      developer.log('Starting local database initialization', name: 'LocalDB');
      
      final dbPath = await getDatabasesPath();
      final path = p.join(dbPath, _databaseName);
      developer.log('Database path: $path', name: 'LocalDB');

      return await openDatabase(
        path,
        version: _databaseVersion,
        onCreate: (db, version) async {
          developer.log('Creating new database...', name: 'LocalDB');
          await db.execute('''
            CREATE TABLE IF NOT EXISTS users (
              user_id INTEGER PRIMARY KEY,
              nombre_completo TEXT,
              dependencia TEXT,
              cedula TEXT UNIQUE NOT NULL,
              firma TEXT,
              created_at TEXT,
              isSynced INTEGER DEFAULT 0
            )
          ''');
          developer.log('Users table created successfully', name: 'LocalDB');
        },
        onOpen: (db) {
          developer.log('Database opened successfully', name: 'LocalDB');
        },
      );
    } catch (e, stackTrace) {
      developer.log(
        'Failed to initialize local database', 
        name: 'LocalDB',
        error: e,
        stackTrace: stackTrace
      );
      rethrow;
    }
  }
}