import 'package:caja_herramientas/app/core/theme/dagrd_colors.dart';
import 'package:flutter/material.dart';
import 'line_model.dart';

class LinesPainter extends CustomPainter {
  final List<Line> lines;
  LinesPainter({required this.lines});

  @override
  void paint(Canvas canvas, Size size) {
    final p = Paint()
      ..color = DAGRDColors.amarDAGRD
      ..strokeWidth = 2
      ..style = PaintingStyle.stroke;

    final dot = Paint()..color = DAGRDColors.amarDAGRD;

    for (final l in lines) {
      final path = Path()
        ..moveTo(l.from.dx, l.from.dy)
        ..lineTo(l.to.dx, l.to.dy);
      canvas.drawPath(path, p);
      // Quitar el círculo al inicio de la línea
      // canvas.drawCircle(l.from, 3.5, dot);
      canvas.drawCircle(l.to, 3.5, dot);
    }
  }

  @override
  bool shouldRepaint(covariant LinesPainter oldDelegate) =>
      oldDelegate.lines != lines;
}
