import 'package:caja_herramientas/app/shared/widgets/dialogs/confirmation_dialog.dart';
import 'package:caja_herramientas/app/shared/widgets/dialogs/custom_action_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../bloc/risk_threat_analysis_bloc.dart';
import '../../bloc/risk_threat_analysis_state.dart';
import '../widgets/widgets.dart';
import 'package:caja_herramientas/app/shared/models/risk_event_model.dart';
import 'package:caja_herramientas/app/shared/models/risk_event_factory.dart';
import '../../../home/bloc/home_bloc.dart';
import '../../../home/bloc/home_event.dart';

class RatingResultsScreen extends StatelessWidget {
  const RatingResultsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<RiskThreatAnalysisBloc, RiskThreatAnalysisState>(
      builder: (context, state) {
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 26, vertical: 28),
          child: Column(
            children: [
              Text(
                'Metodología de Análisis del Riesgo',
                textAlign: TextAlign.center,
                style: const TextStyle(
                  color: Color(0xFF232B48),
                  fontFamily: 'Work Sans',
                  fontSize: 20,
                  fontStyle: FontStyle.normal,
                  fontWeight: FontWeight.w600,
                  height: 28 / 20,
                ),
              ),
              const SizedBox(height: 24),
              _buildAllSections(context, state),
              const SizedBox(height: 24),

              // Componente de Calificación dinámico
              _buildThreatRatingCard(context, state),

              const SizedBox(height: 14),

              // Barra de progreso dinámica
              const ProgressBarWidget(),

              const SizedBox(height: 40),

              // Botones de navegación
              NavigationButtonsWidget(
                currentIndex: state.currentBottomNavIndex,
                onContinuePressed: () {
                  // Si estamos en la última pestaña (índice 2)
                  if (state.currentBottomNavIndex == 2) {
                    if (state.selectedClassification.toLowerCase() ==
                        'amenaza') {
                      // Guardar datos del formulario antes de marcar como completada
                      final riskBloc = context.read<RiskThreatAnalysisBloc>();
                      final formData = riskBloc.getCurrentFormData();

                      // PRINT COMPLETO DEL OBJETO DILIGENCIADO
                      print('=== OBJETO COMPLETO AMENAZA DILIGENCIADO ===');
                      print('Evento: ${state.selectedRiskEvent}');
                      print('Clasificación: amenaza');
                      print('Datos completos del formulario:');
                      print(formData.toString());
                      print('=== FIN DEL OBJETO ===');

                      context.read<HomeBloc>().add(
                        SaveRiskEventModel(
                          state.selectedRiskEvent,
                          'amenaza',
                          formData,
                        ),
                      );

                      // Marcar amenaza como completada
                      context.read<HomeBloc>().add(
                        MarkEvaluationCompleted(
                          state.selectedRiskEvent,
                          'amenaza',
                        ),
                      );

                      CustomActionDialog.show(
                        context: context,
                        title: 'Finalizar formulario',
                        message:
                            '¿Está seguro que desea finalizar el formulario para la categoría de ${state.selectedClassification}?',
                        leftButtonText: 'Revisar ',
                        leftButtonIcon: Icons.close,
                        rightButtonText: 'Finalizar ',
                        rightButtonIcon: Icons.check,
                        onRightButtonPressed: () {
                          final navigationData = {'showRiskCategories': true};
                          context.go('/home', extra: navigationData);
                        },
                      );
                    } else if (state.selectedClassification.toLowerCase() ==
                        'vulnerabilidad') {
                      // Guardar datos del formulario antes de marcar como completada
                      final riskBloc = context.read<RiskThreatAnalysisBloc>();
                      final formData = riskBloc.getCurrentFormData();

                      // PRINT COMPLETO DEL OBJETO DILIGENCIADO
                      print(
                        '=== OBJETO COMPLETO VULNERABILIDAD DILIGENCIADO ===',
                      );
                      print('Evento: ${state.selectedRiskEvent}');
                      print('Clasificación: vulnerabilidad');
                      print('Datos completos del formulario:');
                      print(formData.toString());
                      print('=== FIN DEL OBJETO ===');

                      context.read<HomeBloc>().add(
                        SaveRiskEventModel(
                          state.selectedRiskEvent,
                          'vulnerabilidad',
                          formData,
                        ),
                      );

                      // Marcar vulnerabilidad como completada
                      context.read<HomeBloc>().add(
                        MarkEvaluationCompleted(
                          state.selectedRiskEvent,
                          'vulnerabilidad',
                        ),
                      );

                      // Navegar de vuelta al HomeScreen con RiskCategoriesScreen activo
                      final navigationData = {'showRiskCategories': true};
                      context.go('/home', extra: navigationData);

                      // Mostrar mensaje de éxito para vulnerabilidad
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text(
                            'Evaluación de Vulnerabilidad completada. ¡Evaluación de riesgo finalizada!',
                          ),
                          backgroundColor: Colors.green,
                          duration: Duration(seconds: 3),
                        ),
                      );
                    }
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

  Widget _buildAllSections(
    BuildContext context,
    RiskThreatAnalysisState state,
  ) {
    final bloc = context.read<RiskThreatAnalysisBloc>();

    // Obtener datos dinámicos desde el BLoC
    final sections = _buildDynamicSections(bloc, state);

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

  List<Map<String, dynamic>> _buildDynamicSections(
    RiskThreatAnalysisBloc bloc,
    RiskThreatAnalysisState state,
  ) {
    final sections = <Map<String, dynamic>>[];

    if (state.selectedClassification.toLowerCase() == 'amenaza') {
      // Secciones para Amenaza
      final probabilidadItems = _buildProbabilidadItems(bloc, state);
      final probabilidadScore = _calculateSectionScore(probabilidadItems);
      sections.add({
        'title': 'Probabilidad',
        'score': probabilidadScore,
        'items': probabilidadItems,
      });

      final intensidadItems = _buildIntensidadItems(bloc, state);
      final intensidadScore = _calculateSectionScore(intensidadItems);
      sections.add({
        'title': 'Intensidad',
        'score': intensidadScore,
        'items': intensidadItems,
      });
    } else {
      // Secciones para Vulnerabilidad
      final vulnerabilidadSections = _buildVulnerabilidadSections(bloc, state);
      sections.addAll(vulnerabilidadSections);
    }

    return sections;
  }

  List<Map<String, dynamic>> _buildProbabilidadItems(
    RiskThreatAnalysisBloc bloc,
    RiskThreatAnalysisState state,
  ) {
    final items = <Map<String, dynamic>>[];

    // Obtener el evento actual y sus categorías de probabilidad
    final selectedEvent = state.selectedRiskEvent;
    final selectedClassification = state.selectedClassification;

    // Buscar las categorías de probabilidad para el evento actual
    final riskEvent = _getRiskEventByName(selectedEvent);
    if (riskEvent != null) {
      final classification = riskEvent.classifications.firstWhere(
        (c) => c.id == selectedClassification,
        orElse: () => riskEvent.classifications.first,
      );

      final probabilidadSubClass = classification.subClassifications.firstWhere(
        (s) => s.id == 'probabilidad',
        orElse: () => classification.subClassifications.first,
      );

      // Crear items basados en las categorías reales del evento
      for (final category in probabilidadSubClass.categories) {
        // Buscar la selección usando el sistema legacy para probabilidad
        final selection = state.probabilidadSelections[category.title];

        final rating = _getRatingFromSelection(selection);
        final color = _getColorFromRating(rating);

        String title = category.title;
        if (rating == -1) {
          title = category.title;
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

    // Obtener el evento actual y sus categorías de intensidad
    final selectedEvent = state.selectedRiskEvent;
    final selectedClassification = state.selectedClassification;

    // Buscar las categorías de intensidad para el evento actual
    final riskEvent = _getRiskEventByName(selectedEvent);
    if (riskEvent != null) {
      final classification = riskEvent.classifications.firstWhere(
        (c) => c.id == selectedClassification,
        orElse: () => riskEvent.classifications.first,
      );

      final intensidadSubClass = classification.subClassifications.firstWhere(
        (s) => s.id == 'intensidad',
        orElse: () => classification.subClassifications.first,
      );

      // Crear items basados en las categorías reales del evento
      for (final category in intensidadSubClass.categories) {
        // Buscar la selección usando el sistema legacy para intensidad
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

  int _getRatingFromSelection(String? selectedLevel) {
    if (selectedLevel == null || selectedLevel.isEmpty) return 0;

    // Si es "No Aplica", devolver -1 para diferenciarlo
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
        return const Color(0xFF6B7280); // Gris más oscuro para "No Aplica"
      case 1:
        return Colors.green;
      case 2:
        return Colors.yellow;
      case 3:
        return Colors.orange;
      case 4:
        return Colors.red;
      default:
        return const Color(0xFF9CA3AF); // Gris para sin calificar
    }
  }

  String _calculateSectionScore(List<Map<String, dynamic>> items) {
    final validRatings = items
        .where(
          (item) => item['rating'] != 0 && item['rating'] != -1,
        ) // Excluir 0 (sin calificar) y -1 (NA)
        .map((item) => item['rating'] as int)
        .toList();

    if (validRatings.isEmpty) return '0,00';

    final average = validRatings.reduce((a, b) => a + b) / validRatings.length;
    return average.toStringAsFixed(2).replaceAll('.', ',');
  }

  Widget _buildThreatRatingCard(
    BuildContext context,
    RiskThreatAnalysisState state,
  ) {
    final bloc = context.read<RiskThreatAnalysisBloc>();

    // Determinar el título basado en la clasificación
    final title = state.selectedClassification.toLowerCase() == 'amenaza'
        ? 'Calificación Amenaza'
        : 'Calificación Vulnerabilidad';

    // Calcular el score final
    final finalScore = _calculateFinalScore(bloc, state);
    final scoreText = finalScore.toStringAsFixed(2).replaceAll('.', ',');

    // Determinar la clasificación del riesgo
    final ratingText = _getRiskClassification(finalScore);

    return ThreatRatingCardWidget(
      title: title,
      score: scoreText,
      ratingText: ratingText,
    );
  }

  double _calculateFinalScore(
    RiskThreatAnalysisBloc bloc,
    RiskThreatAnalysisState state,
  ) {
    if (state.selectedClassification.toLowerCase() == 'amenaza') {
      // Para amenaza, usar el cálculo global de amenaza
      return bloc.calculateAmenazaGlobalScore();
    } else {
      // Para vulnerabilidad, usar el cálculo final de vulnerabilidad
      return bloc.calculateVulnerabilidadFinalScore();
    }
  }

  String _getRiskClassification(double score) {
    // Clasificación cualitativa según especificaciones:
    // Entre 1,0 y 1,75 → Bajo
    // Mayor a 1,75 y hasta 2,5 → Medio - Bajo
    // Mayor a 2,5 y hasta 3,25 → Medio - Alto
    // Mayor a 3,25 y hasta 4 → Alto

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

  List<Map<String, dynamic>> _buildVulnerabilidadSections(
    RiskThreatAnalysisBloc bloc,
    RiskThreatAnalysisState state,
  ) {
    final sections = <Map<String, dynamic>>[];
    final selectedEvent = state.selectedRiskEvent;
    final selectedClassification = state.selectedClassification;

    // Buscar las subclasificaciones de vulnerabilidad para el evento actual
    final riskEvent = _getRiskEventByName(selectedEvent);
    if (riskEvent != null) {
      final classification = riskEvent.classifications.firstWhere(
        (c) => c.id == selectedClassification,
        orElse: () => riskEvent.classifications.first,
      );

      // Construir secciones para cada subclasificación de vulnerabilidad
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
    final selectedClassification = state.selectedClassification;

    // Buscar las categorías para esta subclasificación
    final riskEvent = _getRiskEventByName(selectedEvent);
    if (riskEvent != null) {
      final classification = riskEvent.classifications.firstWhere(
        (c) => c.id == selectedClassification,
        orElse: () => riskEvent.classifications.first,
      );

      final subClass = classification.subClassifications.firstWhere(
        (s) => s.id == subClassificationId,
        orElse: () => classification.subClassifications.first,
      );

      // Crear items basados en las categorías reales del evento
      for (final category in subClass.categories) {
        // Buscar la selección en las selecciones dinámicas
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

  RiskEventModel? _getRiskEventByName(String eventName) {
    return RiskEventFactory.getEventByName(eventName);
  }
}
