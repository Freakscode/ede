import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:caja_herramientas/app/core/icons/app_icons.dart';
import 'package:caja_herramientas/app/core/theme/dagrd_colors.dart';
import '../../bloc/risk_threat_analysis_bloc.dart';
import '../../bloc/risk_threat_analysis_event.dart';
import '../../bloc/risk_threat_analysis_state.dart';

class SaveProgressButton extends StatelessWidget {
  final VoidCallback? onPressed;
  final String? text;

  const SaveProgressButton({
    super.key,
    this.onPressed,
    this.text,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<RiskThreatAnalysisBloc, RiskThreatAnalysisState>(
      builder: (context, state) {
        return SizedBox(
          width: double.infinity,
          height: 48,
          child: ElevatedButton.icon(
            onPressed: onPressed ?? () => _handleSaveProgress(context, state),
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

  void _handleSaveProgress(BuildContext context, RiskThreatAnalysisState state) {
    final bloc = context.read<RiskThreatAnalysisBloc>();
    
    // 1. Guardar progreso actual
    bloc.add(SaveCurrentFormData());
    
    // 2. Verificar si el proceso actual está completo
    if (_isCurrentProcessComplete(state)) {
      // 3. Determinar siguiente paso en el flujo
      if (state.selectedClassification == 'amenaza') {
        // Amenaza completada → pasar a vulnerabilidad
        _showTransitionDialog(context, () {
          bloc.add(SelectClassification('vulnerabilidad'));
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Proceso de Amenaza completado. Ahora evalúe la Vulnerabilidad.'),
              backgroundColor: Colors.blue,
            ),
          );
        });
      } else if (state.selectedClassification == 'vulnerabilidad') {
        // Vulnerabilidad completada → ir a evidencias
        _showCompletionDialog(context, () {
          bloc.add(ChangeBottomNavIndex(1)); // Ir a evidencias
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Evaluación de Vulnerabilidad completada. Agregue evidencias.'),
              backgroundColor: Colors.green,
            ),
          );
        });
      }
    } else {
      // Proceso no completo, solo mostrar confirmación de guardado
      final isNewForm = state.activeFormId == null;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(isNewForm 
                ? '✨ Nuevo formulario creado y guardado' 
                : '✅ Progreso actualizado correctamente'
              ),
              const SizedBox(height: 4),
              Text(
                'Aparecerá en "Mis Formularios" → En proceso',
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.green[100],
                ),
              ),
            ],
          ),
          backgroundColor: Colors.green,
          duration: const Duration(seconds: 4),
        ),
      );
    }
  }

  bool _isCurrentProcessComplete(RiskThreatAnalysisState state) {
    if (state.selectedClassification == 'amenaza') {
      // Verificar si amenaza está completa (probabilidad e intensidad)
      return state.probabilidadSelections.isNotEmpty && 
             state.intensidadSelections.isNotEmpty;
    } else if (state.selectedClassification == 'vulnerabilidad') {
      // Verificar si vulnerabilidad está completa (todos los aspectos)
      final requiredAspects = ['social', 'economico', 'ambiental', 'fisico'];
      return requiredAspects.every((aspect) => 
        state.dynamicSelections[aspect]?.isNotEmpty == true
      );
    }
    return false;
  }

  void _showTransitionDialog(BuildContext context, VoidCallback onConfirm) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Proceso de Amenaza Completado'),
          content: const Text(
            '¿Desea continuar con la evaluación de Vulnerabilidad?'
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Continuar más tarde'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
                onConfirm();
              },
              child: const Text('Evaluar Vulnerabilidad'),
            ),
          ],
        );
      },
    );
  }

  void _showCompletionDialog(BuildContext context, VoidCallback onConfirm) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Evaluación Completada'),
          content: const Text(
            'Ha completado tanto la evaluación de Amenaza como de Vulnerabilidad. ¿Desea agregar evidencias?'
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Más tarde'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
                onConfirm();
              },
              child: const Text('Agregar Evidencias'),
            ),
          ],
        );
      },
    );
  }
}