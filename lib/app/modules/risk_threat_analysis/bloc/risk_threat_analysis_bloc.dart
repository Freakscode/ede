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
    on<ShowFinalResults>(_onShowFinalResults);
    on<LoadAmenazaData>(_onLoadAmenazaData);
    on<LoadVulnerabilidadData>(_onLoadVulnerabilidadData);
    on<LoadFormWithClassificationData>(_onLoadFormWithClassificationData);
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
        // CRÍTICO: Preservar activeFormId para mantener la continuidad del formulario
        activeFormId: state.activeFormId, 
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
            final calificacion = _getSelectedLevelValue(category.title, {category.title: selectedLevel});
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

  // Métodos de persistencia de formularios
  Future<void> _onSaveCurrentFormData(
    SaveCurrentFormData event,
    Emitter<RiskThreatAnalysisState> emit,
  ) async {
    emit(state.copyWith(isSaving: true));
    
    try {
      final formData = _createFormDataFromCurrentState();
      
      String formId;
      bool isUpdatingExisting = false;
      
      if (state.activeFormId != null && state.activeFormId!.isNotEmpty) {
        // CASO 1: Formulario existente - ACTUALIZAR (mantener ID original)
        formId = state.activeFormId!;
        isUpdatingExisting = true;
      } else {
        // CASO 2: Formulario nuevo - CREAR (generar nuevo ID único)
        final timestamp = DateTime.now().millisecondsSinceEpoch;
        final eventSafe = state.selectedRiskEvent.replaceAll(' ', '_').toLowerCase();
        formId = '${eventSafe}_$timestamp';
        isUpdatingExisting = false;
      }
      
      // Crear FormDataModel con el ID correcto
      final FormDataModel updatedFormData;
      if (isUpdatingExisting) {
        // Actualizar formulario existente manteniendo fechas apropiadas
        updatedFormData = formData.copyWith(
          id: formId,
          lastModified: DateTime.now(), // Solo actualizar lastModified
        );
      } else {
        // Nuevo formulario con fecha de creación actual
        updatedFormData = formData.copyWith(
          id: formId,
          createdAt: DateTime.now(),
          lastModified: DateTime.now(),
        );
      }
      
      // Uso seguro del servicio con try-catch
      try {
        await FormPersistenceService().saveForm(updatedFormData);
        print('✅ Form saved successfully: $formId');
      } catch (persistenceError) {
        print('⚠️  FormPersistenceService error (continuing anyway): $persistenceError');
        // Continuamos con el proceso aunque falle la persistencia
      }
      
      emit(state.copyWith(
        isSaving: false,
        activeFormId: formId,
        lastSaved: DateTime.now(),
      ));
    } catch (e) {
      print('❌ Error in SaveCurrentFormData: $e');
      emit(state.copyWith(isSaving: false));
    }
  }

  Future<void> _onLoadFormData(
    LoadFormData event,
    Emitter<RiskThreatAnalysisState> emit,
  ) async {
    emit(state.copyWith(isLoading: true));
    
    try {
      // final formData = await FormPersistenceService().getFormById(event.formId); // TEMPORAL
      // TEMPORAL: Deshabilitado
      emit(state.copyWith(isLoading: false));
    } catch (e) {
      emit(state.copyWith(isLoading: false));
    }
  }

  Future<void> _onResetToNewForm(
    ResetToNewForm event,
    Emitter<RiskThreatAnalysisState> emit,
  ) async {

    // Limpiar el formulario activo del FormPersistenceService
    // await FormPersistenceService().clearActiveForm(); // TEMPORAL
    
    // Resetear COMPLETAMENTE todo el estado para un formulario nuevo
    emit(RiskThreatAnalysisState(
      selectedRiskEvent: event.eventType,
      selectedClassification: 'amenaza', // Siempre empezar con amenaza
      activeFormId: null, // IMPORTANTE: Null para nuevo formulario
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
      // TEMPORAL: Deshabilitado
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
    try {
      print('🔄 AutoSaveProgress triggered');
      print('   activeFormId: ${state.activeFormId}');
      print('   selectedRiskEvent: ${state.selectedRiskEvent}');
      print('   probabilidadSelections: ${state.probabilidadSelections}');
      print('   intensidadSelections: ${state.intensidadSelections}');
      
      if (state.activeFormId != null) {
        print('✅ Calling SaveCurrentFormData (existing form)');
        add(SaveCurrentFormData());
      } else {
        print('❌ No activeFormId - AutoSave SKIPPED for new form');
        
        // SOLUCIÓN: Crear un nuevo formulario automáticamente si hay datos
        if (state.probabilidadSelections.isNotEmpty || 
            state.intensidadSelections.isNotEmpty || 
            state.dynamicSelections.isNotEmpty) {
          print('📝 Creating new form automatically for AutoSave');
          
          final newFormId = 'form_${DateTime.now().millisecondsSinceEpoch}';
          
          emit(state.copyWith(activeFormId: newFormId));
          add(SaveCurrentFormData());
        }
      }
    } catch (e) {
      print('❌ Error in AutoSaveProgress: $e');
    }
  }

  // Método para crear FormDataModel desde el estado actual
  FormDataModel _createFormDataFromCurrentState() {
    final now = DateTime.now();
    
    final progressPercentage = _calculateProgressPercentage();
    final threatProgress = _calculateThreatProgress();
    final vulnerabilityProgress = _calculateVulnerabilityProgress();
    
    // Separar datos de amenaza y vulnerabilidad
    final amenazaData = _extractAmenazaData();
    final vulnerabilidadData = _extractVulnerabilidadData();
    
    print('🔄 Creating FormData with separated classification data:');
    print('   amenazaData: ${amenazaData.keys}');
    print('   vulnerabilidadData: ${vulnerabilidadData.keys}');
    
    return FormDataModel(
      id: state.activeFormId ?? now.millisecondsSinceEpoch.toString(),
      title: 'Análisis de Riesgo - ${state.selectedRiskEvent}',
      eventType: state.selectedRiskEvent,
      formType: FormType.riskAnalysis,
      status: FormStatus.inProgress,
      createdAt: now,
      lastModified: now,
      progressPercentage: progressPercentage / 100.0, // Convertir a 0.0-1.0
      threatProgress: threatProgress / 100.0, // Convertir a 0.0-1.0
      vulnerabilityProgress: vulnerabilityProgress / 100.0, // Convertir a 0.0-1.0
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
      amenazaData: amenazaData,
      vulnerabilidadData: vulnerabilidadData,
      edeData: const {},
    );
  }

  /// Extrae los datos específicos de amenaza (probabilidad + intensidad)
  Map<String, dynamic> _extractAmenazaData() {
    final amenazaSelections = <String, Map<String, String>>{};
    final amenazaScores = <String, double>{};
    final amenazaColors = <String, String>{};
    
    // Incluir probabilidad e intensidad
    if (state.probabilidadSelections.isNotEmpty) {
      amenazaSelections['probabilidad'] = Map<String, String>.from(state.probabilidadSelections);
    }
    if (state.intensidadSelections.isNotEmpty) {
      amenazaSelections['intensidad'] = Map<String, String>.from(state.intensidadSelections);
    }
    
    // Incluir scores y colores de amenaza
    for (final entry in state.subClassificationScores.entries) {
      if (entry.key == 'probabilidad' || entry.key == 'intensidad') {
        amenazaScores[entry.key] = entry.value;
      }
    }
    
    for (final entry in state.subClassificationColors.entries) {
      if (entry.key == 'probabilidad' || entry.key == 'intensidad') {
        amenazaColors[entry.key] = entry.value.toString();
      }
    }
    
    return {
      'selectedRiskEvent': state.selectedRiskEvent,
      'selections': amenazaSelections,
      'scores': amenazaScores,
      'colors': amenazaColors,
      'finalScore': _calculateAmenazaFinalScore(),
      'rating': _calculateAmenazaRating(),
      'lastUpdated': DateTime.now().toIso8601String(),
    };
  }

  /// Extrae los datos específicos de vulnerabilidad (fragilidad física + personas + exposición)
  Map<String, dynamic> _extractVulnerabilidadData() {
    final vulnerabilidadSelections = <String, Map<String, String>>{};
    final vulnerabilidadScores = <String, double>{};
    final vulnerabilidadColors = <String, String>{};
    
    // Incluir todas las subclasificaciones de vulnerabilidad
    final vulnerabilidadSubIds = ['fragilidad_fisica', 'fragilidad_personas', 'exposicion'];
    
    for (final subId in vulnerabilidadSubIds) {
      final selections = state.dynamicSelections[subId];
      if (selections != null && selections.isNotEmpty) {
        vulnerabilidadSelections[subId] = Map<String, String>.from(selections);
      }
      
      // Incluir scores y colores
      final score = state.subClassificationScores[subId];
      if (score != null) {
        vulnerabilidadScores[subId] = score;
      }
      
      final color = state.subClassificationColors[subId];
      if (color != null) {
        vulnerabilidadColors[subId] = color.toString();
      }
    }
    
    return {
      'selectedRiskEvent': state.selectedRiskEvent,
      'selections': vulnerabilidadSelections,
      'scores': vulnerabilidadScores,
      'colors': vulnerabilidadColors,
      'finalScore': _calculateVulnerabilidadFinalScore(),
      'rating': _calculateVulnerabilidadRating(),
      'lastUpdated': DateTime.now().toIso8601String(),
    };
  }

  // Método para crear estado desde FormDataModel
  RiskThreatAnalysisState _createStateFromFormData(FormDataModel formData) {
    final riskData = formData.riskAnalysisData;
    final amenazaData = formData.amenazaData;
    final vulnerabilidadData = formData.vulnerabilidadData;
    
    print('🔄 Restoring FormData with separated classification data:');
    print('   amenazaData available: ${amenazaData.isNotEmpty}');
    print('   vulnerabilidadData available: ${vulnerabilidadData.isNotEmpty}');
    
    // Combinar datos de amenaza y vulnerabilidad para restaurar el estado completo
    final restoredProbabilidadSelections = _restoreProbabilidadSelections(amenazaData, riskData);
    final restoredIntensidadSelections = _restoreIntensidadSelections(amenazaData, riskData);
    final restoredDynamicSelections = _restoreDynamicSelections(amenazaData, vulnerabilidadData, riskData);
    final restoredScores = _restoreSubClassificationScores(amenazaData, vulnerabilidadData, riskData);
    
    return state.copyWith(
      selectedRiskEvent: riskData['selectedRiskEvent'] as String? ?? amenazaData['selectedRiskEvent'] as String? ?? state.selectedRiskEvent,
      selectedClassification: riskData['selectedClassification'] as String? ?? state.selectedClassification,
      probabilidadSelections: restoredProbabilidadSelections,
      intensidadSelections: restoredIntensidadSelections,
      dynamicSelections: restoredDynamicSelections,
      subClassificationScores: restoredScores,
      activeFormId: formData.id,
      lastSaved: formData.lastModified,
    );
  }

  /// Restaura las selecciones de probabilidad desde los datos separados
  Map<String, String> _restoreProbabilidadSelections(Map<String, dynamic> amenazaData, Map<String, dynamic> riskData) {
    if (amenazaData.isNotEmpty) {
      final selections = amenazaData['selections'] as Map<String, dynamic>?;
      if (selections != null && selections['probabilidad'] != null) {
        return Map<String, String>.from(selections['probabilidad'] as Map);
      }
    }
    
    // Fallback a datos legacy
    return Map<String, String>.from(riskData['probabilidadSelections'] as Map? ?? {});
  }

  /// Restaura las selecciones de intensidad desde los datos separados
  Map<String, String> _restoreIntensidadSelections(Map<String, dynamic> amenazaData, Map<String, dynamic> riskData) {
    if (amenazaData.isNotEmpty) {
      final selections = amenazaData['selections'] as Map<String, dynamic>?;
      if (selections != null && selections['intensidad'] != null) {
        return Map<String, String>.from(selections['intensidad'] as Map);
      }
    }
    
    // Fallback a datos legacy
    return Map<String, String>.from(riskData['intensidadSelections'] as Map? ?? {});
  }

  /// Restaura las selecciones dinámicas desde los datos separados
  Map<String, Map<String, String>> _restoreDynamicSelections(
    Map<String, dynamic> amenazaData, 
    Map<String, dynamic> vulnerabilidadData, 
    Map<String, dynamic> riskData
  ) {
    final restored = <String, Map<String, String>>{};
    
    // Restaurar datos de vulnerabilidad
    if (vulnerabilidadData.isNotEmpty) {
      final vulnerabilidadSelections = vulnerabilidadData['selections'] as Map<String, dynamic>?;
      if (vulnerabilidadSelections != null) {
        for (final entry in vulnerabilidadSelections.entries) {
          restored[entry.key] = Map<String, String>.from(entry.value as Map);
        }
      }
    }
    
    // Fallback a datos legacy si no hay datos separados
    if (restored.isEmpty) {
      final legacyDynamicSelections = riskData['dynamicSelections'] as Map?;
      if (legacyDynamicSelections != null) {
        for (final entry in legacyDynamicSelections.entries) {
          restored[entry.key.toString()] = Map<String, String>.from(entry.value as Map);
        }
      }
    }
    
    return restored;
  }

  /// Restaura los scores desde los datos separados
  Map<String, double> _restoreSubClassificationScores(
    Map<String, dynamic> amenazaData, 
    Map<String, dynamic> vulnerabilidadData, 
    Map<String, dynamic> riskData
  ) {
    final restored = <String, double>{};
    
    // Restaurar scores de amenaza
    if (amenazaData.isNotEmpty) {
      final amenazaScores = amenazaData['scores'] as Map<String, dynamic>?;
      if (amenazaScores != null) {
        for (final entry in amenazaScores.entries) {
          restored[entry.key] = (entry.value as num).toDouble();
        }
      }
    }
    
    // Restaurar scores de vulnerabilidad
    if (vulnerabilidadData.isNotEmpty) {
      final vulnerabilidadScores = vulnerabilidadData['scores'] as Map<String, dynamic>?;
      if (vulnerabilidadScores != null) {
        for (final entry in vulnerabilidadScores.entries) {
          restored[entry.key] = (entry.value as num).toDouble();
        }
      }
    }
    
    // Fallback a datos legacy si no hay datos separados
    if (restored.isEmpty) {
      final legacyScores = riskData['subClassificationScores'] as Map?;
      if (legacyScores != null) {
        for (final entry in legacyScores.entries) {
          restored[entry.key.toString()] = double.tryParse(entry.value.toString()) ?? 0.0;
        }
      }
    }
    
    return restored;
  }

  // Métodos de cálculo de progreso
  double _calculateProgressPercentage() {
    
    // Calcular progreso basado en componentes ponderados
    double progress = 0.0;
    
    // 1. Selección de evento (15% del total)
    if (state.selectedRiskEvent.isNotEmpty && state.selectedRiskEvent != 'No seleccionado') {
      progress += 15.0;
    }
    
    // 2. Selección de clasificación (15% del total)
    if (state.selectedClassification.isNotEmpty && state.selectedClassification != 'No seleccionada') {
      progress += 15.0;
    }
    
    // 3. Progreso de amenaza (35% del total)
    final threatProgress = _calculateThreatProgress();
    final threatContribution = (threatProgress / 100.0) * 35.0;
    progress += threatContribution;
    
    // 4. Progreso de vulnerabilidad (35% del total)
    final vulnerabilityProgress = _calculateVulnerabilityProgress();
    final vulnerabilityContribution = (vulnerabilityProgress / 100.0) * 35.0;
    progress += vulnerabilityContribution;
    
    // Aplicar límite mínimo y máximo
    progress = progress.clamp(0.0, 100.0);
    
    return progress;
  }

  double _calculateThreatProgress() {
    
    // Calcular progreso de amenaza independientemente de la clasificación actual
    double total = 2.0; // probabilidad + intensidad
    double completed = 0.0;
    
    if (state.probabilidadSelections.isNotEmpty) {
      completed += 1;
    }
    if (state.intensidadSelections.isNotEmpty) {
      completed += 1;
    }
    
    final progress = total > 0 ? (completed / total) * 100.0 : 0.0;
    
    return progress;
  }

  double _calculateVulnerabilityProgress() {
    
    // Calcular progreso de vulnerabilidad independientemente de la clasificación actual
    final expectedSelections = _getExpectedSelectionsForRiskEvent();
    if (expectedSelections.isEmpty) {
      return 0.0;
    }
    
    
    double completed = 0.0;
    for (final selection in expectedSelections) {
      if (state.dynamicSelections[selection]?.isNotEmpty == true) {
        completed += 1;
      } else {
      }
    }
    
    final progress = (completed / expectedSelections.length) * 100.0;
    
    return progress;
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

  void _onShowFinalResults(
    ShowFinalResults event,
    Emitter<RiskThreatAnalysisState> emit,
  ) {
    emit(state.copyWith(showFinalResults: event.show));
  }

  // Nuevos manejadores para cargar datos específicos por clasificación

  Future<void> _onLoadAmenazaData(
    LoadAmenazaData event,
    Emitter<RiskThreatAnalysisState> emit,
  ) async {
    emit(state.copyWith(isLoading: true));
    
    try {
      final formService = FormPersistenceService();
      final formData = await formService.getFormById(event.formId);
      
      if (formData != null && formData.amenazaData.isNotEmpty) {
        print('📥 Loading amenaza data from form: ${event.formId}');
        
        final amenazaData = formData.amenazaData;
        final selections = amenazaData['selections'] as Map<String, dynamic>? ?? {};
        final scores = amenazaData['scores'] as Map<String, dynamic>? ?? {};
        
        // Restaurar selecciones de amenaza
        final probabilidadSelections = selections['probabilidad'] != null 
          ? Map<String, String>.from(selections['probabilidad'] as Map)
          : <String, String>{};
        
        final intensidadSelections = selections['intensidad'] != null 
          ? Map<String, String>.from(selections['intensidad'] as Map)
          : <String, String>{};
        
        // Restaurar scores de amenaza
        final restoredScores = <String, double>{};
        for (final entry in scores.entries) {
          restoredScores[entry.key] = (entry.value as num).toDouble();
        }
        
        emit(state.copyWith(
          selectedRiskEvent: amenazaData['selectedRiskEvent'] as String? ?? state.selectedRiskEvent,
          selectedClassification: 'amenaza',
          probabilidadSelections: probabilidadSelections,
          intensidadSelections: intensidadSelections,
          subClassificationScores: {...state.subClassificationScores, ...restoredScores},
          activeFormId: formData.id,
          lastSaved: formData.lastModified,
          isLoading: false,
        ));
        
        print('✅ Amenaza data loaded successfully');
      } else {
        print('⚠️ No amenaza data found in form: ${event.formId}');
        emit(state.copyWith(isLoading: false));
      }
    } catch (e) {
      print('❌ Error loading amenaza data: $e');
      emit(state.copyWith(isLoading: false));
    }
  }

  Future<void> _onLoadVulnerabilidadData(
    LoadVulnerabilidadData event,
    Emitter<RiskThreatAnalysisState> emit,
  ) async {
    emit(state.copyWith(isLoading: true));
    
    try {
      final formService = FormPersistenceService();
      final formData = await formService.getFormById(event.formId);
      
      if (formData != null && formData.vulnerabilidadData.isNotEmpty) {
        print('📥 Loading vulnerabilidad data from form: ${event.formId}');
        
        final vulnerabilidadData = formData.vulnerabilidadData;
        final selections = vulnerabilidadData['selections'] as Map<String, dynamic>? ?? {};
        final scores = vulnerabilidadData['scores'] as Map<String, dynamic>? ?? {};
        
        // Restaurar selecciones dinámicas de vulnerabilidad
        final restoredDynamicSelections = <String, Map<String, String>>{};
        for (final entry in selections.entries) {
          restoredDynamicSelections[entry.key] = Map<String, String>.from(entry.value as Map);
        }
        
        // Restaurar scores de vulnerabilidad
        final restoredScores = <String, double>{};
        for (final entry in scores.entries) {
          restoredScores[entry.key] = (entry.value as num).toDouble();
        }
        
        emit(state.copyWith(
          selectedRiskEvent: vulnerabilidadData['selectedRiskEvent'] as String? ?? state.selectedRiskEvent,
          selectedClassification: 'vulnerabilidad',
          dynamicSelections: {...state.dynamicSelections, ...restoredDynamicSelections},
          subClassificationScores: {...state.subClassificationScores, ...restoredScores},
          activeFormId: formData.id,
          lastSaved: formData.lastModified,
          isLoading: false,
        ));
        
        print('✅ Vulnerabilidad data loaded successfully');
      } else {
        print('⚠️ No vulnerabilidad data found in form: ${event.formId}');
        emit(state.copyWith(isLoading: false));
      }
    } catch (e) {
      print('❌ Error loading vulnerabilidad data: $e');
      emit(state.copyWith(isLoading: false));
    }
  }

  Future<void> _onLoadFormWithClassificationData(
    LoadFormWithClassificationData event,
    Emitter<RiskThreatAnalysisState> emit,
  ) async {
    emit(state.copyWith(isLoading: true));
    
    try {
      final formService = FormPersistenceService();
      final formData = await formService.getFormById(event.formId);
      
      if (formData != null) {
        print('📥 Loading complete form data: ${event.formId}');
        print('   Target classification: ${event.targetClassification}');
        
        // Usar el método existente para restaurar el estado completo
        final restoredState = _createStateFromFormData(formData);
        
        // Si se especifica una clasificación objetivo, cambiar a ella
        final targetClassification = event.targetClassification ?? restoredState.selectedClassification;
        
        emit(restoredState.copyWith(
          selectedClassification: targetClassification,
          isLoading: false,
        ));
        
        print('✅ Complete form data loaded successfully');
        print('   Active classification: $targetClassification');
        print('   Has amenaza data: ${formData.amenazaData.isNotEmpty}');
        print('   Has vulnerabilidad data: ${formData.vulnerabilidadData.isNotEmpty}');
      } else {
        print('⚠️ Form not found: ${event.formId}');
        emit(state.copyWith(isLoading: false));
      }
    } catch (e) {
      print('❌ Error loading form with classification data: $e');
      emit(state.copyWith(isLoading: false));
    }
  }

  // Métodos de conveniencia para obtener datos guardados

  /// Obtiene los datos de amenaza guardados para el formulario actual
  Map<String, dynamic> getSavedAmenazaData() {
    if (state.activeFormId == null) return {};
    
    return _extractAmenazaData();
  }

  /// Obtiene los datos de vulnerabilidad guardados para el formulario actual
  Map<String, dynamic> getSavedVulnerabilidadData() {
    if (state.activeFormId == null) return {};
    
    return _extractVulnerabilidadData();
  }

  /// Verifica si hay datos de amenaza guardados
  bool hasAmenazaData() {
    final amenazaData = getSavedAmenazaData();
    final selections = amenazaData['selections'] as Map<String, Map<String, String>>? ?? {};
    return selections.isNotEmpty;
  }

  /// Verifica si hay datos de vulnerabilidad guardados
  bool hasVulnerabilidadData() {
    final vulnerabilidadData = getSavedVulnerabilidadData();
    final selections = vulnerabilidadData['selections'] as Map<String, Map<String, String>>? ?? {};
    return selections.isNotEmpty;
  }

  /// Obtiene un resumen del estado de completitud de los datos
  Map<String, dynamic> getDataCompletionStatus() {
    return {
      'hasAmenaza': hasAmenazaData(),
      'hasVulnerabilidad': hasVulnerabilidadData(),
      'amenazaScore': _calculateAmenazaFinalScore(),
      'vulnerabilidadScore': _calculateVulnerabilidadFinalScore(),
      'amenazaRating': _calculateAmenazaRating(),
      'vulnerabilidadRating': _calculateVulnerabilidadRating(),
      'activeFormId': state.activeFormId,
      'selectedRiskEvent': state.selectedRiskEvent,
      'selectedClassification': state.selectedClassification,
      'lastSaved': state.lastSaved?.toIso8601String(),
    };
  }

  /// Carga datos específicos según la clasificación actual
  void loadDataForCurrentClassification() {
    if (state.activeFormId == null) return;
    
    switch (state.selectedClassification) {
      case 'amenaza':
        add(LoadAmenazaData(state.activeFormId!));
        break;
      case 'vulnerabilidad':
        add(LoadVulnerabilidadData(state.activeFormId!));
        break;
      default:
        // Cargar datos completos por defecto
        add(LoadFormWithClassificationData(state.activeFormId!));
    }
  }
}