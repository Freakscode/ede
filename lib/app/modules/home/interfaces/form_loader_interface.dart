import 'package:caja_herramientas/app/modules/home/models/domain/form_navigation_data.dart';
import 'package:caja_herramientas/app/modules/home/models/domain/form_progress_data.dart';


/// Interfaz para carga de formularios
/// Sigue el principio de inversión de dependencias (DIP)
abstract class FormLoaderInterface {
  /// Cargar formulario por ID
  Future<FormLoadResult> loadFormById(String formId);

  /// Cargar formulario por datos de navegación
  Future<FormLoadResult> loadFormByNavigation(FormNavigationData navigationData);

  /// Cargar progreso de formulario
  Future<FormProgressData?> loadFormProgress(String formId);

  /// Cargar todos los formularios del usuario
  Future<List<FormLoadResult>> loadAllUserForms();

  /// Cargar formularios por estado
  Future<List<FormLoadResult>> loadFormsByStatus(String status);

  /// Verificar si un formulario existe
  Future<bool> formExists(String formId);

  /// Cargar formulario activo
  Future<FormLoadResult?> loadActiveForm();
}

/// Resultado de carga de formulario
class FormLoadResult {
  final bool isSuccess;
  final Map<String, dynamic>? formData;
  final FormProgressData? progressData;
  final String? errorMessage;
  final DateTime timestamp;

  const FormLoadResult({
    required this.isSuccess,
    this.formData,
    this.progressData,
    this.errorMessage,
    required this.timestamp,
  });

  /// Factory method: Carga exitosa
  factory FormLoadResult.success({
    required Map<String, dynamic> formData,
    FormProgressData? progressData,
  }) {
    return FormLoadResult(
      isSuccess: true,
      formData: formData,
      progressData: progressData,
      timestamp: DateTime.now(),
    );
  }

  /// Factory method: Carga fallida
  factory FormLoadResult.failure(String errorMessage) {
    return FormLoadResult(
      isSuccess: false,
      errorMessage: errorMessage,
      timestamp: DateTime.now(),
    );
  }

  /// Lógica de negocio: ¿Tiene datos de formulario?
  bool get hasFormData => formData != null;

  /// Lógica de negocio: ¿Tiene datos de progreso?
  bool get hasProgressData => progressData != null;

  /// Lógica de negocio: ¿Tiene error?
  bool get hasError => !isSuccess;

  /// Lógica de negocio: ¿Es un formulario nuevo?
  bool get isNewForm => formData == null;

  /// Lógica de negocio: ¿Es un formulario existente?
  bool get isExistingForm => hasFormData;

  @override
  String toString() {
    if (isSuccess) {
      return 'FormLoadResult(success, hasFormData: $hasFormData, hasProgressData: $hasProgressData)';
    } else {
      return 'FormLoadResult(failure: $errorMessage)';
    }
  }
}
