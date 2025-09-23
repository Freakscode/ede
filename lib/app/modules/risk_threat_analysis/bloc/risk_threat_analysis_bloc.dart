import 'package:flutter_bloc/flutter_bloc.dart';
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
}