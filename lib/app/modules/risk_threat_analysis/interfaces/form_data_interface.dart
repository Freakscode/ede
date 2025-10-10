import '../models/domain/form_data.dart';

/// Interface para manejo de datos de formularios
/// Sigue el principio de inversión de dependencias (DIP)
abstract class FormDataInterface {
  /// Guardar datos del formulario
  Future<void> saveFormData(FormData formData);
  
  /// Cargar datos del formulario
  Future<FormData?> loadFormData(String eventName, String classificationType);
  
  /// Validar datos del formulario
  bool validateFormData(FormData formData);
  
  /// Limpiar datos del formulario
  Future<void> clearFormData(String eventName, String classificationType);
  
  /// Obtener todos los formularios guardados
  Future<List<FormData>> getAllFormData();
  
  /// Verificar si existe un formulario
  Future<bool> formDataExists(String eventName, String classificationType);
}
