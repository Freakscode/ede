import 'package:flutter/material.dart';

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
    
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: isUnrated ? const Color(0xFFF3F4F6) : Colors.white,
        border: const Border(bottom: BorderSide(color: Color(0xFFE5E7EB), width: 1)),
      ),
      child: Row(
        children: [
          Container(
            width: 32,
            height: 32,
            decoration: BoxDecoration(
              color: color,
              borderRadius: BorderRadius.circular(4),
            ),
            child: Center(
              child: Text(
                rating.toString(),
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: isUnrated ? const Color(0xFFFFFFFF) : const Color(0xFF000000),
                  fontFamily: 'Work Sans',
                  fontSize: 20,
                  fontStyle: FontStyle.normal,
                  fontWeight: FontWeight.w600,
                  height: 16 / 20,
                ),
              ),
            ),
          ),
          const SizedBox(width: 12),
          if (!isUnrated) ...[
            Expanded(
              child: Text(
                title,
                style: const TextStyle(
                  color: Color(0xFF1E1E1E),
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
              color: Color(0xFF6B7280),
              size: 24,
            ),
          ] else ...[
            Expanded(
              child: Text(
                title,
                style: const TextStyle(
                  color: Color(0xFF1E1E1E),
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