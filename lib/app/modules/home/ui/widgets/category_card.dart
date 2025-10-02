import 'package:caja_herramientas/app/core/theme/dagrd_colors.dart';
import 'package:flutter/material.dart';

class CategoryCard extends StatelessWidget {
  const CategoryCard({
    super.key,
    required this.title,
    required this.onTap,
    this.trailingIcon,
  });

  final String title;
  final VoidCallback onTap;
  final Widget? trailingIcon;

  static const double _cardHeight = 50.0;
  static const double _horizontalPadding = 15.0;
  static const double _verticalPadding = 10.0;
  static const double _borderRadius = 8.0;
  static const double _borderWidth = 1.0;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: _cardHeight,
        padding: const EdgeInsets.symmetric(
          horizontal: _horizontalPadding,
          vertical: _verticalPadding,
        ),
        decoration: _getCardDecoration(),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Expanded(
              child: Text(
                title,
                textAlign: TextAlign.center,
                style: _getTextStyle(),
              ),
            ),
            if (trailingIcon != null) ...[
              const SizedBox(width: 8),
              trailingIcon!,
            ],
          ],
        ),
      ),
    );
  }

  BoxDecoration _getCardDecoration() {
    return BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(_borderRadius),
      border: Border.all(
        color: DAGRDColors.azulDAGRD,
        width: _borderWidth,
      ),
    );
  }

  TextStyle _getTextStyle() {
    return const TextStyle(
      color: DAGRDColors.azulDAGRD,
      fontFamily: 'Work Sans',
      fontSize: 16,
      fontStyle: FontStyle.normal,
      fontWeight: FontWeight.w600,
      height: 20 / 16, // 125% line-height
    );
  }
}