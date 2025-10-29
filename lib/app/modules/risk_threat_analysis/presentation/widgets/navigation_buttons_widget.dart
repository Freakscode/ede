import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:caja_herramientas/app/core/theme/dagrd_colors.dart';
import 'package:caja_herramientas/app/shared/widgets/dialogs/custom_action_dialog.dart';
import 'package:caja_herramientas/app/shared/widgets/widgets.dart';
import 'package:caja_herramientas/app/shared/services/form_persistence_service.dart';
import 'package:caja_herramientas/app/shared/models/complete_form_data_model.dart';
import 'package:caja_herramientas/app/modules/auth/services/auth_service.dart';
import '../bloc/risk_threat_analysis_bloc.dart';
import '../bloc/risk_threat_analysis_event.dart';
import '../bloc/risk_threat_analysis_state.dart';
import '../../../home/presentation/bloc/home_bloc.dart';
import '../../../home/presentation/bloc/home_event.dart';
import 'home_navigation_type.dart';

class NavigationButtonsWidget extends StatelessWidget {
  final int currentIndex;
  final VoidCallback? onBackPressed;
  final VoidCallback? onContinuePressed;
  final HomeNavigationType homeNavigationType;
  final int? homeTabIndex;

  const NavigationButtonsWidget({
    super.key,
    required this.currentIndex,
    this.onBackPressed,
    this.onContinuePressed,
    this.homeNavigationType = HomeNavigationType.riskCategories,
    this.homeTabIndex,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        // Botón Volver
        InkWell(
          onTap:
              onBackPressed ??
              () {
                if (currentIndex == 4) {
                  // Cuando estamos en FinalRiskResultsScreen (índice 4), volver a categorías (índice 0)
                  context.read<RiskThreatAnalysisBloc>().add(
                    ChangeBottomNavIndex(0),
                  );
                } else if (currentIndex > 0) {
                  context.read<RiskThreatAnalysisBloc>().add(
                    ChangeBottomNavIndex(currentIndex - 1),
                  );
                } else {
                  // Cuando estamos en el primer índice, volver al HomeScreen
                  final navigationData = homeNavigationType.toNavigationData(
                    tabIndex: homeTabIndex,
                  );
                  context.go('/home', extra: navigationData);
                }
              },
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(
                Icons.arrow_back_ios,
                color: DAGRDColors.negroDAGRD,
                size: 18,
              ),
              const SizedBox(width: 8),
              const Text(
                'Volver',
                style: TextStyle(
                  color: DAGRDColors.negroDAGRD,
                  fontFamily: 'Work Sans',
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  height: 18 / 16,
                ),
              ),
            ],
          ),
        ),

        // Botón Continuar o Finalizar
        if (currentIndex < 3) // Botón Continuar para índices 0, 1, y 2
          InkWell(
            onTap:
                onContinuePressed ??
                () {
                  context.read<RiskThreatAnalysisBloc>().add(
                    ChangeBottomNavIndex(currentIndex + 1),
                  );
                },
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  'Continuar',
                  style: TextStyle(
                    color: DAGRDColors.negroDAGRD,
                    fontFamily: 'Work Sans',
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    height: 18 / 16,
                  ),
                ),
                const SizedBox(width: 8),
                const Icon(
                  Icons.arrow_forward_ios,
                  color: DAGRDColors.negroDAGRD,
                  size: 18,
                ),
              ],
            ),
          )
        else // Botón Finalizar para la pestaña de Resultados (índice 3)
          BlocBuilder<RiskThreatAnalysisBloc, RiskThreatAnalysisState>(
            builder: (context, state) {
              // Verificar si hay variables sin calificar usando el método del BLoC
              final riskBloc = context.read<RiskThreatAnalysisBloc>();
              final hasUnqualifiedVariables = riskBloc.hasUnqualifiedVariables();
              
              return InkWell(
                onTap: hasUnqualifiedVariables 
                      ? () {
                        // Si hay variables sin calificar, mostrar diálogo de advertencia
                        CustomActionDialog.show(
                          context: context,
                          title: 'Formulario incompleto',
                          message: 'Antes de finalizar, revisa el formulario.\nAlgunas variables aún no han sido evaluadas',
                          leftButtonText: 'Cancelar  ',
                          leftButtonIcon: Icons.close,
                          rightButtonText: 'Revisar  ',
                          rightButtonIcon: Icons.edit,
                          onRightButtonPressed: () {
                            // Cerrar el diálogo
                            Navigator.of(context).pop();
                          },
                        );
                      }
                    : onContinuePressed ??
                    () {},
                child: Container(
                  width: 185,
                  height: 48,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 8,
                  ),
                  decoration: BoxDecoration(
                    color: DAGRDColors.azulDAGRD,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(
                        Icons.check_circle_outline,
                        color: DAGRDColors.blancoDAGRD,
                        size: 18,
                      ),
                      const SizedBox(width: 10),
                      const Text(
                        'Finalizar formulario',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: DAGRDColors.blancoDAGRD,
                          fontFamily: 'Work Sans',
                          fontSize: 14,
                          fontStyle: FontStyle.normal,
                          fontWeight: FontWeight.w500,
                          height: 24 / 14,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
      ],
    );
  }
  
}
