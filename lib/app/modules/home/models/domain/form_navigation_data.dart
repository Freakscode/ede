import 'package:equatable/equatable.dart';

/// Value Object para datos de navegación de formularios
/// Encapsula la lógica de negocio relacionada con la navegación
class FormNavigationData extends Equatable {
  final String eventName;
  final String formId;
  final bool loadSavedForm;
  final bool showProgressInfo;
  
  const FormNavigationData({
    required this.eventName,
    required this.formId,
    this.loadSavedForm = false,
    this.showProgressInfo = false,
  });

  @override
  List<Object?> get props => [eventName, formId, loadSavedForm, showProgressInfo];

  /// Lógica de negocio: ¿Es un formulario nuevo?
  bool get isNewForm => !loadSavedForm;

  /// Lógica de negocio: ¿Debe mostrar información de progreso?
  bool get shouldShowProgress => showProgressInfo && !isNewForm;

  /// Lógica de negocio: Validar si los datos son válidos
  bool isValid() {
    return eventName.isNotEmpty && formId.isNotEmpty;
  }

  /// Factory method: Crear navegación para formulario nuevo
  static FormNavigationData forNewForm(String eventName) {
    return FormNavigationData(
      eventName: eventName,
      formId: DateTime.now().millisecondsSinceEpoch.toString(),
      loadSavedForm: false,
      showProgressInfo: false,
    );
  }

  /// Factory method: Crear navegación para formulario existente
  static FormNavigationData forExistingForm({
    required String eventName,
    required String formId,
    bool showProgressInfo = true,
  }) {
    return FormNavigationData(
      eventName: eventName,
      formId: formId,
      loadSavedForm: true,
      showProgressInfo: showProgressInfo,
    );
  }

  /// Método de negocio: Crear copia con cambios
  FormNavigationData copyWith({
    String? eventName,
    String? formId,
    bool? loadSavedForm,
    bool? showProgressInfo,
  }) {
    return FormNavigationData(
      eventName: eventName ?? this.eventName,
      formId: formId ?? this.formId,
      loadSavedForm: loadSavedForm ?? this.loadSavedForm,
      showProgressInfo: showProgressInfo ?? this.showProgressInfo,
    );
  }

  @override
  String toString() {
    return 'FormNavigationData(eventName: $eventName, formId: $formId, '
           'loadSavedForm: $loadSavedForm, showProgressInfo: $showProgressInfo)';
  }
}
