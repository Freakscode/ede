import 'package:flutter/material.dart';

class LabelData {
  final String textTop;
  final String? textBottom;
  final Offset position; // centro aproximado de la burbuja
  final Alignment align;
  LabelData({
    required this.textTop,
    this.textBottom,
    required this.position,
    this.align = Alignment.centerLeft,
  });
}