import '../entities/evaluacion_entity.dart';

abstract class EvaluacionRepository {
  Future<List<EvaluacionEntity>> getAllEvaluaciones();
  Future<EvaluacionEntity> getEvaluacionById(String id);
  Future<void> saveEvaluacion(EvaluacionEntity evaluacion);
  Future<void> deleteEvaluacion(String id);
  Future<void> syncEvaluaciones();
}
