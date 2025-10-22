import '../repositories/risk_analysis_repository_interface.dart';

/// Caso de uso para validar variables no calificadas
/// Encapsula la lógica de negocio para verificar variables críticas sin calificar
class ValidateUnqualifiedVariablesUseCase {
  final RiskAnalysisRepositoryInterface _repository;

  const ValidateUnqualifiedVariablesUseCase(this._repository);

  /// Ejecutar el caso de uso para verificar si hay variables no calificadas
  bool execute(Map<String, dynamic> formData) {
    try {
      // Verificar variables críticas en amenaza
      final amenazaHasUnqualified = _checkAmenazaUnqualifiedVariables(formData);
      
      // Verificar variables críticas en vulnerabilidad
      final vulnerabilidadHasUnqualified = _checkVulnerabilidadUnqualifiedVariables(formData);
      
      return amenazaHasUnqualified || vulnerabilidadHasUnqualified;
    } catch (e) {
      return false;
    }
  }

  /// Verificar variables no calificadas en amenaza
  bool _checkAmenazaUnqualifiedVariables(Map<String, dynamic> formData) {
    // Verificar probabilidad
    final probabilidadSelections = Map<String, dynamic>.from(
      formData['amenazaProbabilidadSelections'] ?? {}
    );
    
    // Verificar intensidad
    final intensidadSelections = Map<String, dynamic>.from(
      formData['amenazaIntensidadSelections'] ?? {}
    );

    // Lista de variables críticas para probabilidad
    final criticalProbabilidadVariables = [
      'Características Geotécnicas',
      'Antecedentes',
      'Evidencias de Materialización o Reactivación'
    ];

    // Lista de variables críticas para intensidad
    final criticalIntensidadVariables = [
      'Potencial de Daño en Edificaciones',
      'Capacidad de Generar Pérdida de Vidas Humanas'
    ];

    // Verificar si alguna variable crítica no está calificada
    for (final variable in criticalProbabilidadVariables) {
      if (!probabilidadSelections.containsKey(variable) || 
          probabilidadSelections[variable] == null ||
          probabilidadSelections[variable] == '') {
        return true;
      }
    }

    for (final variable in criticalIntensidadVariables) {
      if (!intensidadSelections.containsKey(variable) || 
          intensidadSelections[variable] == null ||
          intensidadSelections[variable] == '') {
        return true;
      }
    }

    return false;
  }

  /// Verificar variables no calificadas en vulnerabilidad
  bool _checkVulnerabilidadUnqualifiedVariables(Map<String, dynamic> formData) {
    final vulnerabilidadSelections = Map<String, dynamic>.from(
      formData['vulnerabilidadSelections'] ?? {}
    );

    // Lista de variables críticas para vulnerabilidad
    final criticalVulnerabilidadVariables = [
      'Exposición',
      'Fragilidad',
      'Resistencia'
    ];

    // Verificar si alguna variable crítica no está calificada
    for (final variable in criticalVulnerabilidadVariables) {
      if (!vulnerabilidadSelections.containsKey(variable) || 
          vulnerabilidadSelections[variable] == null ||
          vulnerabilidadSelections[variable] == '') {
        return true;
      }
    }

    return false;
  }

  /// Obtener lista de variables no calificadas
  List<String> getUnqualifiedVariables(Map<String, dynamic> formData) {
    final unqualifiedVariables = <String>[];

    // Verificar probabilidad
    final probabilidadSelections = Map<String, dynamic>.from(
      formData['amenazaProbabilidadSelections'] ?? {}
    );
    
    final criticalProbabilidadVariables = [
      'Características Geotécnicas',
      'Antecedentes',
      'Evidencias de Materialización o Reactivación'
    ];

    for (final variable in criticalProbabilidadVariables) {
      if (!probabilidadSelections.containsKey(variable) || 
          probabilidadSelections[variable] == null ||
          probabilidadSelections[variable] == '') {
        unqualifiedVariables.add('Probabilidad - $variable');
      }
    }

    // Verificar intensidad
    final intensidadSelections = Map<String, dynamic>.from(
      formData['amenazaIntensidadSelections'] ?? {}
    );
    
    final criticalIntensidadVariables = [
      'Potencial de Daño en Edificaciones',
      'Capacidad de Generar Pérdida de Vidas Humanas'
    ];

    for (final variable in criticalIntensidadVariables) {
      if (!intensidadSelections.containsKey(variable) || 
          intensidadSelections[variable] == null ||
          intensidadSelections[variable] == '') {
        unqualifiedVariables.add('Intensidad - $variable');
      }
    }

    // Verificar vulnerabilidad
    final vulnerabilidadSelections = Map<String, dynamic>.from(
      formData['vulnerabilidadSelections'] ?? {}
    );
    
    final criticalVulnerabilidadVariables = [
      'Exposición',
      'Fragilidad',
      'Resistencia'
    ];

    for (final variable in criticalVulnerabilidadVariables) {
      if (!vulnerabilidadSelections.containsKey(variable) || 
          vulnerabilidadSelections[variable] == null ||
          vulnerabilidadSelections[variable] == '') {
        unqualifiedVariables.add('Vulnerabilidad - $variable');
      }
    }

    return unqualifiedVariables;
  }
}
