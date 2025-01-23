import 'dart:developer' as developer;
import 'package:flutter_bloc/flutter_bloc.dart';

import 'acciones_event.dart';
import 'acciones_state.dart';

class AccionesBloc extends Bloc<AccionesEvent, AccionesState> {
  AccionesBloc() : super(AccionesState.initial) {
    on<UpdateAcciones>((event, emit) {
      emit(state.copyWith(
        evaluacionesAdicionales: event.evaluacionesAdicionales,
        medidasSeguridad: event.medidasSeguridad,
        entidadesRecomendadas: event.entidadesRecomendadas,
        observacionesAcciones: event.observacionesAcciones,
        medidasSeguridadSeleccionadas: event.medidasSeguridadSeleccionadas,
        evaluacionesAdicionalesSeleccionadas: event.evaluacionesAdicionalesSeleccionadas,
      ));
      developer.log('UpdateAcciones', name: 'AccionesBloc');
    });

    on<SetEvaluacionAdicional>((event, emit) {
      final evaluacionAdicional = Map<String, String>.from(state.evaluacionAdicional);
      evaluacionAdicional[event.tipo] = event.descripcion;
      emit(state.copyWith(evaluacionAdicional: evaluacionAdicional));
      developer.log('SetEvaluacionAdicional: ${event.tipo} - ${event.descripcion}', name: 'AccionesBloc');
    });

    on<SetRecomendacion>((event, emit) {
      final recomendaciones = Map<String, bool>.from(state.recomendaciones);
      recomendaciones[event.recomendacion] = event.valor;
      emit(state.copyWith(recomendaciones: recomendaciones));
      developer.log('SetRecomendacion: ${event.recomendacion} - ${event.valor}', name: 'AccionesBloc');
    });

    on<SetEntidadRecomendada>((event, emit) {
      final entidadesRecomendadas = Map<String, bool>.from(state.entidadesRecomendadas);
      entidadesRecomendadas[event.entidad] = event.valor;
      
      String? newOtraEntidad = state.otraEntidad;
      if (event.entidad == 'Otra' && !event.valor) {
        newOtraEntidad = null;
      } else if (event.entidad == 'Otra' && event.valor) {
        newOtraEntidad = event.otraEntidad;
      }
      
      emit(state.copyWith(
        entidadesRecomendadas: entidadesRecomendadas,
        otraEntidad: newOtraEntidad,
      ));
      developer.log('SetEntidadRecomendada: ${event.entidad} - ${event.valor}${event.otraEntidad != null ? ' - ${event.otraEntidad}' : ''}', name: 'AccionesBloc');
    });

    on<SetRecomendacionesEspecificas>((event, emit) {
      emit(state.copyWith(recomendacionesEspecificas: event.recomendaciones));
      developer.log('SetRecomendacionesEspecificas: ${event.recomendaciones}', name: 'AccionesBloc');
    });
  }
} 