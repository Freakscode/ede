import 'dart:developer';
import 'package:flutter_bloc/flutter_bloc.dart';
import './riesgos_externos_event.dart';
import './riesgos_externos_state.dart';

class RiesgosExternosBloc extends Bloc<RiesgosExternosEvent, RiesgosExternosState> {
  RiesgosExternosBloc() : super(const RiesgosExternosState()) {
    on<SetRiesgoExterno>((event, emit) {
      log('SetRiesgoExterno: ${event.riesgoId} - ${event.valor}');
      final riesgoActual = state.riesgos[event.riesgoId];
      if (riesgoActual != null) {
        final riesgosActualizados = Map<String, RiesgoItem>.from(state.riesgos);
        riesgosActualizados[event.riesgoId] = riesgoActual.copyWith(
          existeRiesgo: event.valor,
          // Si se desactiva el riesgo, resetear las otras opciones
          comprometeAccesos: event.valor ? riesgoActual.comprometeAccesos : false,
          comprometeEstabilidad: event.valor ? riesgoActual.comprometeEstabilidad : false,
        );
        emit(state.copyWith(riesgos: riesgosActualizados));
      }
    });

    on<SetComprometeAccesos>((event, emit) {
      log('SetComprometeAccesos: ${event.riesgoId} - ${event.valor}');
      final riesgoActual = state.riesgos[event.riesgoId];
      if (riesgoActual != null && riesgoActual.existeRiesgo) {
        final riesgosActualizados = Map<String, RiesgoItem>.from(state.riesgos);
        riesgosActualizados[event.riesgoId] = riesgoActual.copyWith(
          comprometeAccesos: event.valor,
        );
        emit(state.copyWith(riesgos: riesgosActualizados));
      }
    });

    on<SetComprometeEstabilidad>((event, emit) {
      log('SetComprometeEstabilidad: ${event.riesgoId} - ${event.valor}');
      final riesgoActual = state.riesgos[event.riesgoId];
      if (riesgoActual != null && riesgoActual.existeRiesgo) {
        final riesgosActualizados = Map<String, RiesgoItem>.from(state.riesgos);
        riesgosActualizados[event.riesgoId] = riesgoActual.copyWith(
          comprometeEstabilidad: event.valor,
        );
        emit(state.copyWith(riesgos: riesgosActualizados));
      }
    });

    on<SetOtroRiesgo>((event, emit) {
      log('SetOtroRiesgo: ${event.valor}');
      emit(state.copyWith(otroRiesgo: event.valor));
    });
  }
} 