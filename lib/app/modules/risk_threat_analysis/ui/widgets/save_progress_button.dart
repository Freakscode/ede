import 'package:caja_herramientas/app/shared/widgets/dialogs/custom_action_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:caja_herramientas/app/core/icons/app_icons.dart';
import 'package:caja_herramientas/app/core/theme/dagrd_colors.dart';
import 'package:caja_herramientas/app/shared/services/form_persistence_service.dart';
import 'package:caja_herramientas/app/shared/models/complete_form_data_model.dart';
import '../../bloc/risk_threat_analysis_bloc.dart';
import '../../bloc/risk_threat_analysis_state.dart';

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

    try {
      final persistenceService = FormPersistenceService();

      // Obtener datos actuales del formulario
      final formData = bloc.getCurrentFormData();

      // Crear ID único para el formulario completo
      final formId =
          '${state.selectedRiskEvent}_complete_${DateTime.now().millisecondsSinceEpoch}';

      // Verificar si ya existe un formulario completo para este evento
      final existingForms = await persistenceService.getCompleteFormsByEvent(
        state.selectedRiskEvent,
      );

      CompleteFormDataModel completeForm;
      final now = DateTime.now();

      if (existingForms.isNotEmpty) {
        // Actualizar formulario existente
        print(
          'SaveProgressButton: Actualizando formulario existente ${existingForms.first.id}',
        );
        completeForm = existingForms.first;

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
      } else {
        // Crear nuevo formulario completo (primera vez que se guarda progreso)
        print(
          'SaveProgressButton: Creando formulario por primera vez para evento ${state.selectedRiskEvent}',
        );
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
      }

      if (context.mounted) {
        CustomActionDialog.show(
          context: context,
          title: 'Guardar borrador',
          message:
              '¿Está seguro que desea guardar un borrador de este formulario? Podrá continuar más tarde. ',
          leftButtonText: 'Revisar ',
          leftButtonIcon: Icons.close,
          rightButtonText: 'Guardar ',
          rightButtonIcon: Icons.check,
          onRightButtonPressed: () async {
            // Guardar formulario completo
            await persistenceService.saveCompleteForm(completeForm);

            // Establecer como formulario activo
            await persistenceService.setActiveFormId(completeForm.id);
            
            Navigator.of(context).pop();

            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Progreso guardado exitosamente'),
                duration: Duration(seconds: 2),
                backgroundColor: Colors.green,
              ),
            );
          },
        );
      }

      print(
        'SaveProgressButton: Formulario completo guardado - ${completeForm.id} (${state.selectedClassification})',
      );
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
