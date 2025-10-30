import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:caja_herramientas/app/core/theme/dagrd_colors.dart';
import '../bloc/risk_threat_analysis_bloc.dart';
import '../bloc/risk_threat_analysis_state.dart';
import '../bloc/risk_threat_analysis_event.dart';
import '../widgets/widgets.dart';
import 'package:caja_herramientas/app/shared/models/risk_event_model.dart';
import 'package:caja_herramientas/app/shared/models/risk_event_factory.dart';
import '../../../home/presentation/bloc/home_bloc.dart';
import '../../../../shared/services/form_persistence_service.dart';

class FinalRiskResultsScreen extends StatefulWidget {
  const FinalRiskResultsScreen({super.key});

  @override
  State<FinalRiskResultsScreen> createState() => _FinalRiskResultsScreenState();
}

class _FinalRiskResultsScreenState extends State<FinalRiskResultsScreen> {
  bool _hasLoadedData = false;

  @override
  void initState() {
    super.initState();
  }

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
                  color: DAGRDColors.azulDAGRD,
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
                  color: DAGRDColors.azulDAGRD, // AzulDAGRD
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
                  color: DAGRDColors.azulDAGRD, // AzulDAGRD
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

    // Obtener subclasificaciones de amenaza
    final amenazaSubClassifications = ['probabilidad', 'intensidad'];

    return Column(
      children: amenazaSubClassifications.asMap().entries.map((entry) {
        final index = entry.key;
        final subClassId = entry.value;

        // Usar el método centralizado del BLoC para obtener items
        final items = bloc.getItemsForSubClassification(subClassId);
        final score = bloc.calculateSectionScore(subClassId);

        // Obtener el nombre de la subclasificación desde el evento
        final riskEvent = _getRiskEventByName(state.selectedRiskEvent ?? '');
        String title = subClassId;
        if (riskEvent != null) {
          final classification = riskEvent.classifications.firstWhere(
            (c) => c.id == 'amenaza',
            orElse: () => riskEvent.classifications.first,
          );
          final subClass = classification.subClassifications.firstWhere(
            (s) => s.id == subClassId,
            orElse: () => classification.subClassifications.first,
          );
          title = subClass.name;
        }

        return Column(
          children: [
            if (index > 0) const SizedBox(height: 24),
            RatingSectionWidget(title: title, score: score, items: items),
          ],
        );
      }).toList(),
    );
  }

  Widget _buildAmenazaRatingCard(
    BuildContext context,
    RiskThreatAnalysisState state,
  ) {
    return const ClassificationRatingCardWidget(classificationType: 'amenaza');
  }

  // Métodos para construir secciones de Vulnerabilidad
  Widget _buildVulnerabilidadSections(
    BuildContext context,
    RiskThreatAnalysisState state,
  ) {
    final bloc = context.read<RiskThreatAnalysisBloc>();

    // Obtener subclasificaciones de vulnerabilidad desde el evento
    final riskEvent = _getRiskEventByName(state.selectedRiskEvent ?? '');
    List<String> vulnerabilidadSubClassifications = [];

    if (riskEvent != null) {
      final classification = riskEvent.classifications.firstWhere(
        (c) => c.id == 'vulnerabilidad',
        orElse: () => riskEvent.classifications.first,
      );
      vulnerabilidadSubClassifications = classification.subClassifications
          .map((s) => s.id)
          .toList();
    }

    return Column(
      children: vulnerabilidadSubClassifications.asMap().entries.map((entry) {
        final index = entry.key;
        final subClassId = entry.value;

        // Construir items manualmente para vulnerabilidad
        final items = _buildVulnerabilidadItems(
          bloc,
          state,
          subClassId,
          riskEvent,
        );
        final score = bloc.calculateSectionScore(subClassId);

        // Obtener el nombre de la subclasificación
        String title = subClassId;
        if (riskEvent != null) {
          final classification = riskEvent.classifications.firstWhere(
            (c) => c.id == 'vulnerabilidad',
            orElse: () => riskEvent.classifications.first,
          );
          final subClass = classification.subClassifications.firstWhere(
            (s) => s.id == subClassId,
            orElse: () => classification.subClassifications.first,
          );
          title = subClass.name;
        }

        return Column(
          children: [
            if (index > 0) const SizedBox(height: 24),
            RatingSectionWidget(title: title, score: score, items: items),
          ],
        );
      }).toList(),
    );
  }

  Widget _buildVulnerabilidadRatingCard(
    BuildContext context,
    RiskThreatAnalysisState state,
  ) {
    return const ClassificationRatingCardWidget(
      classificationType: 'vulnerabilidad',
    );
  }

  // Método auxiliar para construir items de vulnerabilidad
  List<Map<String, dynamic>> _buildVulnerabilidadItems(
    RiskThreatAnalysisBloc bloc,
    RiskThreatAnalysisState state,
    String subClassId,
    RiskEventModel? riskEvent,
  ) {
    final items = <Map<String, dynamic>>[];

    if (riskEvent != null) {
      final classification = riskEvent.classifications.firstWhere(
        (c) => c.id == 'vulnerabilidad',
        orElse: () => riskEvent.classifications.first,
      );

      final subClass = classification.subClassifications.firstWhere(
        (s) => s.id == subClassId,
        orElse: () => classification.subClassifications.first,
      );

      for (final category in subClass.categories) {
        final selections = state.dynamicSelections[subClassId] ?? {};
        final selection = selections[category.title];

        final rating = _getRatingFromSelection(selection);
        final color = DAGRDColors.getNivelColorFromRating(rating);

        String title = category.title;
        if (rating == -1) {
          title = '${category.title} - No Aplica';
        } else if (rating == 0) {
          title = '${category.title} - Sin calificar';
        }
        List<String>? detailedItems;
        if (rating > 0 && rating <= category.detailedLevels.length) {
          final levelIndex = rating - 1;
          final level = category.detailedLevels[levelIndex];
          detailedItems = level.items;
        }

        items.add({
          'rating': rating,
          'title': title,
          'color': color,
          'detailedItems': detailedItems,
        });
      }
    }

    return items;
  }

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
              color: DAGRDColors.azulSecundario, // Azul informativo
            ),
            const SizedBox(width: 8),
            Text(
              text,
              style: const TextStyle(
                color: DAGRDColors.azulSecundario, // Azul informativo
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
