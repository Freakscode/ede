import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:caja_herramientas/app/core/theme/dagrd_colors.dart';
import 'package:caja_herramientas/app/core/icons/app_icons.dart';
import 'package:caja_herramientas/app/modules/home/ui/widgets/home_tool_card.dart';
import 'package:caja_herramientas/app/modules/home/bloc/home_bloc.dart';
import 'package:caja_herramientas/app/modules/home/bloc/home_event.dart';
import 'package:caja_herramientas/app/shared/widgets/dialogs/forms_in_progress_dialog.dart';
import 'package:caja_herramientas/app/modules/risk_threat_analysis/bloc/risk_threat_analysis_bloc.dart';
import 'package:caja_herramientas/app/modules/risk_threat_analysis/bloc/risk_threat_analysis_event.dart';
import 'package:go_router/go_router.dart';

class HomeMainSection extends StatefulWidget {
  const HomeMainSection({super.key});

  @override
  State<HomeMainSection> createState() => _HomeMainSectionState();
}

class _HomeMainSectionState extends State<HomeMainSection> {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 28),
          const Center(
            child: Text(
              'Seleccione una herramienta',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: DAGRDColors.azulDAGRD,
                fontFamily: 'Work Sans',
                fontSize: 20,
                fontWeight: FontWeight.w600,
                height: 1.4,
              ),
            ),
          ),
          const SizedBox(height: 24),
          HomeToolCard(
            title: 'Metodología de Análisis del Riesgo',
            iconAsset: AppIcons.analisisRiesgo,
            backgroundColor: DAGRDColors.azulDAGRD,
            onTap: () {
              _handleRiskAnalysisTap(context);
            },
          ),
          const SizedBox(height: 23),
          HomeToolCard(
            title: 'Evaluación del daño en edificaciones EDE',
            iconAsset: AppIcons.danoEdificaciones,
            backgroundColor: DAGRDColors.azulDAGRD,
            onTap: () {
              context.go('/home_ede');
            },
          ),
          const SizedBox(height: 23),
          HomeToolCard(
            title: 'Formulario de caracterización de movimientos en masa',
            iconAsset: AppIcons.danoEdificaciones,
            backgroundColor: DAGRDColors.azulDAGRD,
            onTap: () {},
          ),
          const SizedBox(height: 48),
          GestureDetector(
            onTap: () {
              context.go('/login');

            },
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: DAGRDColors.amarDAGRD, width: 1),
                color: Colors.white,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SvgPicture.asset(
                    AppIcons.globe,
                    width: 24,
                    height: 24,
                    colorFilter: const ColorFilter.mode(
                      Color(0xFF1E1E1E),
                      BlendMode.srcIn,
                    ),
                  ),
                  const SizedBox(width: 12),
                  const Text(
                    'Ir a portal SIRMED',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Color(0xFF1E1E1E),
                      fontFamily: 'Work Sans',
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      height: 1.71,
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }

  void _handleRiskAnalysisTap(BuildContext context) {
    final homeBloc = context.read<HomeBloc>();
    final homeState = homeBloc.state;
    
    // Contar formularios pendientes (evaluaciones completadas parcialmente)
    int pendingFormsCount = 0;
    homeState.completedEvaluations.forEach((key, value) {
      if (value) pendingFormsCount++;
    });
    
    // Siempre mostrar el dialog
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext dialogContext) {
        return FormsInProgressDialog(
          pendingFormsCount: pendingFormsCount,
          onViewForms: () {
            if (context.mounted) {
                context.read<HomeBloc>().add(HomeNavBarTapped(2));
              }
          },
          onCreateNew: () {
            context.read<HomeBloc>().add(ResetAllForNewForm());
            
            try {
              final riskBloc = context.read<RiskThreatAnalysisBloc>();
              riskBloc.add(ResetDropdowns());
            } catch (e) {
              print('RiskThreatAnalysisBloc no disponible en este contexto: $e');
            }
            
            Future.delayed(const Duration(milliseconds: 100), () {
              if (context.mounted) {
                context.read<HomeBloc>().add(HomeShowRiskEventsSection());
              }
            });
          },
        );
      },
    );
  }
}
