// Archivo de compatibilidad temporal - mantiene métodos del BLoC original
// TODO: Refactorizar pantallas para usar nueva arquitectura

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/entities/risk_analysis_entity.dart';
import 'package:caja_herramientas/app/shared/models/dropdown_category.dart';
import 'package:caja_herramientas/app/shared/models/risk_event_factory.dart';
import 'package:caja_herramientas/app/shared/models/risk_model_adapter.dart';
import 'package:caja_herramientas/app/shared/models/risk_event_model.dart';
import '../../domain/use_cases/save_risk_analysis_usecase.dart';
import '../../domain/use_cases/load_risk_analysis_usecase.dart';
import '../../domain/use_cases/validate_form_usecase.dart';
import '../../domain/use_cases/calculate_rating_usecase.dart';
import '../../domain/use_cases/calculate_score_usecase.dart';
import '../../domain/use_cases/validate_unqualified_variables_usecase.dart';
import '../../domain/use_cases/calculate_global_score_usecase.dart';
import 'risk_threat_analysis_event.dart';
import 'risk_threat_analysis_state.dart';

/// BLoC de compatibilidad temporal para RiskThreatAnalysis
/// Mantiene métodos del BLoC original mientras se refactorizan las pantallas
class RiskThreatAnalysisBloc extends Bloc<RiskThreatAnalysisEvent, RiskThreatAnalysisState> {
  final SaveRiskAnalysisUseCase _saveRiskAnalysisUseCase;
  final LoadRiskAnalysisUseCase _loadRiskAnalysisUseCase;
  final ValidateFormUseCase _validateFormUseCase;
  final CalculateRatingUseCase _calculateRatingUseCase;
  final CalculateScoreUseCase _calculateScoreUseCase;
  final ValidateUnqualifiedVariablesUseCase _validateUnqualifiedVariablesUseCase;
  final CalculateGlobalScoreUseCase _calculateGlobalScoreUseCase;

  RiskThreatAnalysisBloc({
    required SaveRiskAnalysisUseCase saveRiskAnalysisUseCase,
    required LoadRiskAnalysisUseCase loadRiskAnalysisUseCase,
    required ValidateFormUseCase validateFormUseCase,
    required CalculateRatingUseCase calculateRatingUseCase,
    required CalculateScoreUseCase calculateScoreUseCase,
    required ValidateUnqualifiedVariablesUseCase validateUnqualifiedVariablesUseCase,
    required CalculateGlobalScoreUseCase calculateGlobalScoreUseCase,
  }) : _saveRiskAnalysisUseCase = saveRiskAnalysisUseCase,
       _loadRiskAnalysisUseCase = loadRiskAnalysisUseCase,
       _validateFormUseCase = validateFormUseCase,
       _calculateRatingUseCase = calculateRatingUseCase,
       _calculateScoreUseCase = calculateScoreUseCase,
       _validateUnqualifiedVariablesUseCase = validateUnqualifiedVariablesUseCase,
       _calculateGlobalScoreUseCase = calculateGlobalScoreUseCase,
       super(RiskThreatAnalysisState.initial()) {
    
    // Registrar todos los event handlers
    on<ToggleProbabilidadDropdown>(_onToggleProbabilidadDropdown);
    on<ToggleIntensidadDropdown>(_onToggleIntensidadDropdown);
    on<SelectProbabilidad>(_onSelectProbabilidad);
    on<SelectIntensidad>(_onSelectIntensidad);
    on<ResetDropdowns>(_onResetDropdowns);
    on<ChangeBottomNavIndex>(_onChangeBottomNavIndex);
    on<UpdateProbabilidadSelection>(_onUpdateProbabilidadSelection);
    on<UpdateIntensidadSelection>(_onUpdateIntensidadSelection);
    on<UpdateSelectedRiskEvent>(_onUpdateSelectedRiskEvent);
    on<SelectClassification>(_onSelectClassification);
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
      emit(state.copyWith(selectedClassification: event.classification));
    } catch (e) {
      emit(state.setError('Error al seleccionar clasificación: $e'));
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
      
      emit(state.copyWith(dynamicSelections: newDynamicSelections));
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
      
      // Cargar datos usando el caso de uso
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
      // TODO: Implementar obtención de ubicación actual
      emit(state.setError('Funcionalidad de ubicación actual no implementada'));
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
    final riskEvent = RiskEventFactory.getEventByName(state.selectedRiskEvent) ??
        RiskEventFactory.createMovimientoEnMasa();
    
    // Buscar la clasificación actual
    final classification = riskEvent.classifications.firstWhere(
      (c) => c.name.toLowerCase() == state.selectedClassification.toLowerCase(),
      orElse: () => riskEvent.classifications.first,
    );
    
    // Retornar los objetos completos para que tengan acceso a categories
    return classification.subClassifications;
  }

  /// Método de compatibilidad temporal
  String getValueForSubClassification(String subClassificationId) {
    // Implementación básica para retornar valores seleccionados
    final dynamicSelections = state.dynamicSelections[subClassificationId];
    if (dynamicSelections != null && dynamicSelections.isNotEmpty) {
      final firstSelection = dynamicSelections.values.first;
      return firstSelection;
    }
    return '';
  }

  /// Método de compatibilidad temporal
  bool getIsSelectedForSubClassification(String subClassificationId) {
    // Determinar si el dropdown está abierto basado en dropdownOpenStates
    return state.dropdownOpenStates[subClassificationId] ?? false;
  }

  /// Método de compatibilidad temporal
  List<dynamic> getCategoriesForCurrentSubClassification(String subClassificationId) {
    // Usar el evento seleccionado dinámicamente
    final riskEvent = RiskEventFactory.getEventByName(state.selectedRiskEvent) ??
        RiskEventFactory.createMovimientoEnMasa();
    
    // Buscar la clasificación actual
    final classification = riskEvent.classifications.firstWhere(
      (c) => c.name.toLowerCase() == state.selectedClassification.toLowerCase(),
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
    final riskEvent = RiskEventFactory.getEventByName(state.selectedRiskEvent) ??
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
    final riskEvent = RiskEventFactory.getEventByName(state.selectedRiskEvent) ??
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
      final formData = getCurrentFormData();
      final globalScoreInfo = _calculateGlobalScoreUseCase.getGlobalScoreInfo(formData);
      final score = globalScoreInfo['finalScore'] ?? 0.0;
      
      // Si no hay score (0.0), devolver el color de borde específico
      if (score == 0.0) {
        return const Color(0xFFD1D5DB); // #D1D5DB
      }
      
      return globalScoreInfo['finalColor'] ?? const Color(0xFFD1D5DB);
    } catch (e) {
      return const Color(0xFFD1D5DB); // #D1D5DB
    }
  }

  /// Método de compatibilidad temporal
  String getFormattedThreatRating() {
    try {
      final formData = getCurrentFormData();
      final globalScoreInfo = _calculateGlobalScoreUseCase.getGlobalScoreInfo(formData);
      final score = globalScoreInfo['finalScore'] ?? 0.0;
      final level = globalScoreInfo['finalLevel'] ?? 'SIN CALIFICAR';
      
      if (score == 0.0) {
        return 'SIN CALIFICAR';
      }
      
      // Formatear el score a 1 decimal y agregar el nivel
      return '${score.toStringAsFixed(1)} $level';
    } catch (e) {
      return 'SIN CALIFICAR';
    }
  }

  /// Método de compatibilidad temporal
  Color getThreatTextColor() {
    try {
      final formData = getCurrentFormData();
      final globalScoreInfo = _calculateGlobalScoreUseCase.getGlobalScoreInfo(formData);
      final score = globalScoreInfo['finalScore'] ?? 0.0;
      
      // Si no hay score (0.0), devolver negro para texto sobre fondo gris
      if (score == 0.0) {
        return Colors.black;
      }
      
      final color = globalScoreInfo['finalColor'] ?? Colors.grey;
      // Retornar color de texto basado en el color de fondo
      return color == Colors.grey ? Colors.black : Colors.white;
    } catch (e) {
      return Colors.black;
    }
  }

  /// Método de compatibilidad temporal
  void loadExistingFormData() {
    add(LoadFormData(
      eventName: state.selectedRiskEvent,
      classificationType: state.selectedClassification,
    ));
  }

  /// Método de compatibilidad temporal
  bool hasUnqualifiedVariables() {
    try {
      final formData = getCurrentFormData();
      return _validateUnqualifiedVariablesUseCase.execute(formData);
    } catch (e) {
      return false;
    }
  }

  /// Método de compatibilidad temporal
  bool shouldShowScoreContainer(String subClassificationId) {
    try {
      final formData = getCurrentFormData();
      print('shouldShowScoreContainer - subClassificationId: $subClassificationId');
      print('shouldShowScoreContainer - formData: $formData');
      final score = _calculateScoreUseCase.execute(subClassificationId, formData);
      print('shouldShowScoreContainer - score: $score');
      return score > 0.0;
    } catch (e) {
      print('shouldShowScoreContainer - error: $e');
      return false;
    }
  }

  /// Método de compatibilidad temporal
  double getSubClassificationScore(String subClassificationId) {
    try {
      final formData = getCurrentFormData();
      return _calculateScoreUseCase.execute(subClassificationId, formData);
    } catch (e) {
      return 0.0;
    }
  }

  /// Método de compatibilidad temporal
  Color getSubClassificationColor(String subClassificationId) {
    try {
      final formData = getCurrentFormData();
      final score = _calculateScoreUseCase.execute(subClassificationId, formData);
      return _calculateScoreUseCase.scoreToColor(score);
    } catch (e) {
      return Colors.grey;
    }
  }

  /// Método de compatibilidad temporal
  Map<String, dynamic> getCurrentFormData() {
    try {
      return {
        'amenazaProbabilidadSelections': state.probabilidadSelections,
        'amenazaIntensidadSelections': state.intensidadSelections,
        'vulnerabilidadSelections': state.dynamicSelections,
        'selectedRiskEvent': state.selectedRiskEvent,
        'selectedClassification': state.selectedClassification,
      };
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
