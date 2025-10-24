import 'package:equatable/equatable.dart';

/// Entidad de dominio para análisis de riesgo
/// Encapsula la lógica de negocio relacionada con análisis de riesgo
class RiskAnalysisEntity extends Equatable {
  final String eventName;
  final String classificationType;
  final String formMode;
  final Map<String, dynamic> selections;
  final Map<String, double> scores;
  final Map<String, String> colors;
  final Map<String, List<String>> evidenceImages;
  final Map<String, Map<int, Map<String, String>>> evidenceCoordinates;
  final DateTime? lastModified;
  final bool isCompleted;
  
  const RiskAnalysisEntity({
    required this.eventName,
    required this.classificationType,
    this.formMode = 'create',
    this.selections = const {},
    this.scores = const {},
    this.colors = const {},
    this.evidenceImages = const {},
    this.evidenceCoordinates = const {},
    this.lastModified,
    this.isCompleted = false,
  });

  @override
  List<Object?> get props => [
    eventName,
    classificationType,
    formMode,
    selections,
    scores,
    colors,
    evidenceImages,
    evidenceCoordinates,
    lastModified,
    isCompleted,
  ];

  /// Lógica de negocio: ¿Es un análisis válido?
  bool get isValid => eventName.isNotEmpty && classificationType.isNotEmpty;

  /// Lógica de negocio: ¿Es un análisis de amenaza?
  bool get isAmenaza => classificationType.toLowerCase() == 'amenaza';

  /// Lógica de negocio: ¿Es un análisis de vulnerabilidad?
  bool get isVulnerabilidad => classificationType.toLowerCase() == 'vulnerabilidad';
  
  /// Lógica de negocio: ¿Es modo creación?
  bool get isCreateMode => formMode == 'create';
  
  /// Lógica de negocio: ¿Es modo edición?
  bool get isEditMode => formMode == 'edit';

  /// Lógica de negocio: ¿Está vacío el análisis?
  bool get isEmpty => selections.isEmpty;

  /// Lógica de negocio: ¿Tiene datos?
  bool get hasData => selections.isNotEmpty;

  /// Lógica de negocio: ¿Tiene evidencias?
  bool get hasEvidence => evidenceImages.isNotEmpty;

  /// Lógica de negocio: ¿Está completo el análisis?
  bool get isFullyCompleted => isCompleted && hasData;

  /// Factory method: Crear análisis de amenaza
  static RiskAnalysisEntity forAmenaza(String eventName, Map<String, dynamic> selections) {
    return RiskAnalysisEntity(
      eventName: eventName,
      classificationType: 'amenaza',
      selections: selections,
      lastModified: DateTime.now(),
    );
  }

  /// Factory method: Crear análisis de vulnerabilidad
  static RiskAnalysisEntity forVulnerabilidad(String eventName, Map<String, dynamic> selections) {
    return RiskAnalysisEntity(
      eventName: eventName,
      classificationType: 'vulnerabilidad',
      selections: selections,
      lastModified: DateTime.now(),
    );
  }

  /// Método de negocio: Crear copia con cambios
  RiskAnalysisEntity copyWith({
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
    return RiskAnalysisEntity(
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

  /// Método de negocio: Agregar selección
  RiskAnalysisEntity addSelection(String key, dynamic value) {
    final newSelections = Map<String, dynamic>.from(selections);
    newSelections[key] = value;
    return copyWith(selections: newSelections, lastModified: DateTime.now());
  }

  /// Método de negocio: Remover selección
  RiskAnalysisEntity removeSelection(String key) {
    final newSelections = Map<String, dynamic>.from(selections);
    newSelections.remove(key);
    return copyWith(selections: newSelections, lastModified: DateTime.now());
  }

  /// Método de negocio: Agregar evidencia
  RiskAnalysisEntity addEvidence(String category, String imagePath) {
    final newEvidenceImages = Map<String, List<String>>.from(evidenceImages);
    final categoryImages = List<String>.from(newEvidenceImages[category] ?? []);
    categoryImages.add(imagePath);
    newEvidenceImages[category] = categoryImages;
    return copyWith(evidenceImages: newEvidenceImages, lastModified: DateTime.now());
  }

  /// Método de negocio: Marcar como completado
  RiskAnalysisEntity markAsCompleted() {
    return copyWith(isCompleted: true, lastModified: DateTime.now());
  }

  @override
  String toString() {
    return 'RiskAnalysisEntity(eventName: $eventName, classificationType: $classificationType, '
           'hasData: $hasData, isCompleted: $isCompleted, lastModified: $lastModified)';
  }
}
