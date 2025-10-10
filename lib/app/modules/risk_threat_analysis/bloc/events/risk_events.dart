import 'risk_threat_analysis_event.dart';

/// Eventos de riesgo
/// Sigue el principio de responsabilidad única (SRP)
abstract class RiskEvent extends RiskThreatAnalysisEvent {
  const RiskEvent();
}

/// Evento para actualizar evento de riesgo seleccionado
class UpdateSelectedRiskEvent extends RiskEvent {
  final String riskEvent;
  
  const UpdateSelectedRiskEvent(this.riskEvent);

  @override
  List<Object?> get props => [riskEvent];
}

/// Evento para seleccionar clasificación (Amenaza o Vulnerabilidad)
class SelectClassification extends RiskEvent {
  final String classification; // 'amenaza' or 'vulnerabilidad'
  
  const SelectClassification(this.classification);

  @override
  List<Object?> get props => [classification];
}
