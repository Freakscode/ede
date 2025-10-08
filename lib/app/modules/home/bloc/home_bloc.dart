import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:caja_herramientas/app/core/icons/app_icons.dart';
import 'package:caja_herramientas/app/shared/models/risk_event_factory.dart';
import 'package:caja_herramientas/app/shared/models/risk_event_model.dart';
import 'package:caja_herramientas/app/shared/models/form_data_model.dart';
import 'package:caja_herramientas/app/shared/services/form_persistence_service.dart';
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
    on<HomeCheckAndShowTutorial>((event, emit) async {
      final showTutorial = await TutorialOverlayService.getShowTutorial();
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

    // ======= NUEVOS HANDLERS PARA GESTIÓN DE FORMULARIOS =======
    
    on<LoadForms>(_onLoadForms);
    on<SaveForm>(_onSaveForm);
    on<DeleteForm>(_onDeleteForm);
    on<LoadFormForEditing>(_onLoadFormForEditing);
    on<CompleteForm>(_onCompleteForm);
    on<SetActiveFormId>(_onSetActiveFormId);
  }

  // ======= HANDLERS PARA GESTIÓN DE FORMULARIOS =======
  
  Future<void> _onLoadForms(LoadForms event, Emitter<HomeState> emit) async {
    emit(state.copyWith(isLoadingForms: true));
    
    try {
      final formService = FormPersistenceService();
      final forms = await formService.getAllForms();
      
      emit(state.copyWith(
        savedForms: forms,
        isLoadingForms: false,
      ));
    } catch (e) {
      emit(state.copyWith(isLoadingForms: false));
    }
  }

  Future<void> _onSaveForm(SaveForm event, Emitter<HomeState> emit) async {
    try {
      final formService = FormPersistenceService();
      
      // Buscar formulario existente o crear uno nuevo
      FormDataModel? existingForm;
      final activeFormId = await formService.getActiveFormId();
      
      if (activeFormId != null) {
        existingForm = await formService.getFormById(activeFormId);
      }

      // Calcular progreso
      final progress = formService.calculateProgress(event.formData);
      final threatProgress = formService.calculateThreatProgress(event.formData);
      final vulnerabilityProgress = formService.calculateVulnerabilityProgress(event.formData);
      

      FormDataModel formToSave;
      if (existingForm != null) {
        // Actualizar formulario existente
        formToSave = existingForm.copyWith(
          riskAnalysisData: event.formData,
          progressPercentage: progress,
          threatProgress: threatProgress,
          vulnerabilityProgress: vulnerabilityProgress,
          lastModified: DateTime.now(),
        );
      } else {
        // Crear nuevo formulario
        final formId = formService.generateFormId();
        formToSave = FormDataModel(
          id: formId,
          title: 'Análisis de Riesgo - ${event.eventName}',
          eventType: event.eventName,
          formType: FormType.riskAnalysis,
          status: FormStatus.inProgress,
          createdAt: DateTime.now(),
          lastModified: DateTime.now(),
          progressPercentage: progress,
          threatProgress: threatProgress,
          vulnerabilityProgress: vulnerabilityProgress,
          riskAnalysisData: event.formData,
        );
        
        // Establecer como formulario activo
        await formService.setActiveForm(formId);
      }

      // Guardar formulario
      await formService.saveForm(formToSave);
      
      // Recargar formularios
      add(LoadForms());
      
    } catch (e) {
    }
  }

  Future<void> _onDeleteForm(DeleteForm event, Emitter<HomeState> emit) async {
    try {
      final formService = FormPersistenceService();
      await formService.deleteForm(event.formId);
      
      // Recargar formularios
      add(LoadForms());
      
    } catch (e) {
    }
  }

  Future<void> _onLoadFormForEditing(LoadFormForEditing event, Emitter<HomeState> emit) async {
    try {
      final formService = FormPersistenceService();
      await formService.setActiveForm(event.formId);
      
      emit(state.copyWith(activeFormId: event.formId));
      
    } catch (e) {
    }
  }

  Future<void> _onCompleteForm(CompleteForm event, Emitter<HomeState> emit) async {
    try {
      final formService = FormPersistenceService();
      await formService.markFormAsCompleted(event.formId);
      await formService.clearActiveForm();
      
      // Recargar formularios
      add(LoadForms());
      
    } catch (e) {
    }
  }

  void _onSetActiveFormId(SetActiveFormId event, Emitter<HomeState> emit) {
    emit(state.copyWith(activeFormId: event.formId));
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
