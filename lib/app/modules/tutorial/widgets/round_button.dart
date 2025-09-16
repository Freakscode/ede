import 'package:caja_herramientas/app/core/theme/dagrd_colors.dart';
import 'package:flutter/material.dart';

class RoundButton extends StatelessWidget {
  final IconData icon;
  const RoundButton({super.key, required this.icon});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 32,
      height: 32,
      decoration: const BoxDecoration(
        color: DAGRDColors.amarDAGRD,
        shape: BoxShape.circle,
      ),
      child: Icon(icon, color: DAGRDColors.azulDAGRD, size: 18),
    );
  }
}
