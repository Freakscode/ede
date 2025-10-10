
import 'package:caja_herramientas/app/modules/home/models/domain/form_command_data.dart';
import 'package:caja_herramientas/app/modules/home/models/domain/form_progress_data.dart';

/// Interfaz para persistencia de formularios
/// Sigue el principio de inversión de dependencias (DIP)
abstract class FormPersistenceInterface {
  /// Guardar un formulario
  Future<void> saveForm(FormCommandData command);

  /// Cargar un formulario por ID
  Future<Map<String, dynamic>?> loadForm(String formId);

  /// Eliminar un formulario
  Future<void> deleteForm(String formId);

  /// Obtener progreso de un formulario
  Future<FormProgressData?> getFormProgress(String formId);

  /// Actualizar progreso de un formulario
  Future<void> updateFormProgress(FormProgressData progress);

  /// Obtener todos los formularios
  Future<List<Map<String, dynamic>>> getAllForms();

  /// Obtener formularios por estado
  Future<List<Map<String, dynamic>>> getFormsByStatus(String status);

  /// Verificar si existe un formulario
  Future<bool> formExists(String formId);

  /// Establecer formulario activo
  Future<void> setActiveFormId(String formId);

  /// Obtener formulario activo
  Future<String?> getActiveFormId();

  /// Limpiar formulario activo
  Future<void> clearActiveFormId();
}
