import 'dart:io';

import 'package:ede_final_app/config/database/database_config.dart';
import 'package:ede_final_app/data/models/user_model.dart';
import 'package:postgres/postgres.dart';
import 'dart:developer' as developer;

class RemoteDatasource {
  Connection? _conn;
  bool _isConnected = false;
  static const _maxRetries = 3;

  final String host;
  final int port;
  final String database;
  final String username;
  final String password;

  RemoteDatasource._({
    required this.host,
    required this.port,
    required this.database,
    required this.username,
    required this.password,
  });

  static Future<RemoteDatasource> create() async {
    final datasource = RemoteDatasource._(
      host: DatabaseConfig.host,
      port: DatabaseConfig.port, 
      database: DatabaseConfig.database,
      username: DatabaseConfig.username,
      password: DatabaseConfig.password,
    );

    await datasource._tryConnection();
    return datasource;
  }

  Future<void> _tryConnection() async {
    for (var i = 0; i < _maxRetries; i++) {
      try {
        await openConnection();
        return;
      } catch (e) {
        developer.log(
          'Connection attempt ${i + 1} failed: $e',
          name: 'RemoteDataSource',
        );
        if (i == _maxRetries - 1) rethrow;
        await Future.delayed(Duration(seconds: 1));
      }
    }
  }

  Future<void> openConnection() async {
    try {
      if (_conn == null || !_isConnected) {
        developer.log('''
Attempting PostgreSQL connection with:
- Host: $host
- Port: $port
- Database: $database
- Username: $username
''', name: 'RemoteDataSource');

        _conn = await Connection.open(
          Endpoint(
            host: host,
            port: port,
            database: database,
            username: username,
            password: password,
          ),
          settings: const ConnectionSettings(
            sslMode: SslMode.disable,
            connectTimeout: Duration(seconds: 30),
          ),
        );
        _isConnected = true;
        developer.log('PostgreSQL connection established successfully', 
          name: 'RemoteDataSource');
      }
    } on SocketException catch (e) {
      _isConnected = false;
      developer.log('''
Connection failed with SocketException:
- Error: ${e.message}
- Port: ${e.port}
- Address: ${e.address}
''', name: 'RemoteDataSource', error: e);
      throw DatabaseException('PostgreSQL service may not be running: ${e.message}');
    } catch (e) {
      _isConnected = false;
      developer.log('Unexpected connection error: $e', 
        name: 'RemoteDataSource', error: e);
      throw DatabaseException('Connection failed: $e');
    }
  }

  Future<UserModel?> verifyCredentials({
    required String cedula,
    required String passwordHash,
  }) async {
    try {
      developer.log('Intentando verificar credenciales', name: 'RemoteDataSource');
      developer.log('Cédula: $cedula', name: 'RemoteDataSource');
      developer.log('PasswordHash: $passwordHash', name: 'RemoteDataSource');

      await openConnection();
      developer.log('Conexión a la base de datos abierta', name: 'RemoteDataSource');

      final results = await _conn!.execute(
        Sql.named('''
          SELECT user_id, cedula, nombre_completo, dependencia, firma, created_at
          FROM users 
          WHERE cedula = @cedula AND password_hash = @passwordHash
        '''),
        parameters: {
          'cedula': cedula,
          'passwordHash': passwordHash,
        },
      );

      developer.log('Consulta ejecutada', name: 'RemoteDataSource');
      developer.log('Resultado: ${results.length} filas', name: 'RemoteDataSource');

      if (results.isEmpty) {
        developer.log('No se encontró el usuario', name: 'RemoteDataSource');
        return null;
      }

      final row = results.first.toColumnMap();
      final user = UserModel.fromRow(row);
      developer.log('Usuario encontrado: ${user.userId}', name: 'RemoteDataSource');
      return user;
    } catch (e) {
      developer.log('Error en verifyCredentials: $e', name: 'RemoteDataSource', error: e);
      throw DatabaseException('Verificación de credenciales fallida: $e');
    }
  }

  Future<List<UserModel>> fetchAllUsers() async {
    try {
      await openConnection();
      final result = await _conn?.execute(
        'SELECT user_id, nombre_completo, dependencia, firma, email FROM users ORDER BY user_id',
      );
      if (result == null) return [];

      return result.map((row) {
        final dataMap = row.toColumnMap();
        return UserModel.fromRow(dataMap);
      }).toList();
    } catch (e) {
      throw DatabaseException('Fetch all users failed: $e');
    }
  }

  Future<List<UserModel>> fetchUserById(int id) async {
    try {
      await openConnection();
      final result = await _conn?.execute(
        Sql.named(
            'SELECT user_id, nombre_completo, dependencia, firma, email FROM users WHERE user_id = @id'),
        parameters: {'id': id},
      );
      if (result == null) return [];

      return result.map((row) {
        final dataMap = row.toColumnMap();
        return UserModel.fromRow(dataMap);
      }).toList();
    } catch (e) {
      throw DatabaseException('Fetch user by id failed: $e');
    }
  }

  Future<void> initDatabase() async {
    try {
      await openConnection();
      await _conn?.execute('''
        CREATE TABLE IF NOT EXISTS a_table (
          id TEXT NOT NULL,
          totals INTEGER NOT NULL DEFAULT 0
        )
      ''');
    } catch (e) {
      throw DatabaseException('Init database failed: $e');
    }
  }

  Future<void> insertRow(String id) async {
    try {
      await openConnection();
      final result = await _conn?.execute(
        r'INSERT INTO a_table (id) VALUES ($1)',
        parameters: [id],
      );
      print('Inserted ${result?.affectedRows} rows');
    } catch (e) {
      throw DatabaseException('Insert failed: $e');
    }
  }

  Future<Map<String, dynamic>?> getRow(String id) async {
    try {
      await openConnection();
      final result = await _conn?.execute(
        Sql.named('SELECT * FROM a_table WHERE id=@id'),
        parameters: {'id': id},
      );
      return result?.first.toColumnMap();
    } catch (e) {
      throw DatabaseException('Query failed: $e');
    }
  }

  Future<void> runTransaction() async {
    try {
      await openConnection();
      await _conn?.runTx((ctx) async {
        final rs = await ctx.execute('SELECT count(*) FROM a_table');
        await ctx.execute(
          r'UPDATE a_table SET totals=$1 WHERE id=$2',
          parameters: [rs[0][0], 'xyz'],
        );
      });
    } catch (e) {
      throw DatabaseException('Transaction failed: $e');
    }
  }

  Future<void> closeConnection() async {
    try {
      if (_conn != null && _isConnected) {
        await _conn!.close();
        _isConnected = false;
      }
    } catch (e) {
      throw DatabaseException('Close connection failed: $e');
    }
  }

  Future<List<Map<String, dynamic>>> fetch() async {
    try {
      await openConnection();

      final result = await _conn?.execute(
        'SELECT * FROM a_table ORDER BY id',
      );

      if (result == null) {
        return [];
      }

      return result.map((row) => row.toColumnMap()).toList();
    } catch (e) {
      throw DatabaseException('Fetch failed: $e');
    }
  }

  Future<List<Map<String, dynamic>>> fetchById(String id) async {
    try {
      await openConnection();

      final result = await _conn?.execute(
        Sql.named('SELECT * FROM a_table WHERE id = @id'),
        parameters: {'id': id},
      );

      if (result == null) {
        return [];
      }

      return result.map((row) => row.toColumnMap()).toList();
    } catch (e) {
      throw DatabaseException('Fetch by id failed: $e');
    }
  }
}

class DatabaseException implements Exception {
  final String message;
  DatabaseException(this.message);

  @override
  String toString() => message;
}
