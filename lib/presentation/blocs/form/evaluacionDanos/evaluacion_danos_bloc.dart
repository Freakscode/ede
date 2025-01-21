import 'package:flutter_bloc/flutter_bloc.dart';
import 'dart:developer' as developer;
import 'evaluacion_danos_event.dart';
import 'evaluacion_danos_state.dart';

class EvaluacionDanosBloc extends Bloc<EvaluacionDanosEvent, EvaluacionDanosState> {
  EvaluacionDanosBloc() : super(EvaluacionDanosState()) {
    on<SetCondicionExistente>((event, emit) {
      final updatedCondiciones = Map<String, bool>.from(state.condicionesExistentes);
      updatedCondiciones[event.condicionId] = event.valor ?? false;
      emit(state.copyWith(condicionesExistentes: updatedCondiciones));
      developer.log('SetCondicionExistente: ${event.condicionId} - ${event.valor}',
          name: 'EvaluacionDanosBloc');
    });

    on<SetNivelElemento>((event, emit) {
      final updatedNiveles = Map<String, String>.from(state.nivelesElementos);
      updatedNiveles[event.elementoId] = event.nivel ?? 'Sin daño';
      emit(state.copyWith(nivelesElementos: updatedNiveles));
      developer.log('SetNivelElemento: ${event.elementoId} - ${event.nivel}',
          name: 'EvaluacionDanosBloc');
    });

    on<SetAlcanceEvaluacion>((event, emit) {
      emit(state.copyWith(
        alcanceExterior: event.alcanceExterior,
        alcanceInterior: event.alcanceInterior,
      ));
      developer.log(
          'SetAlcanceEvaluacion: Exterior - ${event.alcanceExterior}, Interior - ${event.alcanceInterior}',
          name: 'EvaluacionDanosBloc');
    });
  }
} 