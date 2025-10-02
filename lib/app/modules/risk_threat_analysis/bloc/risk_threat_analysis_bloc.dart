import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:caja_herramientas/app/shared/models/models.dart';
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
      // Determinar qué selecciones resetear basado en la nueva clasificación
      Map<String, String> newProbabilidadSelections = state.probabilidadSelections;
      Map<String, String> newIntensidadSelections = state.intensidadSelections;
      Map<String, Map<String, String>> newDynamicSelections = state.dynamicSelections;
      
      if (event.classification.toLowerCase() == 'amenaza') {
        // Si cambiamos a amenaza, resetear solo las selecciones de amenaza
        newProbabilidadSelections = {};
        newIntensidadSelections = {};
        // Mantener las selecciones dinámicas de vulnerabilidad
      } else if (event.classification.toLowerCase() == 'vulnerabilidad') {
        // Si cambiamos a vulnerabilidad, resetear solo las selecciones dinámicas de vulnerabilidad
        // Mantener las selecciones de amenaza (probabilidad e intensidad)
        newDynamicSelections = {};
      }
      
      emit(state.copyWith(
        selectedClassification: event.classification,
        probabilidadSelections: newProbabilidadSelections,
        intensidadSelections: newIntensidadSelections,
        dropdownOpenStates: {}, // Reset dropdown states
        dynamicSelections: newDynamicSelections,
        currentBottomNavIndex: 0, // Reset navigation to start from the beginning
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
    
    // Recalcular los scores y colores para todas las subclasificaciones
    final updatedScores = _calculateAllSubClassificationScores(currentSelections);
    final updatedColors = _calculateAllSubClassificationColors(updatedScores);

    emit(state.copyWith(
      dynamicSelections: currentSelections,
      subClassificationScores: updatedScores,
      subClassificationColors: updatedColors,
    ));
  }

  // Calcula todos los scores de subclasificaciones
  Map<String, double> _calculateAllSubClassificationScores(Map<String, Map<String, String>> selections) {
    final scores = <String, double>{};
    
    for (final subClassificationId in selections.keys) {
      scores[subClassificationId] = _calculateSubClassificationScore(subClassificationId, selections);
    }
    
    return scores;
  }

  // Calcula todos los colores de subclasificaciones
  Map<String, Color> _calculateAllSubClassificationColors(Map<String, double> scores) {
    final colors = <String, Color>{};
    
    for (final entry in scores.entries) {
      colors[entry.key] = _getScoreColor(entry.value);
    }
    
    return colors;
  }

  // Calcula el score de una subclasificación específica
  double _calculateSubClassificationScore(String subClassificationId, Map<String, Map<String, String>> selections) {
    final subSelections = selections[subClassificationId] ?? {};
    if (subSelections.isEmpty) return 0.0;

    // Determinar el tipo de cálculo según el contexto
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

  // Determina qué tipo de cálculo aplicar según el contexto
  String _getCalculationType(String subClassificationId) {
    final eventName = state.selectedRiskEvent;
    final classification = state.selectedClassification;
    
    // Movimiento en Masa - Amenaza - Probabilidad (con variable crítica: Evidencias de Materialización)
    if (eventName == 'Movimiento en Masa' && classification == 'amenaza' && subClassificationId == 'probabilidad') {
      return 'critical_variable';
    }
    
    // Movimiento en Masa - Amenaza - Intensidad (con variable crítica: Potencial de Daño en Edificaciones)
    if (eventName == 'Movimiento en Masa' && classification == 'amenaza' && subClassificationId == 'intensidad') {
      return 'critical_variable';
    }
    
    // Movimiento en Masa - Vulnerabilidad - Fragilidad Física (con regla de tope especial)
    if (eventName == 'Movimiento en Masa' && classification == 'vulnerabilidad' && subClassificationId == 'fragilidad_fisica') {
      return 'critical_variable';
    }
    
    // Movimiento en Masa - Vulnerabilidad - Fragilidad en Personas (con regla de tope especial)
    if (eventName == 'Movimiento en Masa' && classification == 'vulnerabilidad' && subClassificationId == 'fragilidad_personas') {
      return 'critical_variable';
    }
    
    // Movimiento en Masa - Vulnerabilidad - Exposición (siempre promedio ponderado, sin tope)
    if (eventName == 'Movimiento en Masa' && classification == 'vulnerabilidad' && subClassificationId == 'exposicion') {
      return 'weighted_average';
    }
    
    // Movimiento en Masa - Vulnerabilidad - Otras subclasificaciones (promedio ponderado)
    if (eventName == 'Movimiento en Masa' && classification == 'vulnerabilidad') {
      return 'weighted_average';
    }
    
    // Inundación - todas las clasificaciones y subclasificaciones
    if (eventName == 'Inundación') {
      return 'weighted_average';
    }
    
    // Incendio Forestal - todas las clasificaciones y subclasificaciones
    if (eventName == 'Incendio Forestal') {
      return 'weighted_average';
    }
    
    // Por defecto: promedio simple
    return 'simple_average';
  }

  // Calcula usando variable crítica para Movimiento en Masa (Probabilidad, Intensidad y Vulnerabilidad)
  double _calculateWithCriticalVariable(String subClassificationId, Map<String, String> selections) {
    final eventName = state.selectedRiskEvent;
    
    if (eventName == 'Movimiento en Masa') {
      if (subClassificationId == 'probabilidad') {
        return _calculateMovimientoEnMasaProbabilidad(selections);
      } else if (subClassificationId == 'intensidad') {
        return _calculateMovimientoEnMasaIntensidad(selections);
      } else if (subClassificationId == 'fragilidad_fisica') {
        return _calculateMovimientoEnMasaFragilidadFisica(selections);
      } else if (subClassificationId == 'fragilidad_personas') {
        return _calculateMovimientoEnMasaFragilidadPersonas(selections);
      }
    }
    
    // Fallback a cálculo ponderado para otros casos
    return _calculateWeightedAverage(subClassificationId, selections);
  }

  // Fórmula específica para Movimiento en Masa - Probabilidad
  double _calculateMovimientoEnMasaProbabilidad(Map<String, String> selections) {
    // Variable crítica: "Evidencias de Materialización o Reactivación"
    final evidenciasValue = _getSelectedLevelValue('Evidencias de Materialización o Reactivación', selections);
    
    // Si la variable crítica tiene valor 4 (ALTO), devolver 4 directamente
    if (evidenciasValue == 4) {
      return 4.0;
    }
    
    // Si no, calcular usando promedio ponderado
    return _calculateWeightedAverage('probabilidad', selections);
  }

  // Fórmula específica para Movimiento en Masa - Intensidad
  double _calculateMovimientoEnMasaIntensidad(Map<String, String> selections) {
    // PASO 1: Revisar la condición - Variable crítica: "Potencial de Daño en Edificaciones"
    // Si esta variable = 4 (ALTO), significa que el daño en edificaciones es crítico
    final potencialDanoValue = _getSelectedLevelValue('Potencial de Daño en Edificaciones', selections);
    
    // CASO ESPECIAL: Si el daño en edificaciones es crítico (4) → intensidad = 4 directamente
    if (potencialDanoValue == 4) {
      return 4.0;
    }
    
    // PASO 2-5: CASO NORMAL - Promedio ponderado de las tres variables:
    // - Potencial de Daño en Edificaciones (Wi específico)
    // - Capacidad de Generar Pérdida de Vidas Humanas (Wi específico)  
    // - Alteración del Funcionamiento de Líneas Vitales y Espacio Público (Wi específico)
    // Fórmula: SUM(calificaciones) / SUM(pesos Wi)
    return _calculateWeightedAverage('intensidad', selections);
  }

  // Fórmula específica para Movimiento en Masa - Fragilidad Física
  double _calculateMovimientoEnMasaFragilidadFisica(Map<String, String> selections) {
    // PASO 1: Verificar regla de tope
    final amenazaGlobal = _calculateAmenazaGlobalScore();
    final potencialDanoEdificaciones = _getPotencialDanoEdificacionesFromAmenaza();
    
    // REGLA DE TOPE: Si amenaza global ≥ 2.6 Y potencial daño edificaciones = 4 → fragilidad = 4
    if (amenazaGlobal >= 2.6 && potencialDanoEdificaciones == 4) {
      return 4.0;
    }
    
    // CASO NORMAL: Promedio ponderado de las variables de fragilidad física
    return _calculateWeightedAverage('fragilidad_fisica', selections);
  }

  // Fórmula específica para Movimiento en Masa - Fragilidad en Personas
  double _calculateMovimientoEnMasaFragilidadPersonas(Map<String, String> selections) {
    // PASO 1: Verificar regla de tope
    final amenazaGlobal = _calculateAmenazaGlobalScore();
    final potencialDanoEdificaciones = _getPotencialDanoEdificacionesFromAmenaza();
    
    // REGLA DE TOPE: Si amenaza global ≥ 2.6 Y potencial daño edificaciones = 4 → fragilidad = 4
    if (amenazaGlobal >= 2.6 && potencialDanoEdificaciones == 4) {
      return 4.0;
    }
    
    // CASO NORMAL: Promedio ponderado de las variables de fragilidad en personas
    return _calculateWeightedAverage('fragilidad_personas', selections);
  }

  // Método para calcular la amenaza global (con pesos específicos para Movimiento en Masa)
  // Método público para acceso externo
  double calculateAmenazaGlobalScore() {
    return _calculateAmenazaGlobalScore();
  }

  double _calculateAmenazaGlobalScore() {
    final eventName = state.selectedRiskEvent;
    
    // Para Movimiento en Masa: usar el cálculo ponderado
    if (eventName == 'Movimiento en Masa') {
      return _calculateMovimientoEnMasaAmenazaFinal();
    }
    
    // Para otros eventos: promedio simple
    final probabilidadScore = state.subClassificationScores['probabilidad'] ?? 0.0;
    final intensidadScore = state.subClassificationScores['intensidad'] ?? 0.0;
    
    // Si alguno es 0, no hay amenaza global calculable
    if (probabilidadScore == 0.0 || intensidadScore == 0.0) {
      return 0.0;
    }
    
    // Promedio simple para otros eventos
    return (probabilidadScore + intensidadScore) / 2;
  }

  // Método para obtener el valor de "Potencial de Daño en Edificaciones" desde la amenaza
  int _getPotencialDanoEdificacionesFromAmenaza() {
    // Buscar en las selecciones de intensidad (amenaza)
    final intensidadSelections = state.dynamicSelections['intensidad'] ?? {};
    return _getSelectedLevelValue('Potencial de Daño en Edificaciones', intensidadSelections);
  }

  // Calcula promedio ponderado usando los valores Wi del RiskEventFactory
  double _calculateWeightedAverage(String subClassificationId, Map<String, String> selections) {
    try {
      // Obtener el modelo del evento actual
      final eventModel = _getCurrentEventModel();
      if (eventModel == null) return _calculateSimpleAverage(subClassificationId, selections);
      
      // Obtener la clasificación actual (amenaza/vulnerabilidad)
      final classification = eventModel.classifications
          .where((c) => c.id == state.selectedClassification)
          .firstOrNull;
      if (classification == null) return _calculateSimpleAverage(subClassificationId, selections);
      
      // Obtener la subclasificación actual (probabilidad/intensidad/etc.)
      final subClassification = classification.subClassifications
          .where((s) => s.id == subClassificationId)
          .firstOrNull;
      if (subClassification == null) return _calculateSimpleAverage(subClassificationId, selections);
      
      // Calcular usando fórmula ponderada: SUM(calificación * wi) / SUM(wi)
      double sumCalificacionPorWi = 0.0;
      double sumWi = 0.0;
      
      for (final category in subClassification.categories) {
        final selectedLevel = selections[category.title];
        if (selectedLevel != null && selectedLevel.isNotEmpty && selectedLevel != 'NA') {
          final calificacion = _getSelectedLevelValue(category.title, {category.title: selectedLevel});
          if (calificacion > 0) { // Excluir 0 y -1 (NA)
            sumCalificacionPorWi += (calificacion * category.wi);
            sumWi += category.wi;
          }
        }
      }
      
      return sumWi > 0 ? sumCalificacionPorWi / sumWi : 0.0;
      
    } catch (e) {
      // Fallback en caso de error
      return _calculateSimpleAverage(subClassificationId, selections);
    }
  }

  // Obtiene el modelo del evento actual
  RiskEventModel? _getCurrentEventModel() {
    final eventName = state.selectedRiskEvent;
    
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

  // Calcula promedio simple
  double _calculateSimpleAverage(String subClassificationId, Map<String, String> selections) {
    if (selections.isEmpty) return 0.0;
    
    double totalScore = 0.0;
    int count = 0;
    
    for (final entry in selections.entries) {
      final value = _getSelectedLevelValue(entry.key, {entry.key: entry.value});
      // Solo incluir valores válidos (excluir 0 y -1 que es NA)
      if (value > 0) {
        totalScore += value;
        count++;
      }
    }
    
    return count > 0 ? totalScore / count : 0.0;
  }

  // Obtiene el valor numérico del nivel seleccionado
  int _getSelectedLevelValue(String categoryTitle, Map<String, String> selections) {
    final selectedLevel = selections[categoryTitle];
    if (selectedLevel == null) return 0;
    
    // Si es "No Aplica", devolver -1 para diferenciarlo
    if (selectedLevel == 'NA') return -1;
    
    // Mapear los niveles a sus valores numéricos
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

  // Obtiene el color basado en el score
  Color _getScoreColor(double score) {
    if (score == 0) {
      return Colors.transparent; // No mostrar si no hay score
    } else if (score <= 1.75) {
      return const Color(0xFF22C55E); // Verde - BAJO (1.00 a 1.75)
    } else if (score <= 2.50) {
      return const Color(0xFFFDE047); // Amarillo - MEDIO-BAJO (>1.75 a 2.50)
    } else if (score <= 3.25) {
      return const Color(0xFFFB923C); // Naranja - MEDIO-ALTO (>2.50 a 3.25)
    } else {
      return const Color(0xFFDC2626); // Rojo - ALTO (>3.25 a 4.00)
    }
  }

  // Métodos públicos para acceder a los cálculos desde los widgets
  double getSubClassificationScore(String subClassificationId) {
    return state.subClassificationScores[subClassificationId] ?? 0.0;
  }

  Color getSubClassificationColor(String subClassificationId) {
    return state.subClassificationColors[subClassificationId] ?? Colors.transparent;
  }

  bool shouldShowScoreContainer(String subClassificationId) {
    final score = getSubClassificationScore(subClassificationId);
    return score > 0;
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
    final finalScore = _calculateAmenazaFinalScore();
    
    if (finalScore == 0.0) {
      return 'SIN CALIFICAR';
    }
    
    // Rangos específicos para la clasificación de amenaza
    if (finalScore <= 1.75) {
      return 'BAJO';
    } else if (finalScore <= 2.50) {
      return 'MEDIO-BAJO';
    } else if (finalScore <= 3.25) {
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
    final eventName = state.selectedRiskEvent;
    
    // Para Movimiento en Masa: usar cálculo ponderado específico
    if (eventName == 'Movimiento en Masa') {
      return _calculateMovimientoEnMasaAmenazaFinal();
    }
    
    // Para otros eventos: promedio simple de probabilidad e intensidad
    final probAverage = calculateProbabilidadAverage();
    final intAverage = calculateIntensidadAverage();
    
    if (probAverage == 0.0 || intAverage == 0.0) {
      return 0.0;
    }
    
    return (probAverage + intAverage) / 2;
  }

  // Cálculo específico para Movimiento en Masa - Amenaza (con pesos específicos)
  double _calculateMovimientoEnMasaAmenazaFinal() {
    // Obtener los scores de probabilidad e intensidad desde el state
    final probabilidadScore = state.subClassificationScores['probabilidad'] ?? 0.0;
    final intensidadScore = state.subClassificationScores['intensidad'] ?? 0.0;
    
    // Si alguno es 0, no hay calificación calculable
    if (probabilidadScore == 0.0 || intensidadScore == 0.0) {
      return 0.0;
    }
    
    // Aplicar pesos específicos para Movimiento en Masa:
    // Probabilidad: 40% (0.4)
    // Intensidad: 60% (0.6)
    final probabilidadPonderada = probabilidadScore * 0.4;
    final intensidadPonderada = intensidadScore * 0.6;
    
    return probabilidadPonderada + intensidadPonderada;
  }

  // Método específico para calcular puntaje final de vulnerabilidad usando calificaciones ponderadas
  // Método público para acceso externo
  double calculateVulnerabilidadFinalScore() {
    return _calculateVulnerabilidadFinalScore();
  }

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
        return const Color(0xFF22C55E); // Verde (1.00 a 1.75)
      case 'MEDIO-BAJO':
        return const Color(0xFFFDE047); // Amarillo (>1.75 a 2.50)
      case 'MEDIO-ALTO':
        return const Color(0xFFFB923C); // Naranja (>2.50 a 3.25)
      case 'ALTO':
        return const Color(0xFFDC2626); // Rojo (>3.25 a 4.00)
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
      case 'MEDIO-BAJO':
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