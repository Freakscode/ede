import 'package:flutter/material.dart';
import '../repositories/risk_analysis_repository_interface.dart';

/// Caso de uso para calcular scores y colores de subclasificaciones
/// Encapsula la lógica de negocio para cálculos de puntuación
class CalculateScoreUseCase {
  final RiskAnalysisRepositoryInterface _repository;

  const CalculateScoreUseCase(this._repository);

  /// Ejecutar el caso de uso para calcular score de una subclasificación
  double execute(String subClassificationId, Map<String, dynamic> formData) {
    try {
      // Obtener datos de la subclasificación
      final subClassificationData = _getSubClassificationData(subClassificationId, formData);
      
      if (subClassificationData.isEmpty) {
        return 0.0;
      }

      // Calcular score basado en las selecciones
      return _calculateScoreFromSelections(subClassificationData);
    } catch (e) {
      return 0.0;
    }
  }

  /// Obtener datos de una subclasificación específica
  Map<String, dynamic> _getSubClassificationData(String subClassificationId, Map<String, dynamic> formData) {
    // Buscar en las selecciones dinámicas (vulnerabilidad)
    if (formData.containsKey('vulnerabilidadSelections')) {
      final vulnerabilidadData = Map<String, dynamic>.from(formData['vulnerabilidadSelections'] ?? {});
      if (vulnerabilidadData.containsKey(subClassificationId)) {
        return Map<String, dynamic>.from(vulnerabilidadData[subClassificationId] ?? {});
      }
    }
    
    // Buscar en amenaza probabilidad (usar el ID real)
    if (formData.containsKey('amenazaProbabilidadSelections')) {
      final probabilidadData = Map<String, dynamic>.from(formData['amenazaProbabilidadSelections'] ?? {});
      if (probabilidadData.containsKey(subClassificationId)) {
        return Map<String, dynamic>.from(probabilidadData);
      }
    }
    
    // Buscar en amenaza intensidad (usar el ID real)
    if (formData.containsKey('amenazaIntensidadSelections')) {
      final intensidadData = Map<String, dynamic>.from(formData['amenazaIntensidadSelections'] ?? {});
      if (intensidadData.containsKey(subClassificationId)) {
        return Map<String, dynamic>.from(intensidadData);
      }
    }

    return {};
  }

  /// Calcular score basado en las selecciones
  double _calculateScoreFromSelections(Map<String, dynamic> selections) {
    if (selections.isEmpty) return 0.0;

    double totalScore = 0.0;
    int count = 0;

    for (final value in selections.values) {
      if (value is String && value != 'No Aplica') {
        final score = _levelToScore(value);
        totalScore += score;
        count++;
      }
    }

    return count > 0 ? totalScore / count : 0.0;
  }

  /// Convertir nivel a puntuación numérica
  double _levelToScore(String level) {
    switch (level.toLowerCase()) {
      case 'muy bajo':
        return 1.0;
      case 'bajo':
        return 2.0;
      case 'medio bajo':
        return 2.5;
      case 'medio':
        return 3.0;
      case 'medio alto':
        return 3.5;
      case 'alto':
        return 4.0;
      case 'muy alto':
        return 5.0;
      default:
        return 0.0;
    }
  }

  /// Calcular color basado en score
  Color scoreToColor(double score) {
    if (score <= 1.5) return Colors.green;
    if (score <= 2.5) return Colors.yellow;
    if (score <= 3.5) return Colors.orange;
    if (score <= 4.5) return Colors.red;
    return Colors.deepPurple;
  }

  /// Calcular nivel de riesgo basado en score (usando las reglas originales)
  String scoreToRiskLevel(double score) {
    if (score >= 1.0 && score <= 1.75) {
      return 'BAJO';
    } else if (score > 1.75 && score <= 2.5) {
      return 'MEDIO - BAJO';
    } else if (score > 2.5 && score <= 3.25) {
      return 'MEDIO - ALTO';
    } else if (score > 3.25 && score <= 4.0) {
      return 'ALTO';
    } else {
      return 'SIN CALIFICAR';
    }
  }
}

