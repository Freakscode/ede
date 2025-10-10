import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:caja_herramientas/app/core/theme/dagrd_colors.dart';
import 'package:caja_herramientas/app/shared/widgets/dialogs/custom_action_dialog.dart';
import 'package:caja_herramientas/app/shared/services/form_persistence_service.dart';
import '../../bloc/risk_threat_analysis_bloc.dart';
import '../../bloc/risk_threat_analysis_event.dart';
import '../../bloc/risk_threat_analysis_state.dart';
import '../../../home/bloc/home_bloc.dart';
import '../../../home/bloc/home_event.dart';
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
                if (currentIndex == 3) {
                  // Cuando estamos en FinalRiskResultsScreen (índice 3), volver a categorías
                  final navigationData = {'showRiskCategories': true};
                  context.go('/home', extra: navigationData);
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
        if (currentIndex < 2) // Botón Continuar para las primeras dos pestañas
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
        else // Botón Finalizar para la última pestaña
          BlocBuilder<RiskThreatAnalysisBloc, RiskThreatAnalysisState>(
            builder: (context, state) {
              return InkWell(
                onTap:
                    onContinuePressed ??
                    () {
                      // Si estamos en FinalRiskResultsScreen (índice 3), completar formulario
                      if (currentIndex == 3) {
                        // Mostrar diálogo de confirmación para completar el formulario
                        CustomActionDialog.show(
                          context: context,
                          title: 'Finalizar formulario',
                          message: ' ¿Deseas finalizar el formulario? Antes de finalizar, puedes revisar tus respuestas. ',
                          leftButtonText: 'Revisar  ',
                          leftButtonIcon: Icons.close,
                          rightButtonText: 'Finalizar  ',
                          rightButtonIcon: Icons.check_circle,
                          onRightButtonPressed: () async {
                            // Marcar el formulario como explícitamente completado
                            final homeBloc = context.read<HomeBloc>();
                            final homeState = homeBloc.state;
                            
                            if (homeState.activeFormId != null) {
                              // Obtener el servicio de persistencia
                              final FormPersistenceService persistenceService = FormPersistenceService();
                              final completeForm = await persistenceService.getCompleteForm(homeState.activeFormId!);
                              
                              if (completeForm != null) {
                                // Marcar como explícitamente completado
                                final updatedForm = completeForm.copyWith(
                                  isExplicitlyCompleted: true,
                                  updatedAt: DateTime.now(),
                                );
                                
                                // Guardar el formulario actualizado
                                await persistenceService.saveCompleteForm(updatedForm);
                                
                                // Recargar los formularios en HomeBloc
                                homeBloc.add(LoadForms());
                                
                                // Mostrar mensaje de éxito
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text('Formulario completado exitosamente'),
                                    backgroundColor: Colors.green,
                                  ),
                                );
                                
                                // Navegar a la pantalla de formulario completado
                                homeBloc.add(HomeShowFormCompletedScreen());
                              }
                            }
                          },
                        );
                      }
                      // Si estamos en la última pestaña (índice 2), manejar finalización
                      else if (currentIndex == 2) {
                        final riskBloc = context.read<RiskThreatAnalysisBloc>();
                        
                        // Validar si hay variables sin calificar antes de finalizar
                        if (riskBloc.hasUnqualifiedVariables()) {
                          // Mostrar diálogo de formulario incompleto
                          CustomActionDialog.show(
                            context: context,
                            title: 'Formulario incompleto',
                            message: 'Antes de finalizar, revisa el formulario. Algunas variables aún no han sido evaluadas',
                            leftButtonText: 'Cancelar ',
                            leftButtonIcon: Icons.close,
                            rightButtonText: 'Revisar ',
                            rightButtonIcon: Icons.edit,
                            onRightButtonPressed: () {
                              Navigator.of(context).pop();
                            },
                          );
                          return;
                        }

                        // Si estamos en amenaza, guardar datos y mostrar diálogo de confirmación
                        if (state.selectedClassification.toLowerCase() == 'amenaza') {
                          // Guardar datos del formulario antes de marcar como completada
                          final formData = riskBloc.getCurrentFormData();

                          context.read<HomeBloc>().add(
                            SaveRiskEventModel(
                              state.selectedRiskEvent,
                              'amenaza',
                              formData,
                            ),
                          );

                          // Marcar amenaza como completada
                          context.read<HomeBloc>().add(
                            MarkEvaluationCompleted(
                              state.selectedRiskEvent,
                              'amenaza',
                            ),
                          );

                          CustomActionDialog.show(
                            context: context,
                            title: 'Finalizar formulario',
                            message: '¿Está seguro que desea finalizar el formulario para la categoría de ${state.selectedClassification}?',
                            leftButtonText: 'Revisar ',
                            leftButtonIcon: Icons.close,
                            rightButtonText: 'Finalizar ',
                            rightButtonIcon: Icons.check,
                            onRightButtonPressed: () {
                              final navigationData = {'showRiskCategories': true};
                              context.go('/home', extra: navigationData);
                            },
                          );
                        } else if (state.selectedClassification.toLowerCase() == 'vulnerabilidad') {
                          // Guardar datos del formulario antes de marcar como completada
                          final formData = riskBloc.getCurrentFormData();

                          context.read<HomeBloc>().add(
                            SaveRiskEventModel(
                              state.selectedRiskEvent,
                              'vulnerabilidad',
                              formData,
                            ),
                          );

                          // Marcar vulnerabilidad como completada
                          context.read<HomeBloc>().add(
                            MarkEvaluationCompleted(
                              state.selectedRiskEvent,
                              'vulnerabilidad',
                            ),
                          );

                          CustomActionDialog.show(
                            context: context,
                            title: 'Finalizar formulario',
                            message: '¿Está seguro que desea finalizar el formulario para la categoría de ${state.selectedClassification}?',
                            leftButtonText: 'Revisar ',
                            leftButtonIcon: Icons.close,
                            rightButtonText: 'Finalizar ',
                            rightButtonIcon: Icons.check,
                            onRightButtonPressed: () {
                              final navigationData = homeNavigationType.toNavigationData(tabIndex: homeTabIndex);
                              context.go('/home', extra: navigationData);
                            },
                          );
                        }
                      } else {
                        // Para las primeras dos pestañas, continuar a la siguiente
                        context.read<RiskThreatAnalysisBloc>().add(
                          ChangeBottomNavIndex(currentIndex + 1),
                        );
                      }
                    },
                child: Container(
                  width: 185,
                  height: 48,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 8,
                  ),
                  decoration: BoxDecoration(
                    color: const Color(0xFF232B48),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(
                        Icons.check_circle_outline,
                        color: Color(0xFFFFFFFF),
                        size: 18,
                      ),
                      const SizedBox(width: 10),
                      const Text(
                        'Finalizar formulario',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Color(0xFFFFFFFF),
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
