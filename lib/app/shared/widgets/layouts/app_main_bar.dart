import 'package:flutter/material.dart';
import 'package:caja_herramientas/app/core/theme/dagrd_colors.dart';

class AppMainBar extends StatelessWidget implements PreferredSizeWidget {
  final VoidCallback? onBack;
  final VoidCallback? onInfo;
  final VoidCallback? onProfile;
  final bool showBack;
  final bool showInfo;
  final bool showProfile;

  const AppMainBar({
    super.key,
    this.onBack,
    this.onInfo,
    this.onProfile,
    this.showBack = true,
    this.showInfo = true,
    this.showProfile = true,
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: DAGRDColors.azulDAGRD,
      elevation: 0,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          bottom: Radius.circular(28),
        ),
      ),
      leading: showBack
          ? _circleButton(
              icon: Icons.arrow_back,
              onTap: onBack ?? () => Navigator.of(context).maybePop(),
            )
          : null,
      title: Padding(
        padding: const EdgeInsets.only(top: 4),
        child: RichText(
          textAlign: TextAlign.start,
          text: const TextSpan(
            style: TextStyle(
              fontFamily: 'Metropolis',
              fontWeight: FontWeight.w500,
              height: 1.0,
            ),
            children: [
              TextSpan(
                text: 'Caja de\n',
                style: TextStyle(
                  color: Colors.white, 
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
              TextSpan(
                text: 'Herramientas\n',
                style: TextStyle(
                  color: Color(0xFFFFCC00), 
                  fontSize: 20,
                  fontWeight: FontWeight.w500,
                ),
              ),
              TextSpan(
                text: 'DAGRD',
                style: TextStyle(
                  color: Colors.white, 
                  fontSize: 23,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ),
      centerTitle: true,
      actions: [
        if (showInfo) ...[
          _circleButton(
            icon: Icons.help_outline,
            onTap: onInfo,
          ),
          const SizedBox(width: 12),
        ],
        if (showProfile) ...[
          _circleButton(
            icon: Icons.person_outline,
            onTap: onProfile,
          ),
          const SizedBox(width: 20),
        ],
      ],
    );
  }

  Widget _circleButton({required IconData icon, VoidCallback? onTap}) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(100),
        child: Container(
          width: 44,
          height: 44,
          decoration: const BoxDecoration(
            color: DAGRDColors.amarDAGRD,
            shape: BoxShape.circle,
          ),
          child: Icon(icon, color: DAGRDColors.azulDAGRD, size: 26),
        ),
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(80);
}
