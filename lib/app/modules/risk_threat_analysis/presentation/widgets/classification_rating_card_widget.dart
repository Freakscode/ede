import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/risk_threat_analysis_bloc.dart';
import '../bloc/risk_threat_analysis_state.dart';
import 'threat_rating_card_widget.dart';

/// Widget reutilizable para mostrar la tarjeta de calificación de una clasificación
/// (Amenaza o Vulnerabilidad)
class ClassificationRatingCardWidget extends StatelessWidget {
  /// Tipo de clasificación: 'amenaza' o 'vulnerabilidad'
  final String classificationType;

  const ClassificationRatingCardWidget({
    super.key,
    required this.classificationType,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<RiskThreatAnalysisBloc, RiskThreatAnalysisState>(
      builder: (context, state) {
        final bloc = context.read<RiskThreatAnalysisBloc>();
        
        // Calcular el score según el tipo de clasificación
        final finalScore = classificationType.toLowerCase() == 'amenaza'
            ? bloc.calculateAmenazaGlobalScore()
            : bloc.calculateVulnerabilidadFinalScore();
        
        final scoreText = finalScore.toStringAsFixed(2).replaceAll('.', ',');
        final ratingText = _getRiskClassification(finalScore);
        
        // Determinar el título
        final title = classificationType.toLowerCase() == 'amenaza'
            ? 'Calificación Amenaza'
            : 'Calificación Vulnerabilidad';

        return ThreatRatingCardWidget(
          title: title,
          score: scoreText,
          ratingText: ratingText,
        );
      },
    );
  }

  /// Determina la clasificación de riesgo basada en el score
  String _getRiskClassification(double score) {
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
