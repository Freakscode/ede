import 'package:flutter/material.dart';
import 'package:caja_herramientas/app/core/theme/theme_colors.dart';

/// Widget para el contenedor de información sobre el análisis de riesgo
class RiskInfoContainer extends StatelessWidget {
  const RiskInfoContainer({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: ThemeColors.surfaceVariant,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: ThemeColors.azulSecundario.withOpacity(0.2),
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
                color: ThemeColors.azulSecundario,
                size: 20,
              ),
              const SizedBox(width: 8),
              const Text(
                'Información del Análisis',
                style: TextStyle(
                  color: ThemeColors.azulDAGRD,
                  fontFamily: 'Work Sans',
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          const Text(
            'El análisis de riesgo se compone de dos categorías principales:',
            style: TextStyle(
              color: ThemeColors.grisOscuro,
              fontFamily: 'Work Sans',
              fontSize: 14,
              fontWeight: FontWeight.w400,
              height: 1.4,
            ),
          ),
          const SizedBox(height: 8),
          _buildInfoItem('Amenaza', 'Probabilidad e intensidad del evento'),
          const SizedBox(height: 4),
          _buildInfoItem('Vulnerabilidad', 'Fragilidad y exposición del sistema'),
        ],
      ),
    );
  }

  Widget _buildInfoItem(String title, String description) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 6,
          height: 6,
          margin: const EdgeInsets.only(top: 6, right: 8),
          decoration: const BoxDecoration(
            color: ThemeColors.azulSecundario,
            shape: BoxShape.circle,
          ),
        ),
        Expanded(
          child: RichText(
            text: TextSpan(
              style: const TextStyle(
                color: ThemeColors.grisOscuro,
                fontFamily: 'Work Sans',
                fontSize: 14,
                fontWeight: FontWeight.w400,
                height: 1.4,
              ),
              children: [
                TextSpan(
                  text: '$title: ',
                  style: const TextStyle(fontWeight: FontWeight.w600),
                ),
                TextSpan(text: description),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
