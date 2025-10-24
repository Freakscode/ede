import '../models/domain/rating_data.dart';

/// Interface para validación de calificaciones
/// Sigue el principio de inversión de dependencias (DIP)
abstract class RatingValidatorInterface {
  /// Validar calificación individual
  bool validateRating(RatingData rating);
  
  /// Validar conjunto de calificaciones
  bool validateRatings(List<RatingData> ratings);
  
  /// Verificar si hay calificaciones faltantes
  bool hasMissingRatings(List<RatingData> ratings, List<String> requiredCategories);
  
  /// Obtener calificaciones faltantes
  List<String> getMissingRatings(List<RatingData> ratings, List<String> requiredCategories);
  
  /// Validar calificación de probabilidad
  bool validateProbabilidadRating(RatingData rating);
  
  /// Validar calificación de intensidad
  bool validateIntensidadRating(RatingData rating);
  
  /// Validar calificación dinámica
  bool validateDynamicRating(RatingData rating, String subClassificationId);
}
