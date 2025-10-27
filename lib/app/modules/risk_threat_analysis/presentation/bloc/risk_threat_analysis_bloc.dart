// Archivo de compatibilidad temporal - mantiene métodos del BLoC original
// TODO: Refactorizar pantallas para usar nueva arquitectura

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geolocator/geolocator.dart';
import 'package:caja_herramientas/app/core/theme/dagrd_colors.dart';
import '../../domain/entities/risk_analysis_entity.dart';
import 'package:caja_herramientas/app/shared/models/risk_event_factory.dart';
import 'package:caja_herramientas/app/shared/models/risk_model_adapter.dart';
import 'package:caja_herramientas/app/shared/models/risk_event_model.dart';
import '../../domain/use_cases/save_risk_analysis_usecase.dart';
import '../../domain/use_cases/load_risk_analysis_usecase.dart';
import '../../domain/use_cases/validate_unqualified_variables_usecase.dart';
import '../../domain/use_cases/calculate_global_score_usecase.dart';
import 'risk_threat_analysis_event.dart';
import 'risk_threat_analysis_state.dart';
import '../models/form_mode.dart';

/// BLoC de compatibilidad temporal para RiskThreatAnalysis
/// Mantiene métodos del BLoC original mientras se refactorizan las pantallas
class RiskThreatAnalysisBloc extends Bloc<RiskThreatAnalysisEvent, RiskThreatAnalysisState> {
  final SaveRiskAnalysisUseCase _saveRiskAnalysisUseCase;
  final LoadRiskAnalysisUseCase _loadRiskAnalysisUseCase;
  final ValidateUnqualifiedVariablesUseCase _validateUnqualifiedVariablesUseCase;
  final CalculateGlobalScoreUseCase _calculateGlobalScoreUseCase;

  RiskThreatAnalysisBloc({
    required SaveRiskAnalysisUseCase saveRiskAnalysisUseCase,
    required LoadRiskAnalysisUseCase loadRiskAnalysisUseCase,
    required ValidateUnqualifiedVariablesUseCase validateUnqualifiedVariablesUseCase,
    required CalculateGlobalScoreUseCase calculateGlobalScoreUseCase,
  }) : _saveRiskAnalysisUseCase = saveRiskAnalysisUseCase,
       _loadRiskAnalysisUseCase = loadRiskAnalysisUseCase,
       _validateUnqualifiedVariablesUseCase = validateUnqualifiedVariablesUseCase,
       _calculateGlobalScoreUseCase = calculateGlobalScoreUseCase,
       super(RiskThreatAnalysisState.initial()) {
    
    // Registrar todos los event handlers
    on<ToggleProbabilidadDropdown>(_onToggleProbabilidadDropdown);
    on<ToggleIntensidadDropdown>(_onToggleIntensidadDropdown);
    on<SelectProbabilidad>(_onSelectProbabilidad);
    on<SelectIntensidad>(_onSelectIntensidad);
    on<ResetDropdowns>(_onResetDropdowns);
    on<ResetState>(_onResetState);
    on<ChangeBottomNavIndex>(_onChangeBottomNavIndex);
    on<UpdateProbabilidadSelection>(_onUpdateProbabilidadSelection);
    on<UpdateIntensidadSelection>(_onUpdateIntensidadSelection);
    on<UpdateSelectedRiskEvent>(_onUpdateSelectedRiskEvent);
    on<SelectClassification>(_onSelectClassification);
    on<SetFormMode>(_onSetFormMode);
    on<SetCreateMode>(_onSetCreateMode);
    on<SetEditMode>(_onSetEditMode);
    on<ToggleDynamicDropdown>(_onToggleDynamicDropdown);
    on<UpdateDynamicSelection>(_onUpdateDynamicSelection);
    on<ShowFinalResults>(_onShowFinalResults);
    on<LoadFormData>(_onLoadFormData);
    on<SaveFormData>(_onSaveFormData);
    on<UpdateImageCoordinates>(_onUpdateImageCoordinates);
    on<GetCurrentLocationForImage>(_onGetCurrentLocationForImage);
    on<SelectLocationFromMapForImage>(_onSelectLocationFromMapForImage);
    on<AddEvidenceImage>(_onAddEvidenceImage);
    on<RemoveEvidenceImage>(_onRemoveEvidenceImage);
    on<UpdateEvidenceCoordinates>(_onUpdateEvidenceCoordinates);
    on<LoadEvidenceData>(_onLoadEvidenceData);
  }

  // ========== EVENT HANDLERS ==========

  Future<void> _onToggleProbabilidadDropdown(
    ToggleProbabilidadDropdown event,
    Emitter<RiskThreatAnalysisState> emit,
  ) async {
    try {
      emit(state.copyWith(
        isProbabilidadDropdownOpen: !state.isProbabilidadDropdownOpen,
        isIntensidadDropdownOpen: false,
      ));
    } catch (e) {
      emit(state.setError('Error al alternar dropdown de probabilidad: $e'));
    }
  }

  Future<void> _onToggleIntensidadDropdown(
    ToggleIntensidadDropdown event,
    Emitter<RiskThreatAnalysisState> emit,
  ) async {
    try {
      emit(state.copyWith(
        isIntensidadDropdownOpen: !state.isIntensidadDropdownOpen,
        isProbabilidadDropdownOpen: false,
      ));
    } catch (e) {
      emit(state.setError('Error al alternar dropdown de intensidad: $e'));
    }
  }

  Future<void> _onSelectProbabilidad(
    SelectProbabilidad event,
    Emitter<RiskThreatAnalysisState> emit,
  ) async {
    try {
      emit(state.copyWith(
        selectedProbabilidad: event.probabilidad,
        isProbabilidadDropdownOpen: false,
      ));
    } catch (e) {
      emit(state.setError('Error al seleccionar probabilidad: $e'));
    }
  }

  Future<void> _onSelectIntensidad(
    SelectIntensidad event,
    Emitter<RiskThreatAnalysisState> emit,
  ) async {
    try {
      emit(state.copyWith(
        selectedIntensidad: event.intensidad,
        isIntensidadDropdownOpen: false,
      ));
    } catch (e) {
      emit(state.setError('Error al seleccionar intensidad: $e'));
    }
  }

  Future<void> _onResetDropdowns(
    ResetDropdowns event,
    Emitter<RiskThreatAnalysisState> emit,
  ) async {
    try {
      emit(state.copyWith(
        isProbabilidadDropdownOpen: false,
        isIntensidadDropdownOpen: false,
        dropdownOpenStates: const {},
      ));
    } catch (e) {
      emit(state.setError('Error al resetear dropdowns: $e'));
    }
  }

  Future<void> _onResetState(
    ResetState event,
    Emitter<RiskThreatAnalysisState> emit,
  ) async {
    try {
      // Resetear completamente el estado a su estado inicial
      emit(RiskThreatAnalysisState.initial());
    } catch (e) {
      emit(state.setError('Error al resetear estado: $e'));
    }
  }

  Future<void> _onChangeBottomNavIndex(
    ChangeBottomNavIndex event,
    Emitter<RiskThreatAnalysisState> emit,
  ) async {
    try {
      emit(state.copyWith(currentBottomNavIndex: event.index));
    } catch (e) {
      emit(state.setError('Error al cambiar navegación: $e'));
    }
  }

  Future<void> _onUpdateProbabilidadSelection(
    UpdateProbabilidadSelection event,
    Emitter<RiskThreatAnalysisState> emit,
  ) async {
    try {
      final newSelections = Map<String, String>.from(state.probabilidadSelections);
      newSelections[event.category] = event.selection;
      
      emit(state.copyWith(probabilidadSelections: newSelections));
    } catch (e) {
      emit(state.setError('Error al actualizar selección de probabilidad: $e'));
    }
  }

  Future<void> _onUpdateIntensidadSelection(
    UpdateIntensidadSelection event,
    Emitter<RiskThreatAnalysisState> emit,
  ) async {
    try {
      final newSelections = Map<String, String>.from(state.intensidadSelections);
      newSelections[event.category] = event.selection;
      
      emit(state.copyWith(intensidadSelections: newSelections));
    } catch (e) {
      emit(state.setError('Error al actualizar selección de intensidad: $e'));
    }
  }

  Future<void> _onUpdateSelectedRiskEvent(
    UpdateSelectedRiskEvent event,
    Emitter<RiskThreatAnalysisState> emit,
  ) async {
    try {
      emit(state.copyWith(selectedRiskEvent: event.eventName));
    } catch (e) {
      emit(state.setError('Error al actualizar evento de riesgo: $e'));
    }
  }

  Future<void> _onSelectClassification(
    SelectClassification event,
    Emitter<RiskThreatAnalysisState> emit,
  ) async {
    try {
      if (state.selectedClassification != event.classification) {
        emit(state.copyWith(selectedClassification: event.classification));
      }
    } catch (e) {
      emit(state.setError('Error al seleccionar clasificación: $e'));
    }
  }

  Future<void> _onSetFormMode(
    SetFormMode event,
    Emitter<RiskThreatAnalysisState> emit,
  ) async {
    try {
      if (state.formMode != event.mode) {
        emit(state.copyWith(formMode: event.mode));
      }
    } catch (e) {
      emit(state.setError('Error al establecer modo del formulario: $e'));
    }
  }

  Future<void> _onSetCreateMode(
    SetCreateMode event,
    Emitter<RiskThreatAnalysisState> emit,
  ) async {
    try {
      emit(state.copyWith(formMode: FormMode.create));
    } catch (e) {
      emit(state.setError('Error al establecer modo creación: $e'));
    }
  }

  Future<void> _onSetEditMode(
    SetEditMode event,
    Emitter<RiskThreatAnalysisState> emit,
  ) async {
    try {
      emit(state.copyWith(formMode: FormMode.edit));
    } catch (e) {
      emit(state.setError('Error al establecer modo edición: $e'));
    }
  }

  Future<void> _onToggleDynamicDropdown(
    ToggleDynamicDropdown event,
    Emitter<RiskThreatAnalysisState> emit,
  ) async {
    try {
      final newDropdownStates = Map<String, bool>.from(state.dropdownOpenStates);
      newDropdownStates[event.subClassificationId] = 
          !(newDropdownStates[event.subClassificationId] ?? false);
      
      emit(state.copyWith(dropdownOpenStates: newDropdownStates));
    } catch (e) {
      emit(state.setError('Error al alternar dropdown dinámico: $e'));
    }
  }

  Future<void> _onUpdateDynamicSelection(
    UpdateDynamicSelection event,
    Emitter<RiskThreatAnalysisState> emit,
  ) async {
    try {
      final newDynamicSelections = Map<String, Map<String, String>>.from(state.dynamicSelections);
      final subClassSelections = Map<String, String>.from(
          newDynamicSelections[event.subClassificationId] ?? {});
      subClassSelections[event.category] = event.selection;
      newDynamicSelections[event.subClassificationId] = subClassSelections;
      
      // Calcular scores actualizados
      final updatedScores = _calculateAllSubClassificationScores(newDynamicSelections);
      final updatedColors = _calculateAllSubClassificationColors(updatedScores);
      
      emit(state.copyWith(
        dynamicSelections: newDynamicSelections,
        subClassificationScores: updatedScores,
        subClassificationColors: updatedColors,
      ));
    } catch (e) {
      emit(state.setError('Error al actualizar selección dinámica: $e'));
    }
  }

  Future<void> _onShowFinalResults(
    ShowFinalResults event,
    Emitter<RiskThreatAnalysisState> emit,
  ) async {
    try {
      emit(state.copyWith(showFinalResults: true));
    } catch (e) {
      emit(state.setError('Error al mostrar resultados finales: $e'));
    }
  }

  Future<void> _onLoadFormData(
    LoadFormData event,
    Emitter<RiskThreatAnalysisState> emit,
  ) async {
    try {
      emit(state.setLoading(true));
      
      
      // Si hay datos de evaluación específicos, cargarlos directamente
      if (event.evaluationData != null) {
        try {
          // Mapear correctamente los datos del CompleteFormDataModel al estado del BLoC
          final evaluationData = event.evaluationData!;
        
        // PRESERVAR DATOS EXISTENTES: Solo actualizar si hay datos nuevos
        final currentProbabilidadSelections = Map<String, String>.from(state.probabilidadSelections);
        final currentIntensidadSelections = Map<String, String>.from(state.intensidadSelections);
        final currentDynamicSelections = Map<String, Map<String, String>>.from(state.dynamicSelections);
        
        // Mapear selecciones de amenaza
        final probabilidadSelections = Map<String, String>.from(
          evaluationData['amenazaProbabilidadSelections'] ?? evaluationData['probabilidadSelections'] ?? {}
        );
        final intensidadSelections = Map<String, String>.from(
          evaluationData['amenazaIntensidadSelections'] ?? evaluationData['intensidadSelections'] ?? {}
        );
        
        // Mapear selecciones de vulnerabilidad
        final dynamicSelections = Map<String, Map<String, String>>.from(
          evaluationData['vulnerabilidadSelections'] ?? evaluationData['dynamicSelections'] ?? {}
        );
        
        // Actualizar solo si hay datos nuevos para la clasificación actual
        if (event.classificationType.toLowerCase() == 'amenaza') {
          // Para amenaza, actualizar probabilidad e intensidad
          
          if (probabilidadSelections.isNotEmpty) {
            currentProbabilidadSelections.addAll(probabilidadSelections);
          }
          if (intensidadSelections.isNotEmpty) {
            currentIntensidadSelections.addAll(intensidadSelections);
          }
        } else if (event.classificationType.toLowerCase() == 'vulnerabilidad') {
          // Para vulnerabilidad, actualizar dynamicSelections
          
          if (dynamicSelections.isNotEmpty) {
            currentDynamicSelections.addAll(dynamicSelections);
          }
        }
        
        
        // Mapear scores combinados
        final Map<String, double> combinedScores = {};
        
        // Mapear scores - combinar scores de amenaza y vulnerabilidad
        if (evaluationData['amenazaScores'] != null) {
          final amenazaScores = Map<String, dynamic>.from(evaluationData['amenazaScores']);
          amenazaScores.forEach((key, value) {
            combinedScores[key] = (value is double) ? value : (value as num).toDouble();
          });
        }
        
        if (evaluationData['vulnerabilidadScores'] != null) {
          final vulnerabilidadScores = Map<String, dynamic>.from(evaluationData['vulnerabilidadScores']);
          vulnerabilidadScores.forEach((key, value) {
            combinedScores[key] = (value is double) ? value : (value as num).toDouble();
          });
        }
        
        // Fallback a subClassificationScores si no hay scores separados
        if (evaluationData['subClassificationScores'] != null && combinedScores.isEmpty) {
          final subClassificationScores = Map<String, dynamic>.from(evaluationData['subClassificationScores']);
          subClassificationScores.forEach((key, value) {
            combinedScores[key] = (value is double) ? value : (value as num).toDouble();
          });
        }
        
        // Si aún no hay scores, usar scores por defecto basados en las selecciones
        if (combinedScores.isEmpty) {
          // Calcular scores por defecto basados en las selecciones
          if (probabilidadSelections.isNotEmpty) {
            combinedScores['probabilidad'] = 2.0; // Score por defecto
          }
          if (intensidadSelections.isNotEmpty) {
            combinedScores['intensidad'] = 2.0; // Score por defecto
          }
          if (dynamicSelections.isNotEmpty) {
            dynamicSelections.forEach((key, value) {
              combinedScores[key] = 2.0; // Score por defecto
            });
          }
        }
        
        // Los colores se calculan dinámicamente basándose en los scores, no se guardan
        // No necesitamos mapear colores desde evaluationData
        
        // Mapear evidencias
        final evidenceImages = evaluationData['evidenceImages'] != null 
            ? (evaluationData['evidenceImages'] as Map<String, dynamic>).map(
                (key, value) => MapEntry(key, List<String>.from(value as List))
              ) 
            : <String, List<String>>{};
        final evidenceCoordinates = evaluationData['evidenceCoordinates'] != null 
            ? (evaluationData['evidenceCoordinates'] as Map<String, dynamic>).map(
                (key, value) => MapEntry(
                  key, 
                  (value as Map<String, dynamic>).map(
                    (k, v) => MapEntry(int.parse(k), Map<String, String>.from(v as Map))
                  )
                )
              ) 
            : <String, Map<int, Map<String, String>>>{};
        
        // Verificar si los datos están vacíos
        if (probabilidadSelections.isEmpty && intensidadSelections.isEmpty && dynamicSelections.isEmpty) {
          // Todos los datos de selección están vacíos
        }
        
      
        
        final newState = state.copyWith(
          selectedRiskEvent: event.eventName,
          selectedClassification: event.classificationType,
          probabilidadSelections: currentProbabilidadSelections,
          intensidadSelections: currentIntensidadSelections,
          dynamicSelections: currentDynamicSelections,
          subClassificationScores: combinedScores,
          subClassificationColors: {}, // Los colores se calculan dinámicamente basándose en los scores
          evidenceImages: evidenceImages,
          evidenceCoordinates: evidenceCoordinates,
          isLoading: false,
          error: null,
        );
        
        
        emit(newState);
        return;
        } catch (e) {
          // Continuar con el fallback
        }
      }
      
      
      // Cargar datos usando el caso de uso (comportamiento original)
      final entity = await _loadRiskAnalysisUseCase.execute(
        event.eventName,
        event.classificationType,
      );
      
      if (entity != null) {
        emit(RiskThreatAnalysisState.fromEntity(entity));
      } else {
        emit(state.copyWith(
          selectedRiskEvent: event.eventName,
          selectedClassification: event.classificationType,
        ));
      }
    } catch (e) {
      emit(state.setError('Error al cargar datos de formulario: $e'));
    } finally {
      emit(state.setLoading(false));
    }
  }

  Future<void> _onSaveFormData(
    SaveFormData event,
    Emitter<RiskThreatAnalysisState> emit,
  ) async {
    try {
      emit(state.setLoading(true));
      
      
      // Crear entidad desde el estado actual
      final entity = state.toEntity();
      
      // Guardar usando el caso de uso
      await _saveRiskAnalysisUseCase.execute(entity);
      
      emit(state.clearError());
    } catch (e) {
      emit(state.setError('Error al guardar datos de formulario: $e'));
    } finally {
      emit(state.setLoading(false));
    }
  }

  Future<void> _onUpdateImageCoordinates(
    UpdateImageCoordinates event,
    Emitter<RiskThreatAnalysisState> emit,
  ) async {
    try {
      final newCoordinates = Map<String, Map<int, Map<String, String>>>.from(
          state.evidenceCoordinates);
      final categoryCoordinates = Map<int, Map<String, String>>.from(
          newCoordinates[event.category] ?? {});
      categoryCoordinates[event.imageIndex] = event.coordinates;
      newCoordinates[event.category] = categoryCoordinates;
      
      emit(state.copyWith(evidenceCoordinates: newCoordinates));
    } catch (e) {
      emit(state.setError('Error al actualizar coordenadas de imagen: $e'));
    }
  }

  Future<void> _onGetCurrentLocationForImage(
    GetCurrentLocationForImage event,
    Emitter<RiskThreatAnalysisState> emit,
  ) async {
    try {
      emit(state.setLoading(true));
      
      // Verificar permisos de ubicación
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        emit(state.setError('Los servicios de ubicación están deshabilitados'));
        return;
      }

      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          emit(state.setError('Permisos de ubicación denegados'));
          return;
        }
      }

      if (permission == LocationPermission.deniedForever) {
        emit(state.setError('Los permisos de ubicación están denegados permanentemente'));
        return;
      }

      // Obtener ubicación actual
      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
        timeLimit: const Duration(seconds: 10),
      );

      // Actualizar coordenadas de la imagen
      add(UpdateImageCoordinates(
        category: event.category,
        imageIndex: event.imageIndex,
        coordinates: {
          'lat': position.latitude.toString(),
          'lng': position.longitude.toString(),
        },
      ));

      emit(state.setLoading(false));
    } catch (e) {
      emit(state.setError('Error al obtener ubicación actual: $e'));
    }
  }

  Future<void> _onSelectLocationFromMapForImage(
    SelectLocationFromMapForImage event,
    Emitter<RiskThreatAnalysisState> emit,
  ) async {
    try {
      add(UpdateImageCoordinates(
        category: event.category,
        imageIndex: event.imageIndex,
        coordinates: event.coordinates,
      ));
    } catch (e) {
      emit(state.setError('Error al seleccionar ubicación desde mapa: $e'));
    }
  }

  Future<void> _onAddEvidenceImage(
    AddEvidenceImage event,
    Emitter<RiskThreatAnalysisState> emit,
  ) async {
    try {
      final newEvidenceImages = Map<String, List<String>>.from(state.evidenceImages);
      final categoryImages = List<String>.from(newEvidenceImages[event.category] ?? []);
      categoryImages.add(event.imagePath);
      newEvidenceImages[event.category] = categoryImages;
      
      emit(state.copyWith(evidenceImages: newEvidenceImages));
    } catch (e) {
      emit(state.setError('Error al agregar imagen de evidencia: $e'));
    }
  }

  Future<void> _onRemoveEvidenceImage(
    RemoveEvidenceImage event,
    Emitter<RiskThreatAnalysisState> emit,
  ) async {
    try {
      final newEvidenceImages = Map<String, List<String>>.from(state.evidenceImages);
      final categoryImages = List<String>.from(newEvidenceImages[event.category] ?? []);
      if (event.imageIndex < categoryImages.length) {
        categoryImages.removeAt(event.imageIndex);
        newEvidenceImages[event.category] = categoryImages;
      }
      
      emit(state.copyWith(evidenceImages: newEvidenceImages));
    } catch (e) {
      emit(state.setError('Error al remover imagen de evidencia: $e'));
    }
  }

  Future<void> _onUpdateEvidenceCoordinates(
    UpdateEvidenceCoordinates event,
    Emitter<RiskThreatAnalysisState> emit,
  ) async {
    try {
      add(UpdateImageCoordinates(
        category: event.category,
        imageIndex: event.imageIndex,
        coordinates: event.coordinates,
      ));
    } catch (e) {
      emit(state.setError('Error al actualizar coordenadas de evidencia: $e'));
    }
  }

  Future<void> _onLoadEvidenceData(
    LoadEvidenceData event,
    Emitter<RiskThreatAnalysisState> emit,
  ) async {
    try {
      emit(state.setLoading(true));
      
      // Cargar datos usando el caso de uso
      final entity = await _loadRiskAnalysisUseCase.execute(
        event.eventName,
        event.classificationType,
      );
      
      if (entity != null) {
        emit(state.copyWith(
          evidenceImages: entity.evidenceImages,
          evidenceCoordinates: entity.evidenceCoordinates,
        ));
      }
    } catch (e) {
      emit(state.setError('Error al cargar datos de evidencia: $e'));
    } finally {
      emit(state.setLoading(false));
    }
  }

  // ========== MÉTODOS DE COMPATIBILIDAD TEMPORAL ==========
  // TODO: Refactorizar pantallas para usar nueva arquitectura

  /// Método de compatibilidad temporal
  List<RiskSubClassification> getCurrentSubClassifications() {
    // Usar el evento seleccionado dinámicamente
    final riskEvent = RiskEventFactory.getEventByName(state.selectedRiskEvent ?? '') ??
        RiskEventFactory.createMovimientoEnMasa();
    
    // Buscar la clasificación actual
    final classification = riskEvent.classifications.firstWhere(
      (c) => c.name.toLowerCase() == (state.selectedClassification ?? '').toLowerCase(),
      orElse: () => riskEvent.classifications.first,
    );
    
    // Retornar los objetos completos para que tengan acceso a categories
    return classification.subClassifications;
  }

  /// Método para obtener el valor seleccionado de una subclasificación
  String? getValueForSubClassification(String subClassificationId) {
    final classification = state.selectedClassification?.toLowerCase();
    
    
    if (classification == 'amenaza') {
      // Para amenaza, buscar en probabilidad e intensidad
      if (subClassificationId.toLowerCase().contains('probabilidad')) {
        // Buscar en las selecciones de probabilidad
        final probabilidadSelections = state.probabilidadSelections;
        if (probabilidadSelections.isNotEmpty) {
          final value = probabilidadSelections.values.first;
          return value;
        }
        return state.selectedProbabilidad;
      } else if (subClassificationId.toLowerCase().contains('intensidad')) {
        // Buscar en las selecciones de intensidad
        final intensidadSelections = state.intensidadSelections;
        if (intensidadSelections.isNotEmpty) {
          final value = intensidadSelections.values.first;
          return value;
        }
        return state.selectedIntensidad;
      }
    } else if (classification == 'vulnerabilidad') {
      // Para vulnerabilidad, buscar en dynamicSelections
      final dynamicSelections = state.dynamicSelections[subClassificationId];
      if (dynamicSelections != null && dynamicSelections.isNotEmpty) {
        final value = dynamicSelections.values.first;
        return value;
      }
    }
    
    return null;
  }

  /// Método de compatibilidad temporal
  bool getIsSelectedForSubClassification(String subClassificationId) {
    // Determinar si el dropdown está abierto basado en dropdownOpenStates
    return state.dropdownOpenStates[subClassificationId] ?? false;
  }

  /// Método de compatibilidad temporal
  List<dynamic> getCategoriesForCurrentSubClassification(String subClassificationId) {
    // Usar el evento seleccionado dinámicamente
    final riskEvent = RiskEventFactory.getEventByName(state.selectedRiskEvent ?? '') ??
        RiskEventFactory.createMovimientoEnMasa();
    
    // Buscar la clasificación actual
    final classification = riskEvent.classifications.firstWhere(
      (c) => c.name.toLowerCase() == (state.selectedClassification ?? '').toLowerCase(),
      orElse: () => riskEvent.classifications.first,
    );
    
    // Buscar la subclasificación actual
    final subClassification = classification.subClassifications.firstWhere(
      (s) => s.id == subClassificationId,
      orElse: () => classification.subClassifications.first,
    );
    
    // Convertir categorías a formato compatible usando el adaptador
    final dropdownCategories = RiskModelAdapter.convertToDropdownCategories(subClassification.categories);
    
    return dropdownCategories;
  }

  /// Método de compatibilidad temporal
  Map<String, dynamic> getSubClassificationCalculationDetails(String subClassificationId) {
    // Implementación básica para mostrar detalles de cálculo
    final dynamicSelections = state.dynamicSelections[subClassificationId];
    if (dynamicSelections != null && dynamicSelections.isNotEmpty) {
      return {
        'hasSelections': true,
        'selections': dynamicSelections,
        'totalSelections': dynamicSelections.length,
      };
    }
    return {
      'hasSelections': false,
      'selections': {},
      'totalSelections': 0,
    };
  }

  /// Método de compatibilidad temporal para obtener subclasificaciones de amenaza
  List<RiskSubClassification> getAmenazaSubClassifications() {
    final riskEvent = RiskEventFactory.getEventByName(state.selectedRiskEvent ?? '') ??
        RiskEventFactory.createMovimientoEnMasa();
    final amenazaClassification = riskEvent.classifications.firstWhere(
      (c) => c.name.toLowerCase() == 'amenaza',
      orElse: () => riskEvent.classifications.first,
    );
    
    // Retornar los objetos completos para que tengan acceso a categories
    return amenazaClassification.subClassifications;
  }

  /// Método de compatibilidad temporal para obtener subclasificaciones de vulnerabilidad
  List<RiskSubClassification> getVulnerabilidadSubClassifications() {
    final riskEvent = RiskEventFactory.getEventByName(state.selectedRiskEvent ?? '') ??
        RiskEventFactory.createMovimientoEnMasa();
    final vulnerabilidadClassification = riskEvent.classifications.firstWhere(
      (c) => c.name.toLowerCase() == 'vulnerabilidad',
      orElse: () => riskEvent.classifications.first,
    );
    
    // Retornar los objetos completos para que tengan acceso a categories
    return vulnerabilidadClassification.subClassifications;
  }

  /// Método de compatibilidad temporal
  void handleDropdownTap(String subClassificationId) {
    add(ToggleDynamicDropdown(subClassificationId));
  }

  /// Método de compatibilidad temporal
  void handleSelectionChanged(String subClassificationId, String category, String selection) {
    add(UpdateDynamicSelection(
      subClassificationId: subClassificationId,
      category: category,
      selection: selection,
    ));
  }

  /// Método de compatibilidad temporal
  Color getThreatBackgroundColor() {
    try {
      double score;
      Color color;
      
      if ((state.selectedClassification ?? '').toLowerCase() == 'amenaza') {
        // Verificar si hay selecciones REALES del usuario
        if (state.probabilidadSelections.isEmpty && state.intensidadSelections.isEmpty) {
          return DAGRDColors.outlineVariant;
        }
        
        // Para amenaza, usar el use case
        final formData = getCurrentFormData();
        final globalScoreInfo = _calculateGlobalScoreUseCase.getGlobalScoreInfo(formData);
        score = globalScoreInfo['amenazaScore'] ?? 0.0;
        color = globalScoreInfo['amenazaColor'] ?? DAGRDColors.outlineVariant;
      } else if ((state.selectedClassification ?? '').toLowerCase() == 'vulnerabilidad') {
        // Verificar si hay selecciones REALES del usuario
        if (state.dynamicSelections.isEmpty) {
          return DAGRDColors.outlineVariant;
        }
        
        // Verificar si hay al menos una selección no vacía
        bool hasValidSelections = false;
        for (final entry in state.dynamicSelections.entries) {
          if (entry.value.isNotEmpty) {
            hasValidSelections = true;
            break;
          }
        }
        
        if (!hasValidSelections) {
          return DAGRDColors.outlineVariant;
        }
        
        // Para vulnerabilidad, calcular del promedio de los scores
        final scores = state.subClassificationScores.values.toList();
        if (scores.isNotEmpty && scores.any((s) => s > 0)) {
          score = scores.where((s) => s > 0).reduce((a, b) => a + b) / scores.where((s) => s > 0).length;
          color = _getColorFromScore(score);
        } else {
          score = 0.0;
          color = DAGRDColors.outlineVariant;
        }
      } else {
        final formData = getCurrentFormData();
        final globalScoreInfo = _calculateGlobalScoreUseCase.getGlobalScoreInfo(formData);
        score = globalScoreInfo['finalScore'] ?? 0.0;
        color = globalScoreInfo['finalColor'] ?? DAGRDColors.outlineVariant;
      }
      
      // Si no hay score (0.0), devolver el color de borde específico
      if (score == 0.0) {
        return DAGRDColors.outlineVariant; // #D1D5DB
      }
      
      return color;
    } catch (e) {
      return DAGRDColors.outlineVariant; // #D1D5DB
    }
  }
  
  /// Helper para obtener color desde score
  Color _getColorFromScore(double score) {
    if (score <= 1.5) {
      return DAGRDColors.nivelBajo;
    } else if (score <= 2.5) {
      return DAGRDColors.nivelMedioBajo;
    } else if (score <= 3.5) {
      return DAGRDColors.nivelMedioAlto;
    } else if (score <= 4.5) {
      return DAGRDColors.nivelAlto;
    } else {
      return Colors.deepPurple;
    }
  }

  /// Método de compatibilidad temporal
  String getFormattedThreatRating() {
    try {
      double score;
      String level;
      
      if ((state.selectedClassification ?? '').toLowerCase() == 'amenaza') {
        // Para amenaza, verificar si hay selecciones REALES del usuario
        if (state.probabilidadSelections.isEmpty && state.intensidadSelections.isEmpty) {
          return 'SIN CALIFICAR';
        }
        
        // Calcular del promedio de probabilidad e intensidad
        final formData = getCurrentFormData();
        final globalScoreInfo = _calculateGlobalScoreUseCase.getGlobalScoreInfo(formData);
        score = globalScoreInfo['amenazaScore'] ?? 0.0;
        level = globalScoreInfo['amenazaLevel'] ?? 'SIN CALIFICAR';
      } else if ((state.selectedClassification ?? '').toLowerCase() == 'vulnerabilidad') {
        // Para vulnerabilidad, verificar si hay selecciones REALES del usuario
        if (state.dynamicSelections.isEmpty) {
          return 'SIN CALIFICAR';
        }
        
        // Verificar si hay al menos una selección no vacía
        bool hasValidSelections = false;
        for (final entry in state.dynamicSelections.entries) {
          if (entry.value.isNotEmpty) {
            hasValidSelections = true;
            break;
          }
        }
        
        if (!hasValidSelections) {
          return 'SIN CALIFICAR';
        }
        
        // Usar los scores ya calculados en el state
        final scores = state.subClassificationScores.values.toList();
        if (scores.isNotEmpty && scores.any((s) => s > 0)) {
          score = scores.where((s) => s > 0).reduce((a, b) => a + b) / scores.where((s) => s > 0).length;
          level = _getLevelFromScore(score);
        } else {
          score = 0.0;
          level = 'SIN CALIFICAR';
        }
      } else {
        final formData = getCurrentFormData();
        final globalScoreInfo = _calculateGlobalScoreUseCase.getGlobalScoreInfo(formData);
        score = globalScoreInfo['finalScore'] ?? 0.0;
        level = globalScoreInfo['finalLevel'] ?? 'SIN CALIFICAR';
      }
      
      if (score == 0.0) {
        return 'SIN CALIFICAR';
      }
      
      // Formatear el score a 1 decimal y agregar el nivel
      return '${score.toStringAsFixed(1)} $level';
    } catch (e) {
      return 'SIN CALIFICAR';
    }
  }
  
  /// Helper para obtener nivel desde score
  String _getLevelFromScore(double score) {
    if (score >= 1.0 && score <= 1.75) {
      return 'BAJO';
    } else if (score > 1.75 && score <= 2.5) {
      return 'MEDIO - BAJO';
    } else if (score > 2.5 && score <= 3.25) {
      return 'MEDIO - ALTO';
    } else if (score > 3.25 && score <= 4.0) {
      return 'ALTO';
    } else {
      return 'SIN CALIFICAR';
    }
  }

  /// Método de compatibilidad temporal
  Color getThreatTextColor() {
    try {
      double score;
      Color bgColor;
      
      if ((state.selectedClassification ?? '').toLowerCase() == 'amenaza') {
        // Verificar si hay selecciones REALES del usuario
        if (state.probabilidadSelections.isEmpty && state.intensidadSelections.isEmpty) {
          return Colors.black;
        }
        
        final formData = getCurrentFormData();
        final globalScoreInfo = _calculateGlobalScoreUseCase.getGlobalScoreInfo(formData);
        score = globalScoreInfo['amenazaScore'] ?? 0.0;
        bgColor = globalScoreInfo['amenazaColor'] ?? Colors.grey;
      } else if ((state.selectedClassification ?? '').toLowerCase() == 'vulnerabilidad') {
        // Verificar si hay selecciones REALES del usuario
        if (state.dynamicSelections.isEmpty) {
          return Colors.black;
        }
        
        // Verificar si hay al menos una selección no vacía
        bool hasValidSelections = false;
        for (final entry in state.dynamicSelections.entries) {
          if (entry.value.isNotEmpty) {
            hasValidSelections = true;
            break;
          }
        }
        
        if (!hasValidSelections) {
          return Colors.black;
        }
        
        // Para vulnerabilidad, calcular del promedio de los scores
        final scores = state.subClassificationScores.values.toList();
        if (scores.isNotEmpty && scores.any((s) => s > 0)) {
          score = scores.where((s) => s > 0).reduce((a, b) => a + b) / scores.where((s) => s > 0).length;
          bgColor = _getColorFromScore(score);
        } else {
          score = 0.0;
          bgColor = DAGRDColors.outlineVariant;
        }
      } else {
        final formData = getCurrentFormData();
        final globalScoreInfo = _calculateGlobalScoreUseCase.getGlobalScoreInfo(formData);
        score = globalScoreInfo['finalScore'] ?? 0.0;
        bgColor = globalScoreInfo['finalColor'] ?? Colors.grey;
      }
      
      // Si no hay score (0.0), devolver negro para texto sobre fondo gris
      if (score == 0.0) {
        return Colors.black;
      }
      
      // Retornar color de texto basado en el color de fondo
      // Todos los colores DAGRD usan texto blanco excepto el gris
      return bgColor == DAGRDColors.outlineVariant ? Colors.black : Colors.white;
    } catch (e) {
      return Colors.black;
    }
  }

  /// Método de compatibilidad temporal
  void loadExistingFormData() {
    add(LoadFormData(
      eventName: state.selectedRiskEvent ?? '',
      classificationType: state.selectedClassification ?? '',
    ));
  }

  /// Método de compatibilidad temporal
  bool hasUnqualifiedVariables() {
    try {
      final formData = getCurrentFormData();
      final result = _validateUnqualifiedVariablesUseCase.execute(formData);
      return result;
    } catch (e) {
      return false;
    }
  }


  /// Método de compatibilidad temporal - Restaurar funcionalidad original
  bool shouldShowScoreContainer(String subClassificationId) {
    final score = getSubClassificationScore(subClassificationId);
    return score > 0;
  }

  /// Método centralizado para obtener score de subclasificación
  double getSubClassificationScore(String subClassificationId) {
    final score = state.subClassificationScores[subClassificationId] ?? 0.0;
    return score;
  }

  /// Método centralizado para obtener el rating numérico de una selección
  int getRatingFromSelection(String? selectedLevel) {
    if (selectedLevel == null || selectedLevel.isEmpty) return 0;

    // Si es "No Aplica", devolver -1 para diferenciarlo
    if (selectedLevel == 'NA') return -1;

    if (selectedLevel.contains('BAJO') && !selectedLevel.contains('MEDIO')) {
      return 1;
    } else if (selectedLevel.contains('MEDIO') && selectedLevel.contains('ALTO')) {
      return 3;
    } else if (selectedLevel.contains('MEDIO')) {
      return 2;
    } else if (selectedLevel.contains('ALTO')) {
      return 4;
    }
    return 0;
  }

  /// Método centralizado para obtener el color basado en el rating
  Color getColorFromRating(int rating) {
    switch (rating) {
      case -1:
        return DAGRDColors.grisMedio; // Gris más oscuro para "No Aplica"
      case 1:
        return Colors.green;
      case 2:
        return Colors.yellow;
      case 3:
        return Colors.orange;
      case 4:
        return Colors.red;
      default:
        return DAGRDColors.grisMedio; // Gris para sin calificar
    }
  }

  /// Método centralizado para obtener la selección de una categoría
  String? getSelectionForCategory(String subClassificationId, String categoryTitle) {
    if (subClassificationId == 'probabilidad') {
      return state.probabilidadSelections[categoryTitle];
    } else if (subClassificationId == 'intensidad') {
      return state.intensidadSelections[categoryTitle];
    } else {
      // Para vulnerabilidad, usar dynamicSelections
      final selections = state.dynamicSelections[subClassificationId] ?? {};
      return selections[categoryTitle];
    }
  }

  /// Método centralizado para calcular el score de una sección
  String calculateSectionScore(String subClassificationId) {
    final categories = getCategoriesForCurrentSubClassification(subClassificationId);
    final validRatings = <int>[];
    
    for (final category in categories) {
      final selection = getSelectionForCategory(subClassificationId, category.title);
      final rating = getRatingFromSelection(selection);
      
      // Excluir 0 (sin calificar) y -1 (NA)
      if (rating > 0) {
        validRatings.add(rating);
      }
    }

    if (validRatings.isEmpty) return '0,00';

    final average = validRatings.reduce((a, b) => a + b) / validRatings.length;
    return average.toStringAsFixed(2).replaceAll('.', ',');
  }

  /// Método centralizado para obtener items de una subclasificación
  List<Map<String, dynamic>> getItemsForSubClassification(String subClassificationId) {
    final categories = getCategoriesForCurrentSubClassification(subClassificationId);
    final items = <Map<String, dynamic>>[];
    
    for (final category in categories) {
      final selection = getSelectionForCategory(subClassificationId, category.title);
      final rating = getRatingFromSelection(selection);
      final color = getColorFromRating(rating);

      String title = category.title;
      if (rating == -1) {
        title = '${category.title} - No Aplica';
      } else if (rating == 0) {
        title = '${category.title} - Sin calificar';
      }

      items.add({'rating': rating, 'title': title, 'color': color});
    }
    
    return items;
  }

  /// Método centralizado para obtener evidencias de una categoría
  List<String> getEvidenceImagesForCategory(String category) {
    return state.evidenceImages[category.toLowerCase()] ?? [];
  }

  /// Método centralizado para obtener coordenadas de evidencias de una categoría
  Map<int, Map<String, String>> getEvidenceCoordinatesForCategory(String category) {
    return state.evidenceCoordinates[category.toLowerCase()] ?? {};
  }

  /// Método centralizado para verificar si una categoría tiene evidencias
  bool hasEvidenceForCategory(String category) {
    final images = getEvidenceImagesForCategory(category);
    return images.isNotEmpty;
  }

  /// Método centralizado para obtener el número de evidencias de una categoría
  int getEvidenceCountForCategory(String category) {
    return getEvidenceImagesForCategory(category).length;
  }

  /// Método centralizado para obtener el porcentaje de completado de una categoría
  double getCompletionPercentageForCategory(String category) {
    final subClassifications = getCurrentSubClassifications();
    if (subClassifications.isEmpty) return 0.0;
    
    int totalCategories = 0;
    int completedCategories = 0;
    
    for (final subClassification in subClassifications) {
      final categories = getCategoriesForCurrentSubClassification(subClassification.id);
      totalCategories += categories.length;
      
      if (subClassification.id == 'probabilidad') {
        completedCategories += state.probabilidadSelections.length;
      } else if (subClassification.id == 'intensidad') {
        completedCategories += state.intensidadSelections.length;
      } else {
        final selections = state.dynamicSelections[subClassification.id] ?? {};
        completedCategories += selections.length;
      }
    }
    
    return totalCategories > 0 ? completedCategories / totalCategories : 0.0;
  }

  /// Método centralizado para verificar si una categoría está completa
  bool isCategoryComplete(String category) {
    final hasSelections = getCompletionPercentageForCategory(category) > 0.0;
    final hasEvidence = hasEvidenceForCategory(category);
    return hasSelections && hasEvidence;
  }

  /// Método centralizado para obtener el estado de una categoría
  Map<String, dynamic> getCategoryStatus(String category) {
    final hasSelections = getCompletionPercentageForCategory(category) > 0.0;
    final hasEvidence = hasEvidenceForCategory(category);
    final isComplete = hasSelections && hasEvidence;
    final evidenceCount = getEvidenceCountForCategory(category);
    final completionPercentage = getCompletionPercentageForCategory(category);
    
    return {
      'isComplete': isComplete,
      'hasSelections': hasSelections,
      'hasEvidence': hasEvidence,
      'evidenceCount': evidenceCount,
      'completionPercentage': completionPercentage,
    };
  }

  /// Método centralizado para obtener datos optimizados para widgets
  Map<String, dynamic> getOptimizedDataForWidgets() {
    return {
      'selectedRiskEvent': state.selectedRiskEvent ?? '',
      'selectedClassification': state.selectedClassification ?? '',
      'currentBottomNavIndex': state.currentBottomNavIndex,
      'isLoading': state.isLoading,
      'amenazaStatus': getCategoryStatus('amenaza'),
      'vulnerabilidadStatus': getCategoryStatus('vulnerabilidad'),
      'totalEvidenceCount': state.evidenceImages.values.fold(0, (sum, images) => sum + images.length),
    };
  }

  /// Método de compatibilidad temporal - Restaurar funcionalidad original
  Color getSubClassificationColor(String subClassificationId) {
    // Calcular el color basándose en el score en lugar de usar colores guardados
    final score = getSubClassificationScore(subClassificationId);
    final color = _scoreToColor(score);
    return color;
  }





  /// Convertir score a color (del código original)
  Color _scoreToColor(double score) {
    if (score == 0) {
      return Colors.transparent; 
    } else if (score <= 1.75) {
      return DAGRDColors.nivelBajo; 
    } else if (score <= 2.50) {
      return DAGRDColors.nivelMedioBajo; 
    } else if (score <= 3.25) {
      return DAGRDColors.nivelMedioAlto; 
    } else {
      return DAGRDColors.nivelAlto; 
    }
  }

  /// Calcular score de subclasificación (del código original)
  double _calculateSubClassificationScore(String subClassificationId, Map<String, Map<String, String>> selections) {
    final subSelections = selections[subClassificationId] ?? {};
    if (subSelections.isEmpty) return 0.0;
    final calculationType = _getCalculationType(subClassificationId);
    
    switch (calculationType) {
      case 'critical_variable':
        return _calculateWithCriticalVariable(subClassificationId, subSelections);
      case 'weighted_average':
        return _calculateWeightedAverage(subClassificationId, subSelections);
      default:
        return _calculateSimpleAverage(subClassificationId, subSelections);
    }
  }

  /// Obtener tipo de cálculo (del código original)
  String _getCalculationType(String subClassificationId) {
    final eventName = state.selectedRiskEvent ?? '';
    final classification = state.selectedClassification ?? '';
    
    RiskEventModel? currentEvent;
    switch (eventName) {
      case 'Movimiento en Masa':
        currentEvent = RiskEventFactory.createMovimientoEnMasa();
        break;
      case 'Inundación':
        currentEvent = RiskEventFactory.createInundacion();
        break;
      case 'Avenida Torrencial':
        currentEvent = RiskEventFactory.createAvenidaTorrencial();
        break;
      case 'Estructural':
        currentEvent = RiskEventFactory.createEstructural();
        break;
      case 'Otros':
        currentEvent = RiskEventFactory.createOtros();
        break;
      case 'Incendio Forestal':
        currentEvent = RiskEventFactory.createIncendioForestal();
        break;
      default:
        return 'simple_average';
    }
    
    try {
      final currentClassification = currentEvent.classifications.firstWhere(
        (cls) => cls.id == classification,
      );
      
      final currentSubClassification = currentClassification.subClassifications.firstWhere(
        (subCls) => subCls.id == subClassificationId,
      );
      if (currentSubClassification.hasCriticalVariable) {
        return 'critical_variable';
      }
    } catch (e) {
      // Error al encontrar clasificación
    }
    
    if (classification == 'vulnerabilidad' && subClassificationId == 'exposicion') {
      return 'weighted_average';
    }
    if (eventName == 'Incendio Forestal') {
      return 'weighted_average';
    }
    if ((eventName == 'Estructural' || eventName == 'Otros') && 
        classification == 'amenaza' && subClassificationId == 'probabilidad') {
      return 'weighted_average';
    }
    if (classification == 'vulnerabilidad') {
      return 'weighted_average';
    }
    
    return 'simple_average';
  }

  /// Calcular con variable crítica (del código original)
  double _calculateWithCriticalVariable(String subClassificationId, Map<String, String> selections) {
    final eventName = state.selectedRiskEvent ?? '';
    
    if (eventName == 'Movimiento en Masa') {
      if (subClassificationId == 'probabilidad') {
        return _calculateMovimientoEnMasaProbabilidad(selections);
      } else if (subClassificationId == 'intensidad') {
        return _calculateMovimientoEnMasaIntensidad(selections);
      }
    }
    
    // Agregar más casos según sea necesario
    return _calculateWeightedAverage(subClassificationId, selections);
  }

  /// Calcular Movimiento en Masa - Probabilidad (del código original)
  double _calculateMovimientoEnMasaProbabilidad(Map<String, String> selections) {
    // Verificar condición especial para EVIDENCIAS DE MATERIALIZACIÓN O REACTIVACIÓN
    final evidenciasValue = _getSelectedLevelValue('Evidencias de Materialización o Reactivación', selections);
    if (evidenciasValue == 4) {
      return 4.0;
    }
    
    return _calculateWeightedAverage('probabilidad', selections);
  }

  /// Calcular Movimiento en Masa - Intensidad (del código original)
  double _calculateMovimientoEnMasaIntensidad(Map<String, String> selections) {
    final potencialDanoValue = _getSelectedLevelValue('Potencial de Daño en Edificaciones', selections);
    if (potencialDanoValue == 4) {
      return 4.0;
    }
    return _calculateWeightedAverage('intensidad', selections);
  }

  /// Calcular promedio ponderado (del código original)
  double _calculateWeightedAverage(String subClassificationId, Map<String, String> selections) {
    try {
      final eventModel = _getCurrentEventModel();
      if (eventModel == null) return _calculateSimpleAverage(subClassificationId, selections);
      
      final classification = eventModel.classifications
          .where((c) => c.name.toLowerCase() == (state.selectedClassification ?? '').toLowerCase())
          .firstOrNull;
      if (classification == null) return _calculateSimpleAverage(subClassificationId, selections);
      
      final subClassification = classification.subClassifications
          .where((s) => s.id == subClassificationId)
          .firstOrNull;
      if (subClassification == null) return _calculateSimpleAverage(subClassificationId, selections);
      
      double sumCalificacionPorWi = 0.0;
      double sumWi = 0.0;
      
      for (final category in subClassification.categories) {
        final selectedLevel = selections[category.title];
        if (selectedLevel != null && selectedLevel.isNotEmpty && selectedLevel != 'NA') {
          final calificacion = _getSelectedLevelValue(category.title, {category.title: selectedLevel});
          if (calificacion > 0) { 
            sumCalificacionPorWi += (calificacion * category.wi);
            sumWi += category.wi;
          }
        }
      }
      
      return sumWi > 0 ? sumCalificacionPorWi / sumWi : 0.0;
      
    } catch (e) {
      return _calculateSimpleAverage(subClassificationId, selections);
    }
  }

  /// Obtener modelo de evento actual (del código original)
  RiskEventModel? _getCurrentEventModel() {
    final eventName = state.selectedRiskEvent ?? '';
    
    switch (eventName) {
      case 'Movimiento en Masa':
        return RiskEventFactory.createMovimientoEnMasa();
      case 'Inundación':
        return RiskEventFactory.createInundacion();
      case 'Incendio Forestal':
        return RiskEventFactory.createIncendioForestal();
      case 'Avenida Torrencial':
        return RiskEventFactory.createAvenidaTorrencial();
      case 'Estructural':
        return RiskEventFactory.createEstructural();
      case 'Otros':
        return RiskEventFactory.createOtros();
      default:
        return null;
    }
  }

  /// Calcular promedio simple (del código original)
  double _calculateSimpleAverage(String subClassificationId, Map<String, String> selections) {
    if (selections.isEmpty) return 0.0;
    
    double totalScore = 0.0;
    int count = 0;
    
    for (final entry in selections.entries) {
      final value = _getSelectedLevelValue(entry.key, {entry.key: entry.value});
      
      if (value > 0) {
        totalScore += value;
        count++;
      }
    }
    
    return count > 0 ? totalScore / count : 0.0;
  }

  /// Obtener valor de nivel seleccionado (del código original)
  int _getSelectedLevelValue(String categoryTitle, Map<String, String> selections) {
    final selectedLevel = selections[categoryTitle];
    if (selectedLevel == null) return 0;
    if (selectedLevel == 'NA') return -1;
    if (selectedLevel.contains('BAJO') && !selectedLevel.contains('MEDIO')) {
      return 1;
    } else if (selectedLevel.contains('MEDIO') && selectedLevel.contains('ALTO')) {
      return 3;
    } else if (selectedLevel.contains('MEDIO')) {
      return 2;
    } else if (selectedLevel.contains('ALTO')) {
      return 4;
    }
    return 0;
  }

  /// Calcular todos los scores de subclasificaciones (del código original)
  Map<String, double> _calculateAllSubClassificationScores(Map<String, Map<String, String>> selections) {
    final scores = <String, double>{};
    
    for (final subClassificationId in selections.keys) {
      scores[subClassificationId] = _calculateSubClassificationScore(subClassificationId, selections);
    }
    
    return scores;
  }

  /// Calcular todos los colores de subclasificaciones (del código original)
  Map<String, Color> _calculateAllSubClassificationColors(Map<String, double> scores) {
    final colors = <String, Color>{};
    
    for (final entry in scores.entries) {
      colors[entry.key] = _scoreToColor(entry.value);
    }
    
    return colors;
  }

  /// Método de compatibilidad temporal
  Map<String, dynamic> getCurrentFormData() {
    try {
      final formData = {
        'amenazaProbabilidadSelections': state.probabilidadSelections,
        'amenazaIntensidadSelections': state.intensidadSelections,
        'vulnerabilidadSelections': state.dynamicSelections,
        'selectedRiskEvent': state.selectedRiskEvent ?? '',
        'selectedClassification': state.selectedClassification ?? '',
        'subClassificationScores': state.subClassificationScores,
        'subClassificationColors': state.subClassificationColors,
        'evidenceImages': state.evidenceImages,
        'evidenceCoordinates': state.evidenceCoordinates,
        'probabilidadSelections': state.probabilidadSelections,
        'intensidadSelections': state.intensidadSelections,
        'dynamicSelections': state.dynamicSelections,
      };
      
      return formData;
    } catch (e) {
      return {};
    }
  }

  /// Método de compatibilidad temporal
  double calculateAmenazaGlobalScore() {
    try {
      final formData = getCurrentFormData();
      return _calculateGlobalScoreUseCase.calculateAmenazaGlobalScore(formData);
    } catch (e) {
    return 0.0;
    }
  }

  /// Método de compatibilidad temporal
  double calculateVulnerabilidadFinalScore() {
    try {
      final formData = getCurrentFormData();
      return _calculateGlobalScoreUseCase.calculateVulnerabilidadGlobalScore(formData);
    } catch (e) {
    return 0.0;
    }
  }

  // ========== HELPER METHODS ==========

  /// Obtener el estado actual como entidad de dominio
  RiskAnalysisEntity get currentEntity => state.toEntity();

  /// Verificar si el análisis está completo
  bool get isAnalysisComplete => currentEntity.isFullyCompleted;

  /// Obtener progreso del análisis
  double get analysisProgress {
    final entity = currentEntity;
    if (entity.isEmpty) return 0.0;
    
    final totalFields = entity.selections.length;
    final completedFields = entity.selections.values.where((v) => v != null && v.toString().isNotEmpty).length;
    
    return totalFields > 0 ? completedFields / totalFields : 0.0;
  }
}
