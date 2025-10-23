import 'package:flutter/material.dart';
import 'package:caja_herramientas/app/core/theme/dagrd_colors.dart';

/// Widget para el contenedor de información sobre el análisis de riesgo
class RiskInfoContainer extends StatelessWidget {
  const RiskInfoContainer({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFF0F4FF),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: DAGRDColors.azulSecundario.withOpacity(0.2),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.info_outline,
                color: DAGRDColors.azulSecundario,
                size: 16,
              ),
              const SizedBox(width: 8),
              Text(
                'Información',
                style: TextStyle(
                  color: DAGRDColors.azulSecundario,
                  fontFamily: 'Work Sans',
                  fontSize: 13,
                  fontStyle: FontStyle.normal,
                  fontWeight: FontWeight.w500,
                  height: 18 / 13,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            'Complete los formularios de Amenaza y Vulnerabilidad para visualizar la evaluación completa del riesgo.',
            style: TextStyle(
              color: DAGRDColors.azulSecundario,
              fontFamily: 'Work Sans',
              fontSize: 13,
              fontStyle: FontStyle.normal,
              fontWeight: FontWeight.w400,
              height: 18 / 13,
            ),
          ),
        ],
      ),
    );
  }
}
