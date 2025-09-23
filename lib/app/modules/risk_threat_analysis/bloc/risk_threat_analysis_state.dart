class RiskThreatAnalysisState {
  final bool isProbabilidadDropdownOpen;
  final bool isIntensidadDropdownOpen;
  final String? selectedProbabilidad;
  final String? selectedIntensidad;
  final int currentBottomNavIndex;

  const RiskThreatAnalysisState({
    this.isProbabilidadDropdownOpen = false,
    this.isIntensidadDropdownOpen = false,
    this.selectedProbabilidad,
    this.selectedIntensidad,
    this.currentBottomNavIndex = 0,
  });

  RiskThreatAnalysisState copyWith({
    bool? isProbabilidadDropdownOpen,
    bool? isIntensidadDropdownOpen,
    String? selectedProbabilidad,
    String? selectedIntensidad,
    int? currentBottomNavIndex,
  }) {
    return RiskThreatAnalysisState(
      isProbabilidadDropdownOpen: isProbabilidadDropdownOpen ?? this.isProbabilidadDropdownOpen,
      isIntensidadDropdownOpen: isIntensidadDropdownOpen ?? this.isIntensidadDropdownOpen,
      selectedProbabilidad: selectedProbabilidad ?? this.selectedProbabilidad,
      selectedIntensidad: selectedIntensidad ?? this.selectedIntensidad,
      currentBottomNavIndex: currentBottomNavIndex ?? this.currentBottomNavIndex,
    );
  }
}