import '../datasources/local_datasource.dart';
import '../datasources/remote_datasource.dart';
import '../models/data_model.dart';
import '../models/user_model.dart';
import 'dart:developer' as developer;

class DataRepository {
  final LocalDataSource localDataSource;
  final RemoteDatasource remoteDataSource;

  DataRepository({
    required this.localDataSource,
    required this.remoteDataSource,
  });

  Future<List<DataModel>> fetchByIdAndStoreLocally(String id) async {
    try {
      final remoteData = await remoteDataSource.fetchById(id);
      final dataModels = remoteData.map((map) => DataModel.fromJson(map)).toList();
      
      // Store in local DB
      for (var model in dataModels) {
        await localDataSource.insertData(model);
      }
      return dataModels;
    } catch (e) {
      // On failure, return local data
      final localData = await localDataSource.getAllData();
      return localData;
    }
  }

  Future<List<UserModel>> fetchAndStoreAllUsers() async {
    try {
      // Fetch remote users
      final remoteUsers = await remoteDataSource.fetchAllUsers();
      developer.log('Fetched ${remoteUsers.length} users from remote DB');

      final userModels = remoteUsers.map((map) => UserModel.fromRow(map)).toList();

      // Store in local DB
      for (var user in userModels) {
        await localDataSource.insertUser(user);
        developer.log('Inserted user ${user.userId} into local DB');
      }
      return userModels;
    } catch (e) {
      developer.log('Failed to fetch remote users: $e');
      return [];
    }
  }

  Future<List<DataModel>> getData() async {
    try {
      final remoteData = await remoteDataSource.fetchAllData();
      developer.log('Fetched ${remoteData.length} items from remote DB');

      final dataModels = remoteData.map((map) => DataModel.fromJson(map)).toList();
      for (var model in dataModels) {
        await localDataSource.insertData(model);
        developer.log('Inserted data model ${model.id} into local DB');
      }
      return dataModels;
    } catch (e) {
      developer.log('Failed to fetch remote data: $e');
      throw Exception('Failed to fetch remote data: $e');
    }
  }

  Future<List<DataModel>> getLocalData() async {
    try {
      return await localDataSource.getAllData();
    } catch (e) {
      throw Exception('Failed to fetch local data: $e');
    }
  }

  Future<List<UserModel>> getUsers() async {
    try {
      final remoteUsers = await remoteDataSource.fetchAllUsers();
      developer.log('Remote DB: fetched ${remoteUsers.length} users', name: 'DataRepository');

      final userModels = remoteUsers.map((map) => UserModel.fromRow(map)).toList();
      for (var user in userModels) {
        await localDataSource.insertUser(user);
        developer.log('Local DB: inserted user ${user.userId}', name: 'DataRepository');
      }
      return userModels;
    } catch (e) {
      developer.log('Failed to fetch remote users: $e', name: 'DataRepository');
      return getLocalUsers();
    }
  }

  Future<List<UserModel>> getLocalUsers() async {
    developer.log('Fetching local users...', name: 'DataRepository');
    return await localDataSource.getAllUsers();
  }

  Future<void> syncData() async {
    try {
      // 1. Get unsyncronized users from local DB
      final unsyncedUsers = await localDataSource.getUnsyncedUsers();
      developer.log('Found ${unsyncedUsers.length} unsynced users locally');

      // 2. Push each unsynced user to remote
      for (var user in unsyncedUsers) {
        try {
          await remoteDataSource.createUser(user.toJson());
          await localDataSource.markUserAsSynced(user.userId);
          developer.log('Synced user ${user.userId} successfully');
        } catch (e) {
          developer.log('Failed to sync user ${user.userId}: $e');
          continue;
        }
      }

      // 3. Get latest data from remote
      await fetchAndStoreAllUsers();
      developer.log('Synced data and fetched latest users from remote DB');
    } catch (e) {
      developer.log('Sync failed: $e');
      throw Exception('Sync failed: $e');
    }
  }
}
