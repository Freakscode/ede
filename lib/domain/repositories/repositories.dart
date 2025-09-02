import '../entities/evaluacion_entity.dart';

abstract class EvaluacionRepository {
  Future<List<EvaluacionEntity>> getAllEvaluaciones();
  Future<EvaluacionEntity> getEvaluacionById(String id);
  Future<void> saveEvaluacion(EvaluacionEntity evaluacion);
  Future<void> updateEvaluacion(EvaluacionEntity evaluacion);
  Future<void> deleteEvaluacion(String id);
  Future<void> syncEvaluaciones();
}

abstract class AuthRepository {
  Future<String> login(String username, String password);
  Future<void> logout();
  Future<String?> getStoredToken();
  Future<bool> isLoggedIn();
}

abstract class SyncRepository {
  Future<void> syncAllData();
  Future<List<EvaluacionEntity>> getUnsyncedEvaluaciones();
  Future<void> markEvaluacionAsSynced(String id);
}
