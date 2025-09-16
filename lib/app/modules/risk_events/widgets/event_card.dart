import 'package:caja_herramientas/app/core/theme/dagrd_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class EventCard extends StatelessWidget {
  final String iconAsset;
  final String title;
  const EventCard({required this.iconAsset, required this.title, super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 140,
      decoration: BoxDecoration(
        color: DAGRDColors.azul3DAGRD,
        borderRadius: BorderRadius.circular(4),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SvgPicture.asset(
            iconAsset,
            width: 80,
            height: 55,
            colorFilter: const ColorFilter.mode(Colors.white, BlendMode.srcIn),
          ),
          Text(
            title,
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: Colors.white,
              fontFamily: 'Work Sans',
              fontSize: 18,
              fontWeight: FontWeight.w600,
              height: 24 / 18, // line-height / font-size
            ),
          ),
        ],
      ),
    );
  }
}