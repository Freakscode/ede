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
    );
  }
}