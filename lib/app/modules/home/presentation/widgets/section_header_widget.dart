import 'package:flutter/material.dart';

/// Widget para el encabezado de secciones con título y descripción
class SectionHeaderWidget extends StatelessWidget {
  final String title;
  final String description;
  final EdgeInsets? margin;

  const SectionHeaderWidget({
    super.key,
    required this.title,
    required this.description,
    this.margin,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: margin,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: const Color(0xFFEBF2F8),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: const Color(0xFF2C3E50),
              fontFamily: 'Work Sans',
            ),
          ),
          const SizedBox(height: 10),
          Text(
            description,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w400,
              color: const Color(0xFF5C6F80),
              fontFamily: 'Work Sans',
            ),
          ),
        ],
      ),
    );
  }
}

