import 'package:flutter/material.dart';
import 'package:caja_herramientas/app/core/theme/dagrd_colors.dart';

class RatingItemWidget extends StatelessWidget {
  final int rating;
  final String title;
  final Color color;

  const RatingItemWidget({
    super.key,
    required this.rating,
    required this.title,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    final isUnrated = rating == 0;
    final isNotApplicable = rating == -1;
    
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: (isUnrated || isNotApplicable) ? DAGRDColors.surfaceVariant : DAGRDColors.surface,
        border: const Border(bottom: BorderSide(color: DAGRDColors.outline, width: 1)),
      ),
      child: Row(
        children: [
          Container(
            width: 32,
            height: 32,
            decoration: BoxDecoration(
              color: isNotApplicable ? Colors.white : color,
              borderRadius: BorderRadius.circular(4),
            ),
            child: Center(
              child: Text(
                isNotApplicable ? 'NA' : rating.toString(),
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: isUnrated ? DAGRDColors.blancoDAGRD : DAGRDColors.negroDAGRD,
                  fontFamily: 'Work Sans',
                  fontSize: isNotApplicable ? 16 : 20,
                  fontStyle: FontStyle.normal,
                  fontWeight: FontWeight.w600,
                  height: 16 / 20,
                ),
              ),
            ),
          ),
          const SizedBox(width: 12),
          if (!isUnrated && !isNotApplicable) ...[
            Expanded(
              child: Text(
                title,
                style: const TextStyle(
                  color: DAGRDColors.negroDAGRD,
                  fontFamily: 'Work Sans',
                  fontSize: 15,
                  fontStyle: FontStyle.normal,
                  fontWeight: FontWeight.w500,
                  height: 20 / 15,
                ),
              ),
            ),
            const Icon(
              Icons.keyboard_arrow_down,
              color: DAGRDColors.grisMedio,
              size: 24,
            ),
          ] else ...[
            Expanded(
              child: Text(
                title,
                style: const TextStyle(
                  color: DAGRDColors.negroDAGRD,
                  fontFamily: 'Work Sans',
                  fontSize: 14,
                  fontStyle: FontStyle.normal,
                  fontWeight: FontWeight.w500,
                  height: 20 / 14,
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}