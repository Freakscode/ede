import 'package:caja_herramientas/app/core/theme/dagrd_colors.dart';
import 'package:flutter/material.dart';

class SectionTitle extends StatelessWidget {
  final String title;
  final String? subtitle;
  final bool centerTitle;

  const SectionTitle({
    super.key,
    required this.title,
    this.subtitle,
    this.centerTitle = true,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        if (centerTitle)
          Center(
            child: Text(
              title,
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: ThemeColors.azulDAGRD,
                fontFamily: 'Work Sans',
                fontSize: 24,
                fontWeight: FontWeight.w600,
                height: 1.16667, // 28px / 24px = 1.16667 (116.667%)
              ),
            ),
          )
        else
          Text(
            title,
            style: const TextStyle(
              color: ThemeColors.azulDAGRD,
              fontFamily: 'Work Sans',
              fontSize: 24,
              fontWeight: FontWeight.w600,
              height: 1.16667, // 28px / 24px = 1.16667 (116.667%)
            ),
          ),
        
        if (subtitle != null) ...[
          const SizedBox(height: 8),
          Center(
            child: Text(
              subtitle!,
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: ThemeColors.negroDAGRD,
                fontFamily: 'Work Sans',
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ],
    );
  }
}
