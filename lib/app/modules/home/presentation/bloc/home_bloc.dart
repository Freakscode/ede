import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/entities/home_entity.dart';
import '../../domain/entities/form_entity.dart';
import '../../domain/use_cases/get_home_state_usecase.dart';
import '../../domain/use_cases/update_home_state_usecase.dart';
import '../../domain/use_cases/manage_forms_usecase.dart';
import '../../domain/use_cases/manage_tutorial_usecase.dart';
import 'home_event.dart';
import 'home_state.dart';

/// BLoC refactorizado para el módulo Home
/// Solo maneja el estado de la UI, delegando la lógica de negocio a los casos de uso
class HomeBloc extends Bloc<HomeEvent, HomeState> {
  final GetHomeStateUseCase _getHomeStateUseCase;
  final UpdateHomeStateUseCase _updateHomeStateUseCase;
  final ManageFormsUseCase _manageFormsUseCase;
  final ManageTutorialUseCase _manageTutorialUseCase;

  HomeBloc({
    required GetHomeStateUseCase getHomeStateUseCase,
    required UpdateHomeStateUseCase updateHomeStateUseCase,
    required ManageFormsUseCase manageFormsUseCase,
    required ManageTutorialUseCase manageTutorialUseCase,
  }) : _getHomeStateUseCase = getHomeStateUseCase,
       _updateHomeStateUseCase = updateHomeStateUseCase,
       _manageFormsUseCase = manageFormsUseCase,
       _manageTutorialUseCase = manageTutorialUseCase,
       super(HomeState.initial()) {
    
    // Registrar todos los event handlers
    on<HomeInitialized>(_onHomeInitialized);
    on<HomeNavBarTapped>(_onNavBarTapped);
    on<HomeShowRiskEventsSection>(_onShowRiskEventsSection);
    on<SelectRiskEvent>(_onSelectRiskEvent);
    on<SelectRiskCategory>(_onSelectRiskCategory);
    on<HomeResetRiskSections>(_onResetRiskSections);
    on<HomeShowFormCompletedScreen>(_onShowFormCompletedScreen);
    on<HomeToggleNotifications>(_onToggleNotifications);
    on<HomeToggleDarkMode>(_onToggleDarkMode);
    on<HomeChangeLanguage>(_onChangeLanguage);
    on<HomeClearData>(_onClearData);
    on<LoadForms>(_onLoadForms);
    on<DeleteForm>(_onDeleteForm);
    on<LoadFormForEditing>(_onLoadFormForEditing);
    on<CompleteForm>(_onCompleteForm);
    on<SetActiveFormId>(_onSetActiveFormId);
    on<SetFormProgress>(_onSetFormProgress);
    on<SaveRiskEventModel>(_onSaveRiskEventModel);
    on<ResetAllForNewForm>(_onResetAllForNewForm);
    on<MarkEvaluationCompleted>(_onMarkEvaluationCompleted);
    on<ResetEvaluationsForEvent>(_onResetEvaluationsForEvent);
    on<HomeCheckAndShowTutorial>(_onCheckAndShowTutorial);
    on<HomeSetShowTutorial>(_onSetShowTutorial);
  }

  // ========== EVENT HANDLERS ==========

  Future<void> _onHomeInitialized(HomeInitialized event, Emitter<HomeState> emit) async {
    try {
      emit(state.copyWith(isLoading: true));
      
      // Obtener estado inicial usando el caso de uso
      final homeEntity = await _getHomeStateUseCase.execute();
      
      // Convertir entidad a estado de UI
      emit(HomeState.fromEntity(homeEntity));
    } catch (e) {
      emit(state.copyWith(
        error: 'Error al inicializar: $e',
        isLoading: false,
      ));
    }
  }

  Future<void> _onNavBarTapped(HomeNavBarTapped event, Emitter<HomeState> emit) async {
    try {
      final currentEntity = state.toEntity();
      final updatedEntity = currentEntity.copyWith(
        selectedIndex: event.index,
        showRiskEvents: false,
        showFormCompleted: false,
      );
      
      await _updateHomeStateUseCase.execute(updatedEntity);
      emit(HomeState.fromEntity(updatedEntity));
    } catch (e) {
      emit(state.copyWith(error: 'Error al cambiar navegación: $e'));
    }
  }

  Future<void> _onShowRiskEventsSection(HomeShowRiskEventsSection event, Emitter<HomeState> emit) async {
    try {
      final currentEntity = state.toEntity();
      final updatedEntity = currentEntity.copyWith(
        showRiskEvents: true,
        showFormCompleted: false,
      );
      
      await _updateHomeStateUseCase.execute(updatedEntity);
      emit(HomeState.fromEntity(updatedEntity));
    } catch (e) {
      emit(state.copyWith(error: 'Error al mostrar eventos de riesgo: $e'));
    }
  }

  Future<void> _onSelectRiskEvent(SelectRiskEvent event, Emitter<HomeState> emit) async {
    try {
      print('=== HomeBloc: SelectRiskEvent recibido ===');
      print('Evento seleccionado: ${event.eventName}');
      
      // Crear un nuevo formulario con ID único
      final formId = '${event.eventName}_${DateTime.now().millisecondsSinceEpoch}';
      print('Nuevo formId creado: $formId');
      
      final currentEntity = state.toEntity();
      final updatedEntity = currentEntity.copyWith(
        selectedRiskEvent: event.eventName,
        showRiskEvents: false,
        selectedRiskCategory: null,
        activeFormId: formId,
        isCreatingNew: true,
        savedForms: const [],
        isLoadingForms: false,
      );
      
      print('Estado nuevo - activeFormId: ${updatedEntity.activeFormId}');
      
      await _updateHomeStateUseCase.execute(updatedEntity);
      emit(HomeState.fromEntity(updatedEntity));
      
      print('=== HomeBloc: SelectRiskEvent completado ===');
    } catch (e) {
      print('=== HomeBloc: Error en SelectRiskEvent ===');
      print('Error: $e');
      emit(state.copyWith(error: 'Error al seleccionar evento de riesgo: $e'));
    }
  }

  Future<void> _onSelectRiskCategory(SelectRiskCategory event, Emitter<HomeState> emit) async {
    try {
      final currentEntity = state.toEntity();
      final updatedEntity = currentEntity.copyWith(
        selectedRiskCategory: '${event.categoryType} ${event.eventName}',
      );
      
      await _updateHomeStateUseCase.execute(updatedEntity);
      emit(HomeState.fromEntity(updatedEntity));
    } catch (e) {
      emit(state.copyWith(error: 'Error al seleccionar categoría de riesgo: $e'));
    }
  }

  Future<void> _onResetRiskSections(HomeResetRiskSections event, Emitter<HomeState> emit) async {
    try {
      print('=== HomeBloc: ResetRiskSections ejecutado ===');
      print('Estado anterior - selectedRiskEvent: ${state.selectedRiskEvent}');
      print('Estado anterior - activeFormId: ${state.activeFormId}');
      
      final currentEntity = state.toEntity();
      final updatedEntity = currentEntity.copyWith(
        showRiskEvents: false,
        showFormCompleted: false,
        // Resetear también el estado interno para permitir crear nuevo formulario
        selectedRiskEvent: null,
        selectedRiskCategory: null,
        activeFormId: null,
        isCreatingNew: true,
        completedEvaluations: const {},
        savedRiskEventModels: const {},
      );
      
      print('Estado nuevo - selectedRiskEvent: ${updatedEntity.selectedRiskEvent}');
      print('Estado nuevo - activeFormId: ${updatedEntity.activeFormId}');
      
      await _updateHomeStateUseCase.execute(updatedEntity);
      emit(HomeState.fromEntity(updatedEntity));
      
      print('=== HomeBloc: ResetRiskSections completado ===');
    } catch (e) {
      print('=== HomeBloc: Error en ResetRiskSections ===');
      print('Error: $e');
      emit(state.copyWith(error: 'Error al resetear secciones de riesgo: $e'));
    }
  }

  Future<void> _onShowFormCompletedScreen(HomeShowFormCompletedScreen event, Emitter<HomeState> emit) async {
    try {
      final currentEntity = state.toEntity();
      final updatedEntity = currentEntity.copyWith(
        showFormCompleted: true,
        showRiskEvents: false,
      );
      
      await _updateHomeStateUseCase.execute(updatedEntity);
      emit(HomeState.fromEntity(updatedEntity));
    } catch (e) {
      emit(state.copyWith(error: 'Error al mostrar formulario completado: $e'));
    }
  }

  Future<void> _onToggleNotifications(HomeToggleNotifications event, Emitter<HomeState> emit) async {
    try {
      final currentEntity = state.toEntity();
      final updatedEntity = currentEntity.copyWith(
        notificationsEnabled: event.enabled,
      );
      
      await _updateHomeStateUseCase.execute(updatedEntity);
      emit(HomeState.fromEntity(updatedEntity));
    } catch (e) {
      emit(state.copyWith(error: 'Error al cambiar notificaciones: $e'));
    }
  }

  Future<void> _onToggleDarkMode(HomeToggleDarkMode event, Emitter<HomeState> emit) async {
    try {
      final currentEntity = state.toEntity();
      final updatedEntity = currentEntity.copyWith(
        darkModeEnabled: event.enabled,
      );
      
      await _updateHomeStateUseCase.execute(updatedEntity);
      emit(HomeState.fromEntity(updatedEntity));
    } catch (e) {
      emit(state.copyWith(error: 'Error al cambiar modo oscuro: $e'));
    }
  }

  Future<void> _onChangeLanguage(HomeChangeLanguage event, Emitter<HomeState> emit) async {
    try {
      final currentEntity = state.toEntity();
      final updatedEntity = currentEntity.copyWith(
        selectedLanguage: event.language,
      );
      
      await _updateHomeStateUseCase.execute(updatedEntity);
      emit(HomeState.fromEntity(updatedEntity));
    } catch (e) {
      emit(state.copyWith(error: 'Error al cambiar idioma: $e'));
    }
  }

  Future<void> _onClearData(HomeClearData event, Emitter<HomeState> emit) async {
    try {
      // Limpiar datos usando el caso de uso
      await _manageTutorialUseCase.clearTutorialConfig();
      
      final currentEntity = state.toEntity();
      final updatedEntity = currentEntity.copyWith(
        showTutorial: true,
      );
      
      await _updateHomeStateUseCase.execute(updatedEntity);
      emit(HomeState.fromEntity(updatedEntity));
    } catch (e) {
      emit(state.copyWith(error: 'Error al limpiar datos: $e'));
    }
  }

  Future<void> _onLoadForms(LoadForms event, Emitter<HomeState> emit) async {
    try {
      emit(state.copyWith(isLoadingForms: true));
      
      // Cargar formularios usando el caso de uso
      final forms = await _manageFormsUseCase.getAllForms();
      
      final currentEntity = state.toEntity();
      final updatedEntity = currentEntity.copyWith(
        savedForms: forms,
        isLoadingForms: false,
      );
      
      await _updateHomeStateUseCase.execute(updatedEntity);
      emit(HomeState.fromEntity(updatedEntity));
    } catch (e) {
      emit(state.copyWith(
        error: 'Error al cargar formularios: $e',
        isLoadingForms: false,
      ));
    }
  }

  Future<void> _onDeleteForm(DeleteForm event, Emitter<HomeState> emit) async {
    try {
      // Eliminar formulario usando el caso de uso
      await _manageFormsUseCase.deleteForm(event.formId);
      
      // Recargar formularios
      add(LoadForms());
    } catch (e) {
      emit(state.copyWith(error: 'Error al eliminar formulario: $e'));
    }
  }

  Future<void> _onLoadFormForEditing(LoadFormForEditing event, Emitter<HomeState> emit) async {
    try {
      // Cargar formulario para edición usando el caso de uso
      final form = await _manageFormsUseCase.getActiveForm();
      
      if (form != null) {
        final currentEntity = state.toEntity();
        final updatedEntity = currentEntity.copyWith(
          activeFormId: form.id,
          isCreatingNew: false,
        );
        
        await _updateHomeStateUseCase.execute(updatedEntity);
        emit(HomeState.fromEntity(updatedEntity));
      }
    } catch (e) {
      emit(state.copyWith(error: 'Error al cargar formulario para edición: $e'));
    }
  }

  Future<void> _onCompleteForm(CompleteForm event, Emitter<HomeState> emit) async {
    try {
      // Completar formulario usando el caso de uso
      await _manageFormsUseCase.completeForm(formId: event.formId);
      
      // Recargar formularios
      add(LoadForms());
    } catch (e) {
      emit(state.copyWith(error: 'Error al completar formulario: $e'));
    }
  }

  Future<void> _onSetActiveFormId(SetActiveFormId event, Emitter<HomeState> emit) async {
    try {
      final currentEntity = state.toEntity();
      final updatedEntity = currentEntity.copyWith(
        activeFormId: event.formId,
        isCreatingNew: event.isCreatingNew,
      );
      
      await _updateHomeStateUseCase.execute(updatedEntity);
      emit(HomeState.fromEntity(updatedEntity));
    } catch (e) {
      emit(state.copyWith(error: 'Error al establecer formulario activo: $e'));
    }
  }

  Future<void> _onSetFormProgress(SetFormProgress event, Emitter<HomeState> emit) async {
    try {
      final updatedProgressData = Map<String, Map<String, double>>.from(state.formProgressData);
      updatedProgressData[event.formId] = event.progressData;
      
      emit(state.copyWith(formProgressData: updatedProgressData));
    } catch (e) {
      emit(state.copyWith(error: 'Error al establecer progreso del formulario: $e'));
    }
  }

  Future<void> _onSaveRiskEventModel(SaveRiskEventModel event, Emitter<HomeState> emit) async {
    try {
      // Guardar modelo de evento de riesgo usando el caso de uso
      final currentEntity = state.toEntity();
      final key = '${event.eventName}_${event.classificationType}';
      final updatedSavedModels = Map<String, Map<String, dynamic>>.from(currentEntity.savedRiskEventModels);
      
      updatedSavedModels[key] = {
        'eventName': event.eventName,
        'classificationType': event.classificationType,
        'evaluationData': event.evaluationData,
        'savedAt': DateTime.now().toIso8601String(),
      };
      
      final updatedEntity = currentEntity.copyWith(
        savedRiskEventModels: updatedSavedModels,
      );
      
      await _updateHomeStateUseCase.execute(updatedEntity);
      emit(HomeState.fromEntity(updatedEntity));
    } catch (e) {
      emit(state.copyWith(error: 'Error al guardar modelo de evento de riesgo: $e'));
    }
  }

  Future<void> _onResetAllForNewForm(ResetAllForNewForm event, Emitter<HomeState> emit) async {
    try {
      // Limpiar formulario activo usando el caso de uso
      await _manageFormsUseCase.clearActiveForm();
      
      final currentEntity = state.toEntity();
      final updatedEntity = currentEntity.copyWith(
        selectedRiskEvent: null,
        selectedRiskCategory: null,
        activeFormId: null,
        isCreatingNew: true,
        completedEvaluations: const {},
        savedRiskEventModels: const {},
        savedForms: const [],
        isLoadingForms: false,
      );
      
      await _updateHomeStateUseCase.execute(updatedEntity);
      emit(HomeState.fromEntity(updatedEntity));
    } catch (e) {
      emit(state.copyWith(error: 'Error al resetear para nuevo formulario: $e'));
    }
  }

  Future<void> _onMarkEvaluationCompleted(MarkEvaluationCompleted event, Emitter<HomeState> emit) async {
    try {
      final currentEntity = state.toEntity();
      final key = '${event.eventName}_${event.classificationType}';
      final updatedCompletedEvaluations = Map<String, bool>.from(currentEntity.completedEvaluations);
      updatedCompletedEvaluations[key] = true;
      
      final updatedEntity = currentEntity.copyWith(
        completedEvaluations: updatedCompletedEvaluations,
      );
      
      await _updateHomeStateUseCase.execute(updatedEntity);
      emit(HomeState.fromEntity(updatedEntity));
    } catch (e) {
      emit(state.copyWith(error: 'Error al marcar evaluación como completada: $e'));
    }
  }

  Future<void> _onResetEvaluationsForEvent(ResetEvaluationsForEvent event, Emitter<HomeState> emit) async {
    try {
      final currentEntity = state.toEntity();
      final updatedCompletedEvaluations = Map<String, bool>.from(currentEntity.completedEvaluations);
      
      // Remover las claves relacionadas con este evento
      final keysToRemove = updatedCompletedEvaluations.keys
          .where((key) => key.startsWith('${event.eventName}_'))
          .toList();
      
      for (final key in keysToRemove) {
        updatedCompletedEvaluations.remove(key);
      }
      
      final updatedEntity = currentEntity.copyWith(
        completedEvaluations: updatedCompletedEvaluations,
        activeFormId: null,
      );
      
      await _updateHomeStateUseCase.execute(updatedEntity);
      emit(HomeState.fromEntity(updatedEntity));
    } catch (e) {
      emit(state.copyWith(error: 'Error al resetear evaluaciones: $e'));
    }
  }

  Future<void> _onCheckAndShowTutorial(HomeCheckAndShowTutorial event, Emitter<HomeState> emit) async {
    try {
      // Verificar configuración del tutorial usando el caso de uso
      final tutorialConfig = await _manageTutorialUseCase.getTutorialConfig();
      
      if (tutorialConfig.shouldShow && !tutorialConfig.hasBeenShown) {
        final updatedConfig = tutorialConfig.markAsShown();
        await _manageTutorialUseCase.updateTutorialConfig(updatedConfig);
        
        final currentEntity = state.toEntity();
        final updatedEntity = currentEntity.copyWith(
          tutorialShown: true,
          showTutorial: true,
        );
        
        await _updateHomeStateUseCase.execute(updatedEntity);
        emit(HomeState.fromEntity(updatedEntity));
      } else {
        final currentEntity = state.toEntity();
        final updatedEntity = currentEntity.copyWith(
          showTutorial: tutorialConfig.showTutorial,
        );
        
        await _updateHomeStateUseCase.execute(updatedEntity);
        emit(HomeState.fromEntity(updatedEntity));
      }
    } catch (e) {
      emit(state.copyWith(error: 'Error al verificar tutorial: $e'));
    }
  }

  Future<void> _onSetShowTutorial(HomeSetShowTutorial event, Emitter<HomeState> emit) async {
    try {
      // Actualizar configuración del tutorial usando el caso de uso
      final tutorialConfig = await _manageTutorialUseCase.getTutorialConfig();
      final updatedConfig = tutorialConfig.copyWith(showTutorial: event.value);
      await _manageTutorialUseCase.updateTutorialConfig(updatedConfig);
      
      final currentEntity = state.toEntity();
      final updatedEntity = currentEntity.copyWith(
        showTutorial: event.value,
      );
      
      await _updateHomeStateUseCase.execute(updatedEntity);
      emit(HomeState.fromEntity(updatedEntity));
    } catch (e) {
      emit(state.copyWith(error: 'Error al establecer tutorial: $e'));
    }
  }

  // ========== HELPER METHODS ==========

  /// Obtener el estado actual como entidad de dominio
  HomeEntity get currentEntity => state.toEntity();

  /// Verificar si una evaluación está completada
  bool isEvaluationCompleted(String eventName, String classificationType) {
    return currentEntity.isEvaluationCompleted(eventName, classificationType);
  }

  /// Obtener formularios en progreso
  List<FormEntity> get inProgressForms => currentEntity.inProgressForms;

  /// Obtener formularios completados
  List<FormEntity> get completedForms => currentEntity.completedForms;

  /// Obtener clasificaciones de evento (método temporal)
  List<String> getEventClassifications(String eventName) {
    // TODO: Implementar lógica real para obtener clasificaciones
    return ['Amenaza', 'Vulnerabilidad'];
  }

  /// Obtener icono para evento (método temporal)
  String getIconForEvent(String eventName) {
    // TODO: Implementar lógica real para obtener iconos
    // Por defecto usar Sismo.svg (que existe)
    return 'assets/icons/svg/Sismo.svg';
  }
}
