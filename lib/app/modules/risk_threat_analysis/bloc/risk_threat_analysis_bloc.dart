import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:caja_herramientas/app/shared/models/models.dart';
import 'package:caja_herramientas/app/shared/models/risk_model_adapter.dart';
import 'risk_threat_analysis_event.dart';
import 'risk_threat_analysis_state.dart';

class RiskThreatAnalysisBloc extends Bloc<RiskThreatAnalysisEvent, RiskThreatAnalysisState> {
  RiskThreatAnalysisBloc() : super(const RiskThreatAnalysisState()) {
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
  }

  void _onToggleProbabilidadDropdown(
    ToggleProbabilidadDropdown event,
    Emitter<RiskThreatAnalysisState> emit,
  ) {
    emit(state.copyWith(
      isProbabilidadDropdownOpen: !state.isProbabilidadDropdownOpen,
      isIntensidadDropdownOpen: false, // Cerrar el otro dropdown
    ));
  }

  void _onToggleIntensidadDropdown(
    ToggleIntensidadDropdown event,
    Emitter<RiskThreatAnalysisState> emit,
  ) {
    emit(state.copyWith(
      isIntensidadDropdownOpen: !state.isIntensidadDropdownOpen,
      isProbabilidadDropdownOpen: false, // Cerrar el otro dropdown
    ));
  }

  void _onSelectProbabilidad(
    SelectProbabilidad event,
    Emitter<RiskThreatAnalysisState> emit,
  ) {
    emit(state.copyWith(
      selectedProbabilidad: event.probabilidad,
      isProbabilidadDropdownOpen: false, // Cerrar dropdown después de seleccionar
    ));
  }

  void _onSelectIntensidad(
    SelectIntensidad event,
    Emitter<RiskThreatAnalysisState> emit,
  ) {
    emit(state.copyWith(
      selectedIntensidad: event.intensidad,
      isIntensidadDropdownOpen: false, // Cerrar dropdown después de seleccionar
    ));
  }

  void _onResetDropdowns(
    ResetDropdowns event,
    Emitter<RiskThreatAnalysisState> emit,
  ) {
    emit(const RiskThreatAnalysisState());
  }

  void _onChangeBottomNavIndex(
    ChangeBottomNavIndex event,
    Emitter<RiskThreatAnalysisState> emit,
  ) {
    emit(state.copyWith(currentBottomNavIndex: event.index));
  }

  void _onUpdateProbabilidadSelection(
    UpdateProbabilidadSelection event,
    Emitter<RiskThreatAnalysisState> emit,
  ) {
    final updatedSelections = Map<String, String>.from(state.probabilidadSelections);
    updatedSelections[event.category] = event.level;
    
    emit(state.copyWith(probabilidadSelections: updatedSelections));
  }

  void _onUpdateIntensidadSelection(
    UpdateIntensidadSelection event,
    Emitter<RiskThreatAnalysisState> emit,
  ) {
    final updatedSelections = Map<String, String>.from(state.intensidadSelections);
    updatedSelections[event.category] = event.level;
    
    emit(state.copyWith(intensidadSelections: updatedSelections));
  }

  void _onUpdateSelectedRiskEvent(
    UpdateSelectedRiskEvent event,
    Emitter<RiskThreatAnalysisState> emit,
  ) {
    // Solo resetear las selecciones si el evento realmente cambió
    if (state.selectedRiskEvent != event.riskEvent) {
      emit(state.copyWith(
        selectedRiskEvent: event.riskEvent,
        // Reset selections only when event actually changes
        probabilidadSelections: {},
        intensidadSelections: {},
        dropdownOpenStates: {}, // Reset dynamic dropdown states
        dynamicSelections: {}, // Reset dynamic selections
      ));
    } else {
      // Si es el mismo evento, solo actualizar el valor sin resetear
      emit(state.copyWith(
        selectedRiskEvent: event.riskEvent,
      ));
    }
  }

  void _onSelectClassification(
    SelectClassification event,
    Emitter<RiskThreatAnalysisState> emit,
  ) {
    // Solo resetear las selecciones si la clasificación realmente cambió
    if (state.selectedClassification != event.classification) {
      emit(state.copyWith(
        selectedClassification: event.classification,
        // Reset selections only when classification actually changes
        probabilidadSelections: {},
        intensidadSelections: {},
        dropdownOpenStates: {}, // Reset dynamic dropdown states
        dynamicSelections: {}, // Reset dynamic selections
      ));
    } else {
      // Si es la misma clasificación, solo actualizar el valor sin resetear
      emit(state.copyWith(
        selectedClassification: event.classification,
      ));
    }
  }

  void _onToggleDynamicDropdown(
    ToggleDynamicDropdown event,
    Emitter<RiskThreatAnalysisState> emit,
  ) {
    final currentStates = Map<String, bool>.from(state.dropdownOpenStates);
    final subClassificationId = event.subClassificationId;
    final isCurrentlyOpen = currentStates[subClassificationId] ?? false;
    
    // Close all other dropdowns and toggle this one
    final newStates = <String, bool>{};
    for (final key in currentStates.keys) {
      newStates[key] = key == subClassificationId ? !isCurrentlyOpen : false;
    }
    newStates[subClassificationId] = !isCurrentlyOpen;

    emit(state.copyWith(
      dropdownOpenStates: newStates,
    ));
  }

  void _onUpdateDynamicSelection(
    UpdateDynamicSelection event,
    Emitter<RiskThreatAnalysisState> emit,
  ) {
    final currentSelections = Map<String, Map<String, String>>.from(state.dynamicSelections);
    final subClassificationId = event.subClassificationId;
    
    // Initialize the subclassification map if it doesn't exist
    if (!currentSelections.containsKey(subClassificationId)) {
      currentSelections[subClassificationId] = <String, String>{};
    }
    
    // Update the selection for this category
    currentSelections[subClassificationId]![event.category] = event.level;
    
    // NO cerrar el dropdown después de la selección - mantenerlo abierto
    // para permitir múltiples selecciones en la misma subclasificación

    emit(state.copyWith(
      dynamicSelections: currentSelections,
      // No modificar dropdownOpenStates - mantener el estado actual
    ));
  }

  // Método helper para calcular el promedio de probabilidad
  double calculateProbabilidadAverage() {
    if (state.probabilidadSelections.isEmpty) return 0.0;
    
    double totalScore = 0.0;
    int count = 0;
    
    for (final level in state.probabilidadSelections.values) {
      int value = _getLevelValue(level);
      if (value > 0) {
        totalScore += value;
        count++;
      }
    }
    
    return count > 0 ? totalScore / count : 0.0;
  }

  // Método helper para calcular el promedio de intensidad
  double calculateIntensidadAverage() {
    if (state.intensidadSelections.isEmpty) return 0.0;
    
    double totalScore = 0.0;
    int count = 0;
    
    for (final level in state.intensidadSelections.values) {
      int value = _getLevelValue(level);
      if (value > 0) {
        totalScore += value;
        count++;
      }
    }
    
    return count > 0 ? totalScore / count : 0.0;
  }

  // Método helper para mapear niveles a valores numéricos
  int _getLevelValue(String level) {
    if (level.contains('BAJO') && !level.contains('MEDIO')) {
      return 1;
    } else if (level.contains('MEDIO') && level.contains('ALTO')) {
      return 3;
    } else if (level.contains('MEDIO')) {
      return 2;
    } else if (level.contains('ALTO')) {
      return 4;
    }
    return 0;
  }

  /// Obtiene la calificación (wi * value) de una categoría específica
  /// basándose en la selección actual del usuario en el dropdown
  int getCategoryCalificacion(String subClassificationId, String categoryId, int wi) {
    final selections = getSelectionsForSubClassification(subClassificationId);
    final selectedLevel = selections[categoryId];
    
    if (selectedLevel == null) return 0;
    
    final value = _getLevelValue(selectedLevel);
    return wi * value;
  }

  // Método helper para obtener la calificación ponderada desde el modelo cuando esté disponible
  double _getCategoryWeightedScore(String subClassificationId, String categoryTitle) {
    try {
      final selectedEvent = state.selectedRiskEvent;
      final eventModel = RiskModelAdapter.getEventModel(selectedEvent);
      
      if (eventModel != null) {
        final classification = eventModel.getClassificationById(state.selectedClassification);
        if (classification != null) {
          final subClassification = classification.subClassifications
              .where((sub) => sub.id == subClassificationId)
              .firstOrNull;
          
          if (subClassification != null) {
            final category = subClassification.categories
                .where((cat) => cat.title == categoryTitle)
                .firstOrNull;
            
            if (category != null) {
              // Usar la calificación ponderada del modelo (value * wi)
              return category.weightedScore;
            }
          }
        }
      }
      
      // Fallback: usar el método anterior sin ponderación
      final selectedLevel = getSelectionsForSubClassification(subClassificationId)[categoryTitle];
      return selectedLevel != null ? _getLevelValue(selectedLevel).toDouble() : 0.0;
    } catch (e) {
      // En caso de error, usar el método de fallback
      final selectedLevel = getSelectionsForSubClassification(subClassificationId)[categoryTitle];
      return selectedLevel != null ? _getLevelValue(selectedLevel).toDouble() : 0.0;
    }
  }

  // Método para obtener la calificación de toda una subclasificación (promedio)
  double getSubClassificationCalificacion(String subClassificationId) {
    final riskCategories = _getRiskCategoriesForSubClassification(subClassificationId);
    final selections = getSelectionsForSubClassification(subClassificationId);
    
    if (riskCategories.isEmpty || selections.isEmpty) return 0.0;
    
    double totalCalificacion = 0.0;
    int validCategories = 0;
    
    for (final category in riskCategories) {
      final selectedValue = selections[category.title];
      if (selectedValue != null) {
        final levelValue = _getLevelValue(selectedValue);
        final calificacion = category.wi * levelValue;
        totalCalificacion += calificacion;
        validCategories++;
      }
    }
    
    return validCategories > 0 ? totalCalificacion / validCategories : 0.0;
  }
  
  // Método para obtener detalles de cálculo de una subclasificación
  Map<String, dynamic> getSubClassificationCalculationDetails(String subClassificationId) {
    final riskCategories = _getRiskCategoriesForSubClassification(subClassificationId);
    final selections = getSelectionsForSubClassification(subClassificationId);
    
    final List<Map<String, dynamic>> categoryDetails = [];
    double totalCalificacion = 0.0;
    int validCategories = 0;
    
    for (final category in riskCategories) {
      final selectedValue = selections[category.title];
      if (selectedValue != null) {
        final levelValue = _getLevelValue(selectedValue);
        final calificacion = category.wi * levelValue;
        
        categoryDetails.add({
          'title': category.title,
          'wi': category.wi,
          'value': levelValue,
          'calificacion': calificacion,
          'selectedLevel': selectedValue,
        });
        
        totalCalificacion += calificacion;
        validCategories++;
      }
    }
    
    final promedio = validCategories > 0 ? totalCalificacion / validCategories : 0.0;
    
    return {
      'categories': categoryDetails,
      'totalCalificacion': totalCalificacion,
      'promedio': promedio,
      'validCategories': validCategories,
    };
  }
  
  // Método helper para obtener las RiskCategory (que tienen wi) para una subclasificación
  List<RiskCategory> _getRiskCategoriesForSubClassification(String subClassificationId) {
    final currentEvent = state.selectedRiskEvent;
    
    try {
      RiskEventModel? event;
      
      switch (currentEvent) {
        case 'Movimiento en Masa':
          event = RiskEventFactory.createMovimientoEnMasa();
          break;
        case 'Incendio Forestal':
          event = RiskEventFactory.createIncendioForestal();
          break;
        case 'Inundación':
          event = RiskEventFactory.createInundacion();
          break;
        case 'Avenida Torrencial':
          event = RiskEventFactory.createAvenidaTorrencial();
          break;
        case 'Estructural':
          event = RiskEventFactory.createEstructural();
          break;
        case 'Otros':
          event = RiskEventFactory.createOtros();
          break;
        default:
          event = RiskEventFactory.createMovimientoEnMasa();
      }
      
      // Buscar en todas las clasificaciones y subclasificaciones
      for (final classification in event.classifications) {
        for (final subClassification in classification.subClassifications) {
          if (subClassification.id == subClassificationId) {
            return subClassification.categories;
          }
        }
      }
      return [];
    } catch (e) {
      return [];
    }
  }

  // Método para calcular la calificación final (amenaza o vulnerabilidad)
  String calculateThreatRating() {
    if (state.selectedClassification == 'amenaza') {
      return _calculateAmenazaRating();
    } else {
      return _calculateVulnerabilidadRating();
    }
  }

  // Método específico para calcular calificación de amenaza
  String _calculateAmenazaRating() {
    final probAverage = calculateProbabilidadAverage();
    final intAverage = calculateIntensidadAverage();
    
    if (probAverage == 0.0 || intAverage == 0.0) {
      return 'SIN CALIFICAR';
    }
    
    final finalScore = (probAverage + intAverage) / 2;
    
    if (finalScore <= 1.5) {
      return 'BAJO';
    } else if (finalScore <= 2.5) {
      return 'MEDIO';
    } else if (finalScore <= 3.5) {
      return 'MEDIO-ALTO';
    } else {
      return 'ALTO';
    }
  }

  // Método específico para calcular calificación de vulnerabilidad usando calificaciones ponderadas
  String _calculateVulnerabilidadRating() {
    final subClassifications = getCurrentSubClassifications();
    
    if (subClassifications.isEmpty) {
      return 'SIN CALIFICAR';
    }
    
    // Calcular el promedio ponderado de todas las subclasificaciones de vulnerabilidad
    double totalWeightedScore = 0.0;
    double totalWeight = 0.0;
    
    for (final subClassification in subClassifications) {
      final selections = state.dynamicSelections[subClassification.id] ?? {};
      
      if (selections.isNotEmpty) {
        double subWeightedScore = 0.0;
        double subWeight = 0.0;
        
        // Calcular score ponderado para cada categoría en esta subclasificación
        for (final categoryTitle in selections.keys) {
          // Obtener la categoría del modelo para acceder al peso wi
          final selectedEvent = state.selectedRiskEvent;
          final eventModel = RiskModelAdapter.getEventModel(selectedEvent);
          
          if (eventModel != null) {
            final classification = eventModel.getClassificationById(state.selectedClassification);
            if (classification != null) {
              final subClass = classification.subClassifications
                  .where((sub) => sub.id == subClassification.id)
                  .firstOrNull;
              
              if (subClass != null) {
                final riskCategory = subClass.categories
                    .where((cat) => cat.title == categoryTitle)
                    .firstOrNull;
                
                if (riskCategory != null) {
                  final weightedScore = riskCategory.weightedScore;
                  if (weightedScore > 0) {
                    subWeightedScore += weightedScore;
                    subWeight += riskCategory.wi;
                  }
                }
              }
            }
          }
        }
        
        if (subWeight > 0) {
          totalWeightedScore += subWeightedScore;
          totalWeight += subWeight;
        }
      }
    }
    
    if (totalWeight == 0) {
      return 'SIN CALIFICAR';
    }
    
    final finalScore = totalWeightedScore / totalWeight;
    
    if (finalScore <= 1.5) {
      return 'BAJO';
    } else if (finalScore <= 2.5) {
      return 'MEDIO';
    } else if (finalScore <= 3.5) {
      return 'MEDIO-ALTO';
    } else {
      return 'ALTO';
    }
  }

  // Método para calcular el porcentaje de completado
  double calculateCompletionPercentage() {
    // Obtener las subclasificaciones actuales para calcular el total dinámicamente
    final subClassifications = getCurrentSubClassifications();
    
    if (subClassifications.isEmpty) return 0.0;
    
    // Calcular el total de categorías dinámicamente
    int totalCategories = 0;
    int completedCategories = 0;
    
    for (final subClassification in subClassifications) {
      final categories = getCategoriesForCurrentSubClassification(subClassification.id);
      totalCategories += categories.length;
      
      // Contar categorías completadas
      if (subClassification.id == 'probabilidad') {
        completedCategories += state.probabilidadSelections.length;
      } else if (subClassification.id == 'intensidad') {
        completedCategories += state.intensidadSelections.length;
      } else {
        // Para subclasificaciones dinámicas (como vulnerabilidad)
        final selections = state.dynamicSelections[subClassification.id] ?? {};
        completedCategories += selections.length;
      }
    }
    
    return totalCategories > 0 ? completedCategories / totalCategories : 0.0;
  }

  // Método para obtener el puntaje final numérico
  double calculateFinalScore() {
    if (state.selectedClassification == 'amenaza') {
      return _calculateAmenazaFinalScore();
    } else {
      return _calculateVulnerabilidadFinalScore();
    }
  }

  // Método específico para calcular puntaje final de amenaza
  double _calculateAmenazaFinalScore() {
    final probAverage = calculateProbabilidadAverage();
    final intAverage = calculateIntensidadAverage();
    
    if (probAverage == 0.0 || intAverage == 0.0) {
      return 0.0;
    }
    
    return (probAverage + intAverage) / 2;
  }

  // Método específico para calcular puntaje final de vulnerabilidad usando calificaciones ponderadas
  double _calculateVulnerabilidadFinalScore() {
    final subClassifications = getCurrentSubClassifications();
    
    if (subClassifications.isEmpty) {
      return 0.0;
    }
    
    // Calcular el promedio ponderado de todas las subclasificaciones de vulnerabilidad
    double totalWeightedScore = 0.0;
    double totalWeight = 0.0;
    
    for (final subClassification in subClassifications) {
      final selections = state.dynamicSelections[subClassification.id] ?? {};
      
      if (selections.isNotEmpty) {
        // Calcular score ponderado para cada categoría en esta subclasificación
        for (final categoryTitle in selections.keys) {
          // Obtener la categoría del modelo para acceder al peso wi
          final selectedEvent = state.selectedRiskEvent;
          final eventModel = RiskModelAdapter.getEventModel(selectedEvent);
          
          if (eventModel != null) {
            final classification = eventModel.getClassificationById(state.selectedClassification);
            if (classification != null) {
              final subClass = classification.subClassifications
                  .where((sub) => sub.id == subClassification.id)
                  .firstOrNull;
              
              if (subClass != null) {
                final riskCategory = subClass.categories
                    .where((cat) => cat.title == categoryTitle)
                    .firstOrNull;
                
                if (riskCategory != null) {
                  totalWeightedScore += riskCategory.weightedScore;
                  totalWeight += riskCategory.wi;
                }
              }
            }
          }
        }
      }
    }
    
    return totalWeight > 0 ? totalWeightedScore / totalWeight : 0.0;
  }

  // Método para obtener el color de fondo basado en la calificación
  Color getThreatBackgroundColor() {
    final rating = calculateThreatRating();
    
    switch (rating) {
      case 'BAJO':
        return const Color(0xFF22C55E); // Verde
      case 'MEDIO':
        return const Color(0xFFFDE047); // Amarillo
      case 'MEDIO-ALTO':
        return const Color(0xFFFB923C); // Naranja
      case 'ALTO':
        return const Color(0xFFDC2626); // Rojo
      default:
        return const Color(0xFFD1D5DB); // Gris
    }
  }

  // Método para obtener el color del texto basado en la calificación
  Color getThreatTextColor() {
    final rating = calculateThreatRating();
    
    switch (rating) {
      case 'BAJO':
      case 'MEDIO-ALTO':
      case 'ALTO':
        return const Color(0xFFFFFFFF); // Blanco
      case 'MEDIO':
      default:
        return const Color(0xFF1E1E1E); // Negro/Gris oscuro
    }
  }

  // Método para obtener el texto formateado de la calificación
  String getFormattedThreatRating() {
    final rating = calculateThreatRating();
    
    if (rating == 'SIN CALIFICAR') {
      return rating;
    }
    
    final score = calculateFinalScore().toStringAsFixed(1).replaceAll('.', ',');
    
    // Si el rating es largo, usar salto de línea
    if (rating.length > 5) {
      return '$score\n$rating';
    }
    
    return '$score $rating';
  }

  // Método para obtener categorías dinámicas basadas en el evento seleccionado
  List<DropdownCategory> getCategoriesForEvent(String selectedEvent) {
    // Usar el nuevo modelo jerárquico con adaptador para mantener compatibilidad
    final categories = RiskModelAdapter.getProbabilityCategoriesForEvent(selectedEvent);
    
    if (categories.isNotEmpty) {
      return categories;
    }
    
    switch (selectedEvent) {
      case 'Movimiento en Masa':
        return DropdownCategory.movimientoEnMasaCategories;
      case 'Incendio Forestal':
        return DropdownCategory.incendioForestalCategories;
      case 'Inundación':
        return DropdownCategory.inundacionCategories;
      case 'Avenida Torrencial':
        return DropdownCategory.avenidaTorrencialCategories;
      default:
        return DropdownCategory.defaultCategories;
    }
  }

  // Método para obtener categorías dinámicas basadas en el evento seleccionado desde el estado interno
  List<DropdownCategory> getCategoriesForSelectedEvent() {
    final selectedEvent = state.selectedRiskEvent;
    final categories = getCategoriesForEvent(selectedEvent);
    return categories;
  }

  List<DropdownCategory> getIntensidadCategories() {
    final selectedEvent = state.selectedRiskEvent;
    
    final categories = RiskModelAdapter.getIntensityCategoriesForEvent(selectedEvent);
    
    if (categories.isNotEmpty) {
      return categories;
    }
    
    // Fallback al sistema antiguo si el nuevo no tiene datos
    switch (selectedEvent) {
      case 'Movimiento en Masa':
        return DropdownCategory.movimientoEnMasaIntensidadCategories;
      case 'Incendio Forestal':
        return DropdownCategory.incendioForestalIntensidadCategories;
      case 'Inundación':
        return DropdownCategory.inundacionIntensidadCategories;
      case 'Avenida Torrencial':
        return DropdownCategory.avenidaTorrencialIntensidadCategories;
      default:
        return DropdownCategory.defaultIntensidadCategories;
    }
  }

  /// Obtiene todas las subclasificaciones de amenaza para el evento seleccionado
  List<RiskSubClassification> getAmenazaSubClassifications() {
    final selectedEvent = state.selectedRiskEvent;
    final threatClassifications = RiskModelAdapter.getThreatSubClassifications(selectedEvent);
    return threatClassifications;
  }

  /// Obtiene las categorías para una subclasificación específica
  List<DropdownCategory> getCategoriesForSubClassification(String subClassificationId) {
    final selectedEvent = state.selectedRiskEvent;
    final eventModel = RiskModelAdapter.getEventModel(selectedEvent);
    
    if (eventModel != null) {
      final amenazaClassification = eventModel.getClassificationById('amenaza');
      if (amenazaClassification != null) {
        final subClassification = amenazaClassification.subClassifications
            .where((sub) => sub.id == subClassificationId)
            .firstOrNull;
        
        if (subClassification != null) {
          final categories = RiskModelAdapter.convertToDropdownCategories(subClassification.categories);
          return categories;
        }
      }
    }
    
    // Fallback al sistema antiguo
    if (subClassificationId == 'probabilidad') {
      return getCategoriesForSelectedEvent();
    } else if (subClassificationId == 'intensidad') {
      return getIntensidadCategories();
    }
    
    return [];
  }

  /// Obtiene todas las subclasificaciones de vulnerabilidad para el evento seleccionado
  List<RiskSubClassification> getVulnerabilidadSubClassifications() {
    final selectedEvent = state.selectedRiskEvent;
    final eventModel = RiskModelAdapter.getEventModel(selectedEvent);
    
    if (eventModel != null) {
      final vulnerabilidadClassification = eventModel.getClassificationById('vulnerabilidad');
      if (vulnerabilidadClassification != null) {
        return vulnerabilidadClassification.subClassifications;
      }
    }
    
    return [];
  }

  /// Obtiene las subclasificaciones basadas en la clasificación seleccionada (amenaza o vulnerabilidad)
  List<RiskSubClassification> getCurrentSubClassifications() {
    switch (state.selectedClassification) {
      case 'amenaza':
        return getAmenazaSubClassifications();
      case 'vulnerabilidad':
        return getVulnerabilidadSubClassifications();
      default:
        return getAmenazaSubClassifications();
    }
  }

  /// Obtiene las categorías para una subclasificación específica considerando la clasificación actual
  List<DropdownCategory> getCategoriesForCurrentSubClassification(String subClassificationId) {
    final selectedEvent = state.selectedRiskEvent;
    final eventModel = RiskModelAdapter.getEventModel(selectedEvent);
    
    if (eventModel != null) {
      final classification = eventModel.getClassificationById(state.selectedClassification);
      if (classification != null) {
        final subClassification = classification.subClassifications
            .where((sub) => sub.id == subClassificationId)
            .firstOrNull;
        
        if (subClassification != null) {
          final categories = RiskModelAdapter.convertToDropdownCategories(subClassification.categories);
          return categories;
        }
      }
    }
    
    // Fallback to original method for amenaza
    if (state.selectedClassification == 'amenaza') {
      return getCategoriesForSubClassification(subClassificationId);
    }
    
    return [];
  }

  // ============================================================================
  // MÉTODOS DE LÓGICA DE DROPDOWN (MOVIDOS DESDE UI)
  // ============================================================================

  /// Obtiene el valor seleccionado para una subclasificación específica
  String? getValueForSubClassification(String subClassificationId) {
    switch (subClassificationId) {
      case 'probabilidad':
        return state.selectedProbabilidad;
      case 'intensidad':
        return state.selectedIntensidad;
      default:
        // Check in dynamic selections
        return null;
    }
  }

  /// Verifica si el dropdown está abierto para una subclasificación específica
  bool getIsSelectedForSubClassification(String subClassificationId) {
    switch (subClassificationId) {
      case 'probabilidad':
        return state.isProbabilidadDropdownOpen;
      case 'intensidad':
        return state.isIntensidadDropdownOpen;
      default:
        // Check in dynamic dropdown states
        return state.dropdownOpenStates[subClassificationId] ?? false;
    }
  }

  /// Maneja el tap en un dropdown específico
  void handleDropdownTap(String subClassificationId) {
    // For vulnerabilidad and other dynamic sub-classifications, use the generic event
    if (subClassificationId != 'probabilidad' && subClassificationId != 'intensidad') {
      add(ToggleDynamicDropdown(subClassificationId));
      return;
    }
    
    // Legacy support for amenaza dropdowns
    switch (subClassificationId) {
      case 'probabilidad':
        add(ToggleProbabilidadDropdown());
        break;
      case 'intensidad':
        add(ToggleIntensidadDropdown());
        break;
    }
  }

  /// Maneja la selección de una categoría en un dropdown específico
  void handleSelectionChanged(String subClassificationId, String category, String level) {
    // For vulnerabilidad and other dynamic sub-classifications, use the generic event
    if (subClassificationId != 'probabilidad' && subClassificationId != 'intensidad') {
      add(UpdateDynamicSelection(subClassificationId, category, level));
      return;
    }
    
    // Legacy support for amenaza dropdowns
    switch (subClassificationId) {
      case 'probabilidad':
        add(UpdateProbabilidadSelection(category, level));
        break;
      case 'intensidad':
        add(UpdateIntensidadSelection(category, level));
        break;
    }
  }

  /// Obtiene las selecciones para una subclasificación específica (genérico)
  Map<String, String> getSelectionsForSubClassification(String subClassificationId) {
    switch (subClassificationId) {
      case 'probabilidad':
        return state.probabilidadSelections;
      case 'intensidad':
        return state.intensidadSelections;
      default:
        return state.dynamicSelections[subClassificationId] ?? {};
    }
  }

}