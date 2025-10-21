import '../entities/tutorial_entity.dart';
import '../repositories/home_repository_interface.dart';

/// Caso de uso para gestionar tutoriales
/// Encapsula la lógica de negocio para operaciones con tutoriales
class ManageTutorialUseCase {
  final HomeRepositoryInterface _repository;

  const ManageTutorialUseCase(this._repository);

  /// Obtener configuración del tutorial
  Future<TutorialEntity> getTutorialConfig() async {
    try {
      return await _repository.getTutorialConfig();
    } catch (e) {
      // En caso de error, devolver configuración inicial
      return TutorialEntity.initial();
    }
  }

  /// Actualizar configuración del tutorial
  Future<void> updateTutorialConfig(TutorialEntity tutorial) async {
    try {
      // Validar la configuración del tutorial
      if (!tutorial.isValid()) {
        throw Exception('Configuración del tutorial inválida');
      }
      
      await _repository.updateTutorialConfig(tutorial);
    } catch (e) {
      rethrow;
    }
  }

  /// Mostrar tutorial
  Future<TutorialEntity> showTutorial() async {
    try {
      final currentConfig = await getTutorialConfig();
      
      // Verificar si el tutorial puede ser mostrado
      if (!currentConfig.canBeShownAgain) {
        return currentConfig;
      }
      
      // Marcar como mostrado
      final updatedConfig = currentConfig.markAsShown();
      
      // Guardar la configuración actualizada
      await updateTutorialConfig(updatedConfig);
      
      return updatedConfig;
    } catch (e) {
      rethrow;
    }
  }

  /// Habilitar tutorial
  Future<TutorialEntity> enableTutorial() async {
    try {
      final currentConfig = await getTutorialConfig();
      final updatedConfig = currentConfig.enable();
      
      await updateTutorialConfig(updatedConfig);
      
      return updatedConfig;
    } catch (e) {
      rethrow;
    }
  }

  /// Deshabilitar tutorial
  Future<TutorialEntity> disableTutorial() async {
    try {
      final currentConfig = await getTutorialConfig();
      final updatedConfig = currentConfig.disable();
      
      await updateTutorialConfig(updatedConfig);
      
      return updatedConfig;
    } catch (e) {
      rethrow;
    }
  }

  /// Resetear tutorial
  Future<TutorialEntity> resetTutorial() async {
    try {
      final currentConfig = await getTutorialConfig();
      final resetConfig = currentConfig.reset();
      
      await updateTutorialConfig(resetConfig);
      
      return resetConfig;
    } catch (e) {
      rethrow;
    }
  }

  /// Limpiar configuración del tutorial
  Future<void> clearTutorialConfig() async {
    try {
      await _repository.clearTutorialConfig();
    } catch (e) {
      rethrow;
    }
  }

  /// Verificar si el tutorial debe ser mostrado
  Future<bool> shouldShowTutorial() async {
    try {
      final config = await getTutorialConfig();
      return config.shouldShow;
    } catch (e) {
      return false;
    }
  }

  /// Verificar si el tutorial ha sido mostrado
  Future<bool> hasTutorialBeenShown() async {
    try {
      final config = await getTutorialConfig();
      return config.hasBeenShown;
    } catch (e) {
      return false;
    }
  }

  /// Obtener información del tutorial
  Future<Map<String, dynamic>> getTutorialInfo() async {
    try {
      final config = await getTutorialConfig();
      
      return {
        'shouldShow': config.shouldShow,
        'hasBeenShown': config.hasBeenShown,
        'isEnabled': config.isEnabled,
        'showCount': config.showCount,
        'lastShown': config.lastShown?.toIso8601String(),
        'statusDescription': config.statusDescription,
        'canBeShownAgain': config.canBeShownAgain,
        'isFirstTime': config.isFirstTime,
        'wasShownRecently': config.wasShownRecently,
      };
    } catch (e) {
      return {
        'shouldShow': false,
        'hasBeenShown': false,
        'isEnabled': false,
        'showCount': 0,
        'lastShown': null,
        'statusDescription': 'Error',
        'canBeShownAgain': false,
        'isFirstTime': false,
        'wasShownRecently': false,
      };
    }
  }
}
