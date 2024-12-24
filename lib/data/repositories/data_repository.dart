import 'package:ede_final_app/data/models/user_model.dart';

import '../datasources/local_datasource.dart';
import '../datasources/remote_datasource.dart';
import '../models/data_model.dart';

class DataRepository {
  final LocalDataSource localDataSource;
  final RemoteDatasource remoteDataSource;

  DataRepository({
    required this.localDataSource,
    required this.remoteDataSource,
  });

  Future<List<DataModel>> fetchByIdAndStoreLocally(String id) async {
    final remoteData = await remoteDataSource.fetchById(id);
    final dataModels =
        remoteData.map((map) => DataModel.fromJson(map)).toList();
    for (var model in dataModels) {
      await localDataSource.insertData(model);
    }
    return dataModels;
  }

  /// filepath: /e:/ede_final_app/lib/data/repositories/data_repository.dart
  Future<UserModel?> fetchUserAndStoreLocal(int userId) async {
    final remoteUsers = await remoteDataSource.fetchUserById(userId);
    if (remoteUsers.isEmpty) return null;

    final user = remoteUsers.first;
    await localDataSource.insertUser(user);

    return user;
  }

  Future<List<UserModel>> fetchAndStoreAllUsers() async {
    final remoteUsers = await remoteDataSource.fetchAllUsers();

    if (remoteUsers.isEmpty) {
      return [];
    }

    for (var user in remoteUsers) {
      await localDataSource.insertUser(user);
    }

    // 4. Return the fetched users
    return remoteUsers;
  }

  Future<List<DataModel>> getData() async {
    try {
      final localData = await localDataSource.getAllData();
      try {
        final remoteDataMap = await remoteDataSource.fetch();
        final remoteData =
            remoteDataMap.map((map) => DataModel.fromJson(map)).toList();

        for (var model in remoteData) {
          await localDataSource.insertData(model);
        }
        return remoteData;
      } catch (e) {
        return localData;
      }
    } catch (e) {
      rethrow;
    }
  }

  Future<void> syncData() async {
    final unsyncedData = await localDataSource.getUnsyncedData();
    if (unsyncedData.isNotEmpty) {
      for (var item in unsyncedData) {
        await remoteDataSource.insertRow(item.id);
      }
    }
  }
}
