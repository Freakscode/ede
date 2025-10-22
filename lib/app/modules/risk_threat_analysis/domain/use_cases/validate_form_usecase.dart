import '../entities/form_entity.dart';
import '../repositories/risk_analysis_repository_interface.dart';

/// Caso de uso para validar formulario
/// Encapsula la lógica de negocio para validación de formularios
class ValidateFormUseCase {
  final RiskAnalysisRepositoryInterface _repository;

  const ValidateFormUseCase(this._repository);

  /// Ejecutar el caso de uso
  bool execute(FormEntity entity) {
    try {
      // Validar entidad básica
      if (!entity.isValid) {
        return false;
      }

      // Validar datos específicos según el tipo de formulario
      if (entity.isAmenaza) {
        return _validateAmenazaForm(entity);
      } else if (entity.isVulnerabilidad) {
        return _validateVulnerabilidadForm(entity);
      }

      return false;
    } catch (e) {
      return false;
    }
  }

  /// Validar formulario de amenaza
  bool _validateAmenazaForm(FormEntity entity) {
    // Validar que tenga datos de probabilidad e intensidad
    final data = entity.data;
    return data.containsKey('probabilidad') && data.containsKey('intensidad');
  }

  /// Validar formulario de vulnerabilidad
  bool _validateVulnerabilidadForm(FormEntity entity) {
    // Validar que tenga al menos una subclasificación
    final data = entity.data;
    return data.isNotEmpty;
  }
}
