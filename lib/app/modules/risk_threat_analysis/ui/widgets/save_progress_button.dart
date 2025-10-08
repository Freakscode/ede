import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:caja_herramientas/app/core/icons/app_icons.dart';
import 'package:caja_herramientas/app/core/theme/dagrd_colors.dart';
import 'package:caja_herramientas/app/shared/services/form_persistence_service.dart';
import 'package:caja_herramientas/app/shared/models/persistent_form_data_model.dart';
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
      // Obtener datos actuales del formulario
      final formData = bloc.getCurrentFormData();
      
      // Crear PersistentFormDataModel
      final now = DateTime.now();
      final formModel = PersistentFormDataModel(
        id: '${state.selectedRiskEvent}_${state.selectedClassification}_${now.millisecondsSinceEpoch}',
        eventName: state.selectedRiskEvent,
        classificationType: state.selectedClassification,
        dynamicSelections: formData['dynamicSelections'] ?? {},
        subClassificationScores: formData['subClassificationScores'] ?? {},
        subClassificationColors: formData['subClassificationColors'] ?? {},
        probabilidadSelections: formData['probabilidadSelections'] ?? {},
        intensidadSelections: formData['intensidadSelections'] ?? {},
        selectedProbabilidad: formData['selectedProbabilidad'],
        selectedIntensidad: formData['selectedIntensidad'],
        createdAt: now,
        updatedAt: now,
      );
      
      // Guardar en SQLite
      final persistenceService = FormPersistenceService();
      await persistenceService.saveForm(formModel);
      
      // Establecer como formulario activo
      await persistenceService.setActiveFormId(formModel.id);
      
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Progreso guardado exitosamente'),
            duration: Duration(seconds: 2),
            backgroundColor: Colors.green,
          ),
        );
      }
      
      print('SaveProgressButton: Formulario guardado en SQLite - ${formModel.id}');
      
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
