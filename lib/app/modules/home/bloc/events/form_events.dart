import '../../models/domain/form_command_data.dart';
import 'home_event.dart';

/// Evento para cargar formularios
class LoadForms extends HomeEvent {
  const LoadForms();
}

/// Evento para guardar formulario
class SaveForm extends HomeEvent {
  final FormCommandData commandData;
  
  const SaveForm(this.commandData);

  @override
  List<Object?> get props => [commandData];
}

/// Evento para eliminar formulario
class DeleteForm extends HomeEvent {
  final String formId;
  
  const DeleteForm(this.formId);

  @override
  List<Object?> get props => [formId];
}

/// Evento para cargar formulario para edición
class LoadFormForEditing extends HomeEvent {
  final String formId;
  
  const LoadFormForEditing(this.formId);

  @override
  List<Object?> get props => [formId];
}

/// Evento para completar formulario
class CompleteForm extends HomeEvent {
  final String formId;
  
  const CompleteForm(this.formId);

  @override
  List<Object?> get props => [formId];
}

/// Evento para establecer ID de formulario activo
class SetActiveFormId extends HomeEvent {
  final String formId;
  final bool isCreatingNew;
  
  const SetActiveFormId(this.formId, {this.isCreatingNew = false});

  @override
  List<Object?> get props => [formId, isCreatingNew];
}

/// Evento para guardar modelo de evento de riesgo
class SaveRiskEventModel extends HomeEvent {
  final String eventName;
  final String classificationType; // 'amenaza' o 'vulnerabilidad'
  final Map<String, dynamic> evaluationData;
  
  const SaveRiskEventModel(this.eventName, this.classificationType, this.evaluationData);

  @override
  List<Object?> get props => [eventName, classificationType, evaluationData];
}

/// Evento para resetear todo para nuevo formulario
class ResetAllForNewForm extends HomeEvent {
  const ResetAllForNewForm();
}