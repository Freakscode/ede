import '../entities/rating_entity.dart';
import '../repositories/risk_analysis_repository_interface.dart';

/// Caso de uso para calcular calificación
/// Encapsula la lógica de negocio para cálculos de calificación
class CalculateRatingUseCase {
  final RiskAnalysisRepositoryInterface _repository;

  const CalculateRatingUseCase(this._repository);

  /// Ejecutar el caso de uso
  Future<Map<String, dynamic>> execute(List<RatingEntity> ratings) async {
    try {
      // Validar que haya calificaciones
      if (ratings.isEmpty) {
        throw Exception('No hay calificaciones para calcular');
      }

      // Calcular puntuación total
      final totalScore = _calculateTotalScore(ratings);
      
      // Calcular color basado en puntuación
      final color = _calculateColor(totalScore);
      
      // Calcular nivel de riesgo
      final riskLevel = _calculateRiskLevel(totalScore);

      return {
        'totalScore': totalScore,
        'color': color,
        'riskLevel': riskLevel,
        'ratingsCount': ratings.length,
      };
    } catch (e) {
      throw Exception('Error al calcular calificación: $e');
    }
  }

  /// Calcular puntuación total
  double _calculateTotalScore(List<RatingEntity> ratings) {
    double total = 0.0;
    
    for (final rating in ratings) {
      // Convertir nivel a puntuación numérica
      final score = _levelToScore(rating.level);
      total += score;
    }
    
    return total / ratings.length; // Promedio
  }

  /// Convertir nivel a puntuación
  double _levelToScore(String level) {
    switch (level.toLowerCase()) {
      case 'muy bajo':
        return 1.0;
      case 'bajo':
        return 2.0;
      case 'medio':
        return 3.0;
      case 'alto':
        return 4.0;
      case 'muy alto':
        return 5.0;
      default:
        return 0.0;
    }
  }

  /// Calcular color basado en puntuación
  String _calculateColor(double score) {
    if (score <= 1.5) return 'green';
    if (score <= 2.5) return 'yellow';
    if (score <= 3.5) return 'orange';
    if (score <= 4.5) return 'red';
    return 'dark_red';
  }

  /// Calcular nivel de riesgo
  String _calculateRiskLevel(double score) {
    if (score <= 1.5) return 'Muy Bajo';
    if (score <= 2.5) return 'Bajo';
    if (score <= 3.5) return 'Medio';
    if (score <= 4.5) return 'Alto';
    return 'Muy Alto';
  }
}
