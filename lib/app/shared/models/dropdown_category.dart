import 'package:caja_herramientas/app/shared/models/risk_level.dart';

class DropdownCategory {
  final String title;
  final List<String> levels;
  final List<RiskLevel>? detailedLevels;
  final Map<String, dynamic>? additionalData;

  const DropdownCategory({
    required this.title,
    required this.levels,
    this.detailedLevels,
    this.additionalData,
  });

  factory DropdownCategory.fromMap(Map<String, dynamic> map) {
    return DropdownCategory(
      title: map['title'] as String,
      levels: List<String>.from(map['levels'] as List),
      detailedLevels: map['detailedLevels'] != null
          ? (map['detailedLevels'] as List)
              .map((e) => e is RiskLevel ? e : RiskLevel.fromMap(e as Map<String, dynamic>))
              .toList()
          : null,
      additionalData: map['additionalData'] as Map<String, dynamic>?,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'levels': levels,
      if (detailedLevels != null)
        'detailedLevels': detailedLevels!.map((e) => e.toMap()).toList(),
      if (additionalData != null) 'additionalData': additionalData,
    };
  }


  // Factory para categoría de intensidad
  factory DropdownCategory.intensidad() {
    return DropdownCategory(
      title: 'Intensidad',
      levels: ['BAJO', 'MEDIO', 'MEDIO ALTO', 'ALTO'],
      detailedLevels: [
        RiskLevel.bajo(
          customItems: [
            'Desplazamientos lentos y de poca magnitud.',
            'Afectación menor a la infraestructura.',
          ],
        ),
        RiskLevel.medioBajo(
          customItems: [
            'Desplazamientos moderados.',
            'Afectación parcial a la infraestructura.',
          ],
        ),
        RiskLevel.medioAlto(
          customItems: [
            'Desplazamientos significativos.',
            'Afectación considerable a la infraestructura.',
          ],
        ),
        RiskLevel.alto(
          customItems: [
            'Desplazamientos rápidos y de gran magnitud.',
            'Destrucción total de la infraestructura.',
            'Pérdidas humanas posibles.',
          ],
          customNote: 'NOTA: En eventos de alta intensidad, la evacuación inmediata es necesaria',
        ),
      ],
    );
  }

  // Factory para categoría personalizada
  factory DropdownCategory.custom({
    required String title,
    required List<String> levels,
    List<RiskLevel>? detailedLevels,
    Map<String, dynamic>? additionalData,
  }) {
    return DropdownCategory(
      title: title,
      levels: levels,
      detailedLevels: detailedLevels,
      additionalData: additionalData,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is DropdownCategory &&
        other.title == title &&
        _listEquals(other.levels, levels) &&
        _listEquals(other.detailedLevels, detailedLevels) &&
        _mapEquals(other.additionalData, additionalData);
  }

  @override
  int get hashCode {
    return Object.hash(
      title,
      levels,
      detailedLevels,
      additionalData,
    );
  }

 

  @override
  String toString() {
    return 'DropdownCategory(title: $title, levels: $levels, detailedLevels: $detailedLevels, additionalData: $additionalData)';
  }

  bool _listEquals<T>(List<T>? a, List<T>? b) {
    if (a == null) return b == null;
    if (b == null || a.length != b.length) return false;
    for (int index = 0; index < a.length; index += 1) {
      if (a[index] != b[index]) return false;
    }
    return true;
  }

  bool _mapEquals<K, V>(Map<K, V>? a, Map<K, V>? b) {
    if (a == null) return b == null;
    if (b == null || a.length != b.length) return false;
    for (final key in a.keys) {
      if (!b.containsKey(key) || a[key] != b[key]) return false;
    }
    return true;
  }
}