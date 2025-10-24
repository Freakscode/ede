import 'package:flutter_bloc/flutter_bloc.dart';
import 'dart:developer';

import 'habitabilidad_event.dart';
import 'habitabilidad_state.dart';
import '../form/riesgosExternos/riesgos_externos_state.dart';

class HabitabilidadBloc extends Bloc<HabitabilidadEvent, HabitabilidadState> {
  HabitabilidadBloc() : super(HabitabilidadState.initial) {
    on<CalcularHabitabilidad>(_onCalcularHabitabilidad);
    on<UpdateHabitabilidad>(_onUpdateHabitabilidad);
  }

  void _onUpdateHabitabilidad(
    UpdateHabitabilidad event,
    Emitter<HabitabilidadState> emit,
  ) {
    emit(state.copyWith(
      estadoHabitabilidad: event.estadoHabitabilidad,
      clasificacionHabitabilidad: event.clasificacionHabitabilidad,
      observacionesHabitabilidad: event.observacionesHabitabilidad,
      criterioHabitabilidad: event.criterioHabitabilidad,
    ));
  }

  void _onCalcularHabitabilidad(
    CalcularHabitabilidad event,
    Emitter<HabitabilidadState> emit,
  ) {
    log('=== Calculando Habitabilidad ===');
    log('Riesgos externos: ${event.riesgosExternos}');
    log('Nivel de daño: ${event.nivelDano}');

    // Verificar si es un caso especial (I2)
    if (_esCasoEspecial(event.nivelDano)) {
      emit(state.copyWith(
        criterioHabitabilidad: 'No Habitable',
        clasificacion: 'I2 - Afectación Funcional',
      ));
      return;
    }

    // Verificar condiciones para Habitable (H)
    if (_cumpleCondicionesHabitable(event.riesgosExternos, event.nivelDano)) {
      emit(state.copyWith(
        criterioHabitabilidad: 'Habitable',
        clasificacion: 'H - Segura',
      ));
      return;
    }

    // Verificar condiciones para R1
    if (_cumpleCondicionesR1(event.riesgosExternos, event.nivelDano)) {
      emit(state.copyWith(
        criterioHabitabilidad: 'Acceso restringido',
        clasificacion: 'R1 - Áreas inseguras',
      ));
      return;
    }

    // Verificar condiciones para R2
    if (_cumpleCondicionesR2(event.riesgosExternos)) {
      emit(state.copyWith(
        criterioHabitabilidad: 'Acceso restringido',
        clasificacion: 'R2 - Entrada limitada',
      ));
      return;
    }

    // Verificar condiciones para I1
    if (_cumpleCondicionesI1(event.riesgosExternos)) {
      emit(state.copyWith(
        criterioHabitabilidad: 'No Habitable',
        clasificacion: 'I1 - Riesgo por factores externos',
      ));
      return;
    }

    // Verificar condiciones para I3
    if (event.nivelDano == 'Alto') {
      emit(state.copyWith(
        criterioHabitabilidad: 'No Habitable',
        clasificacion: 'I3 - Daño severo en la edificación',
      ));
      return;
    }
  }

  bool _esCasoEspecial(String nivelDano) {
    return nivelDano == 'Caso Especial';
  }

  bool _cumpleCondicionesHabitable(Map<String, RiesgoItem> riesgos, String nivelDano) {
    bool todosNoABC = riesgos.entries.every((entry) {
      final riesgo = entry.value;
      return !riesgo.existeRiesgo && !riesgo.comprometeAccesos;
    });

    return todosNoABC && (nivelDano == 'Sin daño' || nivelDano == 'Bajo');
  }

  bool _cumpleCondicionesR1(Map<String, RiesgoItem> riesgos, String nivelDano) {
    bool todosNoABC = riesgos.entries.every((entry) {
      final riesgo = entry.value;
      return !riesgo.existeRiesgo && !riesgo.comprometeAccesos;
    });

    return todosNoABC && nivelDano == 'Medio';
  }

  bool _cumpleCondicionesR2(Map<String, RiesgoItem> riesgos) {
    return riesgos.entries.any((entry) {
      final riesgo = entry.value;
      return riesgo.existeRiesgo && riesgo.comprometeAccesos && !riesgo.implicaRiesgoVida;
    });
  }

  bool _cumpleCondicionesI1(Map<String, RiesgoItem> riesgos) {
    return riesgos.entries.any((entry) {
      final riesgo = entry.value;
      return riesgo.existeRiesgo && riesgo.implicaRiesgoVida;
    });
  }
} 