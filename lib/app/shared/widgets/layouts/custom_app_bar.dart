import 'package:caja_herramientas/app/core/icons/app_icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:caja_herramientas/app/core/theme/dagrd_colors.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final VoidCallback? onBack;
  final VoidCallback? onInfo;
  final VoidCallback? onProfile;
  final bool showBack;
  final bool showInfo;
  final bool showProfile;

  const CustomAppBar({
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
        borderRadius: BorderRadius.vertical(bottom: Radius.circular(28)),
      ),
      leadingWidth: 48,
      leading: showBack
          ? Padding(
              padding: const EdgeInsets.only(left: 10),
              child: _circleButton(
                assetName: AppIcons.arrowLeft,
                onTap: onBack ?? () => Navigator.of(context).maybePop(),
              ),
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
            assetName: AppIcons.info,
            onTap: onInfo,
          ),
          const SizedBox(width: 12),
        ],
        if (showProfile) ...[
          _circleButton(
            assetName: AppIcons.persona,
            onTap: onProfile,
          ),
          const SizedBox(width: 20),
        ],
      ],
    );
  }

  Widget _circleButton({required String assetName, VoidCallback? onTap}) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(100),
        child: Container(
          width: 38,
          height: 38,
          decoration: const BoxDecoration(
            color: DAGRDColors.amarDAGRD,
            shape: BoxShape.circle,
          ),
          child: Center(
            child: SvgPicture.asset(
              assetName,
              width: 26,
              height: 26,
              color: DAGRDColors.azulDAGRD,
            ),
          ),
        ),
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(80);
}
