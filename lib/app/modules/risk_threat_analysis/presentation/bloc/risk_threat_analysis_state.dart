import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import '../../domain/entities/risk_analysis_entity.dart';

/// Estado de presentación para el módulo RiskThreatAnalysis
/// Representa el estado de la UI, separado de la lógica de negocio
class RiskThreatAnalysisState extends Equatable {
  final bool isProbabilidadDropdownOpen;
  final bool isIntensidadDropdownOpen;
  final String? selectedProbabilidad;
  final String? selectedIntensidad;
  final int currentBottomNavIndex;
  final Map<String, String> probabilidadSelections;
  final Map<String, String> intensidadSelections;
  final String selectedRiskEvent;
  final String selectedClassification;
  
  // Estado genérico para dropdowns dinámicos
  final Map<String, bool> dropdownOpenStates;
  final Map<String, Map<String, String>> dynamicSelections;
  
  // Cálculos dinámicos por subclasificación
  final Map<String, double> subClassificationScores;
  final Map<String, Color> subClassificationColors;
  
  // Estado de carga
  final bool isLoading;
  
  // Control para mostrar FinalRiskResultsScreen
  final bool showFinalResults;
  
  // Evidencias separadas por categoría
  final Map<String, List<String>> evidenceImages;
  final Map<String, Map<int, Map<String, String>>> evidenceCoordinates;

  // Estados de UI específicos
  final String? error;
  final bool hasError;

  const RiskThreatAnalysisState({
    this.isProbabilidadDropdownOpen = false,
    this.isIntensidadDropdownOpen = false,
    this.selectedProbabilidad,
    this.selectedIntensidad,
    this.currentBottomNavIndex = 0,
    this.probabilidadSelections = const {},
    this.intensidadSelections = const {},
    this.selectedRiskEvent = 'Movimiento en Masa',
    this.selectedClassification = 'amenaza',
    this.dropdownOpenStates = const {},
    this.dynamicSelections = const {},
    this.subClassificationScores = const {},
    this.subClassificationColors = const {},
    this.isLoading = false,
    this.showFinalResults = false,
    this.evidenceImages = const {},
    this.evidenceCoordinates = const {},
    this.error,
    this.hasError = false,
  });

  /// Factory constructor para estado inicial
  factory RiskThreatAnalysisState.initial() {
    return const RiskThreatAnalysisState();
  }

  /// Factory constructor desde entidad de dominio
  factory RiskThreatAnalysisState.fromEntity(RiskAnalysisEntity entity) {
    return RiskThreatAnalysisState(
      selectedRiskEvent: entity.eventName,
      selectedClassification: entity.classificationType,
      evidenceImages: entity.evidenceImages,
      evidenceCoordinates: entity.evidenceCoordinates,
    );
  }

  /// Convertir a entidad de dominio
  RiskAnalysisEntity toEntity() {
    return RiskAnalysisEntity(
      eventName: selectedRiskEvent,
      classificationType: selectedClassification,
      selections: {
        ...probabilidadSelections,
        ...intensidadSelections,
        ...dynamicSelections.values.expand((map) => map.entries).fold<Map<String, String>>({}, (acc, entry) => {...acc, entry.key: entry.value}),
      },
      evidenceImages: evidenceImages,
      evidenceCoordinates: evidenceCoordinates,
      lastModified: DateTime.now(),
    );
  }

  /// Copia con cambios
  RiskThreatAnalysisState copyWith({
    bool? isProbabilidadDropdownOpen,
    bool? isIntensidadDropdownOpen,
    String? selectedProbabilidad,
    String? selectedIntensidad,
    int? currentBottomNavIndex,
    Map<String, String>? probabilidadSelections,
    Map<String, String>? intensidadSelections,
    String? selectedRiskEvent,
    String? selectedClassification,
    Map<String, bool>? dropdownOpenStates,
    Map<String, Map<String, String>>? dynamicSelections,
    Map<String, double>? subClassificationScores,
    Map<String, Color>? subClassificationColors,
    bool? isLoading,
    bool? showFinalResults,
    Map<String, List<String>>? evidenceImages,
    Map<String, Map<int, Map<String, String>>>? evidenceCoordinates,
    String? error,
    bool? hasError,
  }) {
    return RiskThreatAnalysisState(
      isProbabilidadDropdownOpen: isProbabilidadDropdownOpen ?? this.isProbabilidadDropdownOpen,
      isIntensidadDropdownOpen: isIntensidadDropdownOpen ?? this.isIntensidadDropdownOpen,
      selectedProbabilidad: selectedProbabilidad ?? this.selectedProbabilidad,
      selectedIntensidad: selectedIntensidad ?? this.selectedIntensidad,
      currentBottomNavIndex: currentBottomNavIndex ?? this.currentBottomNavIndex,
      probabilidadSelections: probabilidadSelections ?? this.probabilidadSelections,
      intensidadSelections: intensidadSelections ?? this.intensidadSelections,
      selectedRiskEvent: selectedRiskEvent ?? this.selectedRiskEvent,
      selectedClassification: selectedClassification ?? this.selectedClassification,
      dropdownOpenStates: dropdownOpenStates ?? this.dropdownOpenStates,
      dynamicSelections: dynamicSelections ?? this.dynamicSelections,
      subClassificationScores: subClassificationScores ?? this.subClassificationScores,
      subClassificationColors: subClassificationColors ?? this.subClassificationColors,
      isLoading: isLoading ?? this.isLoading,
      showFinalResults: showFinalResults ?? this.showFinalResults,
      evidenceImages: evidenceImages ?? this.evidenceImages,
      evidenceCoordinates: evidenceCoordinates ?? this.evidenceCoordinates,
      error: error ?? this.error,
      hasError: hasError ?? this.hasError,
    );
  }

  /// Limpiar error
  RiskThreatAnalysisState clearError() {
    return copyWith(
      error: null,
      hasError: false,
    );
  }

  /// Establecer error
  RiskThreatAnalysisState setError(String error) {
    return copyWith(
      error: error,
      hasError: true,
    );
  }

  /// Establecer estado de carga
  RiskThreatAnalysisState setLoading(bool loading) {
    return copyWith(isLoading: loading);
  }

  // ========== COMPUTED PROPERTIES ==========

  /// ¿Hay algún dropdown abierto?
  bool get hasOpenDropdown => isProbabilidadDropdownOpen || isIntensidadDropdownOpen || dropdownOpenStates.values.any((isOpen) => isOpen);

  /// ¿Está cerrado un dropdown específico?
  bool isDynamicDropdownOpen(String subClassificationId) {
    return dropdownOpenStates[subClassificationId] ?? false;
  }

  /// ¿Están todos los dropdowns cerrados?
  bool get allDropdownsClosed => !hasOpenDropdown;

  /// ¿Es un análisis de amenaza?
  bool get isAmenaza => selectedClassification.toLowerCase() == 'amenaza';

  /// ¿Es un análisis de vulnerabilidad?
  bool get isVulnerabilidad => selectedClassification.toLowerCase() == 'vulnerabilidad';

  /// ¿Tiene evidencias?
  bool get hasEvidence => evidenceImages.isNotEmpty;

  @override
  List<Object?> get props => [
    isProbabilidadDropdownOpen,
    isIntensidadDropdownOpen,
    selectedProbabilidad,
    selectedIntensidad,
    currentBottomNavIndex,
    probabilidadSelections,
    intensidadSelections,
    selectedRiskEvent,
    selectedClassification,
    dropdownOpenStates,
    dynamicSelections,
    subClassificationScores,
    subClassificationColors,
    isLoading,
    showFinalResults,
    evidenceImages,
    evidenceCoordinates,
    error,
    hasError,
  ];

  @override
  String toString() {
    return 'RiskThreatAnalysisState(selectedRiskEvent: $selectedRiskEvent, '
           'selectedClassification: $selectedClassification, isLoading: $isLoading, '
           'hasError: $hasError, hasOpenDropdown: $hasOpenDropdown)';
  }
}
