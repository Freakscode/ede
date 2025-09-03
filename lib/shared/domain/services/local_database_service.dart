import '../../../modules/evaluacion/data/models/evaluacion_model.dart';

abstract class LocalDatabase {
  Future<List<EvaluacionModel>> getAllEvaluaciones();
  Future<EvaluacionModel?> getEvaluacionById(String id);
  Future<void> saveEvaluacion(EvaluacionModel evaluacion);
  Future<void> deleteEvaluacion(String id);
}
