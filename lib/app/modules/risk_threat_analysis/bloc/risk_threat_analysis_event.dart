abstract class RiskThreatAnalysisEvent {}

class ToggleProbabilidadDropdown extends RiskThreatAnalysisEvent {}

class ToggleIntensidadDropdown extends RiskThreatAnalysisEvent {}

class SelectProbabilidad extends RiskThreatAnalysisEvent {
  final String probabilidad;
  
  SelectProbabilidad(this.probabilidad);
}

class SelectIntensidad extends RiskThreatAnalysisEvent {
  final String intensidad;
  
  SelectIntensidad(this.intensidad);
}

class ResetDropdowns extends RiskThreatAnalysisEvent {}

// Navigation Events
class ChangeBottomNavIndex extends RiskThreatAnalysisEvent {
  final int index;
  
  ChangeBottomNavIndex(this.index);
}