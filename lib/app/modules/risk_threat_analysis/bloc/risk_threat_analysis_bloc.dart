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
    
    // INUNDACIÓN - Amenaza - Probabilidad (con variable crítica)
    if (eventName == 'Inundación' && classification == 'amenaza' && subClassificationId == 'probabilidad') {
      return 'critical_variable';
    }
    
    // INUNDACIÓN - Amenaza - Intensidad (con variable crítica)
    if (eventName == 'Inundación' && classification == 'amenaza' && subClassificationId == 'intensidad') {
      return 'critical_variable';
    }
    
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
    
    // INUNDACIÓN - Vulnerabilidad - Fragilidad Física (con regla de tope especial)
    if (eventName == 'Inundación' && classification == 'vulnerabilidad' && subClassificationId == 'fragilidad_fisica') {
      return 'critical_variable';
    }
    
    // INUNDACIÓN - Vulnerabilidad - Fragilidad en Personas (con regla de tope especial)
    if (eventName == 'Inundación' && classification == 'vulnerabilidad' && subClassificationId == 'fragilidad_personas') {
      return 'critical_variable';
    }
    
    // INUNDACIÓN - Vulnerabilidad - Exposición (siempre promedio ponderado, sin tope)
    if (eventName == 'Inundación' && classification == 'vulnerabilidad' && subClassificationId == 'exposicion') {
      return 'weighted_average';
    }
    
    // Inundación - Amenaza (ya manejado arriba)
    if (eventName == 'Inundación' && classification == 'amenaza') {
      return 'critical_variable';
    }
    
    // Inundación - otras subclasificaciones
    if (eventName == 'Inundación') {
      return 'weighted_average';
    }
    
    // AVENIDA TORRENCIAL - Amenaza - Probabilidad (con variable crítica)
    if (eventName == 'Avenida Torrencial' && classification == 'amenaza' && subClassificationId == 'probabilidad') {
      return 'critical_variable';
    }
    
    // AVENIDA TORRENCIAL - Amenaza - Intensidad (con variable crítica)
    if (eventName == 'Avenida Torrencial' && classification == 'amenaza' && subClassificationId == 'intensidad') {
      return 'critical_variable';
    }
    
    // AVENIDA TORRENCIAL - Vulnerabilidad - Fragilidad Física (con regla de tope especial)
    if (eventName == 'Avenida Torrencial' && classification == 'vulnerabilidad' && subClassificationId == 'fragilidad_fisica') {
      return 'critical_variable';
    }
    
    // AVENIDA TORRENCIAL - Vulnerabilidad - Fragilidad en Personas (con regla de tope especial)
    if (eventName == 'Avenida Torrencial' && classification == 'vulnerabilidad' && subClassificationId == 'fragilidad_personas') {
      return 'critical_variable';
    }
    
    // AVENIDA TORRENCIAL - Vulnerabilidad - Exposición (siempre promedio ponderado, sin tope)
    if (eventName == 'Avenida Torrencial' && classification == 'vulnerabilidad' && subClassificationId == 'exposicion') {
      return 'weighted_average';
    }
    
    // AVENIDA TORRENCIAL - Vulnerabilidad - Otras subclasificaciones (promedio ponderado)
    if (eventName == 'Avenida Torrencial' && classification == 'vulnerabilidad') {
      return 'weighted_average';
    }
    
    // ESTRUCTURAL - Amenaza - Probabilidad (promedio ponderado simple)
    if (eventName == 'Estructural' && classification == 'amenaza' && subClassificationId == 'probabilidad') {
      return 'weighted_average';
    }
    
    // ESTRUCTURAL - Amenaza - Intensidad (con variable crítica)
    if (eventName == 'Estructural' && classification == 'amenaza' && subClassificationId == 'intensidad') {
      return 'critical_variable';
    }
    
    // ESTRUCTURAL - Vulnerabilidad - Fragilidad Física (con regla de tope por amenaza global)
    if (eventName == 'Estructural' && classification == 'vulnerabilidad' && subClassificationId == 'fragilidad_fisica') {
      return 'critical_variable';
    }
    
    // ESTRUCTURAL - Vulnerabilidad - Fragilidad en Personas (con regla de tope por amenaza global)
    if (eventName == 'Estructural' && classification == 'vulnerabilidad' && subClassificationId == 'fragilidad_personas') {
      return 'critical_variable';
    }
    
    // ESTRUCTURAL - Vulnerabilidad - Exposición (siempre promedio ponderado, sin tope)
    if (eventName == 'Estructural' && classification == 'vulnerabilidad' && subClassificationId == 'exposicion') {
      return 'weighted_average';
    }
    
    // ESTRUCTURAL - Vulnerabilidad - Otras subclasificaciones (promedio ponderado)
    if (eventName == 'Estructural' && classification == 'vulnerabilidad') {
      return 'weighted_average';
    }
    
    // OTROS - Amenaza - Probabilidad (promedio ponderado simple)
    if (eventName == 'Otros' && classification == 'amenaza' && subClassificationId == 'probabilidad') {
      return 'weighted_average';
    }
    
    // OTROS - Amenaza - Intensidad (con variable crítica)
    if (eventName == 'Otros' && classification == 'amenaza' && subClassificationId == 'intensidad') {
      return 'critical_variable';
    }
    
    // OTROS - Vulnerabilidad - Fragilidad Física (con regla de tope por severidad)
    if (eventName == 'Otros' && classification == 'vulnerabilidad' && subClassificationId == 'fragilidad_fisica') {
      return 'critical_variable';
    }
    
    // OTROS - Vulnerabilidad - Fragilidad en Personas (con regla de tope por severidad)
    if (eventName == 'Otros' && classification == 'vulnerabilidad' && subClassificationId == 'fragilidad_personas') {
      return 'critical_variable';
    }
    
    // OTROS - Vulnerabilidad - Exposición (siempre promedio ponderado, sin tope)
    if (eventName == 'Otros' && classification == 'vulnerabilidad' && subClassificationId == 'exposicion') {
      return 'weighted_average';
    }
    
    // OTROS - Vulnerabilidad - Otras subclasificaciones (promedio ponderado)
    if (eventName == 'Otros' && classification == 'vulnerabilidad') {
      return 'weighted_average';
    }
    
    // Incendio Forestal - todas las clasificaciones y subclasificaciones
    if (eventName == 'Incendio Forestal') {
      return 'weighted_average';
    }
    
    // Por defecto: promedio simple
    return 'simple_average';
  }

  // Calcula usando variable crítica para eventos específicos (Inundación, Movimiento en Masa, etc.)
  double _calculateWithCriticalVariable(String subClassificationId, Map<String, String> selections) {
    final eventName = state.selectedRiskEvent;
    
    if (eventName == 'Inundación') {
      if (subClassificationId == 'probabilidad') {
        return _calculateInundacionProbabilidad(selections);
      } else if (subClassificationId == 'intensidad') {
        return _calculateInundacionIntensidad(selections);
      } else if (subClassificationId == 'fragilidad_fisica') {
        return _calculateInundacionFragilidadFisica(selections);
      } else if (subClassificationId == 'fragilidad_personas') {
        return _calculateInundacionFragilidadPersonas(selections);
      }
    }
    
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
    
    if (eventName == 'Avenida Torrencial') {
      if (subClassificationId == 'probabilidad') {
        return _calculateAvenidaTorrencialProbabilidad(selections);
      } else if (subClassificationId == 'intensidad') {
        return _calculateAvenidaTorrencialIntensidad(selections);
      } else if (subClassificationId == 'fragilidad_fisica') {
        return _calculateAvenidaTorrencialFragilidadFisica(selections);
      } else if (subClassificationId == 'fragilidad_personas') {
        return _calculateAvenidaTorrencialFragilidadPersonas(selections);
      }
    }
    
    if (eventName == 'Estructural') {
      if (subClassificationId == 'intensidad') {
        return _calculateEstructuralIntensidad(selections);
      } else if (subClassificationId == 'fragilidad_fisica') {
        return _calculateEstructuralFragilidadFisica(selections);
      } else if (subClassificationId == 'fragilidad_personas') {
        return _calculateEstructuralFragilidadPersonas(selections);
      }
    }
    
    if (eventName == 'Otros') {
      if (subClassificationId == 'intensidad') {
        return _calculateOtrosIntensidad(selections);
      } else if (subClassificationId == 'fragilidad_fisica') {
        return _calculateOtrosFragilidadFisica(selections);
      } else if (subClassificationId == 'fragilidad_personas') {
        return _calculateOtrosFragilidadPersonas(selections);
      }
    }
    
    // Fallback a cálculo ponderado para otros casos
    return _calculateWeightedAverage(subClassificationId, selections);
  }

  // Fórmula específica para Movimiento en Masa - Probabilidad
  double _calculateMovimientoEnMasaProbabilidad(Map<String, String> selections) {
    // PASO 1: Revisar la celda de control (I20) - Variable crítica: "Evidencias de Materialización o Reactivación"
    final evidenciasValue = _getSelectedLevelValue('Evidencias de Materialización o Reactivación', selections);
    
    // PASO 2: Si I20 es 4, fija la Probabilidad = 4 y termina
    if (evidenciasValue == 4) {
      return 4.0;
    }
    
    // PASO 3: Si I20 no es 4, procede a promediar usando fórmula ponderada
    // Suma las calificaciones de todas las variables de probabilidad (calificación = wi * valor)
    // Suma los pesos (Wi) de esas mismas variables
    // Divide la suma de calificaciones entre la suma de pesos
    return _calculateWeightedAverage('probabilidad', selections);
  }

  // Fórmula específica para Movimiento en Masa - Intensidad
  double _calculateMovimientoEnMasaIntensidad(Map<String, String> selections) {
    // PASO 1: Revisar la celda de control (I31) - Variable crítica: "Potencial de Daño en Edificaciones"
    final potencialDanoValue = _getSelectedLevelValue('Potencial de Daño en Edificaciones', selections);
    
    // PASO 2: Si I31 es 4, fija la Intensidad = 4 y termina
    if (potencialDanoValue == 4) {
      return 4.0;
    }
    
    // PASO 3: Si I31 no es 4, procede a promediar usando fórmula ponderada:
    // - Suma las calificaciones de las variables de intensidad (calificación = wi * valor)
    // - Potencial de Daño en Edificaciones
    // - Capacidad de Generar Pérdida de Vidas Humanas  
    // - Alteración del Funcionamiento de Líneas Vitales y Espacio Público
    // - Suma los pesos (Wi) de esas variables
    // - Divide la suma de calificaciones entre la suma de pesos
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

  // ============================================================================
  // MÉTODOS ESPECÍFICOS PARA INUNDACIÓN
  // ============================================================================

  // Fórmula específica para Inundación - Probabilidad
  double _calculateInundacionProbabilidad(Map<String, String> selections) {
    // PASO 1: Revisar la celda de control (I20) - Variable crítica específica para Inundación
    // Buscar la variable crítica en las selecciones (puede variar según el modelo)
    
    // Buscar variables que puedan ser críticas (basado en nombres comunes)
    final criticalVariables = [
      'Evidencias de Materialización o Reactivación',
      'Evidencias de Materialización',
      'Probabilidad de Ocurrencia',
      'Registro Histórico',
    ];
    
    for (final criticalVar in criticalVariables) {
      final criticalValue = _getSelectedLevelValue(criticalVar, selections);
      // PASO 2: Si la variable crítica es 4, fija la Probabilidad = 4 y termina
      if (criticalValue == 4) {
        return 4.0;
      }
    }
    
    // PASO 3: Si ninguna variable crítica es 4, procede a promediar usando fórmula ponderada
    // Suma las calificaciones de todas las variables de probabilidad (calificación = wi * valor)
    // Suma los pesos (Wi) de esas mismas variables
    // Divide la suma de calificaciones entre la suma de pesos
    return _calculateWeightedAverage('probabilidad', selections);
  }

  // Fórmula específica para Inundación - Intensidad
  double _calculateInundacionIntensidad(Map<String, String> selections) {
    // PASO 1: Revisar la celda de control (I31) - Variable crítica específica para Inundación
    
    // Buscar variables que puedan ser críticas para intensidad
    final criticalVariables = [
      'Potencial de Daño en Edificaciones',
      'Daño en Edificaciones',
      'Capacidad de Generar Pérdida de Vidas Humanas',
      'Pérdida de Vidas Humanas',
    ];
    
    for (final criticalVar in criticalVariables) {
      final criticalValue = _getSelectedLevelValue(criticalVar, selections);
      // PASO 2: Si la variable crítica es 4, fija la Intensidad = 4 y termina
      if (criticalValue == 4) {
        return 4.0;
      }
    }
    
    // PASO 3: Si ninguna variable crítica es 4, procede a promediar usando fórmula ponderada:
    // - Suma las calificaciones de las variables de intensidad (calificación = wi * valor)
    // - Suma los pesos (Wi) de esas variables
    // - Divide la suma de calificaciones entre la suma de pesos
    return _calculateWeightedAverage('intensidad', selections);
  }

  // Fórmula específica para Inundación - Fragilidad Física
  double _calculateInundacionFragilidadFisica(Map<String, String> selections) {
    // PASO 1: Verificar regla de tope por severidad
    // Fórmula: =IF(AND(AMENAZA_INUNDACION!E7>=2,6; AMENAZA_INUNDACION!I30=4); 4; (promedio ponderado))
    
    final amenazaGlobal = _calculateAmenazaGlobalScore();
    final potencialDanoEdificaciones = _getPotencialDanoEdificacionesFromAmenaza();
    
    // REGLA DE TOPE: Si amenaza global ≥ 2.6 Y potencial daño edificaciones = 4 → fragilidad = 4
    if (amenazaGlobal >= 2.6 && potencialDanoEdificaciones == 4) {
      return 4.0;
    }
    
    // CASO NORMAL: Promedio ponderado de las variables de fragilidad física
    // (materiales, estado de conservación, tipología estructural, etc.)
    // J20:J22 = calificaciones; H20:H22 = pesos
    // Resultado = suma de calificaciones ÷ suma de pesos
    return _calculateWeightedAverage('fragilidad_fisica', selections);
  }

  // Fórmula específica para Inundación - Fragilidad en Personas
  double _calculateInundacionFragilidadPersonas(Map<String, String> selections) {
    // PASO 1: Verificar regla de tope por severidad
    // Fórmula: =IF(AND(AMENAZA_INUNDACION!E7>=2,6; AMENAZA_INUNDACION!I30=4); 4; (promedio ponderado))
    
    final amenazaGlobal = _calculateAmenazaGlobalScore();
    final potencialDanoEdificaciones = _getPotencialDanoEdificacionesFromAmenaza();
    
    // REGLA DE TOPE: Si amenaza global ≥ 2.6 Y potencial daño edificaciones = 4 → fragilidad = 4
    if (amenazaGlobal >= 2.6 && potencialDanoEdificaciones == 4) {
      return 4.0;
    }
    
    // CASO NORMAL: Promedio ponderado de las variables de fragilidad en personas
    // (nivel de organización, suficiencia económica, etc.)
    // J27:J28 = calificaciones; H27:H28 = pesos
    // Resultado = suma de calificaciones ÷ suma de pesos
    return _calculateWeightedAverage('fragilidad_personas', selections);
  }

  // ============================================================================
  // MÉTODOS ESPECÍFICOS PARA ESTRUCTURAL
  // ============================================================================

  // Fórmula específica para Estructural - Intensidad
  double _calculateEstructuralIntensidad(Map<String, String> selections) {
    // FÓRMULA: =+IF(I26=4;4;(SUM(J26:J28)/SUM(H26:H28)))
    // PASO 1: Revisar la celda de control (I26) - Variable crítica
    
    // Buscar variables que puedan ser críticas para Estructural - Intensidad
    final criticalVariables = [
      'Potencial de Daño en Edificaciones Adyacentes',
      'Potencial de Daño en Edificaciones',
      'Daño en Edificaciones Adyacentes',
      'Capacidad de Generar Pérdida de Vidas Humanas',
      'Pérdida de Vidas Humanas',
    ];
    
    for (final criticalVar in criticalVariables) {
      final criticalValue = _getSelectedLevelValue(criticalVar, selections);
      // PASO 2: Si I26 es 4, la intensidad se define como 4 automáticamente
      // "Si algún criterio clave indica un nivel de impacto crítico, la intensidad no puede ser menor"
      if (criticalValue == 4) {
        return 4.0;
      }
    }
    
    // PASO 3: Si I26 no es 4, calcular promedio ponderado
    // "Se calcula como promedio ponderado de las variables de intensidad"
    // SUM(J26:J28) → suma de calificaciones de las variables de intensidad:
    // - Potencial de daño en edificaciones adyacentes
    // - Capacidad de generar pérdida de vidas humanas  
    // - Alteración del funcionamiento de líneas vitales y espacio público
    // SUM(H26:H28) → suma de los pesos
    // Se divide para obtener la Intensidad
    return _calculateWeightedAverage('intensidad', selections);
  }

  // Fórmula específica para Estructural - Fragilidad Física
  double _calculateEstructuralFragilidadFisica(Map<String, String> selections) {
    // FÓRMULA: =IF(AND(AMENAZA_ESTRUCTURAL!E7=4); 4; SUM(J20:J21)/SUM(H20:H21))
    // PASO 1: Verificar regla de tope por amenaza global
    
    final amenazaGlobal = _calculateAmenazaGlobalScore();
    
    // REGLA DE TOPE: Si amenaza global = 4 → fragilidad física = 4
    // "Si en la hoja AMENAZA_ESTRUCTURAL la calificación global de la amenaza (E7) es 4 (ALTO),
    //  la Fragilidad física se fija directamente en 4"
    if (amenazaGlobal == 4.0) {
      return 4.0;
    }
    
    // CASO NORMAL: Promedio ponderado de las variables de fragilidad física
    // "Se calcula como promedio ponderado de las variables del bloque
    //  (calidad de materiales y tipología estructural):
    //  suma de calificaciones (J20:J21) ÷ suma de pesos (H20:H21)"
    // SUM(J20:J21) = suma de calificaciones ponderadas
    // SUM(H20:H21) = suma de pesos Wi
    // Resultado = suma de calificaciones ÷ suma de pesos
    return _calculateWeightedAverage('fragilidad_fisica', selections);
  }

  // Fórmula específica para Estructural - Fragilidad en Personas
  double _calculateEstructuralFragilidadPersonas(Map<String, String> selections) {
    // FÓRMULA: =IF(AND(AMENAZA_ESTRUCTURAL!E7=4); 4; SUM(J26:J27)/SUM(H26:H27))
    // PASO 1: Verificar regla de tope por amenaza global
    
    final amenazaGlobal = _calculateAmenazaGlobalScore();
    
    // REGLA DE TOPE: Si amenaza global = 4 → fragilidad en personas = 4
    // "Si la amenaza global = 4: la Fragilidad en personas se fija en 4"
    if (amenazaGlobal == 4.0) {
      return 4.0;
    }
    
    // CASO NORMAL: Promedio ponderado de las variables de fragilidad en personas
    // "En cualquier otro caso: se obtiene por promedio ponderado de sus variables
    //  (nivel de organización y suficiencia económica):
    //  (J26:J27) ÷ (H26:H27)"
    // SUM(J26:J27) = suma de calificaciones ponderadas
    // SUM(H26:H27) = suma de pesos Wi
    // Resultado = suma de calificaciones ÷ suma de pesos
    return _calculateWeightedAverage('fragilidad_personas', selections);
  }

  // ============================================================================
  // MÉTODOS ESPECÍFICOS PARA OTROS
  // ============================================================================

  // Fórmula específica para Otros - Intensidad
  double _calculateOtrosIntensidad(Map<String, String> selections) {
    // FÓRMULA: =+IF(I27=4;4;(SUM(J27:J29)/SUM(H27:H29)))
    // PASO 1: Revisar la celda de control (I27) - Variable crítica
    
    // Buscar variables que puedan ser críticas para Otros - Intensidad
    final criticalVariables = [
      'Potencial de Daño en Edificaciones',
      'Potencial de Daño',
      'Capacidad de Generar Pérdida de Vidas Humanas',
      'Pérdida de Vidas Humanas',
      'Alteración del Funcionamiento de Líneas Vitales',
      'Alteración de Líneas Vitales',
      'Impacto en Infraestructura',
    ];
    
    for (final criticalVar in criticalVariables) {
      final criticalValue = _getSelectedLevelValue(criticalVar, selections);
      // PASO 2: Si I27 es 4, la intensidad se define como 4 automáticamente
      // "Si alguna variable dentro de intensidad llega al nivel máximo (4),
      //  entonces se devuelve directamente 4 como calificación final"
      if (criticalValue == 4) {
        return 4.0;
      }
    }
    
    // PASO 3: Si I27 no es 4, calcular promedio ponderado
    // "Si no es 4, entonces calcula el promedio ponderado:"
    // SUM(J27:J29) → suma de los valores de:
    // - Potencial de Daño
    // - Pérdida de Vidas Humanas
    // - Alteración de Líneas Vitales
    // SUM(H27:H29) → suma de los pesos de esas variables
    // Se divide para obtener la calificación de intensidad
    return _calculateWeightedAverage('intensidad', selections);
  }

  // Fórmula específica para Otros - Fragilidad Física
  double _calculateOtrosFragilidadFisica(Map<String, String> selections) {
    // FÓRMULA: =IF(AND(AMENAZA_OTROS!E7>=2,6; AMENAZA_OTROS!I30=4); 4; SUM(J20:J22)/SUM(H20:H22))
    // PASO 1: Verificar regla de tope por severidad
    
    final amenazaGlobal = _calculateAmenazaGlobalScore();
    final potencialDanoEdificaciones = _getPotencialDanoEdificacionesFromAmenaza();
    
    // REGLA DE TOPE: Si amenaza global ≥ 2.6 Y potencial daño edificaciones = 4 → fragilidad = 4
    // "Si en AMENAZA_OTROS la calificación global (E7) es ≥ 2,6 y el Potencial de daño en edificaciones (I30) es 4,
    //  entonces la Fragilidad física = 4 automáticamente (máxima fragilidad)"
    if (amenazaGlobal >= 2.6 && potencialDanoEdificaciones == 4) {
      return 4.0;
    }
    
    // CASO NORMAL: Promedio ponderado de las variables de fragilidad física
    // "Se calcula como promedio ponderado de sus variables (materiales, estado de conservación, tipología):
    //  J20:J22 = calificaciones por variable
    //  H20:H22 = pesos (Wi)
    //  Resultado = suma de calificaciones ÷ suma de pesos"
    // SUM(J20:J22) = suma de calificaciones ponderadas
    // SUM(H20:H22) = suma de pesos Wi
    // Resultado = suma de calificaciones ÷ suma de pesos
    return _calculateWeightedAverage('fragilidad_fisica', selections);
  }

  // Fórmula específica para Otros - Fragilidad en Personas
  double _calculateOtrosFragilidadPersonas(Map<String, String> selections) {
    // FÓRMULA: =IF(AND(AMENAZA_OTROS!E7>=2,6; AMENAZA_OTROS!I30=4); 4; SUM(J27:J28)/SUM(H27:H28))
    // PASO 1: Verificar regla de tope por severidad
    
    final amenazaGlobal = _calculateAmenazaGlobalScore();
    final potencialDanoEdificaciones = _getPotencialDanoEdificacionesFromAmenaza();
    
    // REGLA DE TOPE: Si amenaza global ≥ 2.6 Y potencial daño edificaciones = 4 → fragilidad = 4
    // "Mismo tope: si Amenaza ≥ 2,6 y I30 = 4, la Fragilidad en personas = 4"
    if (amenazaGlobal >= 2.6 && potencialDanoEdificaciones == 4) {
      return 4.0;
    }
    
    // CASO NORMAL: Promedio ponderado de las variables de fragilidad en personas
    // "Si no: promedio ponderado de nivel de organización y suficiencia económica:
    //  J27:J28 (calificaciones) / H27:H28 (pesos)"
    // SUM(J27:J28) = suma de calificaciones ponderadas
    // SUM(H27:H28) = suma de pesos Wi
    // Resultado = suma de calificaciones ÷ suma de pesos
    return _calculateWeightedAverage('fragilidad_personas', selections);
  }

  // ============================================================================
  // MÉTODOS ESPECÍFICOS PARA AVENIDA TORRENCIAL
  // ============================================================================

  // Fórmula específica para Avenida Torrencial - Probabilidad
  double _calculateAvenidaTorrencialProbabilidad(Map<String, String> selections) {
    // FÓRMULA: =IF(I24=4;4;(SUM(J20:J24)/SUM(H20:H24)))
    // PASO 1: Revisar la celda de control (I24) - Variable crítica
    // Buscar la variable crítica en la fila 24 (puede variar según el modelo)
    
    // Buscar variables que puedan ser críticas para Avenida Torrencial - Probabilidad
    final criticalVariables = [
      'Evidencias de Materialización o Reactivación',
      'Evidencias de Materialización',
      'Registro Histórico de Eventos',
      'Registro Histórico',
      'Probabilidad de Ocurrencia',
      'Frecuencia de Eventos',
    ];
    
    for (final criticalVar in criticalVariables) {
      final criticalValue = _getSelectedLevelValue(criticalVar, selections);
      // PASO 2: Si I24 es 4, fija la Probabilidad = 4 y termina
      // "Si en la celda I24 aparece el valor 4, entonces la probabilidad se fuerza directamente a 4"
      if (criticalValue == 4) {
        return 4.0;
      }
    }
    
    // PASO 3: Si I24 no es 4, procede con promedio ponderado
    // "Se hace el promedio ponderado de las calificaciones"
    // SUM(J20:J24) → suma de las calificaciones (valor × peso)
    // SUM(H20:H24) → suma de los pesos
    // Se divide para obtener la calificación de Probabilidad
    return _calculateWeightedAverage('probabilidad', selections);
  }

  // Fórmula específica para Avenida Torrencial - Intensidad
  double _calculateAvenidaTorrencialIntensidad(Map<String, String> selections) {
    // FÓRMULA: =IF(I29=4;4;(SUM(J29:J31)/SUM(H29:H31)))
    // PASO 1: Revisar la celda de control (I29) - Variable crítica
    
    // Buscar variables que puedan ser críticas para Avenida Torrencial - Intensidad
    final criticalVariables = [
      'Potencial de Daño en Edificaciones',
      'Daño en Edificaciones',
      'Capacidad de Generar Pérdida de Vidas Humanas',
      'Pérdida de Vidas Humanas',
      'Alteración del Funcionamiento de Líneas Vitales',
      'Impacto en Infraestructura',
    ];
    
    for (final criticalVar in criticalVariables) {
      final criticalValue = _getSelectedLevelValue(criticalVar, selections);
      // PASO 2: Si I29 es 4, la intensidad se define como 4 automáticamente
      // "Si algún criterio clave indica un nivel de impacto crítico, la intensidad no puede ser menor"
      if (criticalValue == 4) {
        return 4.0;
      }
    }
    
    // PASO 3: Si I29 no es 4, calcular promedio ponderado
    // "Se calcula también como promedio ponderado"
    // SUM(J29:J31) → suma de calificaciones de las variables de intensidad
    // SUM(H29:H31) → suma de los pesos
    // Se divide para obtener la Intensidad
    return _calculateWeightedAverage('intensidad', selections);
  }

  // Fórmula específica para Avenida Torrencial - Fragilidad Física
  double _calculateAvenidaTorrencialFragilidadFisica(Map<String, String> selections) {
    // FÓRMULA: =IF(AND(AMENAZA_AVTORRENCIAL!E7>=2,6; AMENAZA_AVTORRENCIAL!I30=4); 4; SUM(J20:J22)/SUM(H20:H22))
    // PASO 1: Verificar regla de tope por severidad
    
    final amenazaGlobal = _calculateAmenazaGlobalScore();
    final potencialDanoEdificaciones = _getPotencialDanoEdificacionesFromAmenaza();
    
    // REGLA DE TOPE: Si amenaza global ≥ 2.6 Y potencial daño edificaciones = 4 → fragilidad = 4
    // "Si en la hoja de amenaza la calificación global (E7) es ≥ 2,6 (al menos Medio-Alto) 
    //  y el Potencial de daño en edificaciones (I30) es 4 (crítico), 
    //  entonces la fragilidad física se fija en 4 automáticamente"
    if (amenazaGlobal >= 2.6 && potencialDanoEdificaciones == 4) {
      return 4.0;
    }
    
    // CASO NORMAL: Promedio ponderado de las variables de fragilidad física
    // "Se suman las calificaciones (J20:J22) y se dividen entre la suma de los pesos (H20:H22)"
    // Variables: calidad de materiales, estado de conservación, tipología estructural
    // SUM(J20:J22) = suma de calificaciones ponderadas
    // SUM(H20:H22) = suma de pesos Wi
    // Resultado = suma de calificaciones ÷ suma de pesos
    return _calculateWeightedAverage('fragilidad_fisica', selections);
  }

  // Fórmula específica para Avenida Torrencial - Fragilidad en Personas
  double _calculateAvenidaTorrencialFragilidadPersonas(Map<String, String> selections) {
    // FÓRMULA: =IF(AND(AMENAZA_AVTORRENCIAL!E7>=2,6; AMENAZA_AVTORRENCIAL!I30=4); 4; SUM(J27:J28)/SUM(H27:H28))
    // PASO 1: Verificar regla de tope por severidad
    
    final amenazaGlobal = _calculateAmenazaGlobalScore();
    final potencialDanoEdificaciones = _getPotencialDanoEdificacionesFromAmenaza();
    
    // REGLA DE TOPE: Si amenaza global ≥ 2.6 Y potencial daño edificaciones = 4 → fragilidad = 4
    // "Mismo tope: si Amenaza ≥ 2,6 y daño en edificaciones = 4, la fragilidad en personas = 4 (máxima)"
    if (amenazaGlobal >= 2.6 && potencialDanoEdificaciones == 4) {
      return 4.0;
    }
    
    // CASO NORMAL: Promedio ponderado de las variables de fragilidad en personas
    // "Se calcula como promedio ponderado de nivel de organización y suficiencia económica:
    //  suma de calificaciones (J27:J28) / suma de pesos (H27:H28)"
    // Variables: nivel de organización, suficiencia económica
    // SUM(J27:J28) = suma de calificaciones ponderadas  
    // SUM(H27:H28) = suma de pesos Wi
    // Resultado = suma de calificaciones ÷ suma de pesos
    return _calculateWeightedAverage('fragilidad_personas', selections);
  }

  // Método para calcular la amenaza global (con pesos específicos para Movimiento en Masa)
  // Método público para acceso externo
  double calculateAmenazaGlobalScore() {
    return _calculateAmenazaGlobalScore();
  }

  double _calculateAmenazaGlobalScore() {
    final eventName = state.selectedRiskEvent;
    
    // Para Inundación: usar el cálculo ponderado específico
    if (eventName == 'Inundación') {
      return _calculateInundacionAmenazaFinal();
    }
    
    // Para Movimiento en Masa: usar el cálculo ponderado
    if (eventName == 'Movimiento en Masa') {
      return _calculateMovimientoEnMasaAmenazaFinal();
    }
    
    // Para Avenida Torrencial: usar el cálculo ponderado específico
    if (eventName == 'Avenida Torrencial') {
      return _calculateAvenidaTorrencialAmenazaFinal();
    }
    
    // Para Estructural: usar el cálculo ponderado específico
    if (eventName == 'Estructural') {
      return _calculateEstructuralAmenazaFinal();
    }
    
    // Para Otros: usar el cálculo ponderado específico
    if (eventName == 'Otros') {
      return _calculateOtrosAmenazaFinal();
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

  // Método específico para calcular calificación de vulnerabilidad usando el nuevo cálculo ponderado
  String _calculateVulnerabilidadRating() {
    final finalScore = _calculateVulnerabilidadFinalScore();
    
    if (finalScore == 0.0) {
      return 'SIN CALIFICAR';
    }
    
    // Rangos específicos para la clasificación de vulnerabilidad según especificaciones:
    // Entre 1,0 y 1,75 → Bajo
    // Mayor a 1,75 y hasta 2,5 → Medio - Bajo
    // Mayor a 2,5 y hasta 3,25 → Medio - Alto
    // Mayor a 3,25 y hasta 4 → Alto
    if (finalScore >= 1.0 && finalScore <= 1.75) {
      return 'BAJO';
    } else if (finalScore > 1.75 && finalScore <= 2.5) {
      return 'MEDIO-BAJO';
    } else if (finalScore > 2.5 && finalScore <= 3.25) {
      return 'MEDIO-ALTO';
    } else if (finalScore > 3.25 && finalScore <= 4.0) {
      return 'ALTO';
    } else {
      return 'SIN CALIFICAR';
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
    
    // Para Inundación: usar cálculo ponderado específico
    if (eventName == 'Inundación') {
      return _calculateInundacionAmenazaFinal();
    }
    
    // Para Movimiento en Masa: usar cálculo ponderado específico
    if (eventName == 'Movimiento en Masa') {
      return _calculateMovimientoEnMasaAmenazaFinal();
    }
    
    // Para Avenida Torrencial: usar cálculo ponderado específico
    if (eventName == 'Avenida Torrencial') {
      return _calculateAvenidaTorrencialAmenazaFinal();
    }
    
    // Para Estructural: usar cálculo ponderado específico
    if (eventName == 'Estructural') {
      return _calculateEstructuralAmenazaFinal();
    }
    
    // Para Otros: usar cálculo ponderado específico
    if (eventName == 'Otros') {
      return _calculateOtrosAmenazaFinal();
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
    // PASO FINAL: Con Probabilidad e Intensidad calculadas, obtener la Calificación de la Amenaza
    final probabilidadScore = state.subClassificationScores['probabilidad'] ?? 0.0;
    final intensidadScore = state.subClassificationScores['intensidad'] ?? 0.0;
    
    // Si alguno es 0, no hay calificación calculable
    if (probabilidadScore == 0.0 || intensidadScore == 0.0) {
      return 0.0;
    }
    
    // PONDERACIÓN: Aplicar pesos específicos para Movimiento en Masa:
    // Probabilidad: 40% (0.4)
    // Intensidad: 60% (0.6)
    final probabilidadPonderada = probabilidadScore * 0.4;
    final intensidadPonderada = intensidadScore * 0.6;
    
    final amenazaFinal = probabilidadPonderada + intensidadPonderada;
    
    // CLASIFICACIÓN con rangos:
    // 1–1,75 → Bajo
    // >1,75–2,5 → Medio-Bajo  
    // >2,5–3,25 → Medio-Alto
    // >3,25–4 → Alto
    return amenazaFinal;
  }

  // Cálculo específico para Inundación - Amenaza (con pesos específicos)
  double _calculateInundacionAmenazaFinal() {
    // PASO FINAL: Con Probabilidad e Intensidad calculadas, obtener la Calificación de la Amenaza para Inundación
    final probabilidadScore = state.subClassificationScores['probabilidad'] ?? 0.0;
    final intensidadScore = state.subClassificationScores['intensidad'] ?? 0.0;
    
    // Si alguno es 0, no hay calificación calculable
    if (probabilidadScore == 0.0 || intensidadScore == 0.0) {
      return 0.0;
    }
    
    // PONDERACIÓN: Aplicar pesos específicos para Inundación:
    // Probabilidad: 40% (0.4)
    // Intensidad: 60% (0.6)
    final probabilidadPonderada = probabilidadScore * 0.4;
    final intensidadPonderada = intensidadScore * 0.6;
    
    final amenazaFinal = probabilidadPonderada + intensidadPonderada;
    
    // CLASIFICACIÓN con rangos:
    // 1–1,75 → Bajo
    // >1,75–2,5 → Medio-Bajo  
    // >2,5–3,25 → Medio-Alto
    // >3,25–4 → Alto
    return amenazaFinal;
  }

  // Cálculo específico para Avenida Torrencial - Amenaza (con pesos específicos)
  double _calculateAvenidaTorrencialAmenazaFinal() {
    // PASO FINAL: Con Probabilidad e Intensidad calculadas, obtener la Calificación de la Amenaza para Avenida Torrencial
    final probabilidadScore = state.subClassificationScores['probabilidad'] ?? 0.0;
    final intensidadScore = state.subClassificationScores['intensidad'] ?? 0.0;
    
    // Si alguno es 0, no hay calificación calculable
    if (probabilidadScore == 0.0 || intensidadScore == 0.0) {
      return 0.0;
    }
    
    // PONDERACIÓN: Aplicar pesos específicos para Avenida Torrencial:
    // Probabilidad: 40% (0.4)
    // Intensidad: 60% (0.6)
    // (Usando mismos pesos que Inundación y Movimiento en Masa)
    final probabilidadPonderada = probabilidadScore * 0.4;
    final intensidadPonderada = intensidadScore * 0.6;
    
    final amenazaFinal = probabilidadPonderada + intensidadPonderada;
    
    // CLASIFICACIÓN con rangos:
    // 1–1,75 → Bajo
    // >1,75–2,5 → Medio-Bajo  
    // >2,5–3,25 → Medio-Alto
    // >3,25–4 → Alto
    return amenazaFinal;
  }

  // Cálculo específico para Estructural - Amenaza (con pesos específicos)
  double _calculateEstructuralAmenazaFinal() {
    // PASO FINAL: Con Probabilidad e Intensidad calculadas, obtener la Calificación de la Amenaza para Estructural
    final probabilidadScore = state.subClassificationScores['probabilidad'] ?? 0.0;
    final intensidadScore = state.subClassificationScores['intensidad'] ?? 0.0;
    
    // Si alguno es 0, no hay calificación calculable
    if (probabilidadScore == 0.0 || intensidadScore == 0.0) {
      return 0.0;
    }
    
    // PONDERACIÓN: Aplicar pesos específicos para Estructural:
    // Probabilidad: 40% (0.4) - promedio ponderado de estado de deterioro e incremento de carga
    // Intensidad: 60% (0.6) - con variable crítica para casos críticos
    final probabilidadPonderada = probabilidadScore * 0.4;
    final intensidadPonderada = intensidadScore * 0.6;
    
    final amenazaFinal = probabilidadPonderada + intensidadPonderada;
    
    // CLASIFICACIÓN con rangos:
    // 1–1,75 → Bajo
    // >1,75–2,5 → Medio-Bajo  
    // >2,5–3,25 → Medio-Alto
    // >3,25–4 → Alto
    return amenazaFinal;
  }

  // Cálculo específico para Otros - Amenaza (con pesos específicos)
  double _calculateOtrosAmenazaFinal() {
    // PASO FINAL: Con Probabilidad e Intensidad calculadas, obtener la Calificación de la Amenaza para Otros
    final probabilidadScore = state.subClassificationScores['probabilidad'] ?? 0.0;
    final intensidadScore = state.subClassificationScores['intensidad'] ?? 0.0;
    
    // Si alguno es 0, no hay calificación calculable
    if (probabilidadScore == 0.0 || intensidadScore == 0.0) {
      return 0.0;
    }
    
    // PONDERACIÓN: Aplicar pesos específicos para Otros:
    // Probabilidad: 40% (0.4) - promedio ponderado de frecuencia, evidencias y antecedentes
    // Intensidad: 60% (0.6) - con variable crítica para casos críticos
    // Fórmula: =+((E7*D7)+(E8*D8))
    // E7*D7 → Probabilidad × su peso
    // E8*D8 → Intensidad × su peso
    final probabilidadPonderada = probabilidadScore * 0.4;
    final intensidadPonderada = intensidadScore * 0.6;
    
    final amenazaFinal = probabilidadPonderada + intensidadPonderada;
    
    // CLASIFICACIÓN con rangos:
    // 1–1,75 → Bajo
    // >1,75–2,5 → Medio-Bajo  
    // >2,5–3,25 → Medio-Alto
    // >3,25–4 → Alto
    return amenazaFinal;
  }

  // Método específico para calcular puntaje final de vulnerabilidad usando calificaciones ponderadas
  // Método público para acceso externo
  double calculateVulnerabilidadFinalScore() {
    return _calculateVulnerabilidadFinalScore();
  }

  double _calculateVulnerabilidadFinalScore() {
    final eventName = state.selectedRiskEvent;
    
    // Para Inundación: usar cálculo específico
    if (eventName == 'Inundación') {
      return _calculateInundacionVulnerabilidadFinal();
    }
    
    // Para Movimiento en Masa: usar cálculo específico  
    if (eventName == 'Movimiento en Masa') {
      return _calculateMovimientoEnMasaVulnerabilidadFinal();
    }
    
    // Para Avenida Torrencial: usar cálculo específico  
    if (eventName == 'Avenida Torrencial') {
      return _calculateAvenidaTorrencialVulnerabilidadFinal();
    }
    
    // Para Estructural: usar cálculo específico  
    if (eventName == 'Estructural') {
      return _calculateEstructuralVulnerabilidadFinal();
    }
    
    // Para Otros: usar cálculo específico  
    if (eventName == 'Otros') {
      return _calculateOtrosVulnerabilidadFinal();
    }
    
    // Para otros eventos: cálculo ponderado genérico
    return _calculateGenericVulnerabilidadFinal();
  }

  // Cálculo específico para Inundación - Vulnerabilidad
  double _calculateInundacionVulnerabilidadFinal() {
    // FÓRMULA ESPECÍFICA PARA INUNDACIÓN:
    // E6 × D6 + E7 × D7 + E8 × D8
    // Donde:
    // E6 → Fragilidad Física,     D6 → 45% (0.45)
    // E7 → Fragilidad en Personas, D7 → 10% (0.10)  
    // E8 → Exposición,            D8 → 45% (0.45)
    
    final fragilidadFisicaScore = state.subClassificationScores['fragilidad_fisica'] ?? 0.0;      // E6
    final fragilidadPersonasScore = state.subClassificationScores['fragilidad_personas'] ?? 0.0;  // E7
    final exposicionScore = state.subClassificationScores['exposicion'] ?? 0.0;                   // E8
    
    // Si alguna subclasificación no tiene score, no se puede calcular vulnerabilidad
    if (fragilidadFisicaScore == 0.0 || fragilidadPersonasScore == 0.0 || exposicionScore == 0.0) {
      return 0.0;
    }
    
    // CÁLCULO PONDERADO:
    // E6 × D6 = Fragilidad Física × 45%
    final e6_x_d6 = fragilidadFisicaScore * 0.45;
    
    // E7 × D7 = Fragilidad en Personas × 10%
    final e7_x_d7 = fragilidadPersonasScore * 0.10;
    
    // E8 × D8 = Exposición × 45%
    final e8_x_d8 = exposicionScore * 0.45;
    
    // SUMA DE RESULTADOS: E6×D6 + E7×D7 + E8×D8
    final vulnerabilidadFinal = e6_x_d6 + e7_x_d7 + e8_x_d8;
    
    return vulnerabilidadFinal;
  }

  // Cálculo específico para Movimiento en Masa - Vulnerabilidad
  double _calculateMovimientoEnMasaVulnerabilidadFinal() {
    // Mismo cálculo ponderado que Inundación:
    // Fragilidad Física: 45%, Fragilidad en Personas: 10%, Exposición: 45%
    
    final fragilidadFisicaScore = state.subClassificationScores['fragilidad_fisica'] ?? 0.0;
    final fragilidadPersonasScore = state.subClassificationScores['fragilidad_personas'] ?? 0.0;
    final exposicionScore = state.subClassificationScores['exposicion'] ?? 0.0;
    
    if (fragilidadFisicaScore == 0.0 || fragilidadPersonasScore == 0.0 || exposicionScore == 0.0) {
      return 0.0;
    }
    
    final fragilidadFisicaPonderada = fragilidadFisicaScore * 0.45;
    final fragilidadPersonasPonderada = fragilidadPersonasScore * 0.10;
    final exposicionPonderada = exposicionScore * 0.45;
    
    return fragilidadFisicaPonderada + fragilidadPersonasPonderada + exposicionPonderada;
  }

  // Cálculo específico para Avenida Torrencial - Vulnerabilidad
  double _calculateAvenidaTorrencialVulnerabilidadFinal() {
    // Mismo cálculo ponderado que otros eventos:
    // Fragilidad Física: 45%, Fragilidad en Personas: 10%, Exposición: 45%
    
    final fragilidadFisicaScore = state.subClassificationScores['fragilidad_fisica'] ?? 0.0;
    final fragilidadPersonasScore = state.subClassificationScores['fragilidad_personas'] ?? 0.0;
    final exposicionScore = state.subClassificationScores['exposicion'] ?? 0.0;
    
    if (fragilidadFisicaScore == 0.0 || fragilidadPersonasScore == 0.0 || exposicionScore == 0.0) {
      return 0.0;
    }
    
    final fragilidadFisicaPonderada = fragilidadFisicaScore * 0.45;
    final fragilidadPersonasPonderada = fragilidadPersonasScore * 0.10;
    final exposicionPonderada = exposicionScore * 0.45;
    
    return fragilidadFisicaPonderada + fragilidadPersonasPonderada + exposicionPonderada;
  }

  // Cálculo específico para Estructural - Vulnerabilidad
  double _calculateEstructuralVulnerabilidadFinal() {
    // Cálculo ponderado estándar para Estructural:
    // Fragilidad Física: 45%, Fragilidad en Personas: 10%, Exposición: 45%
    
    final fragilidadFisicaScore = state.subClassificationScores['fragilidad_fisica'] ?? 0.0;
    final fragilidadPersonasScore = state.subClassificationScores['fragilidad_personas'] ?? 0.0;
    final exposicionScore = state.subClassificationScores['exposicion'] ?? 0.0;
    
    if (fragilidadFisicaScore == 0.0 || fragilidadPersonasScore == 0.0 || exposicionScore == 0.0) {
      return 0.0;
    }
    
    final fragilidadFisicaPonderada = fragilidadFisicaScore * 0.45;
    final fragilidadPersonasPonderada = fragilidadPersonasScore * 0.10;
    final exposicionPonderada = exposicionScore * 0.45;
    
    return fragilidadFisicaPonderada + fragilidadPersonasPonderada + exposicionPonderada;
  }

  // Cálculo específico para Otros - Vulnerabilidad
  double _calculateOtrosVulnerabilidadFinal() {
    // Cálculo ponderado estándar para Otros:
    // Fragilidad Física: 45%, Fragilidad en Personas: 10%, Exposición: 45%
    
    final fragilidadFisicaScore = state.subClassificationScores['fragilidad_fisica'] ?? 0.0;
    final fragilidadPersonasScore = state.subClassificationScores['fragilidad_personas'] ?? 0.0;
    final exposicionScore = state.subClassificationScores['exposicion'] ?? 0.0;
    
    if (fragilidadFisicaScore == 0.0 || fragilidadPersonasScore == 0.0 || exposicionScore == 0.0) {
      return 0.0;
    }
    
    final fragilidadFisicaPonderada = fragilidadFisicaScore * 0.45;
    final fragilidadPersonasPonderada = fragilidadPersonasScore * 0.10;
    final exposicionPonderada = exposicionScore * 0.45;
    
    return fragilidadFisicaPonderada + fragilidadPersonasPonderada + exposicionPonderada;
  }

  // Cálculo genérico para otros eventos - Vulnerabilidad
  double _calculateGenericVulnerabilidadFinal() {
    // Cálculo ponderado genérico:
    // Fragilidad Física: 45%, Fragilidad en Personas: 10%, Exposición: 45%
    
    final fragilidadFisicaScore = state.subClassificationScores['fragilidad_fisica'] ?? 0.0;
    final fragilidadPersonasScore = state.subClassificationScores['fragilidad_personas'] ?? 0.0;
    final exposicionScore = state.subClassificationScores['exposicion'] ?? 0.0;
    
    if (fragilidadFisicaScore == 0.0 || fragilidadPersonasScore == 0.0 || exposicionScore == 0.0) {
      return 0.0;
    }
    
    final fragilidadFisicaPonderada = fragilidadFisicaScore * 0.45;
    final fragilidadPersonasPonderada = fragilidadPersonasScore * 0.10;
    final exposicionPonderada = exposicionScore * 0.45;
    
    return fragilidadFisicaPonderada + fragilidadPersonasPonderada + exposicionPonderada;
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