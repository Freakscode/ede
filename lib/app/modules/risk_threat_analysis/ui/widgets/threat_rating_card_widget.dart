import 'package:flutter/material.dart';

class ThreatRatingCardWidget extends StatelessWidget {
  final String score;
  final String ratingText;

  const ThreatRatingCardWidget({
    super.key,
    required this.score,
    required this.ratingText,
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
              color: Color(0xFF232B48),
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(8),
                topRight: Radius.circular(8),
              ),
            ),
            child: const Center(
              child: Text(
                'Calificación Amenaza',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Color(0xFFFFFFFF),
                  fontFamily: 'Work Sans',
                  fontSize: 16,
                  fontStyle: FontStyle.normal,
                  fontWeight: FontWeight.w500,
                  height: 16 / 16,
                ),
              ),
            ),
          ),
          // Contenido amarillo
          Container(
            width: double.infinity,
            height: 40,
            padding: const EdgeInsets.fromLTRB(50, 10, 40, 10),
            decoration: const BoxDecoration(
              color: Color(0xFFFDE047),
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
                    color: Color(0xFF1E1E1E),
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
                    color: Color(0xFF1E1E1E),
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