import '../repositories/risk_analysis_repository_interface.dart';

/// Caso de uso para validar variables no calificadas
/// Encapsula la lógica de negocio para verificar variables críticas sin calificar
class ValidateUnqualifiedVariablesUseCase {
  const ValidateUnqualifiedVariablesUseCase();

  /// Ejecutar el caso de uso para verificar si hay variables no calificadas
  bool execute(Map<String, dynamic> formData) {
    try {
      final selectedClassification = formData['selectedClassification'] as String? ?? '';
      print('=== DEBUG execute ===');
      print('selectedClassification: $selectedClassification');
      
      // Solo verificar la clasificación actual
      if (selectedClassification.toLowerCase() == 'amenaza') {
        return _checkAmenazaUnqualifiedVariables(formData);
      } else if (selectedClassification.toLowerCase() == 'vulnerabilidad') {
        return _checkVulnerabilidadUnqualifiedVariables(formData);
      }
      
      // Si no hay clasificación específica, verificar ambas
      final amenazaHasUnqualified = _checkAmenazaUnqualifiedVariables(formData);
      final vulnerabilidadHasUnqualified = _checkVulnerabilidadUnqualifiedVariables(formData);
      
      return amenazaHasUnqualified || vulnerabilidadHasUnqualified;
    } catch (e) {
      print('Error in execute: $e');
      return false;
    }
  }

  /// Verificar variables no calificadas en amenaza
  bool _checkAmenazaUnqualifiedVariables(Map<String, dynamic> formData) {
    print('=== DEBUG _checkAmenazaUnqualifiedVariables ===');
    
    // Verificar probabilidad
    final probabilidadSelections = Map<String, dynamic>.from(
      formData['amenazaProbabilidadSelections'] ?? {}
    );
    print('probabilidadSelections: $probabilidadSelections');
    
    // Verificar intensidad
    final intensidadSelections = Map<String, dynamic>.from(
      formData['amenazaIntensidadSelections'] ?? {}
    );
    print('intensidadSelections: $intensidadSelections');

    // Lista de variables críticas para probabilidad
    final criticalProbabilidadVariables = [
      'Características Geotécnicas',
      'Antecedentes',
      'Evidencias de Materialización o Reactivación'
    ];

    // Lista de variables críticas para intensidad
    final criticalIntensidadVariables = [
      'Potencial de Daño en Edificaciones',
      'Capacidad de Generar Pérdida de Vidas Humanas',
      'Alteración del Funcionamiento de Líneas Vitales y Espacio Público'
    ];

    // Verificar si alguna variable crítica no está calificada
    for (final variable in criticalProbabilidadVariables) {
      print('Checking probabilidad variable: $variable');
      if (!probabilidadSelections.containsKey(variable) || 
          probabilidadSelections[variable] == null ||
          probabilidadSelections[variable] == '') {
        print('Variable probabilidad no calificada: $variable');
        return true;
      }
    }

    for (final variable in criticalIntensidadVariables) {
      print('Checking intensidad variable: $variable');
      if (!intensidadSelections.containsKey(variable) || 
          intensidadSelections[variable] == null ||
          intensidadSelections[variable] == '') {
        print('Variable intensidad no calificada: $variable');
        return true;
      }
    }

    print('Todas las variables de amenaza están calificadas');
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
