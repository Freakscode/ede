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
        final progress = _calculateProgress(context, state);
        
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
  
  double _calculateProgress(BuildContext context, RiskThreatAnalysisState state) {
    double total = 0.0;
    double completed = 0.0;
    
    print('🔍 PROGRESS DEBUG:');
    print('   Clasificación: ${state.selectedClassification}');
    print('   Dynamic Selections: ${state.dynamicSelections}');
    
    if (state.selectedClassification == 'amenaza') {
      // Para amenaza: probabilidad e intensidad
      total += 2;
      if (state.probabilidadSelections.isNotEmpty) completed += 1;
      if (state.intensidadSelections.isNotEmpty) completed += 1;
      print('   Amenaza - Total: $total, Completed: $completed');
    } else if (state.selectedClassification == 'vulnerabilidad') {
      // Para vulnerabilidad: obtener dinámicamente las subclasificaciones
      return _calculateVulnerabilidadProgress(context, state);
    }
    
    final progress = total > 0 ? completed / total : 0.0;
    print('   Progress final: $progress');
    return progress;
  }
  
  double _calculateVulnerabilidadProgress(BuildContext context, RiskThreatAnalysisState state) {
    print('🔍 VULNERABILIDAD DEBUG DETALLADO:');
    print('   subClassificationScores.keys: ${state.subClassificationScores.keys.toList()}');
    print('   dynamicSelections.keys: ${state.dynamicSelections.keys.toList()}');
    
    // Obtener todas las subclasificaciones esperadas desde el BLoC
    final bloc = context.read<RiskThreatAnalysisBloc>();
    final allExpectedSubClassifications = bloc.getVulnerabilidadSubClassifications();
    final expectedIds = allExpectedSubClassifications.map((sub) => sub.id).toList();
    
    print('   📋 Subclasificaciones ESPERADAS desde BLoC: $expectedIds');
    print('   📊 Subclasificaciones CON DATOS en estado: ${state.dynamicSelections.keys.where((id) => id != 'probabilidad' && id != 'intensidad').toList()}');
    
    if (expectedIds.isEmpty) {
      print('   ❌ Sin subclasificaciones de vulnerabilidad definidas en el modelo');
      return 0.0;
    }
    
    double total = expectedIds.length.toDouble();
    double completed = 0.0;
    
    for (final subClassId in expectedIds) {
      final selections = state.dynamicSelections[subClassId];
      final hasSelections = selections?.isNotEmpty == true;
      
      print('   [$subClassId]:');
      print('     - Selections: $selections');
      print('     - isEmpty: ${selections?.isEmpty}');
      print('     - Has selections: $hasSelections');
      
      if (hasSelections) {
        completed += 1;
        print('     ✅ COMPLETADA');
      } else {
        print('     ❌ PENDIENTE');
      }
    }
    
    final progress = total > 0 ? completed / total : 0.0;
    print('   📊 FINAL: $completed completadas de $total total = ${(progress * 100).toInt()}%');
    return progress;
  }
}