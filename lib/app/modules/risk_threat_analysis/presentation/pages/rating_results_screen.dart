import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/risk_threat_analysis_bloc.dart';
import '../bloc/risk_threat_analysis_state.dart';
import '../widgets/widgets.dart';

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

    // Usar la misma lógica que el RatingScreen - obtener subclasificaciones desde el BLoC
    final subClassifications = bloc.getCurrentSubClassifications();

    return Column(
      children: subClassifications.asMap().entries.map((entry) {
        final index = entry.key;
        final subClassification = entry.value;
        
        // Construir items para esta subclasificación
        final items = _buildItemsForSubClassification(bloc, state, subClassification.id);
        final score = _calculateSectionScore(items);
        
        return Column(
          children: [
            if (index > 0) const SizedBox(height: 24),
            RatingSectionWidget(
              title: subClassification.name,
              score: score,
              items: items,
            ),
          ],
        );
      }).toList(),
    );
  }

  List<Map<String, dynamic>> _buildItemsForSubClassification(
    RiskThreatAnalysisBloc bloc,
    RiskThreatAnalysisState state,
    String subClassificationId,
  ) {
    // Usar la misma lógica que el RatingScreen para obtener categorías
    try {
      final categories = bloc.getCategoriesForCurrentSubClassification(subClassificationId);
      final items = <Map<String, dynamic>>[];
      
      // Crear items basados en las categorías obtenidas del BLoC
      for (final category in categories) {
        // Buscar la selección según el tipo de subclasificación
        String? selection;
        if (subClassificationId == 'probabilidad') {
          selection = state.probabilidadSelections[category.title];
        } else if (subClassificationId == 'intensidad') {
          selection = state.intensidadSelections[category.title];
        } else {
          // Para vulnerabilidad, usar dynamicSelections
          final selections = state.dynamicSelections[subClassificationId] ?? {};
          selection = selections[category.title];
        }

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
      
      return items;
    } catch (e) {
      print('Error al obtener items para subclasificación $subClassificationId: $e');
      return [];
    }
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

    // Usar la misma lógica que el RatingScreen - obtener el texto formateado directamente del BLoC
    final formattedRating = bloc.getFormattedThreatRating();
    
    // Parsear el texto formateado para extraer el score y el nivel
    final parts = formattedRating.split(' ');
    String scoreText = '0,0';
    String ratingText = 'SIN CALIFICAR';
    
    if (parts.length >= 2) {
      scoreText = parts[0].replaceAll('.', ',');
      ratingText = parts.sublist(1).join(' ');
    }

    return ThreatRatingCardWidget(
      title: title,
      score: scoreText,
      ratingText: ratingText,
    );
  }





}
