import 'package:equatable/equatable.dart';

/// Value Object para datos de calificación
/// Encapsula la lógica de negocio relacionada con calificaciones
class RatingData extends Equatable {
  final String category;
  final String level;
  final String subClassificationId;
  
  const RatingData({
    required this.category,
    required this.level,
    required this.subClassificationId,
  });

  @override
  List<Object?> get props => [category, level, subClassificationId];

  /// Lógica de negocio: ¿Es una calificación válida?
  bool get isValid => category.isNotEmpty && level.isNotEmpty;

  /// Lógica de negocio: ¿Es una calificación de probabilidad?
  bool get isProbabilidad => subClassificationId.toLowerCase() == 'probabilidad';

  /// Lógica de negocio: ¿Es una calificación de intensidad?
  bool get isIntensidad => subClassificationId.toLowerCase() == 'intensidad';

  /// Factory method: Crear calificación de probabilidad
  static RatingData forProbabilidad(String category, String level) {
    return RatingData(
      category: category,
      level: level,
      subClassificationId: 'probabilidad',
    );
  }

  /// Factory method: Crear calificación de intensidad
  static RatingData forIntensidad(String category, String level) {
    return RatingData(
      category: category,
      level: level,
      subClassificationId: 'intensidad',
    );
  }

  /// Método de negocio: Crear copia con cambios
  RatingData copyWith({
    String? category,
    String? level,
    String? subClassificationId,
  }) {
    return RatingData(
      category: category ?? this.category,
      level: level ?? this.level,
      subClassificationId: subClassificationId ?? this.subClassificationId,
    );
  }

  @override
  String toString() {
    return 'RatingData(category: $category, level: $level, subClassificationId: $subClassificationId)';
  }
}
