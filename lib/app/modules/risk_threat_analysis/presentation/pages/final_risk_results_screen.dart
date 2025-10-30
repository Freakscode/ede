import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:caja_herramientas/app/core/theme/dagrd_colors.dart';
import 'package:caja_herramientas/app/core/utils/logger.dart';
import 'package:caja_herramientas/app/modules/home/presentation/bloc/home_bloc.dart';
import 'package:caja_herramientas/app/shared/services/form_persistence_service.dart';
import '../bloc/risk_threat_analysis_bloc.dart';
import '../bloc/risk_threat_analysis_state.dart';
import '../bloc/risk_threat_analysis_event.dart';
import '../widgets/widgets.dart';

class FinalRiskResultsScreen extends StatelessWidget {
  const FinalRiskResultsScreen({super.key});

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
              _buildClassificationSections(context, state, 'amenaza'),

              const SizedBox(height: 24),

              // Calificación de Amenaza
              _buildRatingCard('amenaza'),

              const SizedBox(height: 32),

              // Botón Ir a Análisis de la Amenaza
              _buildAnalysisButton(
                context,
                state,
                'Ir a Análisis de la Amenaza',
                'amenaza',
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
              _buildClassificationSections(context, state, 'vulnerabilidad'),

              const SizedBox(height: 24),

              // Calificación de Vulnerabilidad
              _buildRatingCard('vulnerabilidad'),
              const SizedBox(height: 24),

              _buildAnalysisButton(
                context,
                state,
                'Ir a Análisis de la Vulnerabilidad',
                'vulnerabilidad',
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

  /// Helper para construir rating cards
  static Widget _buildRatingCard(String classificationType) {
    return ClassificationRatingCardWidget(classificationType: classificationType);
  }

  /// Helper genérico para construir secciones de clasificación (amenaza o vulnerabilidad)
  static Widget _buildClassificationSections(
    BuildContext context,
    RiskThreatAnalysisState state,
    String classificationType,
  ) {
    final bloc = context.read<RiskThreatAnalysisBloc>();

    // Obtener IDs de subclasificaciones desde el BLoC
    final subClassificationIds = bloc.getSubClassificationIds(classificationType);

    return Column(
      children: subClassificationIds.asMap().entries.map((entry) {
        final index = entry.key;
        final subClassId = entry.value;

        // Obtener datos usando métodos del BLoC
        final items = bloc.getItemsForSubClassification(subClassId, classificationType);
        final score = bloc.calculateSectionScore(subClassId, classificationType);
        final title = bloc.getSubClassificationName(subClassId, classificationType);

        return Column(
          children: [
            if (index > 0) const SizedBox(height: 24),
            RatingSectionWidget(title: title, score: score, items: items),
          ],
        );
      }).toList(),
    );
  }

  static Widget _buildAnalysisButton(
    BuildContext context,
    RiskThreatAnalysisState state,
    String text,
    String classificationType,
  ) {
    return SizedBox(
      width: double.infinity,
      child: TextButton(
        onPressed: () => _handleAnalysisButtonTap(
          context,
          state,
          classificationType,
        ),
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

  /// Maneja el tap del botón de análisis (igual que en CategoriesScreen)
  static void _handleAnalysisButtonTap(
    BuildContext context,
    RiskThreatAnalysisState state,
    String classificationType,
  ) async {
    final riskBloc = context.read<RiskThreatAnalysisBloc>();

    // Configurar la clasificación seleccionada
    riskBloc.add(SelectClassification(classificationType.toLowerCase()));

    // Si estamos en modo edición, cargar los datos del formulario para esta clasificación
    final homeBloc = context.read<HomeBloc>();
    final homeState = homeBloc.state;

    if (homeState.activeFormId != null && homeState.activeFormId!.isNotEmpty) {
      // Estamos en modo edición, cargar datos específicos para esta clasificación
      try {
        final persistenceService = FormPersistenceService();
        final completeForm = await persistenceService.getCompleteForm(
          homeState.activeFormId!,
        );

        if (completeForm != null) {
          final evaluationData = completeForm.toJson();
          riskBloc.add(
            LoadFormData(
              eventName: completeForm.eventName,
              classificationType: classificationType.toLowerCase(),
              evaluationData: evaluationData,
            ),
          );
        }
      } catch (e) {
        Logger.error(
          'Error loading form data for ${classificationType.toLowerCase()}: $e',
          name: 'FinalRiskResultsScreen',
        );
      }
    }

    // Navegar a RatingScreen (índice 1)
    riskBloc.add(ChangeBottomNavIndex(1));
  }
}
