import '../entities/risk_analysis_entity.dart';
import '../repositories/risk_analysis_repository_interface.dart';

/// Caso de uso para cargar análisis de riesgo
/// Encapsula la lógica de negocio para cargar análisis
class LoadRiskAnalysisUseCase {
  final RiskAnalysisRepositoryInterface _repository;

  const LoadRiskAnalysisUseCase(this._repository);

  /// Ejecutar el caso de uso
  Future<RiskAnalysisEntity?> execute(String eventName, String classificationType) async {
    try {
      // Validar parámetros
      if (eventName.isEmpty || classificationType.isEmpty) {
        throw Exception('Parámetros inválidos para cargar análisis');
      }

      // Cargar análisis
      return await _repository.loadRiskAnalysis(eventName, classificationType);
    } catch (e) {
      throw Exception('Error al cargar análisis de riesgo: $e');
    }
  }

  /// Cargar todos los análisis
  Future<List<RiskAnalysisEntity>> executeAll() async {
    try {
      return await _repository.getAllRiskAnalyses();
    } catch (e) {
      throw Exception('Error al cargar todos los análisis: $e');
    }
  }
}
