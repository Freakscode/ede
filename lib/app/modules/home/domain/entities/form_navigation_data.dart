import 'package:equatable/equatable.dart';

/// Entidad para datos de navegación de formularios
/// Encapsula la información necesaria para navegar entre formularios
class FormNavigationData extends Equatable {
  final String eventName;
  final String formId;
  final bool loadSavedForm;
  final bool showProgressInfo;
  final bool resetForNewForm;
  final Map<String, double>? progressData;

  const FormNavigationData({
    required this.eventName,
    required this.formId,
    this.loadSavedForm = false,
    this.showProgressInfo = false,
    this.resetForNewForm = false,
    this.progressData,
  });

  /// Factory constructor para nuevo formulario
  factory FormNavigationData.forNewForm(String eventName) {
    return FormNavigationData(
      eventName: eventName,
      formId: '',
      loadSavedForm: false,
      showProgressInfo: false,
      resetForNewForm: true,
    );
  }

  /// Factory constructor para formulario existente
  factory FormNavigationData.forExistingForm({
    required String eventName,
    required String formId,
    bool showProgressInfo = true,
    Map<String, double>? progressData,
  }) {
    return FormNavigationData(
      eventName: eventName,
      formId: formId,
      loadSavedForm: true,
      showProgressInfo: showProgressInfo,
      resetForNewForm: false,
      progressData: progressData,
    );
  }

  /// Factory constructor para editar formulario
  factory FormNavigationData.forEditForm({
    required String eventName,
    required String formId,
  }) {
    return FormNavigationData(
      eventName: eventName,
      formId: formId,
      loadSavedForm: true,
      showProgressInfo: false,
      resetForNewForm: false,
    );
  }

  /// Copia con cambios
  FormNavigationData copyWith({
    String? eventName,
    String? formId,
    bool? loadSavedForm,
    bool? showProgressInfo,
    bool? resetForNewForm,
    Map<String, double>? progressData,
  }) {
    return FormNavigationData(
      eventName: eventName ?? this.eventName,
      formId: formId ?? this.formId,
      loadSavedForm: loadSavedForm ?? this.loadSavedForm,
      showProgressInfo: showProgressInfo ?? this.showProgressInfo,
      resetForNewForm: resetForNewForm ?? this.resetForNewForm,
      progressData: progressData ?? this.progressData,
    );
  }

  /// Lógica de negocio: ¿Es para un formulario nuevo?
  bool get isForNewForm => !loadSavedForm && formId.isEmpty;

  /// Lógica de negocio: ¿Es para un formulario existente?
  bool get isForExistingForm => loadSavedForm && formId.isNotEmpty;

  /// Lógica de negocio: ¿Debe mostrar información de progreso?
  bool get shouldShowProgressInfo => showProgressInfo && isForExistingForm;

  /// Lógica de negocio: ¿Debe resetear para nuevo formulario?
  bool get shouldResetForNewForm => resetForNewForm && isForNewForm;

  /// Lógica de negocio: Validar si los datos de navegación son válidos
  bool isValid() {
    if (eventName.isEmpty) return false;
    if (loadSavedForm && formId.isEmpty) return false;
    if (!loadSavedForm && formId.isNotEmpty) return false;
    return true;
  }

  @override
  List<Object?> get props => [
        eventName,
        formId,
        loadSavedForm,
        showProgressInfo,
        resetForNewForm,
        progressData,
      ];

  @override
  String toString() {
    return 'FormNavigationData(eventName: $eventName, formId: $formId, '
           'loadSavedForm: $loadSavedForm, showProgressInfo: $showProgressInfo, '
           'resetForNewForm: $resetForNewForm, progressData: $progressData)';
  }
}
