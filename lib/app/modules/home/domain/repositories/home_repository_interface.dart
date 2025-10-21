import '../entities/home_entity.dart';
import '../entities/form_entity.dart';
import '../entities/tutorial_entity.dart';

/// Interfaz del repositorio para el módulo Home
/// Define el contrato para la gestión de datos del home
abstract class HomeRepositoryInterface {
  /// Obtener el estado actual del home
  Future<HomeEntity> getHomeState();

  /// Actualizar el estado del home
  Future<void> updateHomeState(HomeEntity homeState);

  /// Obtener formularios guardados
  Future<List<FormEntity>> getSavedForms();

  /// Guardar un formulario
  Future<void> saveForm(FormEntity form);

  /// Eliminar un formulario
  Future<void> deleteForm(String formId);

  /// Obtener un formulario por ID
  Future<FormEntity?> getFormById(String formId);

  /// Obtener formularios por estado
  Future<List<FormEntity>> getFormsByStatus(FormStatus status);

  /// Establecer formulario activo
  Future<void> setActiveFormId(String? formId);

  /// Obtener formulario activo
  Future<String?> getActiveFormId();

  /// Limpiar formulario activo
  Future<void> clearActiveFormId();

  /// Obtener configuración del tutorial
  Future<TutorialEntity> getTutorialConfig();

  /// Actualizar configuración del tutorial
  Future<void> updateTutorialConfig(TutorialEntity tutorial);

  /// Limpiar configuración del tutorial
  Future<void> clearTutorialConfig();

  /// Guardar modelo de evento de riesgo
  Future<void> saveRiskEventModel({
    required String eventName,
    required String classificationType,
    required Map<String, dynamic> evaluationData,
  });

  /// Obtener modelo de evento de riesgo
  Future<Map<String, dynamic>?> getRiskEventModel({
    required String eventName,
    required String classificationType,
  });

  /// Obtener todos los modelos de eventos de riesgo para un evento
  Future<Map<String, Map<String, dynamic>>> getRiskEventModelsForEvent(String eventName);

  /// Eliminar modelo de evento de riesgo
  Future<void> deleteRiskEventModel({
    required String eventName,
    required String classificationType,
  });

  /// Marcar evaluación como completada
  Future<void> markEvaluationCompleted({
    required String eventName,
    required String classificationType,
  });

  /// Obtener evaluaciones completadas
  Future<Map<String, bool>> getCompletedEvaluations();

  /// Resetear evaluaciones para un evento
  Future<void> resetEvaluationsForEvent(String eventName);

  /// Verificar si existe un formulario
  Future<bool> formExists(String formId);

  /// Obtener estadísticas de formularios
  Future<Map<String, int>> getFormStatistics();

  /// Limpiar todos los datos
  Future<void> clearAllData();

  /// Verificar conectividad
  Future<bool> isConnected();

  /// Sincronizar datos (si hay backend)
  Future<void> syncData();
}
