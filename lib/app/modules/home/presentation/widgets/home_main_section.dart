import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:caja_herramientas/app/core/theme/dagrd_colors.dart';
import 'package:caja_herramientas/app/core/icons/app_icons.dart';
import 'package:caja_herramientas/app/modules/home/presentation/widgets/home_tool_card.dart';
import 'package:caja_herramientas/app/modules/home/presentation/bloc/home_bloc.dart';
import 'package:caja_herramientas/app/modules/home/presentation/bloc/home_event.dart';
import 'package:caja_herramientas/app/shared/widgets/dialogs/forms_in_progress_dialog.dart';
import 'package:caja_herramientas/app/modules/risk_threat_analysis/presentation/bloc/risk_threat_analysis_bloc.dart';
import 'package:caja_herramientas/app/modules/risk_threat_analysis/presentation/bloc/risk_threat_analysis_event.dart'
    as risk_events;
import 'package:caja_herramientas/app/modules/auth/bloc/auth_bloc.dart';
import 'package:caja_herramientas/app/modules/auth/bloc/auth_state.dart';
import 'package:caja_herramientas/app/modules/auth/bloc/events/auth_events.dart';
import 'package:go_router/go_router.dart';

class HomeMainSection extends StatefulWidget {
  const HomeMainSection({super.key});

  @override
  State<HomeMainSection> createState() => _HomeMainSectionState();
}

class _HomeMainSectionState extends State<HomeMainSection> {
  @override
  void initState() {
    super.initState();
    // Verificar el estado de autenticación al iniciar
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<AuthBloc>().add(AuthStatusCheckRequested());
    });
  }

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
              context.go('/sirmed_portal');
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
                      DAGRDColors.onSurface,
                      BlendMode.srcIn,
                    ),
                  ),
                  const SizedBox(width: 12),
                  const Text(
                    'Ir a portal SIRMED',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: DAGRDColors.onSurface,
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
    // Verificar el tipo de usuario
    print('=== DEBUG NAVEGACIÓN ===');
    try {
      final authBloc = context.read<AuthBloc>();
      final authState = authBloc.state;

      if (authState is AuthAuthenticated) {
        print('Usuario autenticado: ${authState.user.nombre}');
        print('Es usuario DAGRD: ${authState.user.isDagrdUser}');

        // Si es usuario general, redirigir a data_registration
        if (!authState.user.isDagrdUser) {
          print('Redirigiendo a data_registration (usuario general)');
          context.go('/data_registration');
          return;
        } else {
          print('Continuando con flujo DAGRD (usuario DAGRD)');
          // Si es usuario DAGRD, continuar con el flujo normal
          final homeBloc = context.read<HomeBloc>();
          final homeState = homeBloc.state;

          // Contar formularios pendientes (formularios en progreso)
          final pendingFormsCount = homeState.inProgressForms.length;

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
                    riskBloc.add(risk_events.ResetDropdowns());
                  } catch (e) {
                    print(
                      'RiskThreatAnalysisBloc no disponible en este contexto: $e',
                    );
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
      } else {
        print('Usuario no autenticado = Usuario General, redirigiendo a data_registration');
        context.go('/data_registration');
        return;
      }
    } catch (e) {
      print('Error al acceder al AuthBloc: $e');
      print('Error = Usuario General, redirigiendo a data_registration');
      context.go('/data_registration');
      return;
    }
  }
}
