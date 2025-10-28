import 'package:equatable/equatable.dart';

/// Eventos base para el módulo Home
abstract class HomeEvent extends Equatable {
  const HomeEvent();

  @override
  List<Object?> get props => [];
}

// ========== NAVEGACIÓN ==========

/// Evento para inicializar el home
class HomeInitialized extends HomeEvent {
  const HomeInitialized();
}

/// Evento para cambiar el índice de navegación
class HomeNavBarTapped extends HomeEvent {
  final int index;

  const HomeNavBarTapped(this.index);

  @override
  List<Object?> get props => [index];
}

/// Evento para mostrar la sección de eventos de riesgo
class HomeShowRiskEventsSection extends HomeEvent {
  const HomeShowRiskEventsSection();
}

/// Evento para seleccionar un evento de riesgo
class SelectRiskEvent extends HomeEvent {
  final String eventName;

  const SelectRiskEvent(this.eventName);

  @override
  List<Object?> get props => [eventName];
}

/// Evento para resetear las secciones de riesgo
class HomeResetRiskSections extends HomeEvent {
  const HomeResetRiskSections();
}

/// Evento para mostrar la pantalla de formulario completado
class HomeShowFormCompletedScreen extends HomeEvent {
  const HomeShowFormCompletedScreen();
}

// ========== CONFIGURACIÓN ==========

/// Evento para alternar notificaciones
class HomeToggleNotifications extends HomeEvent {
  final bool enabled;

  const HomeToggleNotifications(this.enabled);

  @override
  List<Object?> get props => [enabled];
}

/// Evento para alternar modo oscuro
class HomeToggleDarkMode extends HomeEvent {
  final bool enabled;

  const HomeToggleDarkMode(this.enabled);

  @override
  List<Object?> get props => [enabled];
}

/// Evento para cambiar idioma
class HomeChangeLanguage extends HomeEvent {
  final String language;

  const HomeChangeLanguage(this.language);

  @override
  List<Object?> get props => [language];
}

/// Evento para limpiar datos
class HomeClearData extends HomeEvent {
  const HomeClearData();
}

// ========== FORMULARIOS ==========

/// Evento para cargar formularios
class LoadForms extends HomeEvent {
  const LoadForms();
}

/// Evento para eliminar un formulario
class DeleteForm extends HomeEvent {
  final String formId;

  const DeleteForm(this.formId);

  @override
  List<Object?> get props => [formId];
}

/// Evento para cargar un formulario para edición
class LoadFormForEditing extends HomeEvent {
  final String formId;

  const LoadFormForEditing(this.formId);

  @override
  List<Object?> get props => [formId];
}

/// Evento para completar un formulario
class CompleteForm extends HomeEvent {
  final String formId;

  const CompleteForm(this.formId);

  @override
  List<Object?> get props => [formId];
}

/// Evento para establecer el ID del formulario activo
class SetActiveFormId extends HomeEvent {
  final String? formId;
  final bool isCreatingNew;

  const SetActiveFormId({
    required this.formId,
    required this.isCreatingNew,
  });

  @override
  List<Object?> get props => [formId, isCreatingNew];
}

/// Evento para establecer el progreso de un formulario
class SetFormProgress extends HomeEvent {
  final String formId;
  final Map<String, double> progressData;

  const SetFormProgress({
    required this.formId,
    required this.progressData,
  });

  @override
  List<Object?> get props => [formId, progressData];
}

/// Evento para guardar un modelo de evento de riesgo
class SaveRiskEventModel extends HomeEvent {
  final String eventName;
  final String classificationType;
  final Map<String, dynamic> evaluationData;

  const SaveRiskEventModel({
    required this.eventName,
    required this.classificationType,
    required this.evaluationData,
  });

  @override
  List<Object?> get props => [eventName, classificationType, evaluationData];
}

/// Evento para resetear todo para un nuevo formulario
class ResetAllForNewForm extends HomeEvent {
  const ResetAllForNewForm();
}

// ========== EVALUACIONES ==========

/// Evento para marcar una evaluación como completada
class MarkEvaluationCompleted extends HomeEvent {
  final String eventName;
  final String classificationType;

  const MarkEvaluationCompleted({
    required this.eventName,
    required this.classificationType,
  });

  @override
  List<Object?> get props => [eventName, classificationType];
}

/// Evento para resetear evaluaciones para un evento
class ResetEvaluationsForEvent extends HomeEvent {
  final String eventName;

  const ResetEvaluationsForEvent(this.eventName);

  @override
  List<Object?> get props => [eventName];
}

// ========== TUTORIAL ==========

/// Evento para verificar y mostrar tutorial
class HomeCheckAndShowTutorial extends HomeEvent {
  const HomeCheckAndShowTutorial();
}

/// Evento para establecer si mostrar tutorial
class HomeSetShowTutorial extends HomeEvent {
  final bool value;

  const HomeSetShowTutorial(this.value);

  @override
  List<Object?> get props => [value];
}
