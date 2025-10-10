import 'risk_threat_analysis_event.dart';

/// Eventos de dropdowns
/// Sigue el principio de responsabilidad única (SRP)
abstract class DropdownEvent extends RiskThreatAnalysisEvent {
  const DropdownEvent();
}

/// Evento para alternar dropdown de probabilidad
class ToggleProbabilidadDropdown extends DropdownEvent {
  const ToggleProbabilidadDropdown();
}

/// Evento para alternar dropdown de intensidad
class ToggleIntensidadDropdown extends DropdownEvent {
  const ToggleIntensidadDropdown();
}

/// Evento para alternar dropdown dinámico
class ToggleDynamicDropdown extends DropdownEvent {
  final String subClassificationId;
  
  const ToggleDynamicDropdown(this.subClassificationId);

  @override
  List<Object?> get props => [subClassificationId];
}

/// Evento para resetear todos los dropdowns
class ResetDropdowns extends DropdownEvent {
  const ResetDropdowns();
}
