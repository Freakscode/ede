import '../models/domain/form_data.dart';

/// Interface para cálculo de progreso
/// Sigue el principio de inversión de dependencias (DIP)
abstract class ProgressCalculatorInterface {
  /// Calcular progreso de amenaza
  double calculateAmenazaProgress(FormData formData);
  
  /// Calcular progreso de vulnerabilidad
  double calculateVulnerabilidadProgress(FormData formData);
  
  /// Calcular progreso total
  double calculateTotalProgress(FormData amenazaData, FormData vulnerabilidadData);
  
  /// Verificar si el formulario está completo
  bool isFormComplete(FormData formData);
  
  /// Obtener porcentaje de completado
  int getCompletionPercentage(FormData formData);
  
  /// Obtener categorías faltantes
  List<String> getMissingCategories(FormData formData);
  
  /// Verificar si una categoría específica está completa
  bool isCategoryComplete(FormData formData, String category);
}
