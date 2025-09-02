import '../../domain/entities/evaluacion_entity.dart';
import '../../domain/repositories/repositories.dart';
import '../datasources/local_database.dart';
import '../datasources/remote_api.dart';
import '../models/evaluacion_model.dart';

class SyncRepositoryImpl implements SyncRepository {
  final LocalDatabase localDatabase;
  final RemoteApi remoteApi;
  final AuthRepository authRepository;

  SyncRepositoryImpl({
    required this.localDatabase,
    required this.remoteApi,
    required this.authRepository,
  });

  @override
  Future<void> syncAllData() async {
    try {
      final token = await authRepository.getStoredToken();
      if (token == null) throw Exception('No auth token available');

      // Sync evaluaciones
      await _syncEvaluaciones(token);
    } catch (e) {
      throw Exception('Error syncing all data: $e');
    }
  }

  @override
  Future<List<EvaluacionEntity>> getUnsyncedEvaluaciones() async {
    try {
      final models = await localDatabase.getUnsyncedEvaluaciones();
      return models.map(_modelToEntity).toList();
    } catch (e) {
      throw Exception('Error getting unsynced evaluaciones: $e');
    }
  }

  @override
  Future<void> markEvaluacionAsSynced(String id) async {
    try {
      await localDatabase.markEvaluacionAsSynced(id);
    } catch (e) {
      throw Exception('Error marking evaluacion as synced: $e');
    }
  }

  Future<void> _syncEvaluaciones(String token) async {
    // Get unsynced local evaluaciones
    final unsyncedModels = await localDatabase.getUnsyncedEvaluaciones();
    
    if (unsyncedModels.isNotEmpty) {
      // Sync with remote
      final syncedModels = await remoteApi.syncEvaluaciones(token, unsyncedModels);
      
      // Mark as synced in local database
      for (final model in syncedModels) {
        await localDatabase.markEvaluacionAsSynced(model.id);
      }
    }

    // Get remote evaluaciones and save locally
    final remoteModels = await remoteApi.getEvaluaciones(token);
    for (final model in remoteModels) {
      await localDatabase.insertEvaluacion(model);
    }
  }

  // Helper method
  EvaluacionEntity _modelToEntity(EvaluacionModel model) {
    return EvaluacionEntity(
      id: model.id,
      data: model.data,
      synced: model.synced,
      createdAt: model.createdAt,
      updatedAt: model.updatedAt,
    );
  }
}
