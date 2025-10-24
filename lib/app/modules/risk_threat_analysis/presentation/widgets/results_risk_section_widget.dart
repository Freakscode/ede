import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:caja_herramientas/app/core/icons/app_icons.dart';
import 'package:caja_herramientas/app/core/theme/dagrd_colors.dart';
import 'package:caja_herramientas/app/modules/home/presentation/bloc/home_bloc.dart';
import 'package:caja_herramientas/app/modules/home/presentation/bloc/home_state.dart';

class ResultsRiskSectionWidget extends StatelessWidget {
  const ResultsRiskSectionWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HomeBloc, HomeState>(
      builder: (context, homeState) {
        // Verificar si hay resultados disponibles
        final hasResults = _hasResultsAvailable(homeState);
        
        if (!hasResults) {
          return const SizedBox.shrink();
        }

        return Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: DAGRDColors.surfaceVariant,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color: DAGRDColors.success.withOpacity(0.2),
              width: 1,
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(
                    Icons.check_circle_outline,
                    color: DAGRDColors.success,
                    size: 20,
                  ),
                  const SizedBox(width: 8),
                  const Text(
                    'Análisis Completado',
                    style: TextStyle(
                      color: DAGRDColors.success,
                      fontFamily: 'Work Sans',
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              const Text(
                'El análisis de riesgo ha sido completado exitosamente.',
                style: TextStyle(
                  color: DAGRDColors.grisOscuro,
                  fontFamily: 'Work Sans',
                  fontSize: 14,
                  fontWeight: FontWeight.w400,
                  height: 1.4,
                ),
              ),
              const SizedBox(height: 12),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: () => _navigateToResults(context, homeState),
                  icon: SvgPicture.asset(
                    AppIcons.hoja,
                    width: 16,
                    height: 16,
                    colorFilter: const ColorFilter.mode(
                      DAGRDColors.blancoDAGRD,
                      BlendMode.srcIn,
                    ),
                  ),
                  label: const Text(
                    'Ver Resultados',
                    style: TextStyle(
                      color: DAGRDColors.blancoDAGRD,
                      fontFamily: 'Work Sans',
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: DAGRDColors.success,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 12,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  bool _hasResultsAvailable(HomeState homeState) {
    // Verificar si hay un formulario activo y completado
    if (homeState.activeFormId == null || homeState.activeFormId!.isEmpty) {
      return false;
    }

    // Verificar si ambas categorías están completadas
    final selectedEvent = homeState.selectedRiskEvent;
    if (selectedEvent == null || selectedEvent.isEmpty) {
      return false;
    }

    final amenazaCompleted = homeState.isEvaluationCompleted(selectedEvent, 'amenaza');
    final vulnerabilidadCompleted = homeState.isEvaluationCompleted(selectedEvent, 'vulnerabilidad');

    return amenazaCompleted && vulnerabilidadCompleted;
  }

  void _navigateToResults(BuildContext context, HomeState homeState) {
    final selectedEvent = homeState.selectedRiskEvent ?? '';
    final activeFormId = homeState.activeFormId ?? '';

    final navigationData = {
      'event': selectedEvent,
      'finalResults': true,
      'targetIndex': 3, // FinalRiskResultsScreen
      'formId': activeFormId,
    };

    // Navegar a resultados finales
    context.go('/risk-threat-analysis', extra: navigationData);
  }
}
