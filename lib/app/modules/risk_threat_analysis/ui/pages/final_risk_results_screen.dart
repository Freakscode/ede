import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../bloc/risk_threat_analysis_bloc.dart';
import '../../bloc/risk_threat_analysis_state.dart';
import '../widgets/risk_matrix_widget.dart';
import '../widgets/widgets.dart';
import 'package:caja_herramientas/app/shared/models/risk_event_model.dart';
import 'package:caja_herramientas/app/shared/models/risk_event_factory.dart';

class FinalRiskResultsScreen extends StatelessWidget {
  final String eventName;

  const FinalRiskResultsScreen({
    super.key,
    this.eventName = 'Evento de Prueba', // Valor por defecto para desarrollo
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<RiskThreatAnalysisBloc, RiskThreatAnalysisState>(
      builder: (context, state) {
        return SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 26, vertical: 28),
          child: Column(
            children: [
              // Título principal
              Text(
                'Perfil del Riesgo',
                textAlign: TextAlign.center,
                style: const TextStyle(
                  color: Color(0xFF232B48),
                  fontFamily: 'Work Sans',
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                  height: 28 / 20,
                ),
              ),

              const SizedBox(height: 10),

              // Subtítulo
              Text(
                'Amenaza',
                textAlign: TextAlign.center,
                style: const TextStyle(
                  color: Color(0xFF232B48), // AzulDAGRD
                  fontFamily: 'Work Sans',
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  height: 28 / 18, // 155.556%
                ),
              ),

              const SizedBox(height: 24),

              // Secciones de Amenaza
              _buildAmenazaSections(context, state),

              const SizedBox(height: 24),

              // Calificación de Amenaza
              _buildAmenazaRatingCard(context, state),

              const SizedBox(height: 32),

              // Botón Ir a Análisis de la Amenaza
              _buildAnalysisButton(
                context,
                'Ir a Análisis de la Amenaza',
                () {},
              ),

              const SizedBox(height: 24),
              Text(
                'Vulnerabilidad',
                textAlign: TextAlign.center,
                style: const TextStyle(
                  color: Color(0xFF232B48), // AzulDAGRD
                  fontFamily: 'Work Sans',
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  height: 28 / 18, // 155.556%
                ),
              ),
              const SizedBox(height: 24),

              // Secciones de Vulnerabilidad
              _buildVulnerabilidadSections(context, state),

              const SizedBox(height: 24),

              // Calificación de Vulnerabilidad
              _buildVulnerabilidadRatingCard(context, state),
              const SizedBox(height: 24),

              _buildAnalysisButton(
                context,
                'Ir a Análisis de la Vulnerabilidad',
                () {},
              ),

              const SizedBox(height: 24),

              // Matriz de Riesgo Final
              RiskMatrixWidget(state: state),
              const SizedBox(height: 24),

              NavigationButtonsWidget(
                currentIndex: state.currentBottomNavIndex,
                onContinuePressed: () {
                  // Si estamos en la pestaña de resultados (índice 2) con FinalResults
                  if (state.currentBottomNavIndex == 2 && state.showFinalResults) {
                    // Navegar a la pantalla de inicio
                    context.go('/home');
                  }
                },
              ),

              const SizedBox(height: 50),
            ],
          ),
        );
      },
    );
  }

  // Métodos para construir secciones de Amenaza
  Widget _buildAmenazaSections(
    BuildContext context,
    RiskThreatAnalysisState state,
  ) {
    final bloc = context.read<RiskThreatAnalysisBloc>();

    // Construir secciones de probabilidad e intensidad para amenaza
    final probabilidadItems = _buildProbabilidadItems(bloc, state);
    final probabilidadScore = _calculateSectionScore(probabilidadItems);

    final intensidadItems = _buildIntensidadItems(bloc, state);
    final intensidadScore = _calculateSectionScore(intensidadItems);

    return Column(
      children: [
        RatingSectionWidget(
          title: 'Probabilidad',
          score: probabilidadScore,
          items: probabilidadItems,
        ),
        const SizedBox(height: 24),
        RatingSectionWidget(
          title: 'Intensidad',
          score: intensidadScore,
          items: intensidadItems,
        ),
      ],
    );
  }

  Widget _buildAmenazaRatingCard(
    BuildContext context,
    RiskThreatAnalysisState state,
  ) {
    final bloc = context.read<RiskThreatAnalysisBloc>();
    final finalScore = bloc.calculateAmenazaGlobalScore();
    final scoreText = finalScore.toStringAsFixed(2).replaceAll('.', ',');
    final ratingText = _getRiskClassification(finalScore);

    return ThreatRatingCardWidget(
      title: 'Calificación Amenaza',
      score: scoreText,
      ratingText: ratingText,
    );
  }

  // Métodos para construir secciones de Vulnerabilidad
  Widget _buildVulnerabilidadSections(
    BuildContext context,
    RiskThreatAnalysisState state,
  ) {
    final bloc = context.read<RiskThreatAnalysisBloc>();
    final sections = _buildVulnerabilidadSectionsList(bloc, state);

    return Column(
      children: sections.asMap().entries.map((entry) {
        final index = entry.key;
        final section = entry.value;
        return Column(
          children: [
            if (index > 0) const SizedBox(height: 24),
            RatingSectionWidget(
              title: section['title'] as String,
              score: section['score'] as String,
              items: section['items'] as List<Map<String, dynamic>>,
            ),
          ],
        );
      }).toList(),
    );
  }

  Widget _buildVulnerabilidadRatingCard(
    BuildContext context,
    RiskThreatAnalysisState state,
  ) {
    final bloc = context.read<RiskThreatAnalysisBloc>();
    final finalScore = bloc.calculateVulnerabilidadFinalScore();
    final scoreText = finalScore.toStringAsFixed(2).replaceAll('.', ',');
    final ratingText = _getRiskClassification(finalScore);

    return ThreatRatingCardWidget(
      title: 'Calificación Vulnerabilidad',
      score: scoreText,
      ratingText: ratingText,
    );
  }

  // Métodos auxiliares adaptados de RatingResultsScreen
  List<Map<String, dynamic>> _buildProbabilidadItems(
    RiskThreatAnalysisBloc bloc,
    RiskThreatAnalysisState state,
  ) {
    
    final items = <Map<String, dynamic>>[];
    final selectedEvent = state.selectedRiskEvent;

    final riskEvent = _getRiskEventByName(selectedEvent);
    if (riskEvent != null) {
      final classification = riskEvent.classifications.firstWhere(
        (c) => c.id == 'amenaza',
        orElse: () => riskEvent.classifications.first,
      );

      final probabilidadSubClass = classification.subClassifications.firstWhere(
        (s) => s.id == 'probabilidad',
        orElse: () => classification.subClassifications.first,
      );

      for (final category in probabilidadSubClass.categories) {
        final selection = state.probabilidadSelections[category.title];
        final rating = _getRatingFromSelection(selection);
        final color = _getColorFromRating(rating);

        String title = category.title;
        if (rating == -1) {
          title = '${category.title} - No Aplica';
        } else if (rating == 0) {
          title = '${category.title} - Sin calificar';
        }

        items.add({'rating': rating, 'title': title, 'color': color});
      }
    }

    return items;
  }

  List<Map<String, dynamic>> _buildIntensidadItems(
    RiskThreatAnalysisBloc bloc,
    RiskThreatAnalysisState state,
  ) {
    
    final items = <Map<String, dynamic>>[];
    final selectedEvent = state.selectedRiskEvent;

    final riskEvent = _getRiskEventByName(selectedEvent);
    if (riskEvent != null) {
      final classification = riskEvent.classifications.firstWhere(
        (c) => c.id == 'amenaza',
        orElse: () => riskEvent.classifications.first,
      );

      final intensidadSubClass = classification.subClassifications.firstWhere(
        (s) => s.id == 'intensidad',
        orElse: () => classification.subClassifications.first,
      );

      for (final category in intensidadSubClass.categories) {
        final selection = state.intensidadSelections[category.title];
        final rating = _getRatingFromSelection(selection);
        final color = _getColorFromRating(rating);

        String title = category.title;
        if (rating == -1) {
          title = '${category.title} - No Aplica';
        } else if (rating == 0) {
          title = '${category.title} - Sin calificar';
        }

        items.add({'rating': rating, 'title': title, 'color': color});
      }
    }

    return items;
  }

  List<Map<String, dynamic>> _buildVulnerabilidadSectionsList(
    RiskThreatAnalysisBloc bloc,
    RiskThreatAnalysisState state,
  ) {
    final sections = <Map<String, dynamic>>[];
    final selectedEvent = state.selectedRiskEvent;

    final riskEvent = _getRiskEventByName(selectedEvent);
    if (riskEvent != null) {
      final classification = riskEvent.classifications.firstWhere(
        (c) => c.id == 'vulnerabilidad',
        orElse: () => riskEvent.classifications.first,
      );

      for (final subClassification in classification.subClassifications) {
        final items = _buildVulnerabilidadSubClassificationItems(
          bloc,
          state,
          subClassification.id,
        );
        final score = _calculateSectionScore(items);

        sections.add({
          'title': subClassification.name,
          'score': score,
          'items': items,
        });
      }
    }

    return sections;
  }

  List<Map<String, dynamic>> _buildVulnerabilidadSubClassificationItems(
    RiskThreatAnalysisBloc bloc,
    RiskThreatAnalysisState state,
    String subClassificationId,
  ) {
    final items = <Map<String, dynamic>>[];
    final selectedEvent = state.selectedRiskEvent;

    final riskEvent = _getRiskEventByName(selectedEvent);
    if (riskEvent != null) {
      final classification = riskEvent.classifications.firstWhere(
        (c) => c.id == 'vulnerabilidad',
        orElse: () => riskEvent.classifications.first,
      );

      final subClass = classification.subClassifications.firstWhere(
        (s) => s.id == subClassificationId,
        orElse: () => classification.subClassifications.first,
      );

      for (final category in subClass.categories) {
        final selections = state.dynamicSelections[subClassificationId] ?? {};
        final selection = selections[category.title];

        final rating = _getRatingFromSelection(selection);
        final color = _getColorFromRating(rating);

        String title = category.title;
        if (rating == -1) {
          title = '${category.title} - No Aplica';
        } else if (rating == 0) {
          title = '${category.title} - Sin calificar';
        }

        items.add({'rating': rating, 'title': title, 'color': color});
      }
    }

    return items;
  }

  // Métodos auxiliares
  int _getRatingFromSelection(String? selectedLevel) {
    if (selectedLevel == null || selectedLevel.isEmpty) return 0;
    if (selectedLevel == 'NA') return -1;

    if (selectedLevel.contains('BAJO') && !selectedLevel.contains('MEDIO')) {
      return 1;
    } else if (selectedLevel.contains('MEDIO') &&
        selectedLevel.contains('ALTO')) {
      return 3;
    } else if (selectedLevel.contains('MEDIO')) {
      return 2;
    } else if (selectedLevel.contains('ALTO')) {
      return 4;
    }
    return 0;
  }

  Color _getColorFromRating(int rating) {
    switch (rating) {
      case -1:
        return const Color(0xFF6B7280);
      case 1:
        return Colors.green;
      case 2:
        return Colors.yellow;
      case 3:
        return Colors.orange;
      case 4:
        return Colors.red;
      default:
        return const Color(0xFF9CA3AF);
    }
  }

  String _calculateSectionScore(List<Map<String, dynamic>> items) {
    final validRatings = items
        .where((item) => item['rating'] != 0 && item['rating'] != -1)
        .map((item) => item['rating'] as int)
        .toList();

    if (validRatings.isEmpty) return '0,00';

    final average = validRatings.reduce((a, b) => a + b) / validRatings.length;
    return average.toStringAsFixed(2).replaceAll('.', ',');
  }

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

  RiskEventModel? _getRiskEventByName(String eventName) {
    return RiskEventFactory.getEventByName(eventName);
  }

  Widget _buildAnalysisButton(
    BuildContext context,
    String text,
    VoidCallback onPressed,
  ) {
    return SizedBox(
      width: double.infinity,
      child: TextButton(
        onPressed: onPressed,
        style: TextButton.styleFrom(
          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
          backgroundColor: Colors.transparent,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.arrow_back_ios,
              size: 16,
              color: Color(0xFF2563EB), // Azul informativo
            ),
            const SizedBox(width: 8),
            Text(
              text,
              style: const TextStyle(
                color: Color(0xFF2563EB), // Azul informativo
                fontFamily: 'Work Sans',
                fontSize: 15,
                fontWeight: FontWeight.w500,
                height: 16 / 15, // 106.667%
              ),
            ),
          ],
        ),
      ),
    );
  }
}
