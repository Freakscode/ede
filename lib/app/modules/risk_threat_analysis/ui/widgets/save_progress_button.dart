import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:caja_herramientas/app/core/icons/app_icons.dart';
import 'package:caja_herramientas/app/core/theme/dagrd_colors.dart';
import 'package:caja_herramientas/app/shared/services/form_persistence_service.dart';
import 'package:caja_herramientas/app/shared/models/complete_form_data_model.dart';
import 'package:caja_herramientas/app/shared/widgets/dialogs/custom_action_dialog.dart';
import '../../bloc/risk_threat_analysis_bloc.dart';
import '../../bloc/risk_threat_analysis_state.dart';
import '../../../home/bloc/home_bloc.dart';
import '../../../home/bloc/home_event.dart';

class SaveProgressButton extends StatelessWidget {
  final VoidCallback? onPressed;
  final String? text;

  const SaveProgressButton({super.key, this.onPressed, this.text});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<RiskThreatAnalysisBloc, RiskThreatAnalysisState>(
      builder: (context, state) {
        return SizedBox(
          width: double.infinity,
          height: 48,
          child: ElevatedButton.icon(
            onPressed: onPressed ?? () => _showProgressInfo(context),
            icon: SvgPicture.asset(
              AppIcons.save,
              width: 20,
              height: 20,
              colorFilter: const ColorFilter.mode(
                DAGRDColors.blancoDAGRD,
                BlendMode.srcIn,
              ),
            ),
            label: Text(
              text ?? 'Guardar avance',
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: Color(0xFFFFFFFF), // #FFF
                fontFamily: 'Work Sans',
                fontSize: 14,
                fontWeight: FontWeight.w500,
                height: 24 / 14, // line-height: 171.429%
              ),
            ),
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF2563EB),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              elevation: 0,
            ),
          ),
        );
      },
    );
  }

  void _showProgressInfo(BuildContext context) async {
    final bloc = context.read<RiskThreatAnalysisBloc>();
    final state = bloc.state;
    final homeBloc = context.read<HomeBloc>();
    final homeState = homeBloc.state;

    print('=== SaveProgressButton: Iniciando guardado ===');
    print('Evento seleccionado: ${state.selectedRiskEvent}');
    print('Clasificación seleccionada: ${state.selectedClassification}');
    print('isCreatingNew: ${homeState.isCreatingNew}');
    print('activeFormId: ${homeState.activeFormId}');

    try {
      final persistenceService = FormPersistenceService();

      // Obtener datos actuales del formulario
      final formData = bloc.getCurrentFormData();
      print('FormData obtenido: $formData');

      // Crear ID único para el formulario completo
      final formId =
          '${state.selectedRiskEvent}_complete_${DateTime.now().millisecondsSinceEpoch}';
      print('FormID generado: $formId');

      CompleteFormDataModel completeForm;
      final now = DateTime.now();

      // Si estamos creando un nuevo formulario, siempre crear uno nuevo
      if (homeState.isCreatingNew || homeState.activeFormId == null) {
        print('SaveProgressButton: Creando nuevo formulario (isCreatingNew: ${homeState.isCreatingNew})');
        
        completeForm = CompleteFormDataModel(
          id: formId,
          eventName: state.selectedRiskEvent,
          amenazaSelections:
              state.selectedClassification.toLowerCase() == 'amenaza'
              ? (formData['dynamicSelections'] ?? {})
              : {},
          amenazaScores: state.selectedClassification.toLowerCase() == 'amenaza'
              ? (formData['subClassificationScores'] ?? {})
              : {},
          amenazaColors: state.selectedClassification.toLowerCase() == 'amenaza'
              ? (formData['subClassificationColors'] ?? {})
              : {},
          amenazaProbabilidadSelections:
              state.selectedClassification.toLowerCase() == 'amenaza'
              ? (formData['probabilidadSelections'] ?? {})
              : {},
          amenazaIntensidadSelections:
              state.selectedClassification.toLowerCase() == 'amenaza'
              ? (formData['intensidadSelections'] ?? {})
              : {},
          amenazaSelectedProbabilidad:
              state.selectedClassification.toLowerCase() == 'amenaza'
              ? formData['selectedProbabilidad']
              : null,
          amenazaSelectedIntensidad:
              state.selectedClassification.toLowerCase() == 'amenaza'
              ? formData['selectedIntensidad']
              : null,
          vulnerabilidadSelections:
              state.selectedClassification.toLowerCase() == 'vulnerabilidad'
              ? (formData['dynamicSelections'] ?? {})
              : {},
          vulnerabilidadScores:
              state.selectedClassification.toLowerCase() == 'vulnerabilidad'
              ? (formData['subClassificationScores'] ?? {})
              : {},
          vulnerabilidadColors:
              state.selectedClassification.toLowerCase() == 'vulnerabilidad'
              ? (formData['subClassificationColors'] ?? {})
              : {},
          vulnerabilidadProbabilidadSelections:
              state.selectedClassification.toLowerCase() == 'vulnerabilidad'
              ? (formData['probabilidadSelections'] ?? {})
              : {},
          vulnerabilidadIntensidadSelections:
              state.selectedClassification.toLowerCase() == 'vulnerabilidad'
              ? (formData['intensidadSelections'] ?? {})
              : {},
          vulnerabilidadSelectedProbabilidad:
              state.selectedClassification.toLowerCase() == 'vulnerabilidad'
              ? formData['selectedProbabilidad']
              : null,
          vulnerabilidadSelectedIntensidad:
              state.selectedClassification.toLowerCase() == 'vulnerabilidad'
              ? formData['selectedIntensidad']
              : null,
          createdAt: now,
          updatedAt: now,
        );
      } else {
        // Estamos editando un formulario existente
        print('SaveProgressButton: Editando formulario existente ${homeState.activeFormId}');
        
        // Obtener el formulario existente por ID
        final existingForm = await persistenceService.getCompleteForm(homeState.activeFormId!);
        if (existingForm == null) {
          throw Exception('No se encontró el formulario existente con ID: ${homeState.activeFormId}');
        }

        completeForm = existingForm;

        // Actualizar según la clasificación actual
        if (state.selectedClassification.toLowerCase() == 'amenaza') {
          completeForm = completeForm.copyWith(
            amenazaSelections:
                formData['dynamicSelections'] ?? completeForm.amenazaSelections,
            amenazaScores:
                formData['subClassificationScores'] ??
                completeForm.amenazaScores,
            amenazaColors:
                formData['subClassificationColors'] ??
                completeForm.amenazaColors,
            amenazaProbabilidadSelections:
                formData['probabilidadSelections'] ??
                completeForm.amenazaProbabilidadSelections,
            amenazaIntensidadSelections:
                formData['intensidadSelections'] ??
                completeForm.amenazaIntensidadSelections,
            amenazaSelectedProbabilidad:
                formData['selectedProbabilidad'] ??
                completeForm.amenazaSelectedProbabilidad,
            amenazaSelectedIntensidad:
                formData['selectedIntensidad'] ??
                completeForm.amenazaSelectedIntensidad,
            updatedAt: now,
          );
        } else if (state.selectedClassification.toLowerCase() ==
            'vulnerabilidad') {
          completeForm = completeForm.copyWith(
            vulnerabilidadSelections:
                formData['dynamicSelections'] ??
                completeForm.vulnerabilidadSelections,
            vulnerabilidadScores:
                formData['subClassificationScores'] ??
                completeForm.vulnerabilidadScores,
            vulnerabilidadColors:
                formData['subClassificationColors'] ??
                completeForm.vulnerabilidadColors,
            vulnerabilidadProbabilidadSelections:
                formData['probabilidadSelections'] ??
                completeForm.vulnerabilidadProbabilidadSelections,
            vulnerabilidadIntensidadSelections:
                formData['intensidadSelections'] ??
                completeForm.vulnerabilidadIntensidadSelections,
            vulnerabilidadSelectedProbabilidad:
                formData['selectedProbabilidad'] ??
                completeForm.vulnerabilidadSelectedProbabilidad,
            vulnerabilidadSelectedIntensidad:
                formData['selectedIntensidad'] ??
                completeForm.vulnerabilidadSelectedIntensidad,
            updatedAt: now,
          );
        }
      }

      if (context.mounted) {
        CustomActionDialog.show(
          context: context,
          title: 'Guardar borrador',
          message:
              '¿Está seguro que desea guardar un borrador de este formulario? Podrá continuar más tarde.',
          leftButtonText: 'Cancelar',
          leftButtonIcon: Icons.close,
          rightButtonText: 'Guardar',
          rightButtonIcon: Icons.check,
          onRightButtonPressed: () async {
            print('=== SaveProgressButton: Usuario confirmó guardado ===');
            print('Formulario a guardar: ${completeForm.id}');
            
            try {
              // Guardar formulario completo
              await persistenceService.saveCompleteForm(completeForm);
              print('SaveProgressButton: Formulario guardado en base de datos');

              // Establecer como formulario activo
              await persistenceService.setActiveFormId(completeForm.id);
              print('SaveProgressButton: Formulario activo establecido');

              // Si era un formulario nuevo, actualizar el estado del HomeBloc
              if (homeState.isCreatingNew) {
                homeBloc.add(SetActiveFormId(completeForm.id, isCreatingNew: false));
                print('SaveProgressButton: Actualizando HomeBloc - isCreatingNew: false');
              }

              print(
                'SaveProgressButton: Formulario completo guardado exitosamente - ${completeForm.id} (${state.selectedClassification})',
              );

              Navigator.of(context).pop();

              if (context.mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Progreso guardado exitosamente'),
                    duration: Duration(seconds: 2),
                    backgroundColor: Colors.green,
                  ),
                );
              }
            } catch (e) {
              print('SaveProgressButton: Error en onRightButtonPressed - $e');
              Navigator.of(context).pop();
              
              if (context.mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Error al guardar: $e'),
                    duration: const Duration(seconds: 3),
                    backgroundColor: Colors.red,
                  ),
                );
              }
            }
          },
        );
      }
    } catch (e) {
      print('SaveProgressButton: Error al guardar progreso - $e');

      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error al guardar progreso: $e'),
            duration: const Duration(seconds: 3),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }
}
