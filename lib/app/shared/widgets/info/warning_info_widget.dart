import 'package:flutter/material.dart';

class WarningInfoWidget extends StatelessWidget {
  final String title;
  final String message;

  const WarningInfoWidget({
    super.key,
    required this.title,
    required this.message,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(6),
        border: Border.all(
          color: const Color(0xFFD97706), // #D97706
          width: 1,
        ),
        color: const Color(0xFFFFFAE5), // #FFFAE5
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              color: Color(0xFFD97706), // #D97706
              fontFamily: 'Work Sans',
              fontSize: 14,
              fontWeight: FontWeight.w500,
              height: 1.28571, // 18px / 14px = 1.28571 (128.571%)
            ),
          ),
          const SizedBox(height: 8),
          Text(
            message,
            style: const TextStyle(
              color: Color(0xFFD97706), // #D97706
              fontFamily: 'Work Sans',
              fontSize: 13,
              fontWeight: FontWeight.w400,
              height: 1.38462, // 18px / 13px = 1.38462
            ),
          ),
        ],
      ),
    );
  }
}
