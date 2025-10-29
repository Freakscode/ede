import 'package:caja_herramientas/app/modules/home/presentation/bloc/home_event.dart';
import 'package:caja_herramientas/app/shared/models/complete_form_data_model.dart';
import 'package:caja_herramientas/app/shared/widgets/dialogs/custom_action_dialog.dart';
import 'package:caja_herramientas/app/shared/widgets/snackbars/custom_snackbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:caja_herramientas/app/core/theme/dagrd_colors.dart';
import '../bloc/risk_threat_analysis_bloc.dart';
import '../bloc/risk_threat_analysis_state.dart';
import '../bloc/risk_threat_analysis_event.dart';
import '../widgets/risk_matrix_widget.dart';
import '../widgets/widgets.dart';
import 'package:caja_herramientas/app/shared/models/risk_event_model.dart';
import 'package:caja_herramientas/app/shared/models/risk_event_factory.dart';
import '../../../home/presentation/bloc/home_bloc.dart';
import '../../../../shared/services/form_persistence_service.dart';

class FinalRiskResultsScreen extends StatefulWidget {
  const FinalRiskResultsScreen({super.key});

  @override
  State<FinalRiskResultsScreen> createState() => _FinalRiskResultsScreenState();
}

class _FinalRiskResultsScreenState extends State<FinalRiskResultsScreen> {
  bool _hasLoadedData = false;

  @override
  void initState() {
    super.initState();
    // Cargar todos los datos de amenaza y vulnerabilidad
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!_hasLoadedData && context.mounted) {
        _loadAllFormDataFromHome();
        _hasLoadedData = true;
      }
    });
  }

  void _loadAllFormDataFromHome() {
    final bloc = context.read<RiskThreatAnalysisBloc>();
    final homeBloc = context.read<HomeBloc>();

    final formId = homeBloc.state.activeFormId;
    if (formId != null && formId.isNotEmpty) {
      _loadAllFormData(formId, bloc);
    }
  }

  Future<void> _loadAllFormData(
    String formId,
    RiskThreatAnalysisBloc bloc,
  ) async {
    try {
      final persistenceService = FormPersistenceService();
      final completeForm = await persistenceService.getCompleteForm(formId);

      if (completeForm != null) {
        final evaluationData = completeForm.toJson();

        // Cargar datos de amenaza primero
        bloc.add(
          LoadFormData(
            eventName: completeForm.eventName,
            classificationType: 'amenaza',
            evaluationData: evaluationData,
          ),
        );

        // Esperar un poco antes de cargar vulnerabilidad para que no se sobrescriban
        await Future.delayed(const Duration(milliseconds: 100));

        // Cargar datos de vulnerabilidad
        bloc.add(
          LoadFormData(
            eventName: completeForm.eventName,
            classificationType: 'vulnerabilidad',
            evaluationData: evaluationData,
          ),
        );
      }
    } catch (e) {
      print('Error loading all form data: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<RiskThreatAnalysisBloc, RiskThreatAnalysisState>(
      builder: (context, state) {
        // PRINT DINÁMICO DEL ESTADO EN FINAL RISK RESULTS
        print('=== EVALUACIÓN COMPLETA DE RIESGO ===');
        print('Evento = ${state.selectedRiskEvent ?? ''}');

        // Obtener datos dinámicamente basados en el evento
        final riskEvent = _getRiskEventByName(state.selectedRiskEvent ?? '');
        if (riskEvent != null) {
          // Datos de Amenaza
          final amenazaClassification = riskEvent.classifications.firstWhere(
            (c) => c.name.toLowerCase() == 'amenaza',
            orElse: () => riskEvent.classifications.first,
          );

          print('\n--- AMENAZA ---');
          print(
            'Subclasificaciones disponibles: ${amenazaClassification.subClassifications.map((s) => s.name).join(", ")}',
          );

          // Calcular calificación general de Amenaza
          double amenazaGeneralScore = 0.0;
          int amenazaSubClassCount = 0;

          // Mostrar cada subclasificación de Amenaza usando métodos centralizados
          final bloc = context.read<RiskThreatAnalysisBloc>();
          for (final subClass in amenazaClassification.subClassifications) {
            final score = bloc.getSubClassificationScore(subClass.id);
            print(
              'Calificación de ${subClass.name} = ${score.toStringAsFixed(2)}',
            );

            if (score > 0) {
              amenazaGeneralScore += score;
              amenazaSubClassCount++;
            }

            // Mostrar secciones de esta subclasificación usando método centralizado
            final items = bloc.getItemsForSubClassification(subClass.id);
            if (items.isNotEmpty) {
              print('Calificaciones de cada sección de ${subClass.name}:');
              for (final item in items) {
                print('  - ${item['title']} = ${item['rating']}');
              }
            }
          }

          // Mostrar calificación general de Amenaza
          final amenazaGeneral = amenazaSubClassCount > 0
              ? amenazaGeneralScore / amenazaSubClassCount
              : 0.0;
          print(
            'CALIFICACIÓN GENERAL DE AMENAZA = ${amenazaGeneral.toStringAsFixed(2)}',
          );

          // Datos de Vulnerabilidad
          final vulnerabilidadClassification = riskEvent.classifications
              .firstWhere(
                (c) => c.name.toLowerCase() == 'vulnerabilidad',
                orElse: () => riskEvent.classifications.length > 1
                    ? riskEvent.classifications[1]
                    : riskEvent.classifications.first,
              );

          print('\n--- VULNERABILIDAD ---');
          print(
            'Subclasificaciones disponibles: ${vulnerabilidadClassification.subClassifications.map((s) => s.name).join(", ")}',
          );

          // Calcular calificación general de Vulnerabilidad
          double vulnerabilidadGeneralScore = 0.0;
          int vulnerabilidadSubClassCount = 0;

          // Mostrar cada subclasificación de Vulnerabilidad usando métodos centralizados
          for (final subClass
              in vulnerabilidadClassification.subClassifications) {
            final score = bloc.getSubClassificationScore(subClass.id);
            print(
              'Calificación de ${subClass.name} = ${score.toStringAsFixed(2)}',
            );

            if (score > 0) {
              vulnerabilidadGeneralScore += score;
              vulnerabilidadSubClassCount++;
            }

            // Mostrar secciones de esta subclasificación usando método centralizado
            final items = bloc.getItemsForSubClassification(subClass.id);
            if (items.isNotEmpty) {
              print('Calificaciones de cada sección de ${subClass.name}:');
              for (final item in items) {
                print('  - ${item['title']} = ${item['rating']}');
              }
            }
          }

          // Mostrar calificación general de Vulnerabilidad
          final vulnerabilidadGeneral = vulnerabilidadSubClassCount > 0
              ? vulnerabilidadGeneralScore / vulnerabilidadSubClassCount
              : 0.0;
          print(
            'CALIFICACIÓN GENERAL DE VULNERABILIDAD = ${vulnerabilidadGeneral.toStringAsFixed(2)}',
          );
        }

        // También imprimir datos guardados en HomeBloc para verificación
        // final homeBloc = context.read<HomeBloc>();
        // TODO: Implementar método getSavedRiskEventModel en HomeBloc

        print('\n=== DATOS PERSISTIDOS ===');
        print('Datos guardados: Verificar implementación en HomeBloc');
        print('=== FIN EVALUACIÓN ===');
        return SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 26, vertical: 28),
          child: Column(
            children: [
              // Título principal
              Text(
                'Perfil del Riesgo',
                textAlign: TextAlign.center,
                style: const TextStyle(
                  color: DAGRDColors.azulDAGRD,
                  fontFamily: 'Work Sans',
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                  height: 28 / 20,
                ),
              ),

              const SizedBox(height: 10),

              // Subtítulo
              Text(
                'Amenaza',
                textAlign: TextAlign.center,
                style: const TextStyle(
                  color: DAGRDColors.azulDAGRD, // AzulDAGRD
                  fontFamily: 'Work Sans',
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  height: 28 / 18, // 155.556%
                ),
              ),

              const SizedBox(height: 24),

              // Secciones de Amenaza
              _buildAmenazaSections(context, state),

              const SizedBox(height: 24),

              // Calificación de Amenaza
              _buildAmenazaRatingCard(context, state),

              const SizedBox(height: 32),

              // Botón Ir a Análisis de la Amenaza
              _buildAnalysisButton(
                context,
                'Ir a Análisis de la Amenaza',
                () {},
              ),

              const SizedBox(height: 24),
              Text(
                'Vulnerabilidad',
                textAlign: TextAlign.center,
                style: const TextStyle(
                  color: DAGRDColors.azulDAGRD, // AzulDAGRD
                  fontFamily: 'Work Sans',
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  height: 28 / 18, // 155.556%
                ),
              ),
              const SizedBox(height: 24),

              // Secciones de Vulnerabilidad
              _buildVulnerabilidadSections(context, state),

              const SizedBox(height: 24),

              // Calificación de Vulnerabilidad
              _buildVulnerabilidadRatingCard(context, state),
              const SizedBox(height: 24),

              _buildAnalysisButton(
                context,
                'Ir a Análisis de la Vulnerabilidad',
                () {},
              ),

              const SizedBox(height: 24),

              // Matriz de Riesgo Final
              RiskMatrixWidget(state: state),
              const SizedBox(height: 24),

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
                      // Guardar y completar el formulario
                      final homeBloc = context.read<HomeBloc>();
                      final homeState = homeBloc.state;
                      final persistenceService = FormPersistenceService();

                      if (homeState.activeFormId != null) {
                        // Actualizar formulario existente
                        final completeForm = await persistenceService
                            .getCompleteForm(homeState.activeFormId!);

                        if (completeForm != null) {
                          final now = DateTime.now();

                          CompleteFormDataModel updatedForm = completeForm
                              .copyWith(updatedAt: now);

                          await persistenceService.saveCompleteForm(
                            updatedForm,
                          );

                          if (context.mounted) {
                            context.read<HomeBloc>().add(
                              SetActiveFormId(
                                formId: updatedForm.id,
                                isCreatingNew: false,
                              ),
                            );

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
                        }
                      }
                    },
                    onLeftButtonPressed: () {
                      // Cerrar el diálogo
                      Navigator.of(context).pop();
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

  // Métodos para construir secciones de Amenaza
  Widget _buildAmenazaSections(
    BuildContext context,
    RiskThreatAnalysisState state,
  ) {
    final bloc = context.read<RiskThreatAnalysisBloc>();

    // Obtener subclasificaciones de amenaza
    final amenazaSubClassifications = ['probabilidad', 'intensidad'];

    return Column(
      children: amenazaSubClassifications.asMap().entries.map((entry) {
        final index = entry.key;
        final subClassId = entry.value;

        // Usar el método centralizado del BLoC para obtener items
        final items = bloc.getItemsForSubClassification(subClassId);
        final score = bloc.calculateSectionScore(subClassId);

        // Obtener el nombre de la subclasificación desde el evento
        final riskEvent = _getRiskEventByName(state.selectedRiskEvent ?? '');
        String title = subClassId;
        if (riskEvent != null) {
          final classification = riskEvent.classifications.firstWhere(
            (c) => c.id == 'amenaza',
            orElse: () => riskEvent.classifications.first,
          );
          final subClass = classification.subClassifications.firstWhere(
            (s) => s.id == subClassId,
            orElse: () => classification.subClassifications.first,
          );
          title = subClass.name;
        }

        return Column(
          children: [
            if (index > 0) const SizedBox(height: 24),
            RatingSectionWidget(title: title, score: score, items: items),
          ],
        );
      }).toList(),
    );
  }

  Widget _buildAmenazaRatingCard(
    BuildContext context,
    RiskThreatAnalysisState state,
  ) {
    return const ClassificationRatingCardWidget(classificationType: 'amenaza');
  }

  // Métodos para construir secciones de Vulnerabilidad
  Widget _buildVulnerabilidadSections(
    BuildContext context,
    RiskThreatAnalysisState state,
  ) {
    final bloc = context.read<RiskThreatAnalysisBloc>();

    // Obtener subclasificaciones de vulnerabilidad desde el evento
    final riskEvent = _getRiskEventByName(state.selectedRiskEvent ?? '');
    List<String> vulnerabilidadSubClassifications = [];

    if (riskEvent != null) {
      final classification = riskEvent.classifications.firstWhere(
        (c) => c.id == 'vulnerabilidad',
        orElse: () => riskEvent.classifications.first,
      );
      vulnerabilidadSubClassifications = classification.subClassifications
          .map((s) => s.id)
          .toList();
    }

    return Column(
      children: vulnerabilidadSubClassifications.asMap().entries.map((entry) {
        final index = entry.key;
        final subClassId = entry.value;

        // Construir items manualmente para vulnerabilidad
        final items = _buildVulnerabilidadItems(
          bloc,
          state,
          subClassId,
          riskEvent,
        );
        final score = bloc.calculateSectionScore(subClassId);

        // Obtener el nombre de la subclasificación
        String title = subClassId;
        if (riskEvent != null) {
          final classification = riskEvent.classifications.firstWhere(
            (c) => c.id == 'vulnerabilidad',
            orElse: () => riskEvent.classifications.first,
          );
          final subClass = classification.subClassifications.firstWhere(
            (s) => s.id == subClassId,
            orElse: () => classification.subClassifications.first,
          );
          title = subClass.name;
        }

        return Column(
          children: [
            if (index > 0) const SizedBox(height: 24),
            RatingSectionWidget(title: title, score: score, items: items),
          ],
        );
      }).toList(),
    );
  }

  Widget _buildVulnerabilidadRatingCard(
    BuildContext context,
    RiskThreatAnalysisState state,
  ) {
    return const ClassificationRatingCardWidget(
      classificationType: 'vulnerabilidad',
    );
  }

  // Método auxiliar para construir items de vulnerabilidad
  List<Map<String, dynamic>> _buildVulnerabilidadItems(
    RiskThreatAnalysisBloc bloc,
    RiskThreatAnalysisState state,
    String subClassId,
    RiskEventModel? riskEvent,
  ) {
    final items = <Map<String, dynamic>>[];

    if (riskEvent != null) {
      final classification = riskEvent.classifications.firstWhere(
        (c) => c.id == 'vulnerabilidad',
        orElse: () => riskEvent.classifications.first,
      );

      final subClass = classification.subClassifications.firstWhere(
        (s) => s.id == subClassId,
        orElse: () => classification.subClassifications.first,
      );

      for (final category in subClass.categories) {
        final selections = state.dynamicSelections[subClassId] ?? {};
        final selection = selections[category.title];

        final rating = _getRatingFromSelection(selection);
        final color = DAGRDColors.getNivelColorFromRating(rating);

        String title = category.title;
        if (rating == -1) {
          title = '${category.title} - No Aplica';
        } else if (rating == 0) {
          title = '${category.title} - Sin calificar';
        }

        items.add({'rating': rating, 'title': title, 'color': color});
      }
    }

    return items;
  }

  int _getRatingFromSelection(String? selectedLevel) {
    if (selectedLevel == null || selectedLevel.isEmpty) return 0;
    if (selectedLevel == 'NA') return -1;

    if (selectedLevel.contains('BAJO') && !selectedLevel.contains('MEDIO')) {
      return 1;
    } else if (selectedLevel.contains('MEDIO') &&
        selectedLevel.contains('ALTO')) {
      return 3;
    } else if (selectedLevel.contains('MEDIO')) {
      return 2;
    } else if (selectedLevel.contains('ALTO')) {
      return 4;
    }
    return 0;
  }

  RiskEventModel? _getRiskEventByName(String eventName) {
    return RiskEventFactory.getEventByName(eventName);
  }

  Widget _buildAnalysisButton(
    BuildContext context,
    String text,
    VoidCallback onPressed,
  ) {
    return SizedBox(
      width: double.infinity,
      child: TextButton(
        onPressed: onPressed,
        style: TextButton.styleFrom(
          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
          backgroundColor: Colors.transparent,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.arrow_back_ios,
              size: 16,
              color: DAGRDColors.azulSecundario, // Azul informativo
            ),
            const SizedBox(width: 8),
            Text(
              text,
              style: const TextStyle(
                color: DAGRDColors.azulSecundario, // Azul informativo
                fontFamily: 'Work Sans',
                fontSize: 15,
                fontWeight: FontWeight.w500,
                height: 16 / 15, // 106.667%
              ),
            ),
          ],
        ),
      ),
    );
  }
}
