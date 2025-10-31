import 'package:flutter/material.dart';
import 'package:caja_herramientas/app/core/theme/dagrd_colors.dart';

/// Widget para mostrar el progreso de completitud de las categorías
class RiskCompletionProgress extends StatelessWidget {
  final int completedCategories;
  final int totalCategories;
  final String selectedEvent;

  const RiskCompletionProgress({
    super.key,
    required this.completedCategories,
    required this.totalCategories,
    required this.selectedEvent,
  });

  @override
  Widget build(BuildContext context) {
    final progress = totalCategories > 0 ? completedCategories / totalCategories : 0.0;
    final progressPercentage = (progress * 100).round();

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            ThemeColors.azulSecundario.withOpacity(0.1),
            ThemeColors.azulSecundario.withOpacity(0.05),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: ThemeColors.azulSecundario.withOpacity(0.3),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.trending_up,
                color: ThemeColors.azulSecundario,
                size: 20,
              ),
              const SizedBox(width: 8),
              Text(
                'Progreso de Completitud',
                style: TextStyle(
                  color: ThemeColors.azulSecundario,
                  fontFamily: 'Work Sans',
                  fontSize: 14,
                  fontStyle: FontStyle.normal,
                  fontWeight: FontWeight.w600,
                  height: 20 / 14,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: LinearProgressIndicator(
                  value: progress,
                  backgroundColor: ThemeColors.grisClaro,
                  valueColor: AlwaysStoppedAnimation<Color>(
                    progress >= 1.0 
                        ? ThemeColors.success 
                        : ThemeColors.azulSecundario,
                  ),
                  minHeight: 8,
                ),
              ),
              const SizedBox(width: 12),
              Text(
                '$progressPercentage%',
                style: TextStyle(
                  color: ThemeColors.azulSecundario,
                  fontFamily: 'Work Sans',
                  fontSize: 14,
                  fontStyle: FontStyle.normal,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            '$completedCategories de $totalCategories categorías completadas',
            style: TextStyle(
              color: ThemeColors.azulSecundario,
              fontFamily: 'Work Sans',
              fontSize: 12,
              fontStyle: FontStyle.normal,
              fontWeight: FontWeight.w400,
              height: 16 / 12,
            ),
          ),
        ],
      ),
    );
  }
}
