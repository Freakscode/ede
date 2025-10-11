import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:caja_herramientas/app/shared/models/models.dart';

import 'events/risk_threat_analysis_event.dart';
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
    
    // Actualizar las dynamicSelections para usar el sistema correcto
    final currentSelections = Map<String, Map<String, String>>.from(state.dynamicSelections);
    if (!currentSelections.containsKey('probabilidad')) {
      currentSelections['probabilidad'] = <String, String>{};
    }
    currentSelections['probabilidad']!['Probabilidad'] = event.probabilidad;
    
    // Calcular score usando el sistema correcto
    final probabilidadScore = _calculateSubClassificationScore('probabilidad', currentSelections);
    
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
    
    // Actualizar las dynamicSelections para usar el sistema correcto
    final currentSelections = Map<String, Map<String, String>>.from(state.dynamicSelections);
    if (!currentSelections.containsKey('intensidad')) {
      currentSelections['intensidad'] = <String, String>{};
    }
    currentSelections['intensidad']!['Intensidad'] = event.intensidad;
    
    // Calcular score usando el sistema correcto
    final intensidadScore = _calculateSubClassificationScore('intensidad', currentSelections);
    
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
    print('=== RiskThreatAnalysisBloc: ResetDropdowns ejecutado ===');
    print('Estado anterior: ${state.toString()}');
    print('Estado anterior - dynamicSelections: ${state.dynamicSelections}');
    print('Estado anterior - probabilidadSelections: ${state.probabilidadSelections}');
    print('Estado anterior - intensidadSelections: ${state.intensidadSelections}');
    
    // Reset completo a estado inicial
    emit(const RiskThreatAnalysisState());
    
    print('Estado nuevo: Estado inicial completamente limpio');
    print('=== Fin ResetDropdowns ===');
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
    
    if (state.selectedRiskEvent != event.riskEvent) {
      
      // Nuevo evento seleccionado - RESETEAR COMPLETAMENTE TODO EL ESTADO
      emit(state.copyWith(
        // Evento nuevo
        selectedRiskEvent: event.riskEvent,
        
        // Limpiar clasificación - volver al default
        selectedClassification: 'amenaza', // Volver a amenaza por defecto
        
        // Resetear estado de carga
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
      }
      return 'weighted_average';
    }
    final result = 'simple_average';
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
    final amenazaGlobal = _calculateAmenazaGlobalScore();
    final potencialDanoEdificaciones = _getPotencialDanoEdificacionesFromAmenaza();
    
    if (amenazaGlobal >= 2.6 && potencialDanoEdificaciones == 4) {
      return 4.0;
    }
    final result = _calculateWeightedAverage('fragilidad_fisica', selections);
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
    final result = _calculateAmenazaGlobalScore();
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
        for (final category in subClassification.categories) {
          final selectedLevel = selections[category.title];
          if (selectedLevel != null && selectedLevel.isNotEmpty && selectedLevel != 'NA') {
            _getSelectedLevelValue(category.title, {category.title: selectedLevel});
          }
        }
      }
      
      return result;
      
    } catch (e) {
      
      if (subClassificationId == 'exposicion') {
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

  void _onShowFinalResults(
    ShowFinalResults event,
    Emitter<RiskThreatAnalysisState> emit,
  ) {
    emit(state.copyWith(showFinalResults: event.show));
  }

  /// Carga datos existentes de un formulario
  void _onLoadFormData(
    LoadFormData event,
    Emitter<RiskThreatAnalysisState> emit,
  ) {
    print('=== _onLoadFormData DEBUG ===');
    print('Event: ${event.eventName}_${event.classificationType}');
    print('FormData recibido: ${event.formData}');
    
    // Cargar las selecciones dinámicas
    final dynamicSelections = Map<String, Map<String, String>>.from(event.formData['dynamicSelections'] ?? {});
    
    // Cargar scores
    final subClassificationScores = Map<String, double>.from(event.formData['subClassificationScores'] ?? {});
    
    // Cargar colores de scores
    final colorsData = Map<String, dynamic>.from(event.formData['subClassificationColors'] ?? {});
    final subClassificationColors = <String, Color>{};
    colorsData.forEach((key, value) {
      if (value is Color) {
        subClassificationColors[key] = value;
      }
    });
    
    // Cargar selecciones específicas de probabilidad e intensidad
    final probabilidadSelections = Map<String, String>.from(event.formData['probabilidadSelections'] ?? {});
    final intensidadSelections = Map<String, String>.from(event.formData['intensidadSelections'] ?? {});
    
    // Cargar valores seleccionados para mostrar en dropdowns
    final selectedProbabilidad = event.formData['selectedProbabilidad'] as String?;
    final selectedIntensidad = event.formData['selectedIntensidad'] as String?;
    
    print('Datos procesados:');
    print('  - dynamicSelections: $dynamicSelections');
    print('  - probabilidadSelections: $probabilidadSelections');
    print('  - intensidadSelections: $intensidadSelections');
    print('  - selectedProbabilidad: $selectedProbabilidad');
    print('  - selectedIntensidad: $selectedIntensidad');
    print('  - subClassificationScores: $subClassificationScores');
    print('=== FIN _onLoadFormData DEBUG ===');
    
    emit(state.copyWith(
      dynamicSelections: dynamicSelections,
      subClassificationScores: subClassificationScores,
      subClassificationColors: subClassificationColors,
      probabilidadSelections: probabilidadSelections,
      intensidadSelections: intensidadSelections,
      selectedProbabilidad: selectedProbabilidad,
      selectedIntensidad: selectedIntensidad,
      isLoading: false,
    ));
    
    print('Estado actualizado con datos del formulario para: ${event.eventName}_${event.classificationType}');
  }

  /// Guarda datos actuales del formulario
  void _onSaveFormData(
    SaveFormData event,
    Emitter<RiskThreatAnalysisState> emit,
  ) {
    // Los datos se guardan a través del HomeBloc
    // Este evento solo notifica que se deben guardar los datos
    print('Datos del formulario guardados para: ${event.eventName}_${event.classificationType}');
  }



  /// Método para cargar datos existentes de una evaluación específica
  void loadExistingFormData(String eventName, String classificationType, Map<String, dynamic>? savedData) {
    if (savedData != null && savedData['evaluationData'] != null) {
      final evaluationData = savedData['evaluationData'] as Map<String, dynamic>;
      
      // Cargar los datos existentes
      add(LoadFormData(eventName, classificationType, evaluationData));
      
      print('Cargando datos existentes para: $eventName - $classificationType');
    } else {
      print('No hay datos existentes para: $eventName - $classificationType');
    }
  }

  /// Método para obtener datos actuales del formulario para guardar
  Map<String, dynamic> getCurrentFormData() {
    return {
      'dynamicSelections': state.dynamicSelections,
      'subClassificationScores': state.subClassificationScores,
      'subClassificationColors': state.subClassificationColors,
      'probabilidadSelections': state.probabilidadSelections,
      'intensidadSelections': state.intensidadSelections,
      'selectedProbabilidad': state.selectedProbabilidad,
      'selectedIntensidad': state.selectedIntensidad,
    };
  }

  /// Valida si hay variables sin calificar en la clasificación actual
  bool hasUnqualifiedVariables() {
    final classification = state.selectedClassification.toLowerCase();
    
    if (classification == 'amenaza') {
      // Para amenaza, verificar probabilidad e intensidad
      final probabilidadSelections = state.probabilidadSelections;
      final intensidadSelections = state.intensidadSelections;
      
      // Obtener el evento de riesgo para acceder a las categorías
      final riskEvent = RiskEventFactory.getEventByName(state.selectedRiskEvent);
      if (riskEvent == null) return false;
      
      final amenazaClassifications = riskEvent.classifications
          .where((c) => c.name.toLowerCase() == 'amenaza')
          .toList();
      
      if (amenazaClassifications.isNotEmpty) {
        final amenazaClassification = amenazaClassifications.first;
        final probabilidadSubClass = amenazaClassification.subClassifications
            .where((sc) => sc.id == 'probabilidad')
            .firstOrNull;
        final intensidadSubClass = amenazaClassification.subClassifications
            .where((sc) => sc.id == 'intensidad')
            .firstOrNull;
        
        if (probabilidadSubClass != null) {
          // Verificar que todas las categorías de probabilidad estén calificadas
          for (final category in probabilidadSubClass.categories) {
            if (!probabilidadSelections.containsKey(category.title)) {
              print('RiskThreatAnalysisBloc: Variable sin calificar en Probabilidad: ${category.title}');
              return true;
            }
          }
        }
        
        if (intensidadSubClass != null) {
          // Verificar que todas las categorías de intensidad estén calificadas
          for (final category in intensidadSubClass.categories) {
            if (!intensidadSelections.containsKey(category.title)) {
              print('RiskThreatAnalysisBloc: Variable sin calificar en Intensidad: ${category.title}');
              return true;
            }
          }
        }
      }
      
    } else if (classification == 'vulnerabilidad') {
      // Para vulnerabilidad, verificar todas las subclasificaciones dinámicas
      final dynamicSelections = state.dynamicSelections;
      
      // Obtener el evento de riesgo para acceder a las categorías
      final riskEvent = RiskEventFactory.getEventByName(state.selectedRiskEvent);
      if (riskEvent == null) return false;
      
      final vulnerabilidadClassifications = riskEvent.classifications
          .where((c) => c.name.toLowerCase() == 'vulnerabilidad')
          .toList();
      
      if (vulnerabilidadClassifications.isNotEmpty) {
        final vulnerabilidadClassification = vulnerabilidadClassifications.first;
        
        // Verificar todas las subclasificaciones de vulnerabilidad
        for (final subClass in vulnerabilidadClassification.subClassifications) {
          final subClassSelections = dynamicSelections[subClass.id] ?? {};
          
          // Verificar que todas las categorías de esta subclasificación estén calificadas
          for (final category in subClass.categories) {
            if (!subClassSelections.containsKey(category.title)) {
              print('RiskThreatAnalysisBloc: Variable sin calificar en Vulnerabilidad - ${subClass.name}: ${category.title}');
              return true;
            }
          }
        }
      }
    }
    
    return false; // Todas las variables están calificadas
  }

  void _onUpdateImageCoordinates(
    UpdateImageCoordinates event,
    Emitter<RiskThreatAnalysisState> emit,
  ) {
    // Este método se mantiene para compatibilidad con el LocationDialog original
    // Las nuevas coordenadas se manejan con UpdateEvidenceCoordinates
    emit(state);
  }

  void _onGetCurrentLocationForImage(
    GetCurrentLocationForImage event,
    Emitter<RiskThreatAnalysisState> emit,
  ) async {
    // Este método se mantiene para compatibilidad con el LocationDialog original
    // Las nuevas ubicaciones se manejan con UpdateEvidenceCoordinates
    emit(state);
  }

  void _onSelectLocationFromMapForImage(
    SelectLocationFromMapForImage event,
    Emitter<RiskThreatAnalysisState> emit,
  ) {
    // Este método se mantiene para compatibilidad con el LocationDialog original
    // Las nuevas selecciones de ubicación se manejan con UpdateEvidenceCoordinates
    emit(state);
  }

  /// Agregar imagen de evidencia para una categoría específica
  void _onAddEvidenceImage(
    AddEvidenceImage event,
    Emitter<RiskThreatAnalysisState> emit,
  ) {
    final updatedImages = Map<String, List<String>>.from(state.evidenceImages);
    
    if (!updatedImages.containsKey(event.category)) {
      updatedImages[event.category] = [];
    }
    
    updatedImages[event.category]!.add(event.imagePath);
    
    emit(state.copyWith(evidenceImages: updatedImages));
  }

  /// Remover imagen de evidencia para una categoría específica
  void _onRemoveEvidenceImage(
    RemoveEvidenceImage event,
    Emitter<RiskThreatAnalysisState> emit,
  ) {
    final updatedImages = Map<String, List<String>>.from(state.evidenceImages);
    final updatedCoordinates = Map<String, Map<int, Map<String, String>>>.from(state.evidenceCoordinates);
    
    if (updatedImages.containsKey(event.category) && 
        event.imageIndex < updatedImages[event.category]!.length) {
      
      // Remover la imagen
      updatedImages[event.category]!.removeAt(event.imageIndex);
      
      // Remover coordenadas asociadas y reindexar
      if (updatedCoordinates.containsKey(event.category)) {
        final categoryCoordinates = Map<int, Map<String, String>>.from(updatedCoordinates[event.category]!);
        categoryCoordinates.remove(event.imageIndex);
        
        // Reindexar coordenadas
        final reindexedCoordinates = <int, Map<String, String>>{};
        categoryCoordinates.forEach((key, value) {
          if (key > event.imageIndex) {
            reindexedCoordinates[key - 1] = value;
          } else {
            reindexedCoordinates[key] = value;
          }
        });
        
        updatedCoordinates[event.category] = reindexedCoordinates;
      }
    }
    
    emit(state.copyWith(
      evidenceImages: updatedImages,
      evidenceCoordinates: updatedCoordinates,
    ));
  }

  /// Actualizar coordenadas de imagen de evidencia para una categoría específica
  void _onUpdateEvidenceCoordinates(
    UpdateEvidenceCoordinates event,
    Emitter<RiskThreatAnalysisState> emit,
  ) {
    final updatedCoordinates = Map<String, Map<int, Map<String, String>>>.from(state.evidenceCoordinates);
    
    if (!updatedCoordinates.containsKey(event.category)) {
      updatedCoordinates[event.category] = {};
    }
    
    updatedCoordinates[event.category]![event.imageIndex] = {
      'lat': event.lat,
      'lng': event.lng,
    };
    
    emit(state.copyWith(evidenceCoordinates: updatedCoordinates));
  }

  /// Cargar datos de evidencia para una categoría específica
  void _onLoadEvidenceData(
    LoadEvidenceData event,
    Emitter<RiskThreatAnalysisState> emit,
  ) {
    final updatedImages = Map<String, List<String>>.from(state.evidenceImages);
    final updatedCoordinates = Map<String, Map<int, Map<String, String>>>.from(state.evidenceCoordinates);
    
    updatedImages[event.category] = List<String>.from(event.imagePaths);
    updatedCoordinates[event.category] = Map<int, Map<String, String>>.from(event.coordinates);
    
    emit(state.copyWith(
      evidenceImages: updatedImages,
      evidenceCoordinates: updatedCoordinates,
    ));
  }

  @override
  Future<void> close() {
    return super.close();
  }
}