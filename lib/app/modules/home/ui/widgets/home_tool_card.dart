import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class HomeToolCard extends StatelessWidget {
  final String title;
  final String iconAsset;
  final Color backgroundColor;
  final double iconWidth;
  final double iconHeight;
  final VoidCallback? onTap;

  const HomeToolCard({
    super.key,
    required this.title,
    required this.iconAsset,
    this.backgroundColor = const Color(0xFF2B388F),
    this.iconWidth = 60,
    this.iconHeight = 54.203,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final card = Container(
      height: 105,
      padding: const EdgeInsets.all(23),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        color: backgroundColor,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SvgPicture.asset(
            iconAsset,
            width: iconWidth,
            height: iconHeight,
          ),
          const SizedBox(width: 18),
          Expanded(
            child: Text(
              title,
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: Colors.white,
                fontFamily: 'Work Sans',
                fontSize: 18,
                fontWeight: FontWeight.w500,
                height: 1.3,
              ),
            ),
          ),
        ],
      ),
    );
    if (onTap != null) {
      return GestureDetector(
        onTap: onTap,
        child: card,
      );
    }
    return card;
  }
}
