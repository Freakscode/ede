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
  
  // Persistencia de formularios
  final String? activeFormId;
  final bool isSaving;
  final bool isLoading;
  final DateTime? lastSaved;
  
  // Control para mostrar FinalRiskResultsScreen
  final bool showFinalResults;

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
    this.activeFormId,
    this.isSaving = false,
    this.isLoading = false,
    this.lastSaved,
    this.showFinalResults = false,
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
    String? activeFormId,
    bool? isSaving,
    bool? isLoading,
    DateTime? lastSaved,
    bool? showFinalResults,
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
      activeFormId: activeFormId ?? this.activeFormId,
      isSaving: isSaving ?? this.isSaving,
      isLoading: isLoading ?? this.isLoading,
      lastSaved: lastSaved ?? this.lastSaved,
      showFinalResults: showFinalResults ?? this.showFinalResults,
    );
  }
}