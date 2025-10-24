import 'package:flutter/material.dart';

/// Modelo para representar una línea en el tutorial
class Line {
  final Offset from;
  final Offset to;

  const Line({
    required this.from,
    required this.to,
  });
}

/// Modelo para representar datos de un label en el tutorial
class LabelData {
  final String textTop;
  final String? textBottom;
  final Offset position;
  final Alignment align;

  const LabelData({
    required this.textTop,
    this.textBottom,
    required this.position,
    required this.align,
  });
}
