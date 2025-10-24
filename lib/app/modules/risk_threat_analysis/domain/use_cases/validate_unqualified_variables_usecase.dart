import 'package:caja_herramientas/app/shared/models/risk_event_factory.dart';

/// Caso de uso para validar variables no calificadas
/// Encapsula la lógica de negocio para verificar variables críticas sin calificar
class ValidateUnqualifiedVariablesUseCase {
  const ValidateUnqualifiedVariablesUseCase();

  /// Ejecutar el caso de uso para verificar si hay variables no calificadas
  bool execute(Map<String, dynamic> formData) {
    try {
      final selectedClassification = formData['selectedClassification'] as String? ?? '';
      
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

    // Obtener las variables críticas dinámicamente desde RiskEventFactory
    final selectedEvent = formData['selectedRiskEvent'] as String? ?? '';
    
    final criticalProbabilidadVariables = _getDynamicProbabilidadVariables(selectedEvent);
    final criticalIntensidadVariables = _getDynamicIntensidadVariables(selectedEvent);

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

    // Las subclasificaciones de vulnerabilidad según RiskEventFactory
    final criticalVulnerabilidadSubClassifications = [
      'fragilidad_fisica',
      'fragilidad_personas',
      'exposicion'
    ];

    // Verificar si alguna subclasificación crítica no está calificada
    for (final subClassificationId in criticalVulnerabilidadSubClassifications) {
      if (!vulnerabilidadSelections.containsKey(subClassificationId) || 
          vulnerabilidadSelections[subClassificationId] == null ||
          vulnerabilidadSelections[subClassificationId] == '') {
        return true;
      }
      
      // Verificar que la subclasificación tenga al menos una categoría calificada
      final subClassificationData = vulnerabilidadSelections[subClassificationId];
      if (subClassificationData is Map && subClassificationData.isEmpty) {
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

  /// Obtener variables críticas de probabilidad dinámicamente desde RiskEventFactory
  List<String> _getDynamicProbabilidadVariables(String eventName) {
    try {
      final eventModel = RiskEventFactory.getEventByName(eventName);
      if (eventModel == null) return [];
      
      // Buscar la clasificación de amenaza
      final amenazaClassification = eventModel.classifications
          .where((c) => c.id.toLowerCase() == 'amenaza')
          .firstOrNull;
      
      if (amenazaClassification == null) return [];
      
      // Buscar la subclasificación de probabilidad
      final probabilidadSubClassification = amenazaClassification.subClassifications
          .where((s) => s.id == 'probabilidad')
          .firstOrNull;
      
      if (probabilidadSubClassification == null) return [];
      
      // Obtener los títulos de las categorías
      return probabilidadSubClassification.categories
          .map((category) => category.title)
          .toList();
    } catch (e) {
      return [];
    }
  }

  /// Obtener variables críticas de intensidad dinámicamente desde RiskEventFactory
  List<String> _getDynamicIntensidadVariables(String eventName) {
    try {
      final eventModel = RiskEventFactory.getEventByName(eventName);
      if (eventModel == null) return [];
      
      // Buscar la clasificación de amenaza
      final amenazaClassification = eventModel.classifications
          .where((c) => c.id.toLowerCase() == 'amenaza')
          .firstOrNull;
      
      if (amenazaClassification == null) return [];
      
      // Buscar la subclasificación de intensidad
      final intensidadSubClassification = amenazaClassification.subClassifications
          .where((s) => s.id == 'intensidad')
          .firstOrNull;
      
      if (intensidadSubClassification == null) return [];
      
      // Obtener los títulos de las categorías
      return intensidadSubClassification.categories
          .map((category) => category.title)
          .toList();
    } catch (e) {
      print('Error getting dynamic intensidad variables: $e');
      return [];
    }
  }
}
