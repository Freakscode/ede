import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:caja_herramientas/app/shared/models/models.dart';
import 'package:caja_herramientas/app/shared/models/form_data_model.dart';
import 'package:caja_herramientas/app/shared/services/form_persistence_service.dart';
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
    on<SaveCurrentFormData>(_onSaveCurrentFormData);
    on<LoadFormData>(_onLoadFormData);
    on<ResetToNewForm>(_onResetToNewForm);
    on<CompleteForm>(_onCompleteForm);
    on<AutoSaveProgress>(_onAutoSaveProgress);
  }

  void _onToggleProbabilidadDropdown(
    ToggleProbabilidadDropdown event,
    Emitter<RiskThreatAnalysisState> emit,
  ) {
    emit(state.copyWith(
      isProbabilidadDropdownOpen: !state.isProbabilidadDropdownOpen,
      isIntensidadDropdownOpen: false, 
    ));
  }

  void _onToggleIntensidadDropdown(
    ToggleIntensidadDropdown event,
    Emitter<RiskThreatAnalysisState> emit,
  ) {
    emit(state.copyWith(
      isIntensidadDropdownOpen: !state.isIntensidadDropdownOpen,
      isProbabilidadDropdownOpen: false, 
    ));
  }

  void _onSelectProbabilidad(
    SelectProbabilidad event,
    Emitter<RiskThreatAnalysisState> emit,
  ) {
    print('DEBUG Probabilidad: ${event.probabilidad}');
    
    // Actualizar las dynamicSelections para usar el sistema correcto
    final currentSelections = Map<String, Map<String, String>>.from(state.dynamicSelections);
    if (!currentSelections.containsKey('probabilidad')) {
      currentSelections['probabilidad'] = <String, String>{};
    }
    currentSelections['probabilidad']!['Probabilidad'] = event.probabilidad;
    
    // Calcular score usando el sistema correcto
    final probabilidadScore = _calculateSubClassificationScore('probabilidad', currentSelections);
    print('DEBUG Probabilidad Score calculado: $probabilidadScore');
    
    final updatedScores = Map<String, double>.from(state.subClassificationScores);
    updatedScores['probabilidad'] = probabilidadScore;
    
    final updatedColors = Map<String, Color>.from(state.subClassificationColors);
    updatedColors['probabilidad'] = _getScoreColor(probabilidadScore);
    
    emit(state.copyWith(
      selectedProbabilidad: event.probabilidad,
      isProbabilidadDropdownOpen: false,
      dynamicSelections: currentSelections,
      subClassificationScores: updatedScores,
      subClassificationColors: updatedColors,
    ));
  }

  void _onSelectIntensidad(
    SelectIntensidad event,
    Emitter<RiskThreatAnalysisState> emit,
  ) {
    print('DEBUG Intensidad: ${event.intensidad}');
    
    // Actualizar las dynamicSelections para usar el sistema correcto
    final currentSelections = Map<String, Map<String, String>>.from(state.dynamicSelections);
    if (!currentSelections.containsKey('intensidad')) {
      currentSelections['intensidad'] = <String, String>{};
    }
    currentSelections['intensidad']!['Intensidad'] = event.intensidad;
    
    // Calcular score usando el sistema correcto
    final intensidadScore = _calculateSubClassificationScore('intensidad', currentSelections);
    print('DEBUG Intensidad Score calculado: $intensidadScore');
    
    final updatedScores = Map<String, double>.from(state.subClassificationScores);
    updatedScores['intensidad'] = intensidadScore;
    
    final updatedColors = Map<String, Color>.from(state.subClassificationColors);
    updatedColors['intensidad'] = _getScoreColor(intensidadScore);
    
    emit(state.copyWith(
      selectedIntensidad: event.intensidad,
      isIntensidadDropdownOpen: false,
      dynamicSelections: currentSelections,
      subClassificationScores: updatedScores,
      subClassificationColors: updatedColors,
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
    
    // Auto-guardar progreso
    add(AutoSaveProgress());
  }

  void _onUpdateIntensidadSelection(
    UpdateIntensidadSelection event,
    Emitter<RiskThreatAnalysisState> emit,
  ) {
    final updatedSelections = Map<String, String>.from(state.intensidadSelections);
    updatedSelections[event.category] = event.level;
    
    emit(state.copyWith(intensidadSelections: updatedSelections));
    
    // Auto-guardar progreso
    add(AutoSaveProgress());
  }

  void _onUpdateSelectedRiskEvent(
    UpdateSelectedRiskEvent event,
    Emitter<RiskThreatAnalysisState> emit,
  ) {
    
    if (state.selectedRiskEvent != event.riskEvent) {
      print('🔄 Nuevo evento seleccionado: ${event.riskEvent}. Limpiando TODO el estado para nuevo formulario');
      
      // Nuevo evento seleccionado - RESETEAR COMPLETAMENTE TODO EL ESTADO
      emit(state.copyWith(
        // Evento nuevo
        selectedRiskEvent: event.riskEvent,
        
        // Limpiar clasificación - volver al default
        selectedClassification: 'amenaza', // Volver a amenaza por defecto
        
        // Resetear formulario
        activeFormId: null, // Resetear para crear un nuevo formulario
        lastSaved: null,
        isSaving: false,
        isLoading: false,
        
        // Limpiar TODAS las selecciones
        probabilidadSelections: {},
        intensidadSelections: {},
        dynamicSelections: {},
        
        // Limpiar estados de UI
        dropdownOpenStates: {},
        isProbabilidadDropdownOpen: false,
        isIntensidadDropdownOpen: false,
        selectedProbabilidad: null,
        selectedIntensidad: null,
        
        // Limpiar cálculos y scores
        subClassificationScores: {},
        subClassificationColors: {},
        
        // Resetear navegación a la primera pestaña
        currentBottomNavIndex: 0,
      ));
    } else {
      // Mismo evento - solo actualizar sin cambios
      emit(state.copyWith(
        selectedRiskEvent: event.riskEvent,
      ));
    }
  }

  void _onSelectClassification(
    SelectClassification event,
    Emitter<RiskThreatAnalysisState> emit,
  ) {
    
    if (state.selectedClassification != event.classification) {
      
      Map<String, String> newProbabilidadSelections = state.probabilidadSelections;
      Map<String, String> newIntensidadSelections = state.intensidadSelections;
      Map<String, Map<String, String>> newDynamicSelections = state.dynamicSelections;
      
      // CRÍTICO: Preservar subClassificationScores existentes
      Map<String, double> preservedScores = Map<String, double>.from(state.subClassificationScores);
      Map<String, Color> preservedColors = Map<String, Color>.from(state.subClassificationColors);
      
      if (event.classification.toLowerCase() == 'amenaza') {
        // Al cambiar a amenaza, limpiar solo las selecciones de vulnerabilidad
        // pero preservar los scores de amenaza (probabilidad, intensidad)
        final vulnerabilidadKeys = newDynamicSelections.keys
            .where((key) => key != 'probabilidad' && key != 'intensidad')
            .toList();
        
        for (final key in vulnerabilidadKeys) {
          newDynamicSelections.remove(key);
          preservedScores.remove(key);
          preservedColors.remove(key);
        }
        
      } else if (event.classification.toLowerCase() == 'vulnerabilidad') {
        // Al cambiar a vulnerabilidad, preservar los scores de amenaza
        // No eliminar probabilidad e intensidad de dynamicSelections ni de scores
      }
      
      emit(state.copyWith(
        selectedClassification: event.classification,
        probabilidadSelections: newProbabilidadSelections,
        intensidadSelections: newIntensidadSelections,
        dropdownOpenStates: {}, 
        dynamicSelections: newDynamicSelections,
        subClassificationScores: preservedScores,
        subClassificationColors: preservedColors,
        currentBottomNavIndex: 0, 
      ));
    } else {
      
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
    if (!currentSelections.containsKey(subClassificationId)) {
      currentSelections[subClassificationId] = <String, String>{};
    }
    currentSelections[subClassificationId]![event.category] = event.level;
    final updatedScores = _calculateAllSubClassificationScores(currentSelections);
    final updatedColors = _calculateAllSubClassificationColors(updatedScores);

    emit(state.copyWith(
      dynamicSelections: currentSelections,
      subClassificationScores: updatedScores,
      subClassificationColors: updatedColors,
    ));
    
    // Auto-guardar progreso
    add(AutoSaveProgress());
  }
  Map<String, double> _calculateAllSubClassificationScores(Map<String, Map<String, String>> selections) {
    final scores = <String, double>{};
    
    for (final subClassificationId in selections.keys) {
      scores[subClassificationId] = _calculateSubClassificationScore(subClassificationId, selections);
    }
    
    return scores;
  }
  Map<String, Color> _calculateAllSubClassificationColors(Map<String, double> scores) {
    final colors = <String, Color>{};
    
    for (final entry in scores.entries) {
      colors[entry.key] = _getScoreColor(entry.value);
    }
    
    return colors;
  }
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
  String _getCalculationType(String subClassificationId) {
    final eventName = state.selectedRiskEvent;
    final classification = state.selectedClassification;
    
    print('DEBUG _getCalculationType:');
    print('  eventName: $eventName');
    print('  classification: $classification');
    print('  subClassificationId: $subClassificationId');
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
      if (subClassificationId == 'exposicion') {
        print('DEBUG _getCalculationType - EXPOSICION: clasificación=vulnerabilidad, returning: weighted_average');
      }
      return 'weighted_average';
    }
    final result = 'simple_average';
    print('DEBUG _getCalculationType - returning: $result');
    return result;
  }
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
    return _calculateWeightedAverage(subClassificationId, selections);
  }
  double _calculateMovimientoEnMasaProbabilidad(Map<String, String> selections) {
    
    final evidenciasValue = _getSelectedLevelValue('Evidencias de Materialización o Reactivación', selections);
    if (evidenciasValue == 4) {
      return 4.0;
    }
    
    return _calculateWeightedAverage('probabilidad', selections);
  }
  double _calculateMovimientoEnMasaIntensidad(Map<String, String> selections) {
    
    final potencialDanoValue = _getSelectedLevelValue('Potencial de Daño en Edificaciones', selections);
    if (potencialDanoValue == 4) {
      return 4.0;
    }
    return _calculateWeightedAverage('intensidad', selections);
  }
  double _calculateMovimientoEnMasaFragilidadFisica(Map<String, String> selections) {
    print('DEBUG MM FRAGILIDAD FÍSICA - selections: $selections');
    final amenazaGlobal = _calculateAmenazaGlobalScore();
    final potencialDanoEdificaciones = _getPotencialDanoEdificacionesFromAmenaza();
    
    print('DEBUG MM FRAGILIDAD FÍSICA - amenazaGlobal: $amenazaGlobal');
    print('DEBUG MM FRAGILIDAD FÍSICA - potencialDanoEdificaciones: $potencialDanoEdificaciones');
    if (amenazaGlobal >= 2.6 && potencialDanoEdificaciones == 4) {
      print('DEBUG MM FRAGILIDAD FÍSICA - Aplicando regla de tope: 4.0');
      return 4.0;
    }
    print('DEBUG MM FRAGILIDAD FÍSICA - Calculando promedio ponderado');
    final result = _calculateWeightedAverage('fragilidad_fisica', selections);
    print('DEBUG MM FRAGILIDAD FÍSICA - resultado final: $result');
    return result;
  }
  double _calculateMovimientoEnMasaFragilidadPersonas(Map<String, String> selections) {
    
    final amenazaGlobal = _calculateAmenazaGlobalScore();
    final potencialDanoEdificaciones = _getPotencialDanoEdificacionesFromAmenaza();
    if (amenazaGlobal >= 2.6 && potencialDanoEdificaciones == 4) {
      return 4.0;
    }
    return _calculateWeightedAverage('fragilidad_personas', selections);
  }
  double _calculateInundacionProbabilidad(Map<String, String> selections) {
    final criticalVariables = [
      'Evidencias de Materialización o Reactivación',
      'Evidencias de Materialización',
      'Probabilidad de Ocurrencia',
      'Registro Histórico',
    ];
    
    for (final criticalVar in criticalVariables) {
      final criticalValue = _getSelectedLevelValue(criticalVar, selections);
      
      if (criticalValue == 4) {
        return 4.0;
      }
    }
    
    return _calculateWeightedAverage('probabilidad', selections);
  }
  double _calculateInundacionIntensidad(Map<String, String> selections) {
    
    final criticalVariables = [
      'Potencial de Daño en Edificaciones',
      'Daño en Edificaciones',
      'Capacidad de Generar Pérdida de Vidas Humanas',
      'Pérdida de Vidas Humanas',
    ];
    
    for (final criticalVar in criticalVariables) {
      final criticalValue = _getSelectedLevelValue(criticalVar, selections);
      
      if (criticalValue == 4) {
        return 4.0;
      }
    }
    
    return _calculateWeightedAverage('intensidad', selections);
  }
  double _calculateInundacionFragilidadFisica(Map<String, String> selections) {
    
    final amenazaGlobal = _calculateAmenazaGlobalScore();
    final potencialDanoEdificaciones = _getPotencialDanoEdificacionesFromAmenaza();
    if (amenazaGlobal >= 2.6 && potencialDanoEdificaciones == 4) {
      return 4.0;
    }
    
    return _calculateWeightedAverage('fragilidad_fisica', selections);
  }
  double _calculateInundacionFragilidadPersonas(Map<String, String> selections) {
    
    final amenazaGlobal = _calculateAmenazaGlobalScore();
    final potencialDanoEdificaciones = _getPotencialDanoEdificacionesFromAmenaza();
    if (amenazaGlobal >= 2.6 && potencialDanoEdificaciones == 4) {
      return 4.0;
    }
    
    return _calculateWeightedAverage('fragilidad_personas', selections);
  }
  double _calculateEstructuralIntensidad(Map<String, String> selections) {
    final criticalVariables = [
      'Potencial de Daño en Edificaciones Adyacentes',
      'Potencial de Daño en Edificaciones',
      'Daño en Edificaciones Adyacentes',
      'Capacidad de Generar Pérdida de Vidas Humanas',
      'Pérdida de Vidas Humanas',
    ];
    
    for (final criticalVar in criticalVariables) {
      final criticalValue = _getSelectedLevelValue(criticalVar, selections);
      if (criticalValue == 4) {
        return 4.0;
      }
    }
    
    return _calculateWeightedAverage('intensidad', selections);
  }
  double _calculateEstructuralFragilidadFisica(Map<String, String> selections) {
    
    final amenazaGlobal = _calculateAmenazaGlobalScore();
    if (amenazaGlobal == 4.0) {
      return 4.0;
    }
    return _calculateWeightedAverage('fragilidad_fisica', selections);
  }
  double _calculateEstructuralFragilidadPersonas(Map<String, String> selections) {
    
    final amenazaGlobal = _calculateAmenazaGlobalScore();
    
    if (amenazaGlobal == 4.0) {
      return 4.0;
    }
    return _calculateWeightedAverage('fragilidad_personas', selections);
  }
  double _calculateOtrosIntensidad(Map<String, String> selections) {
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
      
      if (criticalValue == 4) {
        return 4.0;
      }
    }
    
    return _calculateWeightedAverage('intensidad', selections);
  }
  double _calculateOtrosFragilidadFisica(Map<String, String> selections) {
    
    final amenazaGlobal = _calculateAmenazaGlobalScore();
    final potencialDanoEdificaciones = _getPotencialDanoEdificacionesFromAmenaza();
    if (amenazaGlobal >= 2.6 && potencialDanoEdificaciones == 4) {
      return 4.0;
    }
    
    return _calculateWeightedAverage('fragilidad_fisica', selections);
  }
  double _calculateOtrosFragilidadPersonas(Map<String, String> selections) {
    
    final amenazaGlobal = _calculateAmenazaGlobalScore();
    final potencialDanoEdificaciones = _getPotencialDanoEdificacionesFromAmenaza();
    
    if (amenazaGlobal >= 2.6 && potencialDanoEdificaciones == 4) {
      return 4.0;
    }
    
    return _calculateWeightedAverage('fragilidad_personas', selections);
  }
  double _calculateAvenidaTorrencialProbabilidad(Map<String, String> selections) {
    
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
      if (criticalValue == 4) {
        return 4.0;
      }
    }
    return _calculateWeightedAverage('probabilidad', selections);
  }
  double _calculateAvenidaTorrencialIntensidad(Map<String, String> selections) {
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
      if (criticalValue == 4) {
        return 4.0;
      }
    }
    return _calculateWeightedAverage('intensidad', selections);
  }
  double _calculateAvenidaTorrencialFragilidadFisica(Map<String, String> selections) {
    
    final amenazaGlobal = _calculateAmenazaGlobalScore();
    final potencialDanoEdificaciones = _getPotencialDanoEdificacionesFromAmenaza();
    
    if (amenazaGlobal >= 2.6 && potencialDanoEdificaciones == 4) {
      return 4.0;
    }
    
    return _calculateWeightedAverage('fragilidad_fisica', selections);
  }
  double _calculateAvenidaTorrencialFragilidadPersonas(Map<String, String> selections) {
    
    final amenazaGlobal = _calculateAmenazaGlobalScore();
    final potencialDanoEdificaciones = _getPotencialDanoEdificacionesFromAmenaza();
    
    if (amenazaGlobal >= 2.6 && potencialDanoEdificaciones == 4) {
      return 4.0;
    }
    return _calculateWeightedAverage('fragilidad_personas', selections);
  }
  
  double calculateAmenazaGlobalScore() {
    print('DEBUG calculateAmenazaGlobalScore called');
    final result = _calculateAmenazaGlobalScore();
    print('DEBUG calculateAmenazaGlobalScore result: $result');
    return result;
  }

  double _calculateAmenazaGlobalScore() {
    final eventName = state.selectedRiskEvent;
    if (eventName == 'Inundación') {
      return _calculateInundacionAmenazaFinal();
    }
    if (eventName == 'Movimiento en Masa') {
      return _calculateMovimientoEnMasaAmenazaFinal();
    }
    if (eventName == 'Avenida Torrencial') {
      return _calculateAvenidaTorrencialAmenazaFinal();
    }
    if (eventName == 'Estructural') {
      return _calculateEstructuralAmenazaFinal();
    }
    if (eventName == 'Otros') {
      return _calculateOtrosAmenazaFinal();
    }
    final probabilidadScore = state.subClassificationScores['probabilidad'] ?? 0.0;
    final intensidadScore = state.subClassificationScores['intensidad'] ?? 0.0;
    if (probabilidadScore == 0.0 || intensidadScore == 0.0) {
      return 0.0;
    }
    return (probabilidadScore + intensidadScore) / 2;
  }
  int _getPotencialDanoEdificacionesFromAmenaza() {
    
    final intensidadSelections = state.dynamicSelections['intensidad'] ?? {};
    return _getSelectedLevelValue('Potencial de Daño en Edificaciones', intensidadSelections);
  }
  double _calculateWeightedAverage(String subClassificationId, Map<String, String> selections) {
    try {
      
      final eventModel = _getCurrentEventModel();
      if (eventModel == null) return _calculateSimpleAverage(subClassificationId, selections);
      final classification = eventModel.classifications
          .where((c) => c.id == state.selectedClassification)
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
      
      final result = sumWi > 0 ? sumCalificacionPorWi / sumWi : 0.0;
      if (subClassificationId == 'exposicion') {
        print('DEBUG EXPOSICIÓN _calculateWeightedAverage:');
        print('  sumCalificacionPorWi: $sumCalificacionPorWi');
        print('  sumWi: $sumWi');
        print('  result: $result');
        for (final category in subClassification.categories) {
          final selectedLevel = selections[category.title];
          if (selectedLevel != null && selectedLevel.isNotEmpty && selectedLevel != 'NA') {
            final calificacion = _getSelectedLevelValue(category.title, {category.title: selectedLevel});
            print('  ${category.title}: Wi=${category.wi}, Valor=$calificacion, Calificación=${calificacion * category.wi}');
          }
        }
      }
      
      return result;
      
    } catch (e) {
      
      if (subClassificationId == 'exposicion') {
        print('DEBUG EXPOSICIÓN - ERROR en _calculateWeightedAverage, fallback a simple_average: $e');
      }
      return _calculateSimpleAverage(subClassificationId, selections);
    }
  }
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


  Color _getScoreColor(double score) {
    if (score == 0) {
      return Colors.transparent; 
    } else if (score <= 1.75) {
      return const Color(0xFF22C55E); 
    } else if (score <= 2.50) {
      return const Color(0xFFFDE047); 
    } else if (score <= 3.25) {
      return const Color(0xFFFB923C); 
    } else {
      return const Color(0xFFDC2626); 
    }
  }
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
  
  int getCategoryCalificacion(String subClassificationId, String categoryId, int wi) {
    final selections = getSelectionsForSubClassification(subClassificationId);
    final selectedLevel = selections[categoryId];
    
    if (selectedLevel == null) return 0;
    
    final value = _getLevelValue(selectedLevel);
    return wi * value;
  }
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
  String calculateThreatRating() {
    if (state.selectedClassification == 'amenaza') {
      return _calculateAmenazaRating();
    } else {
      return _calculateVulnerabilidadRating();
    }
  }
  String _calculateAmenazaRating() {
    final finalScore = _calculateAmenazaFinalScore();
    
    if (finalScore == 0.0) {
      return 'SIN CALIFICAR';
    }
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
  String _calculateVulnerabilidadRating() {
    final finalScore = _calculateVulnerabilidadFinalScore();
    
    if (finalScore == 0.0) {
      return 'SIN CALIFICAR';
    }
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
  double calculateCompletionPercentage() {
    
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
  double calculateFinalScore() {
    if (state.selectedClassification == 'amenaza') {
      return _calculateAmenazaFinalScore();
    } else {
      return _calculateVulnerabilidadFinalScore();
    }
  }
  double _calculateAmenazaFinalScore() {
    final eventName = state.selectedRiskEvent;
    if (eventName == 'Inundación') {
      return _calculateInundacionAmenazaFinal();
    }
    if (eventName == 'Movimiento en Masa') {
      return _calculateMovimientoEnMasaAmenazaFinal();
    }
    if (eventName == 'Avenida Torrencial') {
      return _calculateAvenidaTorrencialAmenazaFinal();
    }
    if (eventName == 'Estructural') {
      return _calculateEstructuralAmenazaFinal();
    }
    if (eventName == 'Otros') {
      return _calculateOtrosAmenazaFinal();
    }
    final probAverage = calculateProbabilidadAverage();
    final intAverage = calculateIntensidadAverage();
    
    if (probAverage == 0.0 || intAverage == 0.0) {
      return 0.0;
    }
    
    return (probAverage + intAverage) / 2;
  }
  double _calculateMovimientoEnMasaAmenazaFinal() {
    
    final probabilidadScore = state.subClassificationScores['probabilidad'] ?? 0.0;
    final intensidadScore = state.subClassificationScores['intensidad'] ?? 0.0;
    
    if (probabilidadScore == 0.0 || intensidadScore == 0.0) {
      return 0.0;
    }
    
    final probabilidadPonderada = probabilidadScore * 0.4;
    final intensidadPonderada = intensidadScore * 0.6;
    
    final amenazaFinal = probabilidadPonderada + intensidadPonderada;
    return amenazaFinal;
  }
  double _calculateInundacionAmenazaFinal() {
    
    final probabilidadScore = state.subClassificationScores['probabilidad'] ?? 0.0;
    final intensidadScore = state.subClassificationScores['intensidad'] ?? 0.0;
    if (probabilidadScore == 0.0 || intensidadScore == 0.0) {
      return 0.0;
    }
    final probabilidadPonderada = probabilidadScore * 0.4;
    final intensidadPonderada = intensidadScore * 0.6;
    
    final amenazaFinal = probabilidadPonderada + intensidadPonderada;
    return amenazaFinal;
  }
  double _calculateAvenidaTorrencialAmenazaFinal() {
    
    final probabilidadScore = state.subClassificationScores['probabilidad'] ?? 0.0;
    final intensidadScore = state.subClassificationScores['intensidad'] ?? 0.0;
    if (probabilidadScore == 0.0 || intensidadScore == 0.0) {
      return 0.0;
    }
    
    final probabilidadPonderada = probabilidadScore * 0.4;
    final intensidadPonderada = intensidadScore * 0.6;
    
    final amenazaFinal = probabilidadPonderada + intensidadPonderada;
    return amenazaFinal;
  }
  double _calculateEstructuralAmenazaFinal() {
    
    final probabilidadScore = state.subClassificationScores['probabilidad'] ?? 0.0;
    final intensidadScore = state.subClassificationScores['intensidad'] ?? 0.0;
    if (probabilidadScore == 0.0 || intensidadScore == 0.0) {
      return 0.0;
    }
    
    final probabilidadPonderada = probabilidadScore * 0.6;
    final intensidadPonderada = intensidadScore * 0.4;
    
    final amenazaFinal = probabilidadPonderada + intensidadPonderada;
    return amenazaFinal;
  }
  double _calculateOtrosAmenazaFinal() {
    
    final probabilidadScore = state.subClassificationScores['probabilidad'] ?? 0.0;
    final intensidadScore = state.subClassificationScores['intensidad'] ?? 0.0;
    if (probabilidadScore == 0.0 || intensidadScore == 0.0) {
      return 0.0;
    }
    
    final probabilidadPonderada = probabilidadScore * 0.6;
    final intensidadPonderada = intensidadScore * 0.4;
    
    final amenazaFinal = probabilidadPonderada + intensidadPonderada;
    return amenazaFinal;
  }
  
  double calculateVulnerabilidadFinalScore() {
    return _calculateVulnerabilidadFinalScore();
  }

  double _calculateVulnerabilidadFinalScore() {
    final eventName = state.selectedRiskEvent;
    if (eventName == 'Inundación') {
      return _calculateInundacionVulnerabilidadFinal();
    }
    if (eventName == 'Movimiento en Masa') {
      return _calculateMovimientoEnMasaVulnerabilidadFinal();
    }
    if (eventName == 'Avenida Torrencial') {
      return _calculateAvenidaTorrencialVulnerabilidadFinal();
    }
    if (eventName == 'Estructural') {
      return _calculateEstructuralVulnerabilidadFinal();
    }
    if (eventName == 'Otros') {
      return _calculateOtrosVulnerabilidadFinal();
    }
    return _calculateGenericVulnerabilidadFinal();
  }
  double _calculateInundacionVulnerabilidadFinal() {
    
    final fragilidadFisicaScore = state.subClassificationScores['fragilidad_fisica'] ?? 0.0;      
    final fragilidadPersonasScore = state.subClassificationScores['fragilidad_personas'] ?? 0.0;  
    final exposicionScore = state.subClassificationScores['exposicion'] ?? 0.0;                   
    if (fragilidadFisicaScore == 0.0 || fragilidadPersonasScore == 0.0 || exposicionScore == 0.0) {
      return 0.0;
    }
    
    final e6_x_d6 = fragilidadFisicaScore * 0.45;
    final e7_x_d7 = fragilidadPersonasScore * 0.10;
    final e8_x_d8 = exposicionScore * 0.45;
    final vulnerabilidadFinal = e6_x_d6 + e7_x_d7 + e8_x_d8;
    
    return vulnerabilidadFinal;
  }
  double _calculateMovimientoEnMasaVulnerabilidadFinal() {
    
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
  double _calculateAvenidaTorrencialVulnerabilidadFinal() {
    
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
  double _calculateEstructuralVulnerabilidadFinal() {
    
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
  double _calculateOtrosVulnerabilidadFinal() {
    
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
  double _calculateGenericVulnerabilidadFinal() {
    
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
  Color getThreatBackgroundColor() {
    final rating = calculateThreatRating();
    
    switch (rating) {
      case 'BAJO':
        return const Color(0xFF22C55E); 
      case 'MEDIO-BAJO':
        return const Color(0xFFFDE047); 
      case 'MEDIO-ALTO':
        return const Color(0xFFFB923C); 
      case 'ALTO':
        return const Color(0xFFDC2626); 
      default:
        return const Color(0xFFD1D5DB); 
    }
  }
  Color getThreatTextColor() {
    final rating = calculateThreatRating();
    
    switch (rating) {
      case 'BAJO':
      case 'MEDIO-ALTO':
      case 'ALTO':
        return const Color(0xFFFFFFFF); 
      case 'MEDIO-BAJO':
      default:
        return const Color(0xFF1E1E1E); 
    }
  }
  String getFormattedThreatRating() {
    final rating = calculateThreatRating();
    
    if (rating == 'SIN CALIFICAR') {
      return rating;
    }
    
    final score = calculateFinalScore().toStringAsFixed(1).replaceAll('.', ',');
    if (rating.length > 5) {
      return '$score\n$rating';
    }
    
    return '$score $rating';
  }
  List<DropdownCategory> getCategoriesForEvent(String selectedEvent) {
    
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
  List<RiskSubClassification> getAmenazaSubClassifications() {
    final selectedEvent = state.selectedRiskEvent;
    final threatClassifications = RiskModelAdapter.getThreatSubClassifications(selectedEvent);
    return threatClassifications;
  }
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
    if (subClassificationId == 'probabilidad') {
      return getCategoriesForSelectedEvent();
    } else if (subClassificationId == 'intensidad') {
      return getIntensidadCategories();
    }
    
    return [];
  }
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
    if (state.selectedClassification == 'amenaza') {
      return getCategoriesForSubClassification(subClassificationId);
    }
    
    return [];
  }
  String? getValueForSubClassification(String subClassificationId) {
    switch (subClassificationId) {
      case 'probabilidad':
        return state.selectedProbabilidad;
      case 'intensidad':
        return state.selectedIntensidad;
      default:
        
        return null;
    }
  }
  bool getIsSelectedForSubClassification(String subClassificationId) {
    switch (subClassificationId) {
      case 'probabilidad':
        return state.isProbabilidadDropdownOpen;
      case 'intensidad':
        return state.isIntensidadDropdownOpen;
      default:
        
        return state.dropdownOpenStates[subClassificationId] ?? false;
    }
  }
  void handleDropdownTap(String subClassificationId) {
    
    if (subClassificationId != 'probabilidad' && subClassificationId != 'intensidad') {
      add(ToggleDynamicDropdown(subClassificationId));
      return;
    }
    switch (subClassificationId) {
      case 'probabilidad':
        add(ToggleProbabilidadDropdown());
        break;
      case 'intensidad':
        add(ToggleIntensidadDropdown());
        break;
    }
  }
  void handleSelectionChanged(String subClassificationId, String category, String level) {
    
    if (subClassificationId != 'probabilidad' && subClassificationId != 'intensidad') {
      add(UpdateDynamicSelection(subClassificationId, category, level));
      return;
    }
    switch (subClassificationId) {
      case 'probabilidad':
        add(UpdateProbabilidadSelection(category, level));
        break;
      case 'intensidad':
        add(UpdateIntensidadSelection(category, level));
        break;
    }
  }
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

  // Métodos de persistencia de formularios
  Future<void> _onSaveCurrentFormData(
    SaveCurrentFormData event,
    Emitter<RiskThreatAnalysisState> emit,
  ) async {
    emit(state.copyWith(isSaving: true));
    
    try {
      final formData = _createFormDataFromCurrentState();
      
      // Generar ID único basado en evento y timestamp para evitar sobrescritura
      String formId;
      if (state.activeFormId != null) {
        // Si ya existe un activeFormId, usarlo (para actualizar formulario existente)
        formId = state.activeFormId!;
        print('📝 Actualizando formulario existente: $formId');
      } else {
        // Nuevo formulario: generar ID único con evento y timestamp
        final timestamp = DateTime.now().millisecondsSinceEpoch;
        final eventSafe = state.selectedRiskEvent.replaceAll(' ', '_').toLowerCase();
        formId = '${eventSafe}_$timestamp';
        print('✨ Creando NUEVO formulario: $formId para evento: ${state.selectedRiskEvent}');
      }
      
      // Actualizar el formData con el ID correcto
      final FormDataModel updatedFormData = formData.copyWith(id: formId);
      
      await FormPersistenceService().saveForm(updatedFormData);
      
      emit(state.copyWith(
        isSaving: false,
        activeFormId: formId,
        lastSaved: DateTime.now(),
      ));
    } catch (e) {
      print('Error saving form data: $e');
      emit(state.copyWith(isSaving: false));
    }
  }

  Future<void> _onLoadFormData(
    LoadFormData event,
    Emitter<RiskThreatAnalysisState> emit,
  ) async {
    emit(state.copyWith(isLoading: true));
    
    try {
      final formData = await FormPersistenceService().getFormById(event.formId);
      if (formData != null) {
        emit(_createStateFromFormData(formData).copyWith(
          isLoading: false,
          activeFormId: event.formId,
        ));
      } else {
        emit(state.copyWith(isLoading: false));
      }
    } catch (e) {
      emit(state.copyWith(isLoading: false));
    }
  }

  Future<void> _onResetToNewForm(
    ResetToNewForm event,
    Emitter<RiskThreatAnalysisState> emit,
  ) async {

    
    // Resetear COMPLETAMENTE todo el estado para un formulario nuevo
    emit(RiskThreatAnalysisState(
      selectedRiskEvent: event.eventType,
      selectedClassification: 'amenaza', // Siempre empezar con amenaza
      currentBottomNavIndex: 0, // Ir a la primera pestaña
      // Todos los demás valores toman los defaults del constructor
    ));
  }

  Future<void> _onCompleteForm(
    CompleteForm event,
    Emitter<RiskThreatAnalysisState> emit,
  ) async {
    if (state.activeFormId == null) return;
    
    emit(state.copyWith(isSaving: true));
    
    try {
      final formData = _createFormDataFromCurrentState();
      final completedFormData = formData.copyWith(
        status: FormStatus.completed,
        lastModified: DateTime.now(),
        progressPercentage: 100.0,
      );
      
      await FormPersistenceService().saveForm(completedFormData);
      
      emit(state.copyWith(
        isSaving: false,
        lastSaved: DateTime.now(),
      ));
    } catch (e) {
      emit(state.copyWith(isSaving: false));
    }
  }

  Future<void> _onAutoSaveProgress(
    AutoSaveProgress event,
    Emitter<RiskThreatAnalysisState> emit,
  ) async {
    if (state.activeFormId != null) {
      add(SaveCurrentFormData());
    }
  }

  // Método para crear FormDataModel desde el estado actual
  FormDataModel _createFormDataFromCurrentState() {
    final now = DateTime.now();
    return FormDataModel(
      id: state.activeFormId ?? now.millisecondsSinceEpoch.toString(),
      title: 'Análisis de Riesgo - ${state.selectedRiskEvent}',
      eventType: state.selectedRiskEvent,
      formType: FormType.riskAnalysis,
      status: FormStatus.inProgress,
      createdAt: now,
      lastModified: now,
      progressPercentage: _calculateProgressPercentage(),
      threatProgress: _calculateThreatProgress(),
      vulnerabilityProgress: _calculateVulnerabilityProgress(),
      riskAnalysisData: {
        'selectedRiskEvent': state.selectedRiskEvent,
        'selectedClassification': state.selectedClassification,
        'probabilidadSelections': state.probabilidadSelections,
        'intensidadSelections': state.intensidadSelections,
        'dynamicSelections': state.dynamicSelections,
        'subClassificationScores': state.subClassificationScores.map(
          (key, value) => MapEntry(key, value.toString()),
        ),
      },
      edeData: const {},
    );
  }

  // Método para crear estado desde FormDataModel
  RiskThreatAnalysisState _createStateFromFormData(FormDataModel formData) {
    final riskData = formData.riskAnalysisData;
    
    return state.copyWith(
      selectedRiskEvent: riskData['selectedRiskEvent'] as String? ?? state.selectedRiskEvent,
      selectedClassification: riskData['selectedClassification'] as String? ?? state.selectedClassification,
      probabilidadSelections: Map<String, String>.from(
        riskData['probabilidadSelections'] as Map? ?? {},
      ),
      intensidadSelections: Map<String, String>.from(
        riskData['intensidadSelections'] as Map? ?? {},
      ),
      dynamicSelections: (riskData['dynamicSelections'] as Map?)?.map(
        (key, value) => MapEntry(
          key.toString(),
          Map<String, String>.from(value as Map),
        ),
      ) ?? {},
      subClassificationScores: (riskData['subClassificationScores'] as Map?)?.map(
        (key, value) => MapEntry(
          key.toString(),
          double.tryParse(value.toString()) ?? 0.0,
        ),
      ) ?? {},
    );
  }

  // Métodos de cálculo de progreso
  double _calculateProgressPercentage() {
    // Calcular progreso basado en las selecciones realizadas
    double total = 0.0;
    double completed = 0.0;
    
    // Si tenemos clasificación seleccionada, eso cuenta como progreso inicial
    if (state.selectedClassification.isNotEmpty) {
      completed += 0.5; // Progreso base por tener clasificación
    }
    
    // Contar probabilidad y intensidad como base
    total += 2;
    if (state.probabilidadSelections.isNotEmpty) completed += 1;
    if (state.intensidadSelections.isNotEmpty) completed += 1;
    
    // Agregar selecciones dinámicas
    final expectedSelections = _getExpectedSelectionsForRiskEvent();
    total += expectedSelections.length;
    for (final selection in expectedSelections) {
      if (state.dynamicSelections[selection]?.isNotEmpty == true) {
        completed += 1;
      }
    }
    
    // Asegurar que siempre haya al menos un mínimo de progreso cuando se inicia
    final progress = total > 0 ? (completed / (total + 0.5)) * 100.0 : 0.0;
    
    // Si hay alguna selección pero el progreso es muy bajo, garantizar un mínimo del 5%
    if (progress > 0 && progress < 5.0) {
      return 5.0;
    }
    
    return progress;
  }

  double _calculateThreatProgress() {
    if (state.selectedClassification != 'amenaza') return 0.0;
    
    double total = 2.0; // probabilidad + intensidad
    double completed = 0.0;
    
    if (state.probabilidadSelections.isNotEmpty) completed += 1;
    if (state.intensidadSelections.isNotEmpty) completed += 1;
    
    return total > 0 ? (completed / total) * 100.0 : 0.0;
  }

  double _calculateVulnerabilityProgress() {
    if (state.selectedClassification != 'vulnerabilidad') return 0.0;
    
    final expectedSelections = _getExpectedSelectionsForRiskEvent();
    if (expectedSelections.isEmpty) return 0.0;
    
    double completed = 0.0;
    for (final selection in expectedSelections) {
      if (state.dynamicSelections[selection]?.isNotEmpty == true) {
        completed += 1;
      }
    }
    
    return (completed / expectedSelections.length) * 100.0;
  }

  List<String> _getExpectedSelectionsForRiskEvent() {
    switch (state.selectedRiskEvent) {
      case 'Movimiento en Masa':
        return ['social', 'economico', 'ambiental', 'fisico'];
      case 'Inundación':
        return ['social', 'economico', 'ambiental', 'fisico'];
      case 'Avenida Torrencial':
        return ['social', 'economico', 'ambiental', 'fisico'];
      case 'Incendio de Cobertura Vegetal':
        return ['social', 'economico', 'ambiental', 'fisico'];
      case 'Sismo':
        return ['social', 'economico', 'ambiental', 'fisico'];
      case 'Vendaval':
        return ['social', 'economico', 'ambiental', 'fisico'];
      case 'Granizada':
        return ['social', 'economico', 'ambiental', 'fisico'];
      default:
        return [];
    }
  }

}