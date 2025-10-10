import 'risk_threat_analysis_event.dart';

/// Eventos de formularios
/// Sigue el principio de responsabilidad única (SRP)
abstract class FormEvent extends RiskThreatAnalysisEvent {
  const FormEvent();
}

/// Evento para cargar datos existentes de un formulario
class LoadFormData extends FormEvent {
  final String eventName;
  final String classificationType;
  final Map<String, dynamic> formData;
  
  const LoadFormData(this.eventName, this.classificationType, this.formData);

  @override
  List<Object?> get props => [eventName, classificationType, formData];
}

/// Evento para guardar datos del formulario actual
class SaveFormData extends FormEvent {
  final String eventName;
  final String classificationType;
  final Map<String, dynamic> formData;
  
  const SaveFormData(this.eventName, this.classificationType, this.formData);

  @override
  List<Object?> get props => [eventName, classificationType, formData];
}
