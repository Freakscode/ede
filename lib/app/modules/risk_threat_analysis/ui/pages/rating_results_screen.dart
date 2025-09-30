import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../bloc/risk_threat_analysis_bloc.dart';
import '../../bloc/risk_threat_analysis_state.dart';
import '../widgets/widgets.dart';
import 'package:caja_herramientas/app/shared/models/risk_event_model.dart';
import 'package:caja_herramientas/app/shared/models/risk_event_factory.dart';

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

              // Componente de Calificación de Amenaza
              const ThreatRatingCardWidget(
                score: '2,3',
                ratingText: 'MEDIO - BAJO',
              ),

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

  Widget _buildAllSections(BuildContext context, RiskThreatAnalysisState state) {
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

  List<Map<String, dynamic>> _buildDynamicSections(RiskThreatAnalysisBloc bloc, RiskThreatAnalysisState state) {
    final sections = <Map<String, dynamic>>[];
    
    // Sección Probabilidad
    final probabilidadItems = _buildProbabilidadItems(bloc, state);
    final probabilidadScore = _calculateSectionScore(probabilidadItems);
    sections.add({
      'title': 'Probabilidad',
      'score': probabilidadScore,
      'items': probabilidadItems,
    });
    
    // Sección Intensidad
    final intensidadItems = _buildIntensidadItems(bloc, state);
    final intensidadScore = _calculateSectionScore(intensidadItems);
    sections.add({
      'title': 'Intensidad',
      'score': intensidadScore,
      'items': intensidadItems,
    });
    
    return sections;
  }

  List<Map<String, dynamic>> _buildProbabilidadItems(RiskThreatAnalysisBloc bloc, RiskThreatAnalysisState state) {
    final items = <Map<String, dynamic>>[];
    
    // Obtener el evento actual y sus categorías de probabilidad
    final selectedEvent = state.selectedRiskEvent;
    final selectedClassification = state.selectedClassification;
    
    // Buscar las categorías de probabilidad para el evento actual
    final riskEvent = _getRiskEventByName(selectedEvent);
    if (riskEvent != null) {
      final classification = riskEvent.classifications
          .firstWhere((c) => c.id == selectedClassification, orElse: () => riskEvent.classifications.first);
      
      final probabilidadSubClass = classification.subClassifications
          .firstWhere((s) => s.id == 'probabilidad', orElse: () => classification.subClassifications.first);
      
      // Crear items basados en las categorías reales del evento
      for (final category in probabilidadSubClass.categories) {
        // Buscar la selección en dynamicSelections usando el ID de la categoría
        final selectionKey = '${selectedClassification}_probabilidad_${category.id}';
        final selectionData = state.dynamicSelections[selectionKey];
        final selection = selectionData?['selectedLevel'];
        
        final rating = _getRatingFromSelection(selection);
        final color = _getColorFromRating(rating);
        
        items.add({
          'rating': rating,
          'title': rating == 0 ? '${category.title} - Sin calificar' : category.title,
          'color': color,
        });
      }
    }
    
    return items;
  }

  List<Map<String, dynamic>> _buildIntensidadItems(RiskThreatAnalysisBloc bloc, RiskThreatAnalysisState state) {
    final items = <Map<String, dynamic>>[];
    
    // Obtener el evento actual y sus categorías de intensidad
    final selectedEvent = state.selectedRiskEvent;
    final selectedClassification = state.selectedClassification;
    
    // Buscar las categorías de intensidad para el evento actual
    final riskEvent = _getRiskEventByName(selectedEvent);
    if (riskEvent != null) {
      final classification = riskEvent.classifications
          .firstWhere((c) => c.id == selectedClassification, orElse: () => riskEvent.classifications.first);
      
      final intensidadSubClass = classification.subClassifications
          .firstWhere((s) => s.id == 'intensidad', orElse: () => classification.subClassifications.first);
      
      // Crear items basados en las categorías reales del evento
      for (final category in intensidadSubClass.categories) {
        // Buscar la selección en dynamicSelections usando el ID de la categoría
        final selectionKey = '${selectedClassification}_intensidad_${category.id}';
        final selectionData = state.dynamicSelections[selectionKey];
        final selection = selectionData?['selectedLevel'];
        
        final rating = _getRatingFromSelection(selection);
        final color = _getColorFromRating(rating);
        
        items.add({
          'rating': rating,
          'title': rating == 0 ? '${category.title} - Sin calificar' : category.title,
          'color': color,
        });
      }
    }
    
    return items;
  }

  int _getRatingFromSelection(String? selectedLevel) {
    if (selectedLevel == null || selectedLevel.isEmpty) return 0;
    
    if (selectedLevel.contains('BAJO') && !selectedLevel.contains('MEDIO')) {
      return 1;
    } else if (selectedLevel.contains('MEDIO') && selectedLevel.contains('ALTO')) {
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
        .where((item) => item['rating'] != 0)
        .map((item) => item['rating'] as int)
        .toList();
    
    if (validRatings.isEmpty) return '0,00';
    
    final average = validRatings.reduce((a, b) => a + b) / validRatings.length;
    return average.toStringAsFixed(2).replaceAll('.', ',');
  }

  RiskEventModel? _getRiskEventByName(String eventName) {
    return RiskEventFactory.getEventByName(eventName);
  }
}
