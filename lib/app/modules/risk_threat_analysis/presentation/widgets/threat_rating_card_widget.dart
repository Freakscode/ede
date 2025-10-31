import 'package:flutter/material.dart';
import 'package:caja_herramientas/app/core/theme/theme_colors.dart';

class ThreatRatingCardWidget extends StatelessWidget {
  final String score;
  final String ratingText;
  final String title;

  const ThreatRatingCardWidget({
    super.key,
    required this.score,
    required this.ratingText,
    this.title = 'Calificación Amenaza',
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          // Header azul
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(10),
            decoration: const BoxDecoration(
              color: ThemeColors.azulDAGRD,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(8),
                topRight: Radius.circular(8),
              ),
            ),
            child: Center(
              child: Text(
                title,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  color: ThemeColors.blancoDAGRD,
                  fontFamily: 'Work Sans',
                  fontSize: 16,
                  fontStyle: FontStyle.normal,
                  fontWeight: FontWeight.w500,
                  height: 16 / 16,
                ),
              ),
            ),
          ),
          // Contenido con color dinámico según el nivel
          Container(
            width: double.infinity,
            height: 40,
            padding: const EdgeInsets.fromLTRB(50, 10, 40, 10),
            decoration: const BoxDecoration(
              color: ThemeColors.amarilloDAGRD,
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(8),
                bottomRight: Radius.circular(8),
              ),
            ),
            child: Row(
              children: [
                Text(
                  score,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    color: ThemeColors.negroDAGRD,
                    fontFamily: 'Work Sans',
                    fontSize: 16,
                    fontStyle: FontStyle.normal,
                    fontWeight: FontWeight.w600,
                    height: 16 / 16,
                  ),
                ),
                const SizedBox(width: 33),
                Text(
                  ratingText,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    color: ThemeColors.negroDAGRD,
                    fontFamily: 'Work Sans',
                    fontSize: 16,
                    fontStyle: FontStyle.normal,
                    fontWeight: FontWeight.w600,
                    height: 16 / 16,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}