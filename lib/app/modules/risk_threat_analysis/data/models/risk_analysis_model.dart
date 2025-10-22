import 'package:equatable/equatable.dart';
import '../../domain/entities/risk_analysis_entity.dart';

/// Modelo de datos para análisis de riesgo
/// Mapea entre la entidad de dominio y los datos persistentes
class RiskAnalysisModel extends Equatable {
  final String eventName;
  final String classificationType;
  final Map<String, dynamic> selections;
  final Map<String, double> scores;
  final Map<String, String> colors;
  final Map<String, List<String>> evidenceImages;
  final Map<String, Map<int, Map<String, String>>> evidenceCoordinates;
  final DateTime? lastModified;
  final bool isCompleted;

  const RiskAnalysisModel({
    required this.eventName,
    required this.classificationType,
    this.selections = const {},
    this.scores = const {},
    this.colors = const {},
    this.evidenceImages = const {},
    this.evidenceCoordinates = const {},
    this.lastModified,
    this.isCompleted = false,
  });

  /// Factory constructor desde entidad de dominio
  factory RiskAnalysisModel.fromEntity(RiskAnalysisEntity entity) {
    return RiskAnalysisModel(
      eventName: entity.eventName,
      classificationType: entity.classificationType,
      selections: entity.selections,
      scores: entity.scores,
      colors: entity.colors,
      evidenceImages: entity.evidenceImages,
      evidenceCoordinates: entity.evidenceCoordinates,
      lastModified: entity.lastModified,
      isCompleted: entity.isCompleted,
    );
  }

  /// Convertir a entidad de dominio
  RiskAnalysisEntity toEntity() {
    return RiskAnalysisEntity(
      eventName: eventName,
      classificationType: classificationType,
      selections: selections,
      scores: scores,
      colors: colors,
      evidenceImages: evidenceImages,
      evidenceCoordinates: evidenceCoordinates,
      lastModified: lastModified,
      isCompleted: isCompleted,
    );
  }

  /// Factory constructor desde JSON
  factory RiskAnalysisModel.fromJson(Map<String, dynamic> json) {
    return RiskAnalysisModel(
      eventName: json['eventName'] ?? '',
      classificationType: json['classificationType'] ?? '',
      selections: Map<String, dynamic>.from(json['selections'] ?? {}),
      scores: Map<String, double>.from(json['scores'] ?? {}),
      colors: Map<String, String>.from(json['colors'] ?? {}),
      evidenceImages: Map<String, List<String>>.from(
        (json['evidenceImages'] ?? {}).map(
          (key, value) => MapEntry(key, List<String>.from(value)),
        ),
      ),
      evidenceCoordinates: Map<String, Map<int, Map<String, String>>>.from(
        (json['evidenceCoordinates'] ?? {}).map(
          (key, value) => MapEntry(
            key,
            Map<int, Map<String, String>>.from(
              (value as Map).map(
                (k, v) => MapEntry(
                  int.parse(k.toString()),
                  Map<String, String>.from(v),
                ),
              ),
            ),
          ),
        ),
      ),
      lastModified: json['lastModified'] != null 
          ? DateTime.parse(json['lastModified']) 
          : null,
      isCompleted: json['isCompleted'] ?? false,
    );
  }

  /// Convertir a JSON
  Map<String, dynamic> toJson() {
    return {
      'eventName': eventName,
      'classificationType': classificationType,
      'selections': selections,
      'scores': scores,
      'colors': colors,
      'evidenceImages': evidenceImages,
      'evidenceCoordinates': evidenceCoordinates.map(
        (key, value) => MapEntry(
          key,
          value.map((k, v) => MapEntry(k.toString(), v)),
        ),
      ),
      'lastModified': lastModified?.toIso8601String(),
      'isCompleted': isCompleted,
    };
  }

  /// Copia con cambios
  RiskAnalysisModel copyWith({
    String? eventName,
    String? classificationType,
    Map<String, dynamic>? selections,
    Map<String, double>? scores,
    Map<String, String>? colors,
    Map<String, List<String>>? evidenceImages,
    Map<String, Map<int, Map<String, String>>>? evidenceCoordinates,
    DateTime? lastModified,
    bool? isCompleted,
  }) {
    return RiskAnalysisModel(
      eventName: eventName ?? this.eventName,
      classificationType: classificationType ?? this.classificationType,
      selections: selections ?? this.selections,
      scores: scores ?? this.scores,
      colors: colors ?? this.colors,
      evidenceImages: evidenceImages ?? this.evidenceImages,
      evidenceCoordinates: evidenceCoordinates ?? this.evidenceCoordinates,
      lastModified: lastModified ?? this.lastModified,
      isCompleted: isCompleted ?? this.isCompleted,
    );
  }

  @override
  List<Object?> get props => [
    eventName,
    classificationType,
    selections,
    scores,
    colors,
    evidenceImages,
    evidenceCoordinates,
    lastModified,
    isCompleted,
  ];
}
