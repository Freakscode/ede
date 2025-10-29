import 'package:caja_herramientas/app/modules/auth/services/auth_service.dart';
import 'package:caja_herramientas/app/modules/home/presentation/bloc/home_bloc.dart';
import 'package:caja_herramientas/app/modules/home/presentation/bloc/home_event.dart';
import 'package:caja_herramientas/app/modules/risk_threat_analysis/presentation/bloc/risk_threat_analysis_event.dart';
import 'package:caja_herramientas/app/shared/models/complete_form_data_model.dart';
import 'package:caja_herramientas/app/shared/services/form_persistence_service.dart';
import 'package:caja_herramientas/app/shared/widgets/dialogs/custom_action_dialog.dart';
import 'package:caja_herramientas/app/shared/widgets/snackbars/custom_snackbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:caja_herramientas/app/core/theme/dagrd_colors.dart';
import '../bloc/risk_threat_analysis_bloc.dart';
import '../bloc/risk_threat_analysis_state.dart';
import '../widgets/widgets.dart';

class RatingResultsScreen extends StatelessWidget {
  const RatingResultsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<RiskThreatAnalysisBloc, RiskThreatAnalysisState>(
      builder: (context, state) {
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 26, vertical: 28),
          child: Column(
            children: [
              Text(
                'Metodología de Análisis del Riesgo',
                textAlign: TextAlign.center,
                style: const TextStyle(
                  color: DAGRDColors.azulDAGRD,
                  fontFamily: 'Work Sans',
                  fontSize: 20,
                  fontStyle: FontStyle.normal,
                  fontWeight: FontWeight.w600,
                  height: 28 / 20,
                ),
              ),
              const SizedBox(height: 24),
              _buildAllSections(context, state),
              const SizedBox(height: 24),

              // Componente de Calificación dinámico
              _buildThreatRatingCard(context, state),

              const SizedBox(height: 14),

              // Barra de progreso dinámica
              const ProgressBarWidget(),

              const SizedBox(height: 40),

              // Botones de navegación
              NavigationButtonsWidget(
                currentIndex: state.currentBottomNavIndex,
                onContinuePressed: () {
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
                      final persistenceService = FormPersistenceService();
                      final riskBloc = context.read<RiskThreatAnalysisBloc>();

                      if (homeState.activeFormId != null) {
                        // Actualizar formulario existente
                        final completeForm = await persistenceService
                            .getCompleteForm(homeState.activeFormId!);

                        if (completeForm != null) {
                          final formData = riskBloc.getCurrentFormData();
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
                            final amenazaScoresOnly = Map<String, double>.from(
                              completeForm.amenazaScores,
                            );
                            final amenazaColorsOnly = Map<String, Color>.from(
                              completeForm.amenazaColors,
                            );

                            if (allScoresUpdate.containsKey('probabilidad')) {
                              amenazaScoresOnly['probabilidad'] =
                                  allScoresUpdate['probabilidad']!;
                            }
                            if (allScoresUpdate.containsKey('intensidad')) {
                              amenazaScoresOnly['intensidad'] =
                                  allScoresUpdate['intensidad']!;
                            }
                            if (allColorsUpdate.containsKey('probabilidad')) {
                              amenazaColorsOnly['probabilidad'] =
                                  allColorsUpdate['probabilidad']!;
                            }
                            if (allColorsUpdate.containsKey('intensidad')) {
                              amenazaColorsOnly['intensidad'] =
                                  allColorsUpdate['intensidad']!;
                            }

                            updatedForm = completeForm.copyWith(
                              amenazaSelections:
                                  formData['dynamicSelections'] ??
                                  completeForm.amenazaSelections,
                              amenazaProbabilidadSelections:
                                  formData['probabilidadSelections'] ??
                                  completeForm.amenazaProbabilidadSelections,
                              amenazaIntensidadSelections:
                                  formData['intensidadSelections'] ??
                                  completeForm.amenazaIntensidadSelections,
                              amenazaScores: amenazaScoresOnly,
                              amenazaColors: amenazaColorsOnly,
                              amenazaSelectedProbabilidad:
                                  formData['selectedProbabilidad'] ??
                                  completeForm.amenazaSelectedProbabilidad,
                              amenazaSelectedIntensidad:
                                  formData['selectedIntensidad'] ??
                                  completeForm.amenazaSelectedIntensidad,
                              evidenceImages: riskBloc.state.evidenceImages,
                              evidenceCoordinates:
                                  riskBloc.state.evidenceCoordinates,
                              updatedAt: now,
                            );
                          } else if (classification == 'vulnerabilidad') {
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
                              if (allScoresUpdate.containsKey(key)) {
                                vulnerabilidadScoresOnly[key] =
                                    allScoresUpdate[key]!;
                              }
                              if (allColorsUpdate.containsKey(key)) {
                                vulnerabilidadColorsOnly[key] =
                                    allColorsUpdate[key]!;
                              }
                            }

                            updatedForm = completeForm.copyWith(
                              vulnerabilidadSelections:
                                  formData['dynamicSelections'] ??
                                  completeForm.vulnerabilidadSelections,
                              vulnerabilidadProbabilidadSelections:
                                  formData['probabilidadSelections'] ??
                                  completeForm
                                      .vulnerabilidadProbabilidadSelections,
                              vulnerabilidadIntensidadSelections:
                                  formData['intensidadSelections'] ??
                                  completeForm
                                      .vulnerabilidadIntensidadSelections,
                              vulnerabilidadScores: vulnerabilidadScoresOnly,
                              vulnerabilidadColors: vulnerabilidadColorsOnly,
                              vulnerabilidadSelectedProbabilidad:
                                  formData['selectedProbabilidad'] ??
                                  completeForm
                                      .vulnerabilidadSelectedProbabilidad,
                              vulnerabilidadSelectedIntensidad:
                                  formData['selectedIntensidad'] ??
                                  completeForm.vulnerabilidadSelectedIntensidad,
                              evidenceImages: riskBloc.state.evidenceImages,
                              evidenceCoordinates:
                                  riskBloc.state.evidenceCoordinates,
                              updatedAt: now,
                            );
                          } else {
                            // Si no hay clasificación clara, actualizar ambos
                            updatedForm = completeForm.copyWith(
                              evidenceImages: riskBloc.state.evidenceImages,
                              evidenceCoordinates:
                                  riskBloc.state.evidenceCoordinates,
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
                            
                            // Marcar el formulario como completado
                            context.read<HomeBloc>().add(
                              CompleteForm(updatedForm.id),
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
                          context.read<RiskThreatAnalysisBloc>().add(
                            ChangeBottomNavIndex(0),
                          );

                          // Cerrar el diálogo
                          Navigator.of(context).pop();
                        } else {
                          // No existe el formulario, crear uno nuevo
                          final formData = riskBloc.getCurrentFormData();
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
                          Map<String, double> vulnerabilidadScores = {};

                          if (classification == 'amenaza') {
                            if (allScoresNew.containsKey('probabilidad')) {
                              amenazaScores['probabilidad'] =
                                  allScoresNew['probabilidad']!;
                            }
                            if (allScoresNew.containsKey('intensidad')) {
                              amenazaScores['intensidad'] =
                                  allScoresNew['intensidad']!;
                            }
                          } else if (classification == 'vulnerabilidad') {
                            final vulnerabilidadKeys = [
                              'fragilidad_fisica',
                              'fragilidad_personas',
                              'exposicion',
                            ];
                            for (final key in vulnerabilidadKeys) {
                              if (allScoresNew.containsKey(key)) {
                                vulnerabilidadScores[key] = allScoresNew[key]!;
                              }
                            }
                          }

                          // Convertir colores
                          final colorsData =
                              formData['subClassificationColors']
                                  as Map<String, Color>? ??
                              {};
                          final serializableColors = <String, Color>{};
                          colorsData.forEach((key, value) {
                            serializableColors[key] = value;
                          });

                          final newFormId =
                              '${state.selectedRiskEvent ?? ''}_complete_${now.millisecondsSinceEpoch}';

                          final newCompleteForm = CompleteFormDataModel(
                            id: newFormId,
                            eventName: state.selectedRiskEvent ?? '',
                            contactData: contactData,
                            inspectionData: inspectionData,
                            amenazaSelections: classification == 'amenaza'
                                ? (formData['dynamicSelections'] ?? {})
                                : {},
                            amenazaScores: amenazaScores,
                            amenazaColors: classification == 'amenaza'
                                ? serializableColors
                                : {},
                            amenazaProbabilidadSelections:
                                classification == 'amenaza'
                                ? (formData['probabilidadSelections'] ?? {})
                                : {},
                            amenazaIntensidadSelections:
                                classification == 'amenaza'
                                ? (formData['intensidadSelections'] ?? {})
                                : {},
                            amenazaSelectedProbabilidad: null,
                            amenazaSelectedIntensidad: null,
                            vulnerabilidadSelections:
                                classification == 'vulnerabilidad'
                                ? (formData['dynamicSelections'] ?? {})
                                : {},
                            vulnerabilidadScores: vulnerabilidadScores,
                            vulnerabilidadColors:
                                classification == 'vulnerabilidad'
                                ? serializableColors
                                : {},
                            vulnerabilidadProbabilidadSelections:
                                classification == 'vulnerabilidad'
                                ? (formData['probabilidadSelections'] ?? {})
                                : {},
                            vulnerabilidadIntensidadSelections:
                                classification == 'vulnerabilidad'
                                ? (formData['intensidadSelections'] ?? {})
                                : {},
                            vulnerabilidadSelectedProbabilidad: null,
                            vulnerabilidadSelectedIntensidad: null,
                            evidenceImages: state.evidenceImages,
                            evidenceCoordinates: state.evidenceCoordinates,
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
                          
                          // Marcar el formulario como completado
                          context.read<HomeBloc>().add(
                            CompleteForm(newCompleteForm.id),
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
                          context.read<RiskThreatAnalysisBloc>().add(
                            ChangeBottomNavIndex(0),
                          );
                        }
                      }
                    },
                  );
                },
              ),

              const SizedBox(height: 50),
            ],
          ),
        );
      },
    );
  }

  Widget _buildAllSections(
    BuildContext context,
    RiskThreatAnalysisState state,
  ) {
    final bloc = context.read<RiskThreatAnalysisBloc>();

    // Usar la misma lógica que el RatingScreen - obtener subclasificaciones desde el BLoC
    final subClassifications = bloc.getCurrentSubClassifications();

    return Column(
      children: subClassifications.asMap().entries.map((entry) {
        final index = entry.key;
        final subClassification = entry.value;

        // Construir items para esta subclasificación
        final items = _buildItemsForSubClassification(
          bloc,
          state,
          subClassification.id,
        );
        final score = bloc.calculateSectionScore(subClassification.id);

        return Column(
          children: [
            if (index > 0) const SizedBox(height: 24),
            RatingSectionWidget(
              title: subClassification.name,
              score: score,
              items: items,
            ),
          ],
        );
      }).toList(),
    );
  }

  List<Map<String, dynamic>> _buildItemsForSubClassification(
    RiskThreatAnalysisBloc bloc,
    RiskThreatAnalysisState state,
    String subClassificationId,
  ) {
    // Usar el método centralizado del BLoC para obtener items
    return bloc.getItemsForSubClassification(subClassificationId);
  }

  // Métodos eliminados - ahora se usan los métodos centralizados del BLoC
  // _getRatingFromSelection -> bloc.getRatingFromSelection
  // _getColorFromRating -> bloc.getColorFromRating
  // _calculateSectionScore -> bloc.calculateSectionScore

  Widget _buildThreatRatingCard(
    BuildContext context,
    RiskThreatAnalysisState state,
  ) {
    final classificationType = (state.selectedClassification ?? '')
        .toLowerCase();
    return ClassificationRatingCardWidget(
      classificationType: classificationType,
    );
  }
}
