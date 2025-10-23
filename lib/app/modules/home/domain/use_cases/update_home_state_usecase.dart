import '../entities/home_entity.dart';
import '../repositories/home_repository_interface.dart';

/// Caso de uso para actualizar el estado del home
/// Encapsula la lógica de negocio para actualizar el estado
class UpdateHomeStateUseCase {
  final HomeRepositoryInterface _repository;

  const UpdateHomeStateUseCase(this._repository);

  /// Ejecutar el caso de uso
  Future<void> execute(HomeEntity newState) async {
    try {
      // Validar el nuevo estado antes de guardarlo
      if (!_isValidHomeState(newState)) {
        throw Exception('Estado del home inválido');
      }
      
      // Actualizar el estado en el repositorio
      await _repository.updateHomeState(newState);
    } catch (e) {
      // Re-lanzar el error para que la capa de presentación lo maneje
      rethrow;
    }
  }

  /// Lógica de negocio: Validar si el estado del home es válido
  bool _isValidHomeState(HomeEntity homeState) {
    // Validar que el índice seleccionado esté en rango válido
    if (homeState.selectedIndex < 0 || homeState.selectedIndex > 4) {
      return false;
    }
    
    // Validar que el evento seleccionado no esté vacío SOLO si estamos mostrando categorías
    if (homeState.showRiskCategories && (homeState.selectedRiskEvent?.isEmpty ?? true)) {
      return false;
    }
    
    // Validar que no haya conflictos en las secciones mostradas
    if (homeState.showRiskEvents && homeState.showRiskCategories) {
      return false;
    }
    
    if (homeState.showRiskCategories && homeState.showFormCompleted) {
      return false;
    }
    
    if (homeState.showRiskEvents && homeState.showFormCompleted) {
      return false;
    }
    
    // Validar que el formulario activo sea consistente
    // Si estamos creando nuevo, puede tener o no activeFormId
    // Si no estamos creando nuevo, debe tener activeFormId
    if (!homeState.isCreatingNew && homeState.activeFormId == null) {
      return false;
    }
    
    return true;
  }
}
