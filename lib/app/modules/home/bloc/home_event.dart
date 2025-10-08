import 'package:equatable/equatable.dart';

abstract class HomeEvent extends Equatable {
  const HomeEvent();

  @override
  List<Object?> get props => [];
}

class HomeNavBarTapped extends HomeEvent {
  final int index;
  const HomeNavBarTapped(this.index);

  @override
  List<Object?> get props => [index];
}

class HomeShowRiskEventsSection extends HomeEvent {}

class HomeShowRiskCategoriesScreen extends HomeEvent {}

class SelectRiskEvent extends HomeEvent {
  final String eventName;
  const SelectRiskEvent(this.eventName);

  @override
  List<Object?> get props => [eventName];
}

class SelectRiskCategory extends HomeEvent {
  final String categoryType; // 'Amenaza' o 'Vulnerabilidad'
  final String eventName; // El evento asociado
  const SelectRiskCategory(this.categoryType, this.eventName);

  @override
  List<Object?> get props => [categoryType, eventName];
}

class HomeResetRiskSections extends HomeEvent {}

class HomeCheckAndShowTutorial extends HomeEvent {}

class HomeSetShowTutorial extends HomeEvent {
  final bool value;
  const HomeSetShowTutorial(this.value);

  @override
  List<Object?> get props => [value];
}

class HomeToggleNotifications extends HomeEvent {
  final bool enabled;
  const HomeToggleNotifications(this.enabled);

  @override
  List<Object?> get props => [enabled];
}

class HomeToggleDarkMode extends HomeEvent {
  final bool enabled;
  const HomeToggleDarkMode(this.enabled);

  @override
  List<Object?> get props => [enabled];
}

class HomeChangeLanguage extends HomeEvent {
  final String language;
  const HomeChangeLanguage(this.language);

  @override
  List<Object?> get props => [language];
}

class HomeClearData extends HomeEvent {}

class MarkEvaluationCompleted extends HomeEvent {
  final String eventName;
  final String classificationType; // 'amenaza' o 'vulnerabilidad'
  
  const MarkEvaluationCompleted(this.eventName, this.classificationType);

  @override
  List<Object?> get props => [eventName, classificationType];
}

/// Resetear las evaluaciones completadas para un evento específico
/// Esto permite empezar una nueva evaluación limpia del mismo tipo de evento
class ResetEvaluationsForEvent extends HomeEvent {
  final String eventName;
  
  const ResetEvaluationsForEvent(this.eventName);

  @override
  List<Object?> get props => [eventName];
}

// ======= NUEVOS EVENTOS PARA GESTIÓN DE FORMULARIOS =======

class LoadForms extends HomeEvent {}

class SaveForm extends HomeEvent {
  final String eventName;
  final Map<String, dynamic> formData;
  
  const SaveForm(this.eventName, this.formData);

  @override
  List<Object?> get props => [eventName, formData];
}

class DeleteForm extends HomeEvent {
  final String formId;
  
  const DeleteForm(this.formId);

  @override
  List<Object?> get props => [formId];
}

class LoadFormForEditing extends HomeEvent {
  final String formId;
  
  const LoadFormForEditing(this.formId);

  @override
  List<Object?> get props => [formId];
}

class CompleteForm extends HomeEvent {
  final String formId;
  
  const CompleteForm(this.formId);

  @override
  List<Object?> get props => [formId];
}
  
class SetActiveFormId extends HomeEvent {
  final String formId;
  
  const SetActiveFormId(this.formId);

  @override
  List<Object?> get props => [formId];
}