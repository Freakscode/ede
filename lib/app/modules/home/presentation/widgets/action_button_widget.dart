import 'package:flutter/material.dart';

class ActionButtonWidget extends StatelessWidget {
  final String title;
  final IconData icon;
  final Color backgroundColor;
  final Color textColor;
  final Color iconColor;
  final VoidCallback onTap;

  const ActionButtonWidget({
    super.key,
    required this.title,
    required this.icon,
    required this.backgroundColor,
    required this.textColor,
    required this.iconColor,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 320,
        height: 48,
        decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: BorderRadius.circular(4),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              color: iconColor,
              size: 24,
            ),
            const SizedBox(width: 10),
            Text(
              title,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: textColor,
                fontFamily: 'Work Sans',
                fontSize: 14,
                fontStyle: FontStyle.normal,
                fontWeight: FontWeight.w500,
                height: 24 / 14, // line-height: 24px (171.429%)
              ),
            ),
          ],
        ),
      ),
    );
  }
}
