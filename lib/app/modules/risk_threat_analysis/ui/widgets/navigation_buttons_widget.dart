import 'package:flutter/material.dart';
import 'package:caja_herramientas/app/core/theme/dagrd_colors.dart';

class NavigationButtonsWidget extends StatelessWidget {
  final VoidCallback? onBackPressed;
  final VoidCallback? onContinuePressed;

  const NavigationButtonsWidget({
    super.key,
    this.onBackPressed,
    this.onContinuePressed,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        // Botón Volver
        InkWell(
          onTap: onBackPressed ?? () => Navigator.of(context).pop(),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(
                Icons.arrow_back_ios,
                color: DAGRDColors.negroDAGRD,
                size: 18,
              ),
              const SizedBox(width: 8),
              const Text(
                'Volver',
                style: TextStyle(
                  color: DAGRDColors.negroDAGRD,
                  fontFamily: 'Work Sans',
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  height: 18 / 16,
                ),
              ),
            ],
          ),
        ),
        // Botón Continuar
        InkWell(
          onTap: onContinuePressed,
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                'Continuar',
                style: TextStyle(
                  color: DAGRDColors.negroDAGRD,
                  fontFamily: 'Work Sans',
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  height: 18 / 16,
                ),
              ),
              const SizedBox(width: 8),
              const Icon(
                Icons.arrow_forward_ios,
                color: DAGRDColors.negroDAGRD,
                size: 18,
              ),
            ],
          ),
        ),
      ],
    );
  }
}