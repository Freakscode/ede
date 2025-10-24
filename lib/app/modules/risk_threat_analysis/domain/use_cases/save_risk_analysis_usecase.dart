import '../entities/risk_analysis_entity.dart';
import '../repositories/risk_analysis_repository_interface.dart';

/// Caso de uso para guardar análisis de riesgo
/// Encapsula la lógica de negocio para guardar análisis
class SaveRiskAnalysisUseCase {
  final RiskAnalysisRepositoryInterface _repository;

  const SaveRiskAnalysisUseCase(this._repository);

  /// Ejecutar el caso de uso
  Future<void> execute(RiskAnalysisEntity entity) async {
    try {
      // Validar entidad antes de guardar
      if (!entity.isValid) {
        throw Exception('Entidad de análisis de riesgo inválida');
      }

      // Guardar análisis
      await _repository.saveRiskAnalysis(entity);
    } catch (e) {
      throw Exception('Error al guardar análisis de riesgo: $e');
    }
  }
}
