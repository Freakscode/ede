import 'package:flutter/material.dart';
import '../repositories/risk_analysis_repository_interface.dart';
import 'calculate_score_usecase.dart';

/// Caso de uso para calcular scores globales de amenaza y vulnerabilidad
/// Encapsula la lógica de negocio para cálculos de puntuación global
class CalculateGlobalScoreUseCase {
  final RiskAnalysisRepositoryInterface _repository;
  final CalculateScoreUseCase _calculateScoreUseCase;

  const CalculateGlobalScoreUseCase(
    this._repository,
    this._calculateScoreUseCase,
  );

  /// Ejecutar el caso de uso para calcular score global de amenaza
  double calculateAmenazaGlobalScore(Map<String, dynamic> formData) {
    try {
      // Calcular score de probabilidad
      final probabilidadScore = _calculateScoreUseCase.execute('probabilidad', formData);
      
      // Calcular score de intensidad
      final intensidadScore = _calculateScoreUseCase.execute('intensidad', formData);
      
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
      final vulnerabilidadSelections = Map<String, dynamic>.from(
        formData['vulnerabilidadSelections'] ?? {}
      );

      if (vulnerabilidadSelections.isEmpty) {
        return 0.0;
      }

      double totalScore = 0.0;
      int count = 0;

      // Calcular score para cada subclasificación de vulnerabilidad
      for (final subClassificationId in vulnerabilidadSelections.keys) {
        final score = _calculateScoreUseCase.execute(subClassificationId, formData);
        if (score > 0) {
          totalScore += score;
          count++;
        }
      }

      return count > 0 ? totalScore / count : 0.0;
    } catch (e) {
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

  /// Obtener nivel de riesgo basado en score global
  String getGlobalRiskLevel(double score) {
    if (score <= 1.5) return 'BAJO';
    if (score <= 2.5) return 'MEDIO BAJO';
    if (score <= 3.5) return 'MEDIO';
    if (score <= 4.5) return 'ALTO';
    return 'ALTO';
  }

  /// Obtener información completa del score global
  Map<String, dynamic> getGlobalScoreInfo(Map<String, dynamic> formData) {
    try {
      final amenazaScore = calculateAmenazaGlobalScore(formData);
      final vulnerabilidadScore = calculateVulnerabilidadGlobalScore(formData);
      final finalScore = calculateFinalRiskScore(formData);

      return {
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
    } catch (e) {
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

