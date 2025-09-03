import 'package:flutter_bloc/flutter_bloc.dart';
import 'dart:developer' as developer;
import 'evaluacion_danos_event.dart';
import 'evaluacion_danos_state.dart';

class EvaluacionDanosBloc extends Bloc<EvaluacionDanosEvent, EvaluacionDanosState> {
  EvaluacionDanosBloc() : super(const EvaluacionDanosState()) {
    on<SetCondicionExistente>((event, emit) {
      final updatedCondiciones = Map<String, bool>.from(state.condicionesExistentes);
      
      // Simplemente actualizar el valor de la condición seleccionada sin ninguna dependencia
      updatedCondiciones[event.condicionId] = event.valor ?? false;

      emit(state.copyWith(condicionesExistentes: updatedCondiciones));
      developer.log('SetCondicionExistente: ${event.condicionId} - ${updatedCondiciones[event.condicionId]}',
          name: 'EvaluacionDanosBloc');
    });

    on<SetNivelElemento>((event, emit) {
      final updatedNiveles = Map<String, String>.from(state.nivelesElementos);
      
      // Simplemente actualizar el nivel del elemento seleccionado
      updatedNiveles[event.elementoId] = event.nivel;
      
      emit(state.copyWith(nivelesElementos: updatedNiveles));
      developer.log('SetNivelElemento: ${event.elementoId} - ${updatedNiveles[event.elementoId]}',
          name: 'EvaluacionDanosBloc');
    });

    on<SetAlcanceEvaluacion>((event, emit) {
      String? newAlcanceExterior = event.alcanceExterior;
      String? newAlcanceInterior = event.alcanceInterior;

      // Si el alcance nuevo es igual al actual, lo reseteamos
      if (event.alcanceExterior == state.alcanceExterior) {
        newAlcanceExterior = null;
      }
      if (event.alcanceInterior == state.alcanceInterior) {
        newAlcanceInterior = null;
      }

      // Validar combinaciones no permitidas
      if (newAlcanceInterior == 'Completa' && state.alcanceInterior == 'No Ingreso') {
        newAlcanceInterior = state.alcanceInterior;
      } else if (newAlcanceInterior == 'No Ingreso' && state.alcanceInterior == 'Completa') {
        newAlcanceInterior = state.alcanceInterior;
      }
      
      emit(state.copyWith(
        alcanceExterior: newAlcanceExterior,
        alcanceInterior: newAlcanceInterior,
      ));
      developer.log(
          'SetAlcanceEvaluacion: Exterior - $newAlcanceExterior, Interior - $newAlcanceInterior',
          name: 'EvaluacionDanosBloc');
    });

    on<UpdateDanosEstructurales>((event, emit) {
      emit(state.copyWith(
        danosEstructurales: event.danosEstructurales as Map<String, dynamic>,
      ));
    });

    on<UpdateDanosNoEstructurales>((event, emit) {
      emit(state.copyWith(
        danosNoEstructurales: event.danosNoEstructurales as Map<String, dynamic>,
      ));
    });

    on<UpdateDanosGeotecnicos>((event, emit) {
      emit(state.copyWith(
        danosGeotecnicos: event.danosGeotecnicos as Map<String, dynamic>,
      ));
    });
  }
} 