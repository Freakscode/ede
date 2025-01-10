import 'dart:developer' as developer;
import 'package:flutter_bloc/flutter_bloc.dart';

import 'acciones_event.dart';
import 'acciones_state.dart';

class AccionesBloc extends Bloc<AccionesEvent, AccionesState> {
  AccionesBloc() : super(AccionesState()) {
    on<SetEvaluacionAdicional>((event, emit) {
      final updatedEvaluacion = Map<String, String>.from(state.evaluacionAdicional);
      updatedEvaluacion[event.tipo] = event.descripcion;
      emit(state.copyWith(evaluacionAdicional: updatedEvaluacion));
      developer.log('SetEvaluacionAdicional: ${event.tipo} - ${event.descripcion}',
          name: 'AccionesBloc');
    });

    on<SetRecomendacion>((event, emit) {
      final updatedRecomendaciones = Map<String, bool>.from(state.recomendaciones);
      updatedRecomendaciones[event.recomendacion] = event.valor;
      emit(state.copyWith(recomendaciones: updatedRecomendaciones));
      developer.log('SetRecomendacion: ${event.recomendacion} - ${event.valor}',
          name: 'AccionesBloc');
    });

    on<SetEntidadRecomendada>((event, emit) {
      final updatedEntidades = Map<String, bool>.from(state.entidadesRecomendadas);
      updatedEntidades[event.entidad] = event.valor;
      
      // Si se está desactivando la opción "Otra", limpiamos el campo de texto
      String? newOtraEntidad = state.otraEntidad;
      if (event.entidad == 'Otra' && !event.valor) {
        newOtraEntidad = null;
      } else if (event.entidad == 'Otra' && event.valor) {
        newOtraEntidad = event.otraEntidad;
      }
      
      emit(state.copyWith(
        entidadesRecomendadas: updatedEntidades,
        otraEntidad: newOtraEntidad,
      ));
      developer.log(
          'SetEntidadRecomendada: ${event.entidad} - ${event.valor}${event.otraEntidad != null ? ' - ${event.otraEntidad}' : ''}',
          name: 'AccionesBloc');
    });

    on<SetRecomendacionesEspecificas>((event, emit) {
      emit(state.copyWith(recomendacionesEspecificas: event.recomendaciones));
      developer.log('SetRecomendacionesEspecificas: ${event.recomendaciones}',
          name: 'AccionesBloc');
    });
  }
} 