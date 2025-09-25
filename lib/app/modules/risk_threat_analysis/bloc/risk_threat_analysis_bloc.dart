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
    emit(state.copyWith(
      selectedRiskEvent: event.riskEvent,
      // Reset selections when event changes
      probabilidadSelections: {},
      intensidadSelections: {},
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

  // Método para calcular la calificación final de amenaza
  String calculateThreatRating() {
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

  // Método para calcular el porcentaje de completado
  double calculateCompletionPercentage() {
    const totalCategories = 7; // 6 categorías de probabilidad + 1 de intensidad
    final completedCategories = state.probabilidadSelections.length + state.intensidadSelections.length;
    return completedCategories / totalCategories;
  }

  // Método para obtener el puntaje final numérico
  double calculateFinalScore() {
    final probAverage = calculateProbabilidadAverage();
    final intAverage = calculateIntensidadAverage();
    
    if (probAverage == 0.0 || intAverage == 0.0) {
      return 0.0;
    }
    
    return (probAverage + intAverage) / 2;
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
    
    // Debug: imprimir el evento seleccionado
    print('🔥 RiskThreatAnalysisBloc: Evento seleccionado: $selectedEvent');
    
    final categories = getCategoriesForEvent(selectedEvent);
    print('🔥 RiskThreatAnalysisBloc: Cargando ${categories.length} categorías para $selectedEvent');
    return categories;
  }

  // Método para obtener las categorías de intensidad dinámicamente
  List<DropdownCategory> getIntensidadCategories() {
    final selectedEvent = state.selectedRiskEvent;
    
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


}