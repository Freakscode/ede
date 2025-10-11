import 'package:flutter/material.dart';

class RiskThreatAnalysisState {
  final bool isProbabilidadDropdownOpen;
  final bool isIntensidadDropdownOpen;
  final String? selectedProbabilidad;
  final String? selectedIntensidad;
  final int currentBottomNavIndex;
  final Map<String, String> probabilidadSelections;
  final Map<String, String> intensidadSelections;
  final String selectedRiskEvent;
  final String selectedClassification; // Nueva propiedad para Amenaza/Vulnerabilidad
  
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
  
  // Coordenadas de imágenes para evidencia
  final Map<int, Map<String, String>> imageCoordinates;

  const RiskThreatAnalysisState({
    this.isProbabilidadDropdownOpen = false,
    this.isIntensidadDropdownOpen = false,
    this.selectedProbabilidad,
    this.selectedIntensidad,
    this.currentBottomNavIndex = 0,
    this.probabilidadSelections = const {},
    this.intensidadSelections = const {},
    this.selectedRiskEvent = 'Movimiento en Masa', // Default
    this.selectedClassification = 'amenaza', // Default: amenaza
    this.dropdownOpenStates = const {},
    this.dynamicSelections = const {},
    this.subClassificationScores = const {},
    this.subClassificationColors = const {},
    this.isLoading = false,
    this.showFinalResults = false,
    this.imageCoordinates = const {},
  });

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
    Map<int, Map<String, String>>? imageCoordinates,
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
      imageCoordinates: imageCoordinates ?? this.imageCoordinates,
    );
  }
}