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
                if (currentIndex == 3) {
                  // Cuando estamos en FinalRiskResultsScreen (índice 3), volver a categorías (índice 0)
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
                            // Guardar el progreso antes de finalizar
                            final homeBloc = context.read<HomeBloc>();
                            final homeState = homeBloc.state;
                            final persistenceService = FormPersistenceService();
                            final riskBloc = context.read<RiskThreatAnalysisBloc>();
                            
                            if (homeState.activeFormId != null) {
                              // Actualizar formulario existente
                              final completeForm = await persistenceService
                                  .getCompleteForm(homeState.activeFormId!);
                              
                              if (completeForm != null) {
                                final formData = riskBloc.getCurrentFormData();
                                final now = DateTime.now();
                                
                                // Actualizar el formulario con los datos actuales
                                final updatedForm = completeForm.copyWith(
                                  amenazaProbabilidadSelections: formData['probabilidadSelections'] ?? completeForm.amenazaProbabilidadSelections,
                                  amenazaIntensidadSelections: formData['intensidadSelections'] ?? completeForm.amenazaIntensidadSelections,
                                  amenazaScores: formData['subClassificationScores'] ?? completeForm.amenazaScores,
                                  amenazaColors: formData['subClassificationColors'] ?? completeForm.amenazaColors,
                                  vulnerabilidadProbabilidadSelections: formData['probabilidadSelections'] ?? completeForm.vulnerabilidadProbabilidadSelections,
                                  vulnerabilidadIntensidadSelections: formData['intensidadSelections'] ?? completeForm.vulnerabilidadIntensidadSelections,
                                  vulnerabilidadScores: formData['subClassificationScores'] ?? completeForm.vulnerabilidadScores,
                                  vulnerabilidadColors: formData['subClassificationColors'] ?? completeForm.vulnerabilidadColors,
                                  evidenceImages: riskBloc.state.evidenceImages,
                                  evidenceCoordinates: riskBloc.state.evidenceCoordinates,
                                  updatedAt: now,
                                );

                                // Guardar el formulario actualizado
                                await persistenceService.saveCompleteForm(updatedForm);
                                
                                // Mostrar mensaje de éxito
                                CustomSnackBar.showSuccess(
                                  context,
                                  title: 'Progreso guardado',
                                  message: 'El formulario ha sido guardado exitosamente',
                                );
                                
                                // Volver a Categorías (índice 0)
                                context.read<RiskThreatAnalysisBloc>().add(
                                  ChangeBottomNavIndex(0),
                                );
                                
                                // Cerrar el diálogo
                                Navigator.of(context).pop();
                              }
                            }
                          },
                        );
                      }
                      // Solo ejecutar la lógica de finalización en índice 3 (Resultados)
                    },
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

  /// Método no utilizado actualmente (guardado para referencia futura)
  /// TODO: Eliminar o re-implementar según necesidades
  @Deprecated('Ya no se usa, la lógica de guardado está en índice 3')
  Future<void> _saveProgressBeforeFinalize(
    BuildContext context,
    RiskThreatAnalysisState state,
    RiskThreatAnalysisBloc riskBloc,
  ) async {
    try {
      print('=== GUARDANDO AVANCE ANTES DE FINALIZAR ===');
      print('Clasificación: ${state.selectedClassification ?? ''}');
      print('Evento: ${state.selectedRiskEvent ?? ''}');

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
      
      print('=== DEBUG FINALIZAR FORMULARIO ===');
      print('isCreatingNew: ${homeState.isCreatingNew}');
      print('activeFormId: ${homeState.activeFormId}');
      print('selectedClassification: ${state.selectedClassification}');
      print('selectedRiskEvent: ${state.selectedRiskEvent}');
      
      if (homeState.isCreatingNew || homeState.activeFormId == null || homeState.activeFormId!.isEmpty) {
        // Crear nuevo formulario
        print('Creando nuevo formulario');
        final formId = '${state.selectedRiskEvent ?? ''}_complete_${now.millisecondsSinceEpoch}';
        completeForm = CompleteFormDataModel(
          id: formId,
          eventName: state.selectedRiskEvent ?? '',
          contactData: contactData,
          inspectionData: inspectionData,
          amenazaSelections: (state.selectedClassification ?? '').toLowerCase() == 'amenaza' 
              ? (formData['dynamicSelections'] ?? {}) : {},
          amenazaScores: (state.selectedClassification ?? '').toLowerCase() == 'amenaza'
              ? (formData['subClassificationScores'] ?? {}) : {},
          amenazaColors: (state.selectedClassification ?? '').toLowerCase() == 'amenaza'
              ? (formData['subClassificationColors'] ?? {}) : {},
          amenazaProbabilidadSelections: (state.selectedClassification ?? '').toLowerCase() == 'amenaza'
              ? (formData['probabilidadSelections'] ?? {}) : {},
          amenazaIntensidadSelections: (state.selectedClassification ?? '').toLowerCase() == 'amenaza'
              ? (formData['intensidadSelections'] ?? {}) : {},
          amenazaSelectedProbabilidad: (state.selectedClassification ?? '').toLowerCase() == 'amenaza'
              ? formData['selectedProbabilidad'] : null,
          amenazaSelectedIntensidad: (state.selectedClassification ?? '').toLowerCase() == 'amenaza'
              ? formData['selectedIntensidad'] : null,
          vulnerabilidadSelections: (state.selectedClassification ?? '').toLowerCase() == 'vulnerabilidad'
              ? (formData['dynamicSelections'] ?? {}) : {},
          vulnerabilidadScores: (state.selectedClassification ?? '').toLowerCase() == 'vulnerabilidad'
              ? (formData['subClassificationScores'] ?? {}) : {},
          vulnerabilidadColors: (state.selectedClassification ?? '').toLowerCase() == 'vulnerabilidad'
              ? (formData['subClassificationColors'] ?? {}) : {},
          vulnerabilidadProbabilidadSelections: (state.selectedClassification ?? '').toLowerCase() == 'vulnerabilidad'
              ? (formData['probabilidadSelections'] ?? {}) : {},
          vulnerabilidadIntensidadSelections: (state.selectedClassification ?? '').toLowerCase() == 'vulnerabilidad'
              ? (formData['intensidadSelections'] ?? {}) : {},
          vulnerabilidadSelectedProbabilidad: (state.selectedClassification ?? '').toLowerCase() == 'vulnerabilidad'
              ? formData['selectedProbabilidad'] : null,
          vulnerabilidadSelectedIntensidad: (state.selectedClassification ?? '').toLowerCase() == 'vulnerabilidad'
              ? formData['selectedIntensidad'] : null,
          evidenceImages: state.evidenceImages,
          evidenceCoordinates: state.evidenceCoordinates,
          createdAt: now,
          updatedAt: now,
        );
      } else {
        // Actualizar formulario existente
        print('Actualizando formulario existente: ${homeState.activeFormId}');
        final existingForm = await persistenceService.getCompleteForm(homeState.activeFormId!);
        if (existingForm == null) {
          print('ERROR: Formulario no encontrado, creando nuevo');
          // Si no se encuentra el formulario, crear uno nuevo
          final formId = '${state.selectedRiskEvent ?? ''}_complete_${now.millisecondsSinceEpoch}';
          completeForm = CompleteFormDataModel(
            id: formId,
            eventName: state.selectedRiskEvent ?? '',
            contactData: contactData,
            inspectionData: inspectionData,
            amenazaSelections: (state.selectedClassification ?? '').toLowerCase() == 'amenaza' 
                ? (formData['dynamicSelections'] ?? {}) : {},
            amenazaScores: (state.selectedClassification ?? '').toLowerCase() == 'amenaza'
                ? (formData['subClassificationScores'] ?? {}) : {},
            amenazaColors: (state.selectedClassification ?? '').toLowerCase() == 'amenaza'
                ? (formData['subClassificationColors'] ?? {}) : {},
            amenazaProbabilidadSelections: (state.selectedClassification ?? '').toLowerCase() == 'amenaza'
                ? (formData['probabilidadSelections'] ?? {}) : {},
            amenazaIntensidadSelections: (state.selectedClassification ?? '').toLowerCase() == 'amenaza'
                ? (formData['intensidadSelections'] ?? {}) : {},
            amenazaSelectedProbabilidad: (state.selectedClassification ?? '').toLowerCase() == 'amenaza'
                ? formData['selectedProbabilidad'] : null,
            amenazaSelectedIntensidad: (state.selectedClassification ?? '').toLowerCase() == 'amenaza'
                ? formData['selectedIntensidad'] : null,
            vulnerabilidadSelections: (state.selectedClassification ?? '').toLowerCase() == 'vulnerabilidad'
                ? (formData['dynamicSelections'] ?? {}) : {},
            vulnerabilidadScores: (state.selectedClassification ?? '').toLowerCase() == 'vulnerabilidad'
                ? (formData['subClassificationScores'] ?? {}) : {},
            vulnerabilidadColors: (state.selectedClassification ?? '').toLowerCase() == 'vulnerabilidad'
                ? (formData['subClassificationColors'] ?? {}) : {},
            vulnerabilidadProbabilidadSelections: (state.selectedClassification ?? '').toLowerCase() == 'vulnerabilidad'
                ? (formData['probabilidadSelections'] ?? {}) : {},
            vulnerabilidadIntensidadSelections: (state.selectedClassification ?? '').toLowerCase() == 'vulnerabilidad'
                ? (formData['intensidadSelections'] ?? {}) : {},
            vulnerabilidadSelectedProbabilidad: (state.selectedClassification ?? '').toLowerCase() == 'vulnerabilidad'
                ? formData['selectedProbabilidad'] : null,
            vulnerabilidadSelectedIntensidad: (state.selectedClassification ?? '').toLowerCase() == 'vulnerabilidad'
                ? formData['selectedIntensidad'] : null,
            evidenceImages: state.evidenceImages,
            evidenceCoordinates: state.evidenceCoordinates,
            createdAt: now,
            updatedAt: now,
          );
        } else {
          completeForm = existingForm;
        if ((state.selectedClassification ?? '').toLowerCase() == 'amenaza') {
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
        } else if ((state.selectedClassification ?? '').toLowerCase() == 'vulnerabilidad') {
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
      }

      // Guardar formulario completo
      await persistenceService.saveCompleteForm(completeForm);
      await persistenceService.setActiveFormId(completeForm.id);

      // Actualizar estado del HomeBloc
      if (homeState.isCreatingNew) {
            homeBloc.add(SetActiveFormId(formId: completeForm.id, isCreatingNew: false));
      }

      print('Avance guardado exitosamente');

      // Guardar datos del formulario antes de marcar como completada
      final formDataForBloc = riskBloc.getCurrentFormData();

      context.read<HomeBloc>().add(
        SaveRiskEventModel(
          eventName: state.selectedRiskEvent ?? '',
          classificationType: (state.selectedClassification ?? '').toLowerCase(),
          evaluationData: formDataForBloc,
        ),
      );

      // Marcar como completada
      context.read<HomeBloc>().add(
        MarkEvaluationCompleted(
          eventName: state.selectedRiskEvent ?? '',
          classificationType: (state.selectedClassification ?? '').toLowerCase(),
        ),
      );

      // Mostrar diálogo de finalización
      CustomActionDialog.show(
        context: context,
        title: 'Finalizar formulario',
        message: '¿Está seguro que desea finalizar el formulario para la categoría de ${state.selectedClassification ?? ''}?',
        leftButtonText: 'Revisar',
        leftButtonIcon: Icons.close,
        rightButtonText: 'Finalizar',
        rightButtonIcon: Icons.check,
        onRightButtonPressed: () {
          if ((state.selectedClassification ?? '').toLowerCase() == 'amenaza') {
            // Si es amenaza, volver a categorías (índice 0)
            context.read<RiskThreatAnalysisBloc>().add(
              ChangeBottomNavIndex(0),
            );
          } else {
            // Si es vulnerabilidad, volver al home
            final navigationData = homeNavigationType.toNavigationData(tabIndex: homeTabIndex);
            context.go('/home', extra: navigationData);
          }
          Navigator.of(context).pop(); // Cerrar el diálogo
        },
      );

    } catch (e) {
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
