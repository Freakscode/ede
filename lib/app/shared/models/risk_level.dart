import 'package:flutter/material.dart';

class RiskLevel {
  final String title;
  final Color color;
  final List<String>? items;
  final String? description;
  final String? note;
  final int? value; // Valor numérico asociado al nivel

  const RiskLevel({
    required this.title,
    required this.color,
    this.items,
    this.description,
    this.note,
    this.value,
  });

  factory RiskLevel.fromMap(Map<String, dynamic> map) {
    return RiskLevel(
      title: map['title'] as String,
      color: map['color'] as Color,
      items: map['items'] != null 
          ? List<String>.from(map['items'] as List)
          : null,
      description: map['description'] as String?,
      note: map['note'] as String?,
      value: map['value'] as int?,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'color': color,
      if (items != null) 'items': items,
      if (description != null) 'description': description,
      if (note != null) 'note': note,
      if (value != null) 'value': value,
    };
  }

    // Factory constructors para los diferentes niveles de riesgo
  factory RiskLevel.bajo({
    String? customDescription,
    List<String>? customItems,
    int? customValue,
  }) {
    return RiskLevel(
      title: 'BAJO (1): Las características del escenario sugieren que la probabilidad de que se presente el evento es mínima',
      color: const Color(0xFF22C55E),
      description: customDescription,
      value: customValue ?? 1,
      items: customItems ?? [
        'Pendientes bajos modeladas en suelos (< 5°).',
        'Pendientes bajas, medias o altas, modeladas en roca sana o levemente meteorizada sin fracturas.',
      ],
    );
  }

  factory RiskLevel.medioBajo({
    String? customDescription,
    List<String>? customItems,
    int? customValue,
  }) {
    return RiskLevel(
      title: 'MEDIO - BAJO (2): Las características del escenario sugieren que es poco probable de que se presente el evento',
      color: const Color(0xFFFDE047),
      description: customDescription,
      value: customValue ?? 2,
      items: customItems ?? [
        'Pendientes moderadas modeladas en suelos (5° - 15°).',
        'Pendientes bajas modeladas en suelos (< 5°), en condiciones saturadas.',
      ],
    );
  }

  factory RiskLevel.medioAlto({
    String? customDescription,
    List<String>? customItems,
    int? customValue,
  }) {
    return RiskLevel(
      title: 'MEDIO - ALTO (3): Las características del escenario sugieren la probabilidad moderada de que se presente el evento.',
      color: const Color(0xFFFB923C),
      description: customDescription,
      value: customValue ?? 3,
      items: customItems ?? [
        'Pendientes altas modeladas en suelos (15° - 30°).',
        'Pendientes moderadas modeladas en suelos (5° - 15°), en condiciones saturadas.',
      ],
    );
  }

  factory RiskLevel.alto({
    String? customDescription,
    List<String>? customItems,
    String? customNote,
    int? customValue,
  }) {
    return RiskLevel(
      title: 'ALTO (4): Las características del escenario sugieren la probabilidad de que se presente el evento.',
      color: const Color(0xFFDC2626),
      description: customDescription,
      value: customValue ?? 4,
      items: customItems ?? [
        'Pendientes medias o altas modeladas en roca fracturada.',
        'Pendientes muy altas modeladas en suelos (> 30°).',
        'Pendientes altas modeladas en suelos (15° - 30°), en condiciones saturadas.',
        'Pendientes medias o altas, modeladas en llenos antrópicos.',
      ],
      note: customNote ?? 'NOTA: En caso de tratarse de llenos antrópicos constituidos sin sustento técnico (vertimiento libre de materiales de excavación, escombros y basuras)',
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is RiskLevel &&
        other.title == title &&
        other.color == color &&
        _listEquals(other.items, items) &&
        other.description == description &&
        other.note == note &&
        other.value == value;
  }

  @override
  int get hashCode {
    return Object.hash(
      title,
      color,
      items,
      description,
      note,
      value,
    );
  }

  @override
  String toString() {
    return 'RiskLevel(title: $title, color: $color, items: $items, description: $description, note: $note, value: $value)';
  }

  bool _listEquals<T>(List<T>? a, List<T>? b) {
    if (a == null) return b == null;
    if (b == null || a.length != b.length) return false;
    for (int index = 0; index < a.length; index += 1) {
      if (a[index] != b[index]) return false;
    }
    return true;
  }
}