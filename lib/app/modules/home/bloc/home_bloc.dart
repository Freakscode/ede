import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:caja_herramientas/app/core/icons/app_icons.dart';
import 'package:caja_herramientas/app/shared/models/risk_event_factory.dart';
import 'package:caja_herramientas/app/shared/models/risk_event_model.dart';
import 'package:caja_herramientas/app/shared/services/form_persistence_service.dart';
import 'package:caja_herramientas/app/shared/models/complete_form_data_model.dart';
import 'package:caja_herramientas/app/shared/models/form_data_model.dart';
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
    on<HomeShowRiskCategoriesScreen>((event, emit) async {
      emit(state.copyWith(
        mostrarEventosRiesgo: false,
        mostrarCategoriasRiesgo: true,
      ));
      
      // Si viene con un evento específico, configurarlo
      if (event.eventName != null) {
        emit(state.copyWith(
          selectedRiskEvent: event.eventName,
          selectedRiskCategory: null, // Resetear la categoría seleccionada
        ));
        
        // Si viene con datos de formulario guardado, configurar el formulario activo
        if (event.loadSavedForm && event.formId != null) {
          emit(state.copyWith(
            activeFormId: event.formId,
            isCreatingNew: false, // Marcar como editar
          ));
          
          // Mostrar mensaje informativo si se especifica
          if (event.showProgressInfo) {
            print('HomeBloc: Cargando formulario guardado - ${event.formId}');
          }
        } else {
          // Si no viene con formulario guardado, limpiar el activeFormId (formulario nuevo)
          emit(state.copyWith(
            activeFormId: null,
            isCreatingNew: true, // Marcar como crear nuevo
          ));
          print('HomeBloc: Creando formulario nuevo - limpiando activeFormId');
        }
      }
    });
    on<SelectRiskEvent>((event, emit) async {
      emit(state.copyWith(
        selectedRiskEvent: event.eventName,
        mostrarEventosRiesgo: false,
        mostrarCategoriasRiesgo: true,
        selectedRiskCategory: null, // Resetear la categoría seleccionada
        activeFormId: null, // Limpiar formulario activo
        // NO resetear completedEvaluations para permitir progreso acumulativo
        savedForms: const [], // Limpiar formularios guardados
        isLoadingForms: false, // Resetear estado de carga
      ));
      
      // Crear formulario inicial para el evento seleccionado
      await _createInitialForm(event.eventName);
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
    on<SaveRiskEventModel>(_onSaveRiskEventModel);
    on<ResetAllForNewForm>(_onResetAllForNewForm);
  }

  // ======= HANDLERS PARA GESTIÓN DE FORMULARIOS =======
  
  Future<void> _onLoadForms(LoadForms event, Emitter<HomeState> emit) async {
    emit(state.copyWith(isLoadingForms: true));
    
    try {
      // Cargar formularios completos desde SQLite
      final persistenceService = FormPersistenceService();
      final completeForms = await persistenceService.getAllCompleteForms();
      
      // Convertir CompleteFormDataModel a FormDataModel para compatibilidad
      final convertedForms = completeForms.map((completeForm) {
        // Determinar el estado del formulario
        FormStatus status;
        if (completeForm.isComplete) {
          status = FormStatus.completed;
        } else if (completeForm.isAmenazaCompleted || completeForm.isVulnerabilidadCompleted) {
          status = FormStatus.inProgress;
        } else {
          status = FormStatus.inProgress;
        }
        
        // Obtener el RiskEventModel correspondiente al eventName
        final riskEvent = RiskEventFactory.getEventByName(completeForm.eventName);
        
        return FormDataModel(
          id: completeForm.id,
          title: '${completeForm.eventName} - Análisis Completo',
          status: status,
          createdAt: completeForm.createdAt,
          lastModified: completeForm.updatedAt,
          riskEvent: riskEvent, // Guardar el RiskEventModel real
        );
      }).toList();
      
      emit(state.copyWith(
        savedForms: convertedForms,
        isLoadingForms: false,
      ));
      
      print('HomeBloc: ${convertedForms.length} formularios completos cargados desde SQLite');
    } catch (e) {
      print('HomeBloc: Error al cargar formularios completos desde SQLite - $e');
      emit(state.copyWith(
        savedForms: [],
        isLoadingForms: false,
      ));
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
    emit(state.copyWith(
      activeFormId: event.formId,
      isCreatingNew: false, // Marcar como editar
    ));
    print('SetActiveFormId recibido para ID: ${event.formId} - marcando como editar');
  }

  /// Guarda un RiskEventModel completo cuando se completa una evaluación
  void _onSaveRiskEventModel(SaveRiskEventModel event, Emitter<HomeState> emit) {
    final key = '${event.eventName}_${event.classificationType}';
    final updatedSavedModels = Map<String, Map<String, dynamic>>.from(state.savedRiskEventModels);
    
    // Guardar los datos de evaluación
    final savedObject = {
      'eventName': event.eventName,
      'classificationType': event.classificationType,
      'evaluationData': event.evaluationData,
      'savedAt': DateTime.now().toIso8601String(),
    };
    
    updatedSavedModels[key] = savedObject;
    
    emit(state.copyWith(savedRiskEventModels: updatedSavedModels));
    
    // PRINT COMPLETO DEL OBJETO GUARDADO EN HOMEBLOC
    print('=== OBJETO GUARDADO EN HOMEBLOC ===');
    print('Key: $key');
    print('Objeto completo guardado:');
    print(savedObject.toString());
    print('=== FIN DEL OBJETO GUARDADO ===');
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

  /// Obtiene los datos guardados de un RiskEventModel para una evaluación específica
  Map<String, dynamic>? getSavedRiskEventModel(String eventName, String classificationType) {
    final key = '${eventName}_${classificationType}';
    return state.savedRiskEventModels[key];
  }

  /// Obtiene todos los datos guardados para un evento específico
  Map<String, Map<String, dynamic>> getSavedModelsForEvent(String eventName) {
    return Map.fromEntries(
      state.savedRiskEventModels.entries
          .where((entry) => entry.key.startsWith('${eventName}_'))
    );
  }

  /// Verifica si un evento tiene ambas evaluaciones guardadas (Amenaza y Vulnerabilidad)
  bool hasCompleteRiskEventModel(String eventName) {
    final amenazaSaved = getSavedRiskEventModel(eventName, 'amenaza') != null;
    final vulnerabilidadSaved = getSavedRiskEventModel(eventName, 'vulnerabilidad') != null;
    return amenazaSaved && vulnerabilidadSaved;
  }

  /// Crea un formulario inicial vacío cuando se selecciona un evento
  Future<void> _createInitialForm(String eventName) async {
    try {
      final persistenceService = FormPersistenceService();
      
      // Crear formulario completo inicial (evento + amenaza + vulnerabilidad)
      final now = DateTime.now();
      final formId = '${eventName}_complete_${now.millisecondsSinceEpoch}';
      final completeForm = CompleteFormDataModel(
        id: formId,
        eventName: eventName,
        // Datos iniciales de amenaza
        amenazaSelections: {},
        amenazaScores: {},
        amenazaColors: {},
        amenazaProbabilidadSelections: {},
        amenazaIntensidadSelections: {},
        amenazaSelectedProbabilidad: null,
        amenazaSelectedIntensidad: null,
        // Datos iniciales de vulnerabilidad
        vulnerabilidadSelections: {},
        vulnerabilidadScores: {},
        vulnerabilidadColors: {},
        vulnerabilidadProbabilidadSelections: {},
        vulnerabilidadIntensidadSelections: {},
        vulnerabilidadSelectedProbabilidad: null,
        vulnerabilidadSelectedIntensidad: null,
        createdAt: now,
        updatedAt: now,
      );
      
      // Guardar formulario completo
      await persistenceService.saveCompleteForm(completeForm);
      
      // Establecer el formulario como activo
      await persistenceService.setActiveFormId(formId);
      
      print('HomeBloc: Formulario completo inicial creado para evento $eventName');
      print('HomeBloc: Form ID: $formId');
      
    } catch (e) {
      print('HomeBloc: Error al crear formulario inicial completo - $e');
    }
  }

  /// Resetear completamente todo el estado para crear un nuevo formulario
  Future<void> _onResetAllForNewForm(ResetAllForNewForm event, Emitter<HomeState> emit) async {
    try {
      // Limpiar el formulario activo de la base de datos
      final persistenceService = FormPersistenceService();
      await persistenceService.setActiveFormId(null);
      
      // Resetear completamente el estado
      emit(state.copyWith(
        selectedRiskEvent: null,
        selectedRiskCategory: null,
        activeFormId: null,
        isCreatingNew: true, // Marcar como crear nuevo
        completedEvaluations: const {}, // Resetear todas las evaluaciones completadas
        savedRiskEventModels: const {}, // Limpiar modelos guardados
        savedForms: const [], // Limpiar formularios guardados
        isLoadingForms: false,
        mostrarEventosRiesgo: false,
        mostrarCategoriasRiesgo: false,
      ));
      
      print('HomeBloc: Estado completamente reseteado para nuevo formulario');
    } catch (e) {
      print('HomeBloc: Error al resetear estado para nuevo formulario - $e');
    }
  }
}
