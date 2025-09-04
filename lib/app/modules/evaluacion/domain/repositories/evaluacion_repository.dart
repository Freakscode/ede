import '../entities/evaluacion_entity.dart';
import '../../../../core/models/evaluacion_model.dart';

abstract class EvaluacionRepository {
  Future<List<EvaluacionEntity>> getAllEvaluaciones();
  Future<EvaluacionEntity> getEvaluacionById(String id);
  Future<void> saveEvaluacion(EvaluacionEntity evaluacion);
  Future<void> deleteEvaluacion(String id);
  Future<void> syncEvaluaciones();
  
  // Métodos para BLoCs existentes
  Future<void> guardarEvaluacion(EvaluacionModel evaluacion);
  Future<EvaluacionModel> obtenerEvaluacion(String id);
  Future<bool> sincronizarEvaluacion(EvaluacionModel evaluacion);
  Future<void> sincronizarPendientes();
  Future<String?> obtenerFirmaEvaluador();
  Future<void> guardarFirmaEvaluador(String firmaPath);
}
