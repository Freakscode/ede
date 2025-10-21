import 'risk_threat_analysis_event.dart';

/// Eventos de selección
/// Sigue el principio de responsabilidad única (SRP)
abstract class SelectionEvent extends RiskThreatAnalysisEvent {
  const SelectionEvent();
}

/// Evento para seleccionar probabilidad
class SelectProbabilidad extends SelectionEvent {
  final String probabilidad;
  
  const SelectProbabilidad(this.probabilidad);

  @override
  List<Object?> get props => [probabilidad];
}

/// Evento para seleccionar intensidad
class SelectIntensidad extends SelectionEvent {
  final String intensidad;
  
  const SelectIntensidad(this.intensidad);

  @override
  List<Object?> get props => [intensidad];
}

/// Evento para actualizar selección de probabilidad
class UpdateProbabilidadSelection extends SelectionEvent {
  final String category;
  final String level;
  
  const UpdateProbabilidadSelection(this.category, this.level);

  @override
  List<Object?> get props => [category, level];
}

/// Evento para actualizar selección de intensidad
class UpdateIntensidadSelection extends SelectionEvent {
  final String category;
  final String level;
  
  const UpdateIntensidadSelection(this.category, this.level);

  @override
  List<Object?> get props => [category, level];
}

/// Evento para actualizar selección dinámica
class UpdateDynamicSelection extends SelectionEvent {
  final String subClassificationId;
  final String category;
  final String level;
  
  const UpdateDynamicSelection(this.subClassificationId, this.category, this.level);

  @override
  List<Object?> get props => [subClassificationId, category, level];
}
