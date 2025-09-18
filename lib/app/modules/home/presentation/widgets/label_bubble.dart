import 'package:flutter/material.dart';

class LabelBubble extends StatelessWidget {
  final String top;
  final String? bottom;
  final Alignment align;

  const LabelBubble({
    super.key,
    required this.top,
    this.bottom,
    this.align = Alignment.centerLeft,
  });

  @override
  Widget build(BuildContext context) {
    final isLoginLabel = top.trim().replaceAll('\n', ' ').contains('inicio de sesión Usuarios DAGRD');
    return Align(
      alignment: align,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            top,
            style: isLoginLabel
                ? const TextStyle(
                    color: Colors.white,
                    fontFamily: 'Metropolis',
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                    height: 1.0,
                  )
                : const TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    height: 1.2,
                  ),
            textAlign: TextAlign.left,
          ),
          if (bottom != null) ...[
            const SizedBox(height: 2),
            Text(
              bottom!,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 12,
                fontWeight: FontWeight.w400,
                height: 1.25,
              ),
            ),
          ],
        ],
      ),
    );
  }
}
