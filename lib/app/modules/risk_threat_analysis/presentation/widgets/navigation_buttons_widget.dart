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
              final hasUnqualifiedVariables = riskBloc
                  .hasUnqualifiedVariables();

              return InkWell(
                onTap: hasUnqualifiedVariables
                    ? () {
                        // Si hay variables sin calificar, mostrar diálogo de advertencia
                        CustomActionDialog.show(
                          context: context,
                          title: 'Formulario incompleto',
                          message:
                              'Antes de finalizar, revisa el formulario.\nAlgunas variables aún no han sido evaluadas',
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
                          () {
                            if (currentIndex == 3) {
                              CustomActionDialog.show(
                                context: context,
                                title: 'Finalizar formulario',
                                message:
                                    '¿Deseas finalizar el formulario? Antes de finalizar, puedes revisar tus respuestas.',
                                leftButtonText: 'Revisar  ',
                                leftButtonIcon: Icons.close,
                                rightButtonText: 'Finalizar  ',
                                rightButtonIcon: Icons.check_circle,
                                onRightButtonPressed: () async {
                                  // Guardar el progreso antes de finalizar
                                  final homeBloc = context.read<HomeBloc>();
                                  final homeState = homeBloc.state;
                                  final persistenceService =
                                      FormPersistenceService();
                                  final riskBloc = context
                                      .read<RiskThreatAnalysisBloc>();

                                  if (homeState.activeFormId != null) {
                                    // Actualizar formulario existente
                                    final completeForm =
                                        await persistenceService
                                            .getCompleteForm(
                                              homeState.activeFormId!,
                                            );

                                    if (completeForm != null) {
                                      final formData = riskBloc
                                          .getCurrentFormData();
                                      final now = DateTime.now();
                                      final state = riskBloc.state;
                                      final classification =
                                          (state.selectedClassification ?? '')
                                              .toLowerCase();

                                      // Actualizar el formulario con los datos actuales
                                      // Obtener scores y colores filtrados
                                      final allScoresUpdate =
                                          formData['subClassificationScores']
                                              as Map<String, double>? ??
                                          {};
                                      final allColorsUpdate =
                                          formData['subClassificationColors']
                                              as Map<String, Color>? ??
                                          {};

                                      CompleteFormDataModel updatedForm;

                                      if (classification == 'amenaza') {
                                        // Para amenaza, solo guardar scores de probabilidad e intensidad
                                        final amenazaScoresOnly =
                                            Map<String, double>.from(
                                              completeForm.amenazaScores,
                                            );
                                        final amenazaColorsOnly =
                                            Map<String, Color>.from(
                                              completeForm.amenazaColors,
                                            );

                                        if (allScoresUpdate.containsKey(
                                          'probabilidad',
                                        )) {
                                          amenazaScoresOnly['probabilidad'] =
                                              allScoresUpdate['probabilidad']!;
                                        }
                                        if (allScoresUpdate.containsKey(
                                          'intensidad',
                                        )) {
                                          amenazaScoresOnly['intensidad'] =
                                              allScoresUpdate['intensidad']!;
                                        }
                                        if (allColorsUpdate.containsKey(
                                          'probabilidad',
                                        )) {
                                          amenazaColorsOnly['probabilidad'] =
                                              allColorsUpdate['probabilidad']!;
                                        }
                                        if (allColorsUpdate.containsKey(
                                          'intensidad',
                                        )) {
                                          amenazaColorsOnly['intensidad'] =
                                              allColorsUpdate['intensidad']!;
                                        }

                                        updatedForm = completeForm.copyWith(
                                          amenazaSelections:
                                              formData['dynamicSelections'] ??
                                              completeForm.amenazaSelections,
                                          amenazaProbabilidadSelections:
                                              formData['probabilidadSelections'] ??
                                              completeForm
                                                  .amenazaProbabilidadSelections,
                                          amenazaIntensidadSelections:
                                              formData['intensidadSelections'] ??
                                              completeForm
                                                  .amenazaIntensidadSelections,
                                          amenazaScores: amenazaScoresOnly,
                                          amenazaColors: amenazaColorsOnly,
                                          amenazaSelectedProbabilidad:
                                              formData['selectedProbabilidad'] ??
                                              completeForm
                                                  .amenazaSelectedProbabilidad,
                                          amenazaSelectedIntensidad:
                                              formData['selectedIntensidad'] ??
                                              completeForm
                                                  .amenazaSelectedIntensidad,
                                          evidenceImages:
                                              riskBloc.state.evidenceImages,
                                          evidenceCoordinates: riskBloc
                                              .state
                                              .evidenceCoordinates,
                                          updatedAt: now,
                                          
                                        );
                                      } else if (classification ==
                                          'vulnerabilidad') {
                                        // Para vulnerabilidad, solo guardar scores de fragilidad_fisica, fragilidad_personas, exposicion
                                        final vulnerabilidadScoresOnly =
                                            Map<String, double>.from(
                                              completeForm.vulnerabilidadScores,
                                            );
                                        final vulnerabilidadColorsOnly =
                                            Map<String, Color>.from(
                                              completeForm.vulnerabilidadColors,
                                            );

                                        final vulnerabilidadKeys = [
                                          'fragilidad_fisica',
                                          'fragilidad_personas',
                                          'exposicion',
                                        ];
                                        for (final key in vulnerabilidadKeys) {
                                          if (allScoresUpdate.containsKey(
                                            key,
                                          )) {
                                            vulnerabilidadScoresOnly[key] =
                                                allScoresUpdate[key]!;
                                          }
                                          if (allColorsUpdate.containsKey(
                                            key,
                                          )) {
                                            vulnerabilidadColorsOnly[key] =
                                                allColorsUpdate[key]!;
                                          }
                                        }

                                        updatedForm = completeForm.copyWith(
                                          vulnerabilidadSelections:
                                              formData['dynamicSelections'] ??
                                              completeForm
                                                  .vulnerabilidadSelections,
                                          vulnerabilidadProbabilidadSelections:
                                              formData['probabilidadSelections'] ??
                                              completeForm
                                                  .vulnerabilidadProbabilidadSelections,
                                          vulnerabilidadIntensidadSelections:
                                              formData['intensidadSelections'] ??
                                              completeForm
                                                  .vulnerabilidadIntensidadSelections,
                                          vulnerabilidadScores:
                                              vulnerabilidadScoresOnly,
                                          vulnerabilidadColors:
                                              vulnerabilidadColorsOnly,
                                          vulnerabilidadSelectedProbabilidad:
                                              formData['selectedProbabilidad'] ??
                                              completeForm
                                                  .vulnerabilidadSelectedProbabilidad,
                                          vulnerabilidadSelectedIntensidad:
                                              formData['selectedIntensidad'] ??
                                              completeForm
                                                  .vulnerabilidadSelectedIntensidad,
                                          evidenceImages:
                                              riskBloc.state.evidenceImages,
                                          evidenceCoordinates: riskBloc
                                              .state
                                              .evidenceCoordinates,
                                          updatedAt: now,
                                          
                                        );
                                      } else {
                                        // Si no hay clasificación clara, actualizar ambos
                                        updatedForm = completeForm.copyWith(
                                          evidenceImages:
                                              riskBloc.state.evidenceImages,
                                          evidenceCoordinates: riskBloc
                                              .state
                                              .evidenceCoordinates,
                                          updatedAt: now,
                                          
                                        );
                                      }

                                      // Guardar el formulario actualizado
                                      await persistenceService.saveCompleteForm(
                                        updatedForm,
                                      );

                                      // Actualizar HomeBloc y completar el formulario
                                      if (context.mounted) {
                                        context.read<HomeBloc>().add(
                                          SetActiveFormId(
                                            formId: updatedForm.id,
                                            isCreatingNew: false,
                                          ),
                                        );
                                      }

                                      // Cerrar el diálogo
                                      Navigator.of(context).pop();

                                      // Mostrar mensaje de éxito
                                      CustomSnackBar.showSuccess(
                                        context,
                                        title: 'Formulario completado',
                                        message:
                                            'El formulario ha sido guardado y completado exitosamente',
                                      );

                                      // Volver a Categorías (índice 0)
                                      context
                                          .read<RiskThreatAnalysisBloc>()
                                          .add(ChangeBottomNavIndex(0));

                                      // Cerrar el diálogo
                                    } else {
                                      // No existe el formulario, crear uno nuevo
                                      final formData = riskBloc
                                          .getCurrentFormData();
                                      final now = DateTime.now();
                                      final state = riskBloc.state;
                                      final classification =
                                          (state.selectedClassification ?? '')
                                              .toLowerCase();

                                      // Obtener datos de contacto e inspección
                                      final authService = AuthService();
                                      Map<String, dynamic> contactData = {};
                                      Map<String, dynamic> inspectionData = {};

                                      if (authService.isLoggedIn) {
                                        final user = authService.currentUser;
                                        contactData = {
                                          'names': user?.nombre ?? '',
                                          'cellPhone': user?.cedula ?? '',
                                          'landline': '',
                                          'email': user?.email ?? '',
                                        };
                                      }

                                      // Filtrar scores por clasificación
                                      final allScoresNew =
                                          formData['subClassificationScores']
                                              as Map<String, double>? ??
                                          {};
                                      Map<String, double> amenazaScores = {};
                                      Map<String, double> vulnerabilidadScores =
                                          {};

                                      if (classification == 'amenaza') {
                                        if (allScoresNew.containsKey(
                                          'probabilidad',
                                        )) {
                                          amenazaScores['probabilidad'] =
                                              allScoresNew['probabilidad']!;
                                        }
                                        if (allScoresNew.containsKey(
                                          'intensidad',
                                        )) {
                                          amenazaScores['intensidad'] =
                                              allScoresNew['intensidad']!;
                                        }
                                      } else if (classification ==
                                          'vulnerabilidad') {
                                        final vulnerabilidadKeys = [
                                          'fragilidad_fisica',
                                          'fragilidad_personas',
                                          'exposicion',
                                        ];
                                        for (final key in vulnerabilidadKeys) {
                                          if (allScoresNew.containsKey(key)) {
                                            vulnerabilidadScores[key] =
                                                allScoresNew[key]!;
                                          }
                                        }
                                      }

                                      // Convertir colores
                                      final colorsData =
                                          formData['subClassificationColors']
                                              as Map<String, Color>? ??
                                          {};
                                      final serializableColors =
                                          <String, Color>{};
                                      colorsData.forEach((key, value) {
                                        serializableColors[key] = value;
                                      });

                                      final newFormId =
                                          '${state.selectedRiskEvent ?? ''}_complete_${now.millisecondsSinceEpoch}';

                                      final newCompleteForm = CompleteFormDataModel(
                                        id: newFormId,
                                        eventName:
                                            state.selectedRiskEvent ?? '',
                                        contactData: contactData,
                                        inspectionData: inspectionData,
                                        amenazaSelections:
                                            classification == 'amenaza'
                                            ? (formData['dynamicSelections'] ??
                                                  {})
                                            : {},
                                        amenazaScores: amenazaScores,
                                        amenazaColors:
                                            classification == 'amenaza'
                                            ? serializableColors
                                            : {},
                                        amenazaProbabilidadSelections:
                                            classification == 'amenaza'
                                            ? (formData['probabilidadSelections'] ??
                                                  {})
                                            : {},
                                        amenazaIntensidadSelections:
                                            classification == 'amenaza'
                                            ? (formData['intensidadSelections'] ??
                                                  {})
                                            : {},
                                        amenazaSelectedProbabilidad: null,
                                        amenazaSelectedIntensidad: null,
                                        vulnerabilidadSelections:
                                            classification == 'vulnerabilidad'
                                            ? (formData['dynamicSelections'] ??
                                                  {})
                                            : {},
                                        vulnerabilidadScores:
                                            vulnerabilidadScores,
                                        vulnerabilidadColors:
                                            classification == 'vulnerabilidad'
                                            ? serializableColors
                                            : {},
                                        vulnerabilidadProbabilidadSelections:
                                            classification == 'vulnerabilidad'
                                            ? (formData['probabilidadSelections'] ??
                                                  {})
                                            : {},
                                        vulnerabilidadIntensidadSelections:
                                            classification == 'vulnerabilidad'
                                            ? (formData['intensidadSelections'] ??
                                                  {})
                                            : {},
                                        vulnerabilidadSelectedProbabilidad:
                                            null,
                                        vulnerabilidadSelectedIntensidad: null,
                                        evidenceImages: state.evidenceImages,
                                        evidenceCoordinates:
                                            state.evidenceCoordinates,
                                        createdAt: now,
                                        updatedAt: now,
                                        
                                      );

                                      // Guardar el nuevo formulario
                                      await persistenceService.saveCompleteForm(
                                        newCompleteForm,
                                      );
                                      await persistenceService.setActiveFormId(
                                        newCompleteForm.id,
                                      );

                                      // Actualizar HomeBloc y completar el formulario
                                      context.read<HomeBloc>().add(
                                        SetActiveFormId(
                                          formId: newCompleteForm.id,
                                          isCreatingNew: false,
                                        ),
                                      );

                                      // Cerrar el diálogo
                                      Navigator.of(context).pop();

                                      // Mostrar mensaje de éxito
                                      CustomSnackBar.showSuccess(
                                        context,
                                        title: 'Formulario completado',
                                        message:
                                            'El nuevo formulario ha sido guardado y completado exitosamente',
                                      );

                                      // Volver a Categorías (índice 0)
                                      context
                                          .read<RiskThreatAnalysisBloc>()
                                          .add(ChangeBottomNavIndex(0));
                                    }
                                  }
                                },
                              );
                            } else if (currentIndex == 4) {
                              CustomActionDialog.show(
                                context: context,
                                title: 'Finalizar formulario',
                                message:
                                    '¿Deseas finalizar el formulario? Antes de finalizar, puedes revisar tus respuestas.',
                                leftButtonText: 'Revisar  ',
                                leftButtonIcon: Icons.close,
                                rightButtonText: 'Finalizar  ',
                                rightButtonIcon: Icons.check_circle,
                                onRightButtonPressed: () async {
                                  // Guardar y completar el formulario
                                  final homeBloc = context.read<HomeBloc>();
                                  final homeState = homeBloc.state;
                                  final persistenceService =
                                      FormPersistenceService();

                                  if (homeState.activeFormId != null) {
                                    // Actualizar formulario existente
                                    final completeForm =
                                        await persistenceService
                                            .getCompleteForm(
                                              homeState.activeFormId!,
                                            );

                                    if (completeForm != null && context.mounted) {
                                      // Completar el formulario
                                      context.read<HomeBloc>().add(
                                        CompleteForm(completeForm.id),
                                      );

                                      // Cerrar el diálogo
                                      Navigator.of(context).pop();

                                      // Mostrar mensaje de éxito
                                      CustomSnackBar.showSuccess(
                                        context,
                                        title: 'Formulario completado',
                                        message:
                                            'El formulario ha sido guardado y completado exitosamente',
                                      );

                                      // Navegar a Home y mostrar FormCompletedScreen
                                      context.read<HomeBloc>().add(
                                        const HomeShowFormCompletedScreen(),
                                      );
                                      context.go('/home');
                                    }
                                  }
                                },
                                onLeftButtonPressed: () {
                                  // Cerrar el diálogo
                                  Navigator.of(context).pop();
                                },
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
