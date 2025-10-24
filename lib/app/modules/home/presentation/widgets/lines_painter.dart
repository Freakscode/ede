import 'package:caja_herramientas/app/core/theme/dagrd_colors.dart';
import 'package:flutter/material.dart';
import 'tutorial_models.dart';

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

    for (final line in lines) {
      canvas.drawLine(line.from, line.to, p);
      
      // Dibujar puntos en los extremos
      canvas.drawCircle(line.from, 3, dot);
      canvas.drawCircle(line.to, 3, dot);
    }
  }

  @override
  bool shouldRepaint(covariant LinesPainter oldDelegate) => 
      oldDelegate.lines != lines;
}