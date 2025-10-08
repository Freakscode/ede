import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:caja_herramientas/app/core/icons/app_icons.dart';
import 'package:caja_herramientas/app/shared/models/risk_event_factory.dart';
import 'package:caja_herramientas/app/shared/models/risk_event_model.dart';
import '../../home/services/tutorial_overlay_service.dart';
import 'home_event.dart';
import 'home_state.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  HomeBloc()
    : super(
        const HomeState(
          selectedIndex: 0,
          mostrarEventosRiesgo: false,
          mostrarCategoriasRiesgo: false,
          tutorialShown: false,
        ),
      ) {
    on<HomeNavBarTapped>((event, emit) {
      emit(state.copyWith(
        selectedIndex: event.index,
        mostrarEventosRiesgo: false,
        mostrarCategoriasRiesgo: false,
      ));
    });
    on<HomeShowRiskEventsSection>((event, emit) {
      emit(state.copyWith(
        mostrarEventosRiesgo: true,
        mostrarCategoriasRiesgo: false,
      ));
    });
    on<HomeShowRiskCategoriesScreen>((event, emit) {
      emit(state.copyWith(
        mostrarEventosRiesgo: false,
        mostrarCategoriasRiesgo: true,
      ));
    });
    on<SelectRiskEvent>((event, emit) {
      emit(state.copyWith(
        selectedRiskEvent: event.eventName,
        mostrarEventosRiesgo: false,
        mostrarCategoriasRiesgo: true,
        activeFormId: null, // Limpiar activeFormId para nuevo formulario
      ));
    });
    on<SelectRiskCategory>((event, emit) {
      emit(state.copyWith(
        selectedRiskCategory: '${event.categoryType} ${event.eventName}',
      ));
    });
    on<HomeResetRiskSections>((event, emit) {
      emit(state.copyWith(
        mostrarEventosRiesgo: false,
        mostrarCategoriasRiesgo: false,
      ));
    });
    on<HomeCheckAndShowTutorial>((event, emit) {
      final showTutorial = TutorialOverlayService.getShowTutorial();
      if (showTutorial && !state.tutorialShown) {
        emit(state.copyWith(tutorialShown: true, showTutorial: showTutorial));
      } else {
        emit(state.copyWith(showTutorial: showTutorial));
      }
    });

    on<HomeSetShowTutorial>((event, emit) async {
      await TutorialOverlayService.setShowTutorial(event.value);
      emit(state.copyWith(showTutorial: event.value));
    });

    on<HomeToggleNotifications>((event, emit) {
      emit(state.copyWith(notificationsEnabled: event.enabled));
    });

    on<HomeToggleDarkMode>((event, emit) {
      emit(state.copyWith(darkModeEnabled: event.enabled));
    });

    on<HomeChangeLanguage>((event, emit) {
      emit(state.copyWith(selectedLanguage: event.language));
    });

    on<HomeClearData>((event, emit) async {
      // Limpiar datos de la aplicación
      await TutorialOverlayService.clearTutorialBox();
      emit(state.copyWith(showTutorial: true));
    });

    on<MarkEvaluationCompleted>((event, emit) {
      final key = '${event.eventName}_${event.classificationType}';
      final updatedCompletedEvaluations = Map<String, bool>.from(state.completedEvaluations);
      updatedCompletedEvaluations[key] = true;
      
      emit(state.copyWith(completedEvaluations: updatedCompletedEvaluations));
    });

    on<ResetEvaluationsForEvent>((event, emit) async {
      // Resetear las evaluaciones completadas para el evento específico
      final updatedCompletedEvaluations = Map<String, bool>.from(state.completedEvaluations);
      
      // Remover las claves relacionadas con este evento
      final keysToRemove = updatedCompletedEvaluations.keys
          .where((key) => key.startsWith('${event.eventName}_'))
          .toList();
      
      for (final key in keysToRemove) {
        updatedCompletedEvaluations.remove(key);
      }
      
      // Placeholder: No persistence service available
      print('📋 Formulario activo limpiado para nueva evaluación de ${event.eventName}');
      
      emit(state.copyWith(
        completedEvaluations: updatedCompletedEvaluations,
        activeFormId: null, // También limpiar el formulario activo del estado
      ));
    });

    // ======= NUEVOS HANDLERS PARA GESTIÓN DE FORMULARIOS =======
    
    on<LoadForms>(_onLoadForms);
    on<DeleteForm>(_onDeleteForm);
    on<LoadFormForEditing>(_onLoadFormForEditing);
    on<CompleteForm>(_onCompleteForm);
    on<SetActiveFormId>(_onSetActiveFormId);
  }

  // ======= HANDLERS PARA GESTIÓN DE FORMULARIOS =======
  
  Future<void> _onLoadForms(LoadForms event, Emitter<HomeState> emit) async {
    emit(state.copyWith(isLoadingForms: true));
    
    try {
            // Simulamos que carga la configuración global de formularios
      // TODO: Implementar nueva lógica sin persistencia
      print('LoadGlobalFormConfiguration: Cargando configuración sin persistencia');
      
      emit(state.copyWith(
        savedForms: [], // Lista vacía temporalmente
        isLoadingForms: false,
      ));
    } catch (e) {
      emit(state.copyWith(isLoadingForms: false));
    }
  }

  // Removido: _onSaveRiskAnalysisData ya no es necesario

  Future<void> _onDeleteForm(DeleteForm event, Emitter<HomeState> emit) async {
    // TODO: Implementar nueva lógica sin persistencia si es necesario
    print('DeleteForm recibido para ID: ${event.formId}');
  }

  Future<void> _onLoadFormForEditing(LoadFormForEditing event, Emitter<HomeState> emit) async {
    // TODO: Implementar nueva lógica sin persistencia si es necesario
    print('LoadFormForEditing recibido para ID: ${event.formId}');
  }

  Future<void> _onCompleteForm(CompleteForm event, Emitter<HomeState> emit) async {
    // TODO: Implementar nueva lógica sin persistencia si es necesario
    print('CompleteForm recibido para ID: ${event.formId}');
  }

  void _onSetActiveFormId(SetActiveFormId event, Emitter<HomeState> emit) {
    // TODO: Actualizar según nueva estructura del estado
    print('SetActiveFormId recibido para ID: ${event.formId}');
  }

  /// Mapea los nombres de eventos a sus iconos correspondientes
  String getIconForEvent(String eventName) {
    switch (eventName) {
      case 'Movimiento en Masa':
        return AppIcons.movimientoMasa;
      case 'Avenida Torrencial':
      case 'Avenidas torrenciales':
        return AppIcons.movimientoMasa; // Usar icono temporal
      case 'Inundación':
        return AppIcons.inundacionCH;
      case 'Estructural':
        return AppIcons.estructuralCH;
      case 'Incendio Forestal':
        return AppIcons.movimientoMasa; // Usar icono temporal
      case 'Otros':
        return AppIcons.inundacionCH; // Usar icono temporal
      default:
        return AppIcons.movimientoMasa; // Icono por defecto
    }
  }

  /// Obtiene el modelo completo de un evento de riesgo
  RiskEventModel? getRiskEventModel(String eventName) {
    return RiskEventFactory.getEventByName(eventName);
  }

  /// Obtiene las clasificaciones de un evento específico
  List<RiskClassification> getEventClassifications(String eventName) {
    final model = getRiskEventModel(eventName);
    return model?.classifications ?? [];
  }

  /// Obtiene todos los eventos disponibles
  List<RiskEventModel> getAllRiskEvents() {
    return RiskEventFactory.getAllEvents();
  }

  /// Verifica si una evaluación está completada
  bool isEvaluationCompleted(String eventName, String classificationType) {
    final key = '${eventName}_${classificationType}';
    return state.completedEvaluations[key] ?? false;
  }

  /// Obtiene el estado de completitud para amenaza
  bool isAmenazaCompleted(String eventName) {
    return isEvaluationCompleted(eventName, 'amenaza');
  }

  /// Obtiene el estado de completitud para vulnerabilidad
  bool isVulnerabilidadCompleted(String eventName) {
    return isEvaluationCompleted(eventName, 'vulnerabilidad');
  }
}
