import 'package:flutter/material.dart';

/// Widget para el header de la pantalla de categorías de riesgo
class RiskCategoriesHeader extends StatelessWidget {
  const RiskCategoriesHeader({super.key});

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
            color: Color(0xFF232B48), // AzulDAGRD
            fontFamily: 'Work Sans',
            fontSize: 20,
            fontStyle: FontStyle.normal,
            fontWeight: FontWeight.w600,
            height: 28 / 20, // 140% line-height
          ),
        ),
        const SizedBox(height: 14),
        const Text(
          'Seleccione una categoría',
          textAlign: TextAlign.center,
          style: TextStyle(
            color: Color(0xFF706F6F), // GrisDAGRD
            fontFamily: 'Work Sans',
            fontSize: 18,
            fontStyle: FontStyle.normal,
            fontWeight: FontWeight.w600,
            height: 28 / 18, // 155.556% line-height
          ),
        ),
        const SizedBox(height: 24),
      ],
    );
  }
}
