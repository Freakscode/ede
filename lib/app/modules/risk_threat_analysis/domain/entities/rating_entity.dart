import 'package:equatable/equatable.dart';

/// Entidad de dominio para datos de calificación
/// Encapsula la lógica de negocio relacionada con calificaciones
class RatingEntity extends Equatable {
  final String category;
  final String level;
  final String subClassificationId;
  
  const RatingEntity({
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
  static RatingEntity forProbabilidad(String category, String level) {
    return RatingEntity(
      category: category,
      level: level,
      subClassificationId: 'probabilidad',
    );
  }

  /// Factory method: Crear calificación de intensidad
  static RatingEntity forIntensidad(String category, String level) {
    return RatingEntity(
      category: category,
      level: level,
      subClassificationId: 'intensidad',
    );
  }

  /// Método de negocio: Crear copia con cambios
  RatingEntity copyWith({
    String? category,
    String? level,
    String? subClassificationId,
  }) {
    return RatingEntity(
      category: category ?? this.category,
      level: level ?? this.level,
      subClassificationId: subClassificationId ?? this.subClassificationId,
    );
  }

  @override
  String toString() {
    return 'RatingEntity(category: $category, level: $level, subClassificationId: $subClassificationId)';
  }
}
