import '../../domain/entities/evaluacion_entity.dart';
import '../../domain/repositories/repositories.dart';
import '../datasources/local_database.dart';
import '../datasources/remote_api.dart';
import '../models/evaluacion_model.dart';

class EvaluacionRepositoryImpl implements EvaluacionRepository {
  final LocalDatabase localDatabase;
  final RemoteApi remoteApi;
  final AuthRepository authRepository;

  EvaluacionRepositoryImpl({
    required this.localDatabase,
    required this.remoteApi,
    required this.authRepository,
  });

  @override
  Future<List<EvaluacionEntity>> getAllEvaluaciones() async {
    try {
      final models = await localDatabase.getAllEvaluaciones();
      return models.map(_modelToEntity).toList();
    } catch (e) {
      throw Exception('Error getting evaluaciones: $e');
    }
  }

  @override
  Future<EvaluacionEntity> getEvaluacionById(String id) async {
    try {
      final models = await localDatabase.getAllEvaluaciones();
      final model = models.firstWhere(
        (e) => e.id == id,
        orElse: () => throw Exception('Evaluacion not found'),
      );
      return _modelToEntity(model);
    } catch (e) {
      throw Exception('Error getting evaluacion by id: $e');
    }
  }

  @override
  Future<void> saveEvaluacion(EvaluacionEntity evaluacion) async {
    try {
      final model = _entityToModel(evaluacion);
      await localDatabase.insertEvaluacion(model);
    } catch (e) {
      throw Exception('Error saving evaluacion: $e');
    }
  }

  @override
  Future<void> updateEvaluacion(EvaluacionEntity evaluacion) async {
    try {
      final model = _entityToModel(evaluacion);
      await localDatabase.insertEvaluacion(model);
    } catch (e) {
      throw Exception('Error updating evaluacion: $e');
    }
  }

  @override
  Future<void> deleteEvaluacion(String id) async {
    try {
      await localDatabase.deleteEvaluacion(id);
    } catch (e) {
      throw Exception('Error deleting evaluacion: $e');
    }
  }

  @override
  Future<void> syncEvaluaciones() async {
    try {
      final token = await authRepository.getStoredToken();
      if (token == null) throw Exception('No auth token available');

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
    } catch (e) {
      throw Exception('Error syncing evaluaciones: $e');
    }
  }

  // Helper methods
  EvaluacionEntity _modelToEntity(EvaluacionModel model) {
    return EvaluacionEntity(
      id: model.id,
      data: model.data,
      synced: model.synced,
      createdAt: model.createdAt,
      updatedAt: model.updatedAt,
    );
  }

  EvaluacionModel _entityToModel(EvaluacionEntity entity) {
    return EvaluacionModel(
      id: entity.id,
      data: entity.data,
      synced: entity.synced,
      createdAt: entity.createdAt,
      updatedAt: entity.updatedAt,
    );
  }
}
