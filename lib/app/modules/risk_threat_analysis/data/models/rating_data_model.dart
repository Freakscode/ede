import 'package:equatable/equatable.dart';
import '../../domain/entities/rating_entity.dart';

/// Modelo de datos para calificación
/// Mapea entre la entidad de dominio y los datos persistentes
class RatingDataModel extends Equatable {
  final String category;
  final String level;
  final String subClassificationId;

  const RatingDataModel({
    required this.category,
    required this.level,
    required this.subClassificationId,
  });

  /// Factory constructor desde entidad de dominio
  factory RatingDataModel.fromEntity(RatingEntity entity) {
    return RatingDataModel(
      category: entity.category,
      level: entity.level,
      subClassificationId: entity.subClassificationId,
    );
  }

  /// Convertir a entidad de dominio
  RatingEntity toEntity() {
    return RatingEntity(
      category: category,
      level: level,
      subClassificationId: subClassificationId,
    );
  }

  /// Factory constructor desde JSON
  factory RatingDataModel.fromJson(Map<String, dynamic> json) {
    return RatingDataModel(
      category: json['category'] ?? '',
      level: json['level'] ?? '',
      subClassificationId: json['subClassificationId'] ?? '',
    );
  }

  /// Convertir a JSON
  Map<String, dynamic> toJson() {
    return {
      'category': category,
      'level': level,
      'subClassificationId': subClassificationId,
    };
  }

  /// Copia con cambios
  RatingDataModel copyWith({
    String? category,
    String? level,
    String? subClassificationId,
  }) {
    return RatingDataModel(
      category: category ?? this.category,
      level: level ?? this.level,
      subClassificationId: subClassificationId ?? this.subClassificationId,
    );
  }

  @override
  List<Object?> get props => [category, level, subClassificationId];
}
