import 'package:flutter/material.dart';
import '../repositories/risk_analysis_repository_interface.dart';
import 'calculate_score_usecase.dart';

/// Caso de uso para calcular scores globales de amenaza y vulnerabilidad
/// Encapsula la lógica de negocio para cálculos de puntuación global
class CalculateGlobalScoreUseCase {
  final CalculateScoreUseCase _calculateScoreUseCase;

  const CalculateGlobalScoreUseCase(
    this._calculateScoreUseCase,
  );

  /// Ejecutar el caso de uso para calcular score global de amenaza
  double calculateAmenazaGlobalScore(Map<String, dynamic> formData) {
    try {
      // Buscar en amenaza probabilidad
      final probabilidadSelections = Map<String, dynamic>.from(
        formData['amenazaProbabilidadSelections'] ?? {}
      );
      
      // Buscar en amenaza intensidad
      final intensidadSelections = Map<String, dynamic>.from(
        formData['amenazaIntensidadSelections'] ?? {}
      );
      
      double probabilidadScore = 0.0;
      double intensidadScore = 0.0;
      
      // Calcular score de probabilidad si hay datos
      if (probabilidadSelections.isNotEmpty) {
        probabilidadScore = _calculateAverageFromSelections(probabilidadSelections);
      }
      
      // Calcular score de intensidad si hay datos
      if (intensidadSelections.isNotEmpty) {
        intensidadScore = _calculateAverageFromSelections(intensidadSelections);
      }
      
      // Si ambos son 0, no hay calificaciones
      if (probabilidadScore == 0.0 && intensidadScore == 0.0) {
        return 0.0;
      }
      
      // Calcular score global (promedio ponderado)
      // Probabilidad tiene peso 0.6, Intensidad tiene peso 0.4
      final globalScore = (probabilidadScore * 0.6) + (intensidadScore * 0.4);
      
      return globalScore;
    } catch (e) {
      return 0.0;
    }
  }

  /// Ejecutar el caso de uso para calcular score global de vulnerabilidad
  double calculateVulnerabilidadGlobalScore(Map<String, dynamic> formData) {
    try {
      print('=== DEBUG calculateVulnerabilidadGlobalScore ===');
      print('formData keys: ${formData.keys.toList()}');
      
      final vulnerabilidadSelections = Map<String, dynamic>.from(
        formData['vulnerabilidadSelections'] ?? {}
      );
      print('vulnerabilidadSelections: $vulnerabilidadSelections');

      if (vulnerabilidadSelections.isEmpty) {
        print('vulnerabilidadSelections is empty, returning 0.0');
        return 0.0;
      }

      double totalScore = 0.0;
      int count = 0;

      // Calcular score para cada subclasificación de vulnerabilidad
      for (final subClassificationId in vulnerabilidadSelections.keys) {
        print('Processing subClassificationId: $subClassificationId');
        final score = _calculateScoreUseCase.execute(subClassificationId, formData);
        print('Score for $subClassificationId: $score');
        if (score > 0) {
          totalScore += score;
          count++;
        }
      }

      final result = count > 0 ? totalScore / count : 0.0;
      print('Final vulnerabilidad score: $result (totalScore: $totalScore, count: $count)');
      print('=== END DEBUG calculateVulnerabilidadGlobalScore ===');
      
      return result;
    } catch (e) {
      print('Error in calculateVulnerabilidadGlobalScore: $e');
      return 0.0;
    }
  }

  /// Calcular score final de riesgo
  double calculateFinalRiskScore(Map<String, dynamic> formData) {
    try {
      final amenazaScore = calculateAmenazaGlobalScore(formData);
      final vulnerabilidadScore = calculateVulnerabilidadGlobalScore(formData);
      
      // Score final es el producto de amenaza y vulnerabilidad
      final finalScore = amenazaScore * vulnerabilidadScore;
      
      return finalScore;
    } catch (e) {
      return 0.0;
    }
  }

  /// Obtener color basado en score global
  Color getGlobalScoreColor(double score) {
    if (score <= 1.5) return Colors.green;
    if (score <= 2.5) return Colors.yellow;
    if (score <= 3.5) return Colors.orange;
    if (score <= 4.5) return Colors.red;
    return Colors.deepPurple;
  }

  /// Obtener nivel de riesgo basado en score global (usando las reglas originales)
  String getGlobalRiskLevel(double score) {
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

  /// Calcular promedio de selecciones
  double _calculateAverageFromSelections(Map<String, dynamic> selections) {
    if (selections.isEmpty) return 0.0;
    
    double totalScore = 0.0;
    int count = 0;
    
    for (final value in selections.values) {
      if (value is String && value != 'No Aplica' && value != 'NA') {
        final score = _levelToScore(value);
        if (score > 0) {
          totalScore += score;
          count++;
        }
      }
    }
    
    return count > 0 ? totalScore / count : 0.0;
  }
  
  /// Convertir nivel de texto a score numérico
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

  /// Obtener información completa del score global
  Map<String, dynamic> getGlobalScoreInfo(Map<String, dynamic> formData) {
    try {
      print('=== DEBUG getGlobalScoreInfo ===');
      print('formData keys: ${formData.keys.toList()}');
      print('selectedClassification: ${formData['selectedClassification']}');
      
      final amenazaScore = calculateAmenazaGlobalScore(formData);
      final vulnerabilidadScore = calculateVulnerabilidadGlobalScore(formData);
      final finalScore = calculateFinalRiskScore(formData);

      print('amenazaScore: $amenazaScore');
      print('vulnerabilidadScore: $vulnerabilidadScore');
      print('finalScore: $finalScore');

      final result = {
        'amenazaScore': amenazaScore,
        'vulnerabilidadScore': vulnerabilidadScore,
        'finalScore': finalScore,
        'amenazaColor': getGlobalScoreColor(amenazaScore),
        'vulnerabilidadColor': getGlobalScoreColor(vulnerabilidadScore),
        'finalColor': getGlobalScoreColor(finalScore),
        'amenazaLevel': getGlobalRiskLevel(amenazaScore),
        'vulnerabilidadLevel': getGlobalRiskLevel(vulnerabilidadScore),
        'finalLevel': getGlobalRiskLevel(finalScore),
      };
      
      print('getGlobalScoreInfo result: $result');
      print('=== END DEBUG getGlobalScoreInfo ===');
      
      return result;
    } catch (e) {
      print('Error in getGlobalScoreInfo: $e');
      return {
        'amenazaScore': 0.0,
        'vulnerabilidadScore': 0.0,
        'finalScore': 0.0,
        'amenazaColor': Colors.grey,
        'vulnerabilidadColor': Colors.grey,
        'finalColor': Colors.grey,
        'amenazaLevel': 'N/A',
        'vulnerabilidadLevel': 'N/A',
        'finalLevel': 'N/A',
      };
    }
  }
}

