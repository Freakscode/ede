import 'package:equatable/equatable.dart';
import '../../domain/entities/tutorial_entity.dart';

/// Modelo de datos para Tutorial
/// Mapea entre la entidad de dominio y los datos persistentes
class TutorialModel extends Equatable {
  final bool showTutorial;
  final bool tutorialShown;
  final DateTime? lastShown;
  final int showCount;
  final bool isEnabled;

  const TutorialModel({
    required this.showTutorial,
    required this.tutorialShown,
    this.lastShown,
    this.showCount = 0,
    this.isEnabled = true,
  });

  /// Factory constructor desde entidad de dominio
  factory TutorialModel.fromEntity(TutorialEntity entity) {
    return TutorialModel(
      showTutorial: entity.showTutorial,
      tutorialShown: entity.tutorialShown,
      lastShown: entity.lastShown,
      showCount: entity.showCount,
      isEnabled: entity.isEnabled,
    );
  }

  /// Convertir a entidad de dominio
  TutorialEntity toEntity() {
    return TutorialEntity(
      showTutorial: showTutorial,
      tutorialShown: tutorialShown,
      lastShown: lastShown,
      showCount: showCount,
      isEnabled: isEnabled,
    );
  }

  /// Factory constructor desde JSON
  factory TutorialModel.fromJson(Map<String, dynamic> json) {
    return TutorialModel(
      showTutorial: json['showTutorial'] ?? true,
      tutorialShown: json['tutorialShown'] ?? false,
      lastShown: json['lastShown'] != null 
          ? DateTime.parse(json['lastShown']) 
          : null,
      showCount: json['showCount'] ?? 0,
      isEnabled: json['isEnabled'] ?? true,
    );
  }

  /// Convertir a JSON
  Map<String, dynamic> toJson() {
    return {
      'showTutorial': showTutorial,
      'tutorialShown': tutorialShown,
      'lastShown': lastShown?.toIso8601String(),
      'showCount': showCount,
      'isEnabled': isEnabled,
    };
  }

  /// Copia con cambios
  TutorialModel copyWith({
    bool? showTutorial,
    bool? tutorialShown,
    DateTime? lastShown,
    int? showCount,
    bool? isEnabled,
  }) {
    return TutorialModel(
      showTutorial: showTutorial ?? this.showTutorial,
      tutorialShown: tutorialShown ?? this.tutorialShown,
      lastShown: lastShown ?? this.lastShown,
      showCount: showCount ?? this.showCount,
      isEnabled: isEnabled ?? this.isEnabled,
    );
  }

  @override
  List<Object?> get props => [
        showTutorial,
        tutorialShown,
        lastShown,
        showCount,
        isEnabled,
      ];
}
