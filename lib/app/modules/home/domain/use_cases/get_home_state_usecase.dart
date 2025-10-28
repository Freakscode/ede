import '../entities/home_entity.dart';
import '../repositories/home_repository_interface.dart';

/// Caso de uso para obtener el estado del home
/// Encapsula la lógica de negocio para recuperar el estado actual
class GetHomeStateUseCase {
  final HomeRepositoryInterface _repository;

  const GetHomeStateUseCase(this._repository);

  /// Ejecutar el caso de uso
  Future<HomeEntity> execute() async {
    try {
      // Obtener el estado del repositorio
      final homeState = await _repository.getHomeState();
      
      // Validar que el estado es válido
      if (!_isValidHomeState(homeState)) {
        // Si no es válido, devolver estado inicial
        return HomeEntity.initial();
      }
      
      return homeState;
    } catch (e) {
      // En caso de error, devolver estado inicial
      return HomeEntity.initial();
    }
  }

  /// Lógica de negocio: Validar si el estado del home es válido
  bool _isValidHomeState(HomeEntity homeState) {
    // Validar que el índice seleccionado esté en rango válido
    if (homeState.selectedIndex < 0 || homeState.selectedIndex > 4) {
      return false;
    }
    
    // Validar que el evento seleccionado no esté vacío
    if (homeState.selectedRiskEvent?.isEmpty ?? true) {
      return false;
    }
    
    // Validar que no haya conflictos en las secciones mostradas
    if (homeState.showRiskEvents && homeState.showFormCompleted) {
      return false;
    }
    
    return true;
  }
}
