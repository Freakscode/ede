import 'home_event.dart';

/// Evento para marcar evaluación como completada
class MarkEvaluationCompleted extends HomeEvent {
  final String eventName;
  final String classificationType; // 'amenaza' o 'vulnerabilidad'
  
  const MarkEvaluationCompleted(this.eventName, this.classificationType);

  @override
  List<Object?> get props => [eventName, classificationType];
}

/// Evento para resetear evaluaciones de un evento específico
class ResetEvaluationsForEvent extends HomeEvent {
  final String eventName;
  
  const ResetEvaluationsForEvent(this.eventName);

  @override
  List<Object?> get props => [eventName];
}

/// Evento para resetear dropdowns
class ResetDropdowns extends HomeEvent {
  const ResetDropdowns();
}

/// Evento para actualizar evento de riesgo seleccionado
class UpdateSelectedRiskEvent extends HomeEvent {
  final String eventName;
  
  const UpdateSelectedRiskEvent(this.eventName);

  @override
  List<Object?> get props => [eventName];
}

/// Evento para seleccionar clasificación
class SelectClassification extends HomeEvent {
  final String classification;
  
  const SelectClassification(this.classification);

  @override
  List<Object?> get props => [classification];
}