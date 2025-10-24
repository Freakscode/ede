import 'command_result.dart';
import '../models/domain/rating_data.dart';
import '../interfaces/rating_validator_interface.dart';

/// Comando abstracto para calificaciones
abstract class RatingCommand {
  Future<CommandResult> execute();
}

/// Comando para validar calificación
class ValidateRatingCommand extends RatingCommand {
  final RatingData rating;
  final RatingValidatorInterface validator;
  
  ValidateRatingCommand({
    required this.rating,
    required this.validator,
  });

  @override
  Future<CommandResult> execute() async {
    try {
      // Validar calificación
      final isValid = validator.validateRating(rating);
      
      if (!isValid) {
        return CommandResult.failure(
          message: 'Calificación inválida: ${rating.category} - ${rating.level}',
        );
      }

      return CommandResult.success(
        message: 'Calificación válida',
        data: rating,
      );
    } catch (e) {
      return CommandResult.failure(
        message: 'Error al validar calificación: $e',
        error: e is Exception ? e : Exception(e.toString()),
      );
    }
  }
}

/// Comando para validar conjunto de calificaciones
class ValidateRatingsCommand extends RatingCommand {
  final List<RatingData> ratings;
  final RatingValidatorInterface validator;
  
  ValidateRatingsCommand({
    required this.ratings,
    required this.validator,
  });

  @override
  Future<CommandResult> execute() async {
    try {
      // Validar todas las calificaciones
      final isValid = validator.validateRatings(ratings);
      
      if (!isValid) {
        final invalidRatings = ratings.where((rating) => !validator.validateRating(rating)).toList();
        return CommandResult.failure(
          message: '${invalidRatings.length} calificaciones inválidas encontradas',
        );
      }

      return CommandResult.success(
        message: 'Todas las calificaciones son válidas',
        data: ratings,
      );
    } catch (e) {
      return CommandResult.failure(
        message: 'Error al validar calificaciones: $e',
        error: e is Exception ? e : Exception(e.toString()),
      );
    }
  }
}

/// Comando para verificar calificaciones faltantes
class CheckMissingRatingsCommand extends RatingCommand {
  final List<RatingData> ratings;
  final List<String> requiredCategories;
  final RatingValidatorInterface validator;
  
  CheckMissingRatingsCommand({
    required this.ratings,
    required this.requiredCategories,
    required this.validator,
  });

  @override
  Future<CommandResult> execute() async {
    try {
      // Verificar calificaciones faltantes
      final hasMissing = validator.hasMissingRatings(ratings, requiredCategories);
      
      if (hasMissing) {
        final missing = validator.getMissingRatings(ratings, requiredCategories);
        return CommandResult.failure(
          message: 'Calificaciones faltantes: ${missing.join(", ")}',
        );
      }

      return CommandResult.success(
        message: 'Todas las calificaciones requeridas están presentes',
        data: ratings,
      );
    } catch (e) {
      return CommandResult.failure(
        message: 'Error al verificar calificaciones faltantes: $e',
        error: e is Exception ? e : Exception(e.toString()),
      );
    }
  }
}
