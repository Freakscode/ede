import '../../../shared/data/models/evaluacion_model.dart';

abstract class RemoteApi {
  Future<Map<String, dynamic>> login(String username, String password);
  Future<void> logout();
  
  Future<List<EvaluacionModel>> getAllEvaluaciones();
  Future<EvaluacionModel?> getEvaluacion(String id);
  Future<EvaluacionModel> createEvaluacion(EvaluacionModel evaluacion);
  Future<EvaluacionModel> updateEvaluacion(EvaluacionModel evaluacion);
  Future<bool> deleteEvaluacion(String id);
  Future<void> syncEvaluaciones();
}
