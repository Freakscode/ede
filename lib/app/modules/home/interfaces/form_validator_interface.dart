
import 'package:caja_herramientas/app/modules/home/models/domain/form_command_data.dart';
import 'package:caja_herramientas/app/modules/home/models/domain/form_progress_data.dart';

/// Interfaz para validación de formularios
/// Sigue el principio de inversión de dependencias (DIP)
abstract class FormValidatorInterface {
  /// Validar datos de comando
  ValidationResult validateCommand(FormCommandData command);

  /// Validar datos de progreso
  ValidationResult validateProgress(FormProgressData progress);

  /// Validar si se puede finalizar un formulario
  ValidationResult canFinalizeForm(FormProgressData progress);

  /// Validar si se puede eliminar un formulario
  ValidationResult canDeleteForm(String formId, FormProgressData progress);

  /// Validar datos de navegación
  ValidationResult validateNavigation(String eventName, String formId);
}

/// Resultado de validación
class ValidationResult {
  final bool isValid;
  final String? errorMessage;
  final List<String> warnings;

  const ValidationResult({
    required this.isValid,
    this.errorMessage,
    this.warnings = const [],
  });

  /// Factory method: Validación exitosa
  factory ValidationResult.success() {
    return const ValidationResult(isValid: true);
  }

  /// Factory method: Validación con advertencias
  factory ValidationResult.successWithWarnings(List<String> warnings) {
    return ValidationResult(
      isValid: true,
      warnings: warnings,
    );
  }

  /// Factory method: Validación fallida
  factory ValidationResult.failure(String errorMessage) {
    return ValidationResult(
      isValid: false,
      errorMessage: errorMessage,
    );
  }

  /// Factory method: Validación fallida con advertencias
  factory ValidationResult.failureWithWarnings(
    String errorMessage,
    List<String> warnings,
  ) {
    return ValidationResult(
      isValid: false,
      errorMessage: errorMessage,
      warnings: warnings,
    );
  }

  /// Lógica de negocio: ¿Tiene advertencias?
  bool get hasWarnings => warnings.isNotEmpty;

  /// Lógica de negocio: ¿Tiene errores?
  bool get hasErrors => !isValid;

  @override
  String toString() {
    if (isValid) {
      return 'ValidationResult(success${hasWarnings ? ', warnings: $warnings' : ''})';
    } else {
      return 'ValidationResult(failure: $errorMessage${hasWarnings ? ', warnings: $warnings' : ''})';
    }
  }
}
