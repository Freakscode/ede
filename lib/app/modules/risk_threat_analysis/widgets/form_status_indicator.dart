import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/risk_threat_analysis_bloc.dart';
import '../bloc/risk_threat_analysis_state.dart';

class FormStatusIndicator extends StatelessWidget {
  const FormStatusIndicator({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<RiskThreatAnalysisBloc, RiskThreatAnalysisState>(
      builder: (context, state) {
        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 4,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Indicador de guardado
              if (state.isSaving) ...[
                const SizedBox(
                  width: 12,
                  height: 12,
                  child: CircularProgressIndicator(strokeWidth: 2),
                ),
                const SizedBox(width: 8),
                const Text(
                  'Guardando...',
                  style: TextStyle(fontSize: 12, color: Colors.orange),
                ),
              ] else if (state.lastSaved != null) ...[
                const Icon(
                  Icons.check_circle,
                  size: 12,
                  color: Colors.green,
                ),
                const SizedBox(width: 4),
                Text(
                  'Guardado ${_formatLastSaved(state.lastSaved!)}',
                  style: const TextStyle(fontSize: 12, color: Colors.green),
                ),
              ] else if (state.activeFormId != null) ...[
                const Icon(
                  Icons.edit,
                  size: 12,
                  color: Colors.blue,
                ),
                const SizedBox(width: 4),
                const Text(
                  'Editando',
                  style: TextStyle(fontSize: 12, color: Colors.blue),
                ),
              ],
              
              // Separador
              if ((state.isSaving || state.lastSaved != null || state.activeFormId != null)) ...[
                const SizedBox(width: 12),
                Container(
                  width: 1,
                  height: 16,
                  color: Colors.grey[300],
                ),
                const SizedBox(width: 12),
              ],
              
              // Indicador de progreso
              Icon(
                Icons.analytics_outlined,
                size: 14,
                color: Colors.grey[600],
              ),
              const SizedBox(width: 4),
              Text(
                'Progreso: ${_getProgressPercentage(state).toStringAsFixed(0)}%',
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey[600],
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  String _formatLastSaved(DateTime lastSaved) {
    final now = DateTime.now();
    final difference = now.difference(lastSaved);
    
    if (difference.inMinutes < 1) {
      return 'ahora';
    } else if (difference.inMinutes < 60) {
      return 'hace ${difference.inMinutes}m';
    } else if (difference.inHours < 24) {
      return 'hace ${difference.inHours}h';
    } else {
      return 'hace ${difference.inDays}d';
    }
  }

  double _getProgressPercentage(RiskThreatAnalysisState state) {
    // Calcular progreso basado en las selecciones realizadas
    double total = 0.0;
    double completed = 0.0;
    
    // Contar probabilidad y intensidad como base
    total += 2;
    if (state.probabilidadSelections.isNotEmpty) completed += 1;
    if (state.intensidadSelections.isNotEmpty) completed += 1;
    
    // Agregar selecciones dinámicas según clasificación
    if (state.selectedClassification == 'vulnerabilidad') {
      final expectedSelections = ['social', 'economico', 'ambiental', 'fisico'];
      total += expectedSelections.length;
      for (final selection in expectedSelections) {
        if (state.dynamicSelections[selection]?.isNotEmpty == true) {
          completed += 1;
        }
      }
    }
    
    return total > 0 ? (completed / total) * 100.0 : 0.0;
  }
}