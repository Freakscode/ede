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

// Dropdown Selection Events
class UpdateProbabilidadSelection extends RiskThreatAnalysisEvent {
  final String category;
  final String level;
  
  UpdateProbabilidadSelection(this.category, this.level);
}

class UpdateIntensidadSelection extends RiskThreatAnalysisEvent {
  final String category;
  final String level;
  
  UpdateIntensidadSelection(this.category, this.level);
}

// Event to update selected risk event
class UpdateSelectedRiskEvent extends RiskThreatAnalysisEvent {
  final String riskEvent;
  
  UpdateSelectedRiskEvent(this.riskEvent);
}

// Event to select classification (Amenaza or Vulnerabilidad)
class SelectClassification extends RiskThreatAnalysisEvent {
  final String classification; // 'amenaza' or 'vulnerabilidad'
  
  SelectClassification(this.classification);
}