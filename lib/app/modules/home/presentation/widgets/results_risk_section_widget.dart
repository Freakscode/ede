import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:caja_herramientas/app/core/icons/app_icons.dart';
import '../../presentation/bloc/home_bloc.dart';
import '../../presentation/bloc/home_state.dart';
import 'package:caja_herramientas/app/modules/risk_threat_analysis/presentation/bloc/risk_threat_analysis_bloc.dart';
import 'package:caja_herramientas/app/modules/risk_threat_analysis/presentation/bloc/risk_threat_analysis_event.dart';

class ResultsRiskSectionWidget extends StatelessWidget {
  final HomeState homeState;
  final String selectedEvent;

  const ResultsRiskSectionWidget({
    super.key,
    required this.homeState,
    required this.selectedEvent,
  });

  /// Verifica si tanto Amenaza como Vulnerabilidad están completadas al 100%
  bool _isBothCompleted(BuildContext context) {
    try {
      final riskBloc = context.read<RiskThreatAnalysisBloc>();
      
      // Verificar si Amenaza está completa
      bool amenazaCompleted = false;
      final currentClassification = riskBloc.state.selectedClassification;
      
      // Cambiar temporalmente a amenaza para verificar completitud
      if (currentClassification != 'amenaza') {
        riskBloc.add(const SelectClassification('amenaza'));
      }
      
      final hasUnqualifiedAmenaza = riskBloc.hasUnqualifiedVariables();
      final hasEvidenceAmenaza = riskBloc.state.evidenceImages.isNotEmpty;
      amenazaCompleted = !hasUnqualifiedAmenaza && hasEvidenceAmenaza;
      
      // Cambiar temporalmente a vulnerabilidad para verificar completitud
      if (currentClassification != 'vulnerabilidad') {
        riskBloc.add(const SelectClassification('vulnerabilidad'));
      }
      
      final hasUnqualifiedVulnerabilidad = riskBloc.hasUnqualifiedVariables();
      final hasEvidenceVulnerabilidad = riskBloc.state.evidenceImages.isNotEmpty;
      final vulnerabilidadCompleted = !hasUnqualifiedVulnerabilidad && hasEvidenceVulnerabilidad;
      
      // Restaurar clasificación original
      if (currentClassification != riskBloc.state.selectedClassification) {
        riskBloc.add(SelectClassification(currentClassification ?? ''));
      }
      
      final bothCompleted = amenazaCompleted && vulnerabilidadCompleted;
      
      print('ResultsRiskSectionWidget - amenazaCompleted: $amenazaCompleted');
      print('ResultsRiskSectionWidget - vulnerabilidadCompleted: $vulnerabilidadCompleted');
      print('ResultsRiskSectionWidget - bothCompleted: $bothCompleted');
      
      return bothCompleted;
    } catch (e) {
      print('Error al verificar completitud en ResultsRiskSectionWidget: $e');
      return false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HomeBloc, HomeState>(
      builder: (context, homeState) {
        final bothCompleted = _isBothCompleted(context);
        print('ResultsRiskSectionWidget - bothCompleted: $bothCompleted');
    
    if (bothCompleted) {
      // Mostrar botón de check cuando esté completado
      return GestureDetector(
        onTap: () {
          // Navegar a la pantalla de análisis de riesgo con navigationData
          final navigationData = {
            'event': selectedEvent,
            'finalResults': true,
            'targetIndex': 3,
          };
          context.go('/risk_threat_analysis', extra: navigationData);
        },
        child: Container(
          padding: const EdgeInsets.symmetric(
            vertical: 10,
            horizontal: 20,
          ),
          decoration: BoxDecoration(
            color: const Color(0xFFFFCC00), // Amarillo cuando está habilitado
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: const Color(0xFFFFCC00), width: 1),
          ),
          child: Row(
            children: [
              Container(
                width: 48,
                height: 48,
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: const Color(0xFF232B48), // AzulDAGRD cuando está habilitado
                  borderRadius: BorderRadius.circular(24),
                ),
                child: SvgPicture.asset(
                  AppIcons.checkCircle,
                  width: 24,
                  height: 24,
                  colorFilter: const ColorFilter.mode(
                    Color(0xFFFFCC00), // Amarillo para el check
                    BlendMode.srcIn,
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      'Resultados Riesgo',
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        color: Color(0xFF1E1E1E), // Negro cuando está habilitado
                        fontFamily: 'Work Sans',
                        fontSize: 18,
                        fontStyle: FontStyle.normal,
                        fontWeight: FontWeight.w600,
                        height: 24 / 18,
                      ),
                    ),
                    Text(
                      selectedEvent,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        color: Color(0xFF1E1E1E), // Negro cuando está habilitado
                        fontFamily: 'Work Sans',
                        fontSize: 18,
                        fontStyle: FontStyle.normal,
                        fontWeight: FontWeight.w600,
                        height: 24 / 18,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      );
    } else {
      // Mostrar widget deshabilitado cuando no esté completado
      return Container(
        padding: const EdgeInsets.symmetric(
          vertical: 10,
          horizontal: 20,
        ),
        decoration: BoxDecoration(
          color: const Color(0xFFE5E7EB), // Gris cuando está deshabilitado
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          children: [
            Container(
              width: 48,
              height: 48,
              padding: const EdgeInsets.all(9.882),
              decoration: BoxDecoration(
                color: const Color(0xFFC6C6C6), // Gris cuando está deshabilitado
                borderRadius: BorderRadius.circular(24),
              ),
              child: SvgPicture.asset(
                AppIcons.warning,
                width: 24.707,
                height: 22.059,
                colorFilter: const ColorFilter.mode(
                  Color(0xFF706F6F), // Gris oscuro cuando está deshabilitado
                  BlendMode.srcIn,
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    'Resultados Riesgo',
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      color: Color(0xFF706F6F), // Gris cuando está deshabilitado
                      fontFamily: 'Work Sans',
                      fontSize: 18,
                      fontStyle: FontStyle.normal,
                      fontWeight: FontWeight.w600,
                      height: 24 / 18,
                    ),
                  ),
                  Text(
                    selectedEvent,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      color: Color(0xFF706F6F), // Gris cuando está deshabilitado
                      fontFamily: 'Work Sans',
                      fontSize: 18,
                      fontStyle: FontStyle.normal,
                      fontWeight: FontWeight.w600,
                      height: 24 / 18,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      );
    }
      },
    );
  }
}