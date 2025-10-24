import 'package:flutter/material.dart';
import 'package:caja_herramientas/app/core/theme/dagrd_colors.dart';

/// Widget para el header de la pantalla de categorías de riesgo
class RiskCategoriesHeader extends StatelessWidget {
  final String selectedEvent;
  
  const RiskCategoriesHeader({
    super.key,
    required this.selectedEvent,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        const SizedBox(height: 28),
        const Text(
          'Metodología de Análisis del Riesgo',
          textAlign: TextAlign.center,
          style: TextStyle(
            color: DAGRDColors.azulDAGRD,
            fontFamily: 'Work Sans',
            fontSize: 20,
            fontStyle: FontStyle.normal,
            fontWeight: FontWeight.w600,
            height: 1.2,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          'Evento: $selectedEvent',
          textAlign: TextAlign.center,
          style: const TextStyle(
            color: DAGRDColors.grisMedio,
            fontFamily: 'Work Sans',
            fontSize: 16,
            fontStyle: FontStyle.normal,
            fontWeight: FontWeight.w500,
            height: 1.2,
          ),
        ),
        const SizedBox(height: 16),
        const Text(
          'Selecciona una categoría para comenzar el análisis',
          textAlign: TextAlign.center,
          style: TextStyle(
            color: DAGRDColors.grisMedio,
            fontFamily: 'Work Sans',
            fontSize: 14,
            fontStyle: FontStyle.normal,
            fontWeight: FontWeight.w400,
            height: 1.2,
          ),
        ),
      ],
    );
  }
}
