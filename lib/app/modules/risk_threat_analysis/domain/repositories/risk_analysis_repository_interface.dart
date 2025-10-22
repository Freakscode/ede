import '../entities/risk_analysis_entity.dart';
import '../entities/form_entity.dart';
import '../entities/rating_entity.dart';

/// Interfaz del repositorio para análisis de riesgo
/// Define el contrato para la gestión de datos del análisis de riesgo
abstract class RiskAnalysisRepositoryInterface {
  /// Guardar análisis de riesgo
  Future<void> saveRiskAnalysis(RiskAnalysisEntity entity);

  /// Cargar análisis de riesgo
  Future<RiskAnalysisEntity?> loadRiskAnalysis(String eventName, String classificationType);

  /// Eliminar análisis de riesgo
  Future<void> deleteRiskAnalysis(String eventName, String classificationType);

  /// Obtener todos los análisis guardados
  Future<List<RiskAnalysisEntity>> getAllRiskAnalyses();

  /// Verificar si existe un análisis
  Future<bool> riskAnalysisExists(String eventName, String classificationType);

  /// Guardar datos de formulario
  Future<void> saveFormData(FormEntity entity);
  
  /// Cargar datos de formulario
  Future<FormEntity?> loadFormData(String eventName, String classificationType);
  
  /// Validar datos de formulario
  bool validateFormData(FormEntity entity);
  
  /// Limpiar datos de formulario
  Future<void> clearFormData(String eventName, String classificationType);
  
  /// Obtener todos los formularios guardados
  Future<List<FormEntity>> getAllFormData();
  
  /// Verificar si existe un formulario
  Future<bool> formDataExists(String eventName, String classificationType);

  /// Guardar datos de calificación
  Future<void> saveRatingData(RatingEntity entity);

  /// Cargar datos de calificación
  Future<RatingEntity?> loadRatingData(String category, String subClassificationId);

  /// Obtener todas las calificaciones guardadas
  Future<List<RatingEntity>> getAllRatingData();

  /// Limpiar todos los datos
  Future<void> clearAllData();

  /// Verificar conectividad
  Future<bool> isConnected();

  /// Sincronizar datos (si hay backend)
  Future<void> syncData();
}
