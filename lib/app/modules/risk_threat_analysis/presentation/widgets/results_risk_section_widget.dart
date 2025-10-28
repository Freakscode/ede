import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:caja_herramientas/app/core/icons/app_icons.dart';
import 'package:caja_herramientas/app/core/theme/dagrd_colors.dart';
import 'package:caja_herramientas/app/modules/home/presentation/bloc/home_bloc.dart';
import 'package:caja_herramientas/app/modules/home/presentation/bloc/home_state.dart';
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

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HomeBloc, HomeState>(
      builder: (context, homeState) {
        // Verificar si amenaza y vulnerabilidad están completas
        final riskBloc = context.read<RiskThreatAnalysisBloc>();
        final isAmenazaComplete = riskBloc.isCategoryComplete('amenaza');
        final isVulnerabilidadComplete = riskBloc.isCategoryComplete('vulnerabilidad');
        final isEnabled = isAmenazaComplete && isVulnerabilidadComplete;
        
        return GestureDetector(
          onTap: isEnabled ? () {
            // Navegar a la pantalla de resultados finales (índice 4)
            context.read<RiskThreatAnalysisBloc>().add(ChangeBottomNavIndex(4));
          } : null,
          child: Container(
            padding: const EdgeInsets.symmetric(
              vertical: 10,
              horizontal: 20,
            ),
            decoration: BoxDecoration(
              color: isEnabled ? DAGRDColors.amarDAGRD : DAGRDColors.outline,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              children: [
                Container(
                  width: 48,
                  height: 48,
                  padding: const EdgeInsets.all(9.882),
                  decoration: BoxDecoration(
                    color: isEnabled ? DAGRDColors.azulDAGRD : DAGRDColors.outlineVariant,
                    borderRadius: BorderRadius.circular(24),
                  ),
                  child: SvgPicture.asset(
                    AppIcons.warning,
                    width: 24.707,
                    height: 22.059,
                    colorFilter: ColorFilter.mode(
                      isEnabled ? DAGRDColors.amarDAGRD : DAGRDColors.onSurfaceVariant,
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
                        style: TextStyle(
                          color: isEnabled ? const Color(0xFF1E1E1E) : DAGRDColors.onSurfaceVariant,
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
                        style: TextStyle(
                          color: isEnabled ? const Color(0xFF1E1E1E) : DAGRDColors.onSurfaceVariant,
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
      },
    );
  }
}