import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:caja_herramientas/app/core/theme/dagrd_colors.dart';
import '../../bloc/risk_threat_analysis_bloc.dart';
import '../../bloc/risk_threat_analysis_state.dart';

class ProgressBarWidget extends StatelessWidget {
  const ProgressBarWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<RiskThreatAnalysisBloc, RiskThreatAnalysisState>(
      builder: (context, state) {
        // Calcular progreso basado en las selecciones realizadas
        final progress = _calculateProgress(state);
        
        // Texto dinámico según la clasificación
        final classificationName = state.selectedClassification == 'amenaza' 
          ? 'Amenaza' 
          : 'Vulnerabilidad';
        final progressText = '${(progress * 100).toInt()}% $classificationName completada';
        
        return Column(
          children: [
            Container(
              height: 16,
              decoration: BoxDecoration(
                color: const Color(0xFFE5E7EB),
                borderRadius: BorderRadius.circular(99),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(99),
                child: LinearProgressIndicator(
                  value: progress,
                  backgroundColor: Colors.transparent,
                  valueColor: AlwaysStoppedAnimation<Color>(
                    // Color dinámico según la clasificación
                    state.selectedClassification == 'amenaza' 
                      ? const Color(0xFF10B981) // Verde para amenaza
                      : const Color(0xFF6366F1), // Morado para vulnerabilidad
                  ),
                ),
              ),
            ),
            const SizedBox(height: 8),
            Text(
              progressText,
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: DAGRDColors.grisMedio,
                fontFamily: 'Work Sans',
                fontSize: 12,
                fontWeight: FontWeight.w400,
                height: 16 / 12,
              ),
            ),
          ],
        );
      },
    );
  }
  
  double _calculateProgress(RiskThreatAnalysisState state) {
    double total = 0.0;
    double completed = 0.0;
    
    if (state.selectedClassification == 'amenaza') {
      // Para amenaza: probabilidad e intensidad
      total += 2;
      if (state.probabilidadSelections.isNotEmpty) completed += 1;
      if (state.intensidadSelections.isNotEmpty) completed += 1;
    } else if (state.selectedClassification == 'vulnerabilidad') {
      // Para vulnerabilidad: selecciones dinámicas
      final expectedSelections = ['social', 'economico', 'ambiental', 'fisico'];
      total += expectedSelections.length;
      for (final selection in expectedSelections) {
        if (state.dynamicSelections[selection]?.isNotEmpty == true) {
          completed += 1;
        }
      }
    }
    
    return total > 0 ? completed / total : 0.0;
  }
}