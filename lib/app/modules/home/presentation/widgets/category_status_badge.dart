import 'package:flutter/material.dart';
import 'package:caja_herramientas/app/core/theme/dagrd_colors.dart';

/// Widget para mostrar el estado de una categoría con un badge
class CategoryStatusBadge extends StatelessWidget {
  final String status;
  final String label;

  const CategoryStatusBadge({
    super.key,
    required this.status,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    final badgeData = _getBadgeData(status);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: badgeData.backgroundColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: badgeData.borderColor,
          width: 1,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            badgeData.icon,
            size: 12,
            color: badgeData.iconColor,
          ),
          const SizedBox(width: 4),
          Text(
            label,
            style: TextStyle(
              color: badgeData.textColor,
              fontFamily: 'Work Sans',
              fontSize: 10,
              fontStyle: FontStyle.normal,
              fontWeight: FontWeight.w500,
              height: 12 / 10,
            ),
          ),
        ],
      ),
    );
  }

  BadgeData _getBadgeData(String status) {
    switch (status.toLowerCase()) {
      case 'completed':
        return BadgeData(
          backgroundColor: ThemeColors.success.withOpacity(0.1),
          borderColor: ThemeColors.success,
          iconColor: ThemeColors.success,
          textColor: ThemeColors.success,
          icon: Icons.check_circle,
        );
      case 'available':
        return BadgeData(
          backgroundColor: ThemeColors.azulSecundario.withOpacity(0.1),
          borderColor: ThemeColors.azulSecundario,
          iconColor: ThemeColors.azulSecundario,
          textColor: ThemeColors.azulSecundario,
          icon: Icons.play_circle,
        );
      case 'locked':
        return BadgeData(
          backgroundColor: ThemeColors.grisMedio.withOpacity(0.1),
          borderColor: ThemeColors.grisMedio,
          iconColor: ThemeColors.grisMedio,
          textColor: ThemeColors.grisMedio,
          icon: Icons.lock,
        );
      default:
        return BadgeData(
          backgroundColor: ThemeColors.grisClaro,
          borderColor: ThemeColors.grisMedio,
          iconColor: ThemeColors.grisMedio,
          textColor: ThemeColors.grisMedio,
          icon: Icons.help,
        );
    }
  }
}

/// Clase para manejar los datos del badge
class BadgeData {
  final Color backgroundColor;
  final Color borderColor;
  final Color iconColor;
  final Color textColor;
  final IconData icon;

  const BadgeData({
    required this.backgroundColor,
    required this.borderColor,
    required this.iconColor,
    required this.textColor,
    required this.icon,
  });
}
