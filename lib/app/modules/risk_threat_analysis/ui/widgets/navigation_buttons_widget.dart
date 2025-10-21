import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:caja_herramientas/app/core/theme/dagrd_colors.dart';
import 'package:caja_herramientas/app/shared/widgets/dialogs/custom_action_dialog.dart';
import 'package:caja_herramientas/app/shared/widgets/widgets.dart';
import 'package:caja_herramientas/app/shared/services/form_persistence_service.dart';
import 'package:caja_herramientas/app/shared/models/complete_form_data_model.dart';
import 'package:caja_herramientas/app/modules/auth/services/auth_service.dart';
import '../../bloc/risk_threat_analysis_bloc.dart';
import '../../bloc/events/risk_threat_analysis_event.dart';
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
                    () async {
                      // Si estamos en FinalRiskResultsScreen (índice 3), completar formulario
                      if (currentIndex == 3) {
                        // Mostrar diálogo de confirmación para completar el formulario
                        CustomActionDialog.show(
                          context: context,
                          title: 'Finalizar formulario',
                          message:
                              ' ¿Deseas finalizar el formulario? Antes de finalizar, puedes revisar tus respuestas. ',
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
                              final FormPersistenceService persistenceService =
                                  FormPersistenceService();
                              final completeForm = await persistenceService
                                  .getCompleteForm(homeState.activeFormId!);

                              if (completeForm != null) {
                                // Marcar como explícitamente completado
                                final updatedForm = completeForm.copyWith(
                                  isExplicitlyCompleted: true,
                                  updatedAt: DateTime.now(),
                                );

                                // Guardar el formulario actualizado
                                await persistenceService.saveCompleteForm(
                                  updatedForm,
                                );

                                // Recargar los formularios en HomeBloc
                                homeBloc.add(LoadForms());

                                // Mostrar mensaje de éxito
                                CustomSnackBar.showSuccess(
                                  context,
                                  title: 'Formulario completado',
                                  message: 'El formulario ha sido completado exitosamente',
                                );

                                // Navegar a la pantalla de formulario completado
                                homeBloc.add(HomeShowFormCompletedScreen());
                                context.go('/home');
                                Navigator.of(context).pop();
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
                            message:
                                'Antes de finalizar, revisa el formulario. Algunas variables aún no han sido evaluadas',
                            leftButtonText: 'Cancelar ',
                            leftButtonIcon: Icons.close,
                            rightButtonText: 'Revisar 2',
                            rightButtonIcon: Icons.edit,
                            onRightButtonPressed: () {
                              Navigator.of(context).pop();
                            },
                          );
                          return;
                        }

                        // Si estamos en amenaza o vulnerabilidad, guardar avance y mostrar diálogo de confirmación
                        if (state.selectedClassification.toLowerCase() == 'amenaza' ||
                            state.selectedClassification.toLowerCase() == 'vulnerabilidad') {
                          // Guardar avance antes de finalizar
                          await _saveProgressBeforeFinalize(context, state, riskBloc);
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

  /// Guarda el progreso antes de finalizar el formulario
  Future<void> _saveProgressBeforeFinalize(
    BuildContext context,
    RiskThreatAnalysisState state,
    RiskThreatAnalysisBloc riskBloc,
  ) async {
    try {
      print('=== GUARDANDO AVANCE ANTES DE FINALIZAR ===');
      print('Clasificación: ${state.selectedClassification}');
      print('Evento: ${state.selectedRiskEvent}');

      final homeBloc = context.read<HomeBloc>();
      final homeState = homeBloc.state;
      final authService = AuthService();
      final persistenceService = FormPersistenceService();

      // Obtener datos de contacto e inspección
      Map<String, dynamic> contactData = {};
      Map<String, dynamic> inspectionData = {};

      if (authService.isLoggedIn) {
        // Usuario logueado - datos de contacto vienen de la API
        final user = authService.currentUser;
        contactData = {
          'names': user?.nombre ?? '',
          'cellPhone': user?.cedula ?? '',
          'landline': '',
          'email': user?.email ?? '',
        };
        inspectionData = {};
      } else {
        // Usuario no logueado - datos por defecto
        contactData = {};
        inspectionData = {};
      }

      // Obtener datos actuales del formulario
      final formData = riskBloc.getCurrentFormData();
      final now = DateTime.now();

      // Crear o actualizar formulario completo
      CompleteFormDataModel completeForm;
      
      if (homeState.isCreatingNew || homeState.activeFormId == null) {
        // Crear nuevo formulario
        final formId = '${state.selectedRiskEvent}_complete_${now.millisecondsSinceEpoch}';
        completeForm = CompleteFormDataModel(
          id: formId,
          eventName: state.selectedRiskEvent,
          contactData: contactData,
          inspectionData: inspectionData,
          amenazaSelections: state.selectedClassification.toLowerCase() == 'amenaza' 
              ? (formData['dynamicSelections'] ?? {}) : {},
          amenazaScores: state.selectedClassification.toLowerCase() == 'amenaza'
              ? (formData['subClassificationScores'] ?? {}) : {},
          amenazaColors: state.selectedClassification.toLowerCase() == 'amenaza'
              ? (formData['subClassificationColors'] ?? {}) : {},
          amenazaProbabilidadSelections: state.selectedClassification.toLowerCase() == 'amenaza'
              ? (formData['probabilidadSelections'] ?? {}) : {},
          amenazaIntensidadSelections: state.selectedClassification.toLowerCase() == 'amenaza'
              ? (formData['intensidadSelections'] ?? {}) : {},
          amenazaSelectedProbabilidad: state.selectedClassification.toLowerCase() == 'amenaza'
              ? formData['selectedProbabilidad'] : null,
          amenazaSelectedIntensidad: state.selectedClassification.toLowerCase() == 'amenaza'
              ? formData['selectedIntensidad'] : null,
          vulnerabilidadSelections: state.selectedClassification.toLowerCase() == 'vulnerabilidad'
              ? (formData['dynamicSelections'] ?? {}) : {},
          vulnerabilidadScores: state.selectedClassification.toLowerCase() == 'vulnerabilidad'
              ? (formData['subClassificationScores'] ?? {}) : {},
          vulnerabilidadColors: state.selectedClassification.toLowerCase() == 'vulnerabilidad'
              ? (formData['subClassificationColors'] ?? {}) : {},
          vulnerabilidadProbabilidadSelections: state.selectedClassification.toLowerCase() == 'vulnerabilidad'
              ? (formData['probabilidadSelections'] ?? {}) : {},
          vulnerabilidadIntensidadSelections: state.selectedClassification.toLowerCase() == 'vulnerabilidad'
              ? (formData['intensidadSelections'] ?? {}) : {},
          vulnerabilidadSelectedProbabilidad: state.selectedClassification.toLowerCase() == 'vulnerabilidad'
              ? formData['selectedProbabilidad'] : null,
          vulnerabilidadSelectedIntensidad: state.selectedClassification.toLowerCase() == 'vulnerabilidad'
              ? formData['selectedIntensidad'] : null,
          evidenceImages: state.evidenceImages,
          evidenceCoordinates: state.evidenceCoordinates,
          createdAt: now,
          updatedAt: now,
        );
      } else {
        // Actualizar formulario existente
        final existingForm = await persistenceService.getCompleteForm(homeState.activeFormId!);
        if (existingForm == null) {
          throw Exception('No se encontró el formulario existente');
        }
        
        completeForm = existingForm;
        if (state.selectedClassification.toLowerCase() == 'amenaza') {
          completeForm = completeForm.copyWith(
            amenazaSelections: formData['dynamicSelections'] ?? completeForm.amenazaSelections,
            amenazaScores: formData['subClassificationScores'] ?? completeForm.amenazaScores,
            amenazaColors: formData['subClassificationColors'] ?? completeForm.amenazaColors,
            amenazaProbabilidadSelections: formData['probabilidadSelections'] ?? completeForm.amenazaProbabilidadSelections,
            amenazaIntensidadSelections: formData['intensidadSelections'] ?? completeForm.amenazaIntensidadSelections,
            amenazaSelectedProbabilidad: formData['selectedProbabilidad'] ?? completeForm.amenazaSelectedProbabilidad,
            amenazaSelectedIntensidad: formData['selectedIntensidad'] ?? completeForm.amenazaSelectedIntensidad,
            contactData: contactData,
            inspectionData: inspectionData,
            evidenceImages: state.evidenceImages,
            evidenceCoordinates: state.evidenceCoordinates,
            updatedAt: now,
          );
        } else if (state.selectedClassification.toLowerCase() == 'vulnerabilidad') {
          completeForm = completeForm.copyWith(
            vulnerabilidadSelections: formData['dynamicSelections'] ?? completeForm.vulnerabilidadSelections,
            vulnerabilidadScores: formData['subClassificationScores'] ?? completeForm.vulnerabilidadScores,
            vulnerabilidadColors: formData['subClassificationColors'] ?? completeForm.vulnerabilidadColors,
            vulnerabilidadProbabilidadSelections: formData['probabilidadSelections'] ?? completeForm.vulnerabilidadProbabilidadSelections,
            vulnerabilidadIntensidadSelections: formData['intensidadSelections'] ?? completeForm.vulnerabilidadIntensidadSelections,
            vulnerabilidadSelectedProbabilidad: formData['selectedProbabilidad'] ?? completeForm.vulnerabilidadSelectedProbabilidad,
            vulnerabilidadSelectedIntensidad: formData['selectedIntensidad'] ?? completeForm.vulnerabilidadSelectedIntensidad,
            contactData: contactData,
            inspectionData: inspectionData,
            evidenceImages: state.evidenceImages,
            evidenceCoordinates: state.evidenceCoordinates,
            updatedAt: now,
          );
        }
      }

      // Guardar formulario completo
      await persistenceService.saveCompleteForm(completeForm);
      await persistenceService.setActiveFormId(completeForm.id);

      // Actualizar estado del HomeBloc
      if (homeState.isCreatingNew) {
        homeBloc.add(SetActiveFormId(completeForm.id, isCreatingNew: false));
      }

      print('Avance guardado exitosamente');

      // Guardar datos del formulario antes de marcar como completada
      final formDataForBloc = riskBloc.getCurrentFormData();

      context.read<HomeBloc>().add(
        SaveRiskEventModel(
          state.selectedRiskEvent,
          state.selectedClassification.toLowerCase(),
          formDataForBloc,
        ),
      );

      // Marcar como completada
      context.read<HomeBloc>().add(
        MarkEvaluationCompleted(
          state.selectedRiskEvent,
          state.selectedClassification.toLowerCase(),
        ),
      );

      // Mostrar diálogo de finalización
      CustomActionDialog.show(
        context: context,
        title: 'Finalizar formulario',
        message: '¿Está seguro que desea finalizar el formulario para la categoría de ${state.selectedClassification}?',
        leftButtonText: 'Revisar',
        leftButtonIcon: Icons.close,
        rightButtonText: 'Finalizar',
        rightButtonIcon: Icons.check,
        onRightButtonPressed: () {
          final navigationData = state.selectedClassification.toLowerCase() == 'amenaza'
              ? {'showRiskCategories': true}
              : homeNavigationType.toNavigationData(tabIndex: homeTabIndex);
          context.go('/home', extra: navigationData);
        },
      );

    } catch (e) {
      print('Error al guardar avance antes de finalizar: $e');
      if (context.mounted) {
        CustomSnackBar.showError(
          context,
          title: 'Error al guardar',
          message: 'Error al guardar avance: $e',
        );
      }
    }
  }
}
