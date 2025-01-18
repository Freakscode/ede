import 'package:flutter_bloc/flutter_bloc.dart';
import 'descripcion_edificacion_event.dart';
import 'descripcion_edificacion_state.dart';
import 'dart:developer' as developer;

class DescripcionEdificacionBloc
    extends Bloc<DescripcionEdificacionEvent, DescripcionEdificacionState> {
  DescripcionEdificacionBloc() : super(DescripcionEdificacionState()) {
    on<SetPisosSobreTerreno>((event, emit) {
      emit(state.copyWith(pisosSobreTerreno: event.pisos));
      developer.log('SetPisosSobreTerreno: ${event.pisos}', 
          name: 'DescripcionEdificacionBloc');
    });

    on<SetSotanos>((event, emit) {
      emit(state.copyWith(sotanos: event.sotanos));
      developer.log('SetSotanos: ${event.sotanos}', 
          name: 'DescripcionEdificacionBloc');
    });

    on<SetDimensiones>((event, emit) {
      emit(state.copyWith(
        frenteDimension: event.frente,
        fondoDimension: event.fondo,
      ));
      developer.log('SetDimensiones: ${event.frente}x${event.fondo}', 
          name: 'DescripcionEdificacionBloc');
    });

    on<SetUnidadesResidenciales>((event, emit) {
      emit(state.copyWith(unidadesResidenciales: event.unidades));
      developer.log('SetUnidadesResidenciales: ${event.unidades}', 
          name: 'DescripcionEdificacionBloc');
    });

    on<SetUnidadesComerciales>((event, emit) {
      emit(state.copyWith(unidadesComerciales: event.unidades));
      developer.log('SetUnidadesComerciales: ${event.unidades}', 
          name: 'DescripcionEdificacionBloc');
    });

    on<SetUnidadesNoHabitadas>((event, emit) {
      emit(state.copyWith(unidadesNoHabitadas: event.unidades));
      developer.log('SetUnidadesNoHabitadas: ${event.unidades}', 
          name: 'DescripcionEdificacionBloc');
    });

    on<SetNumeroOcupantes>((event, emit) {
      emit(state.copyWith(numeroOcupantes: event.ocupantes));
      developer.log('SetNumeroOcupantes: ${event.ocupantes}', 
          name: 'DescripcionEdificacionBloc');
    });

    on<SetMuertosHeridos>((event, emit) {
      emit(state.copyWith(
        muertos: event.muertos,
        heridos: event.heridos,
        noSeSabe: event.noSeSabe,
      ));
      developer.log(
          'SetMuertosHeridos: M:${event.muertos}, H:${event.heridos}, NS:${event.noSeSabe}', 
          name: 'DescripcionEdificacionBloc');
    });

    on<SetAcceso>((event, emit) {
      emit(state.copyWith(
        accesoObstruido: event.obstruido,
        accesoLibre: event.libre,
      ));
      developer.log('SetAcceso: Obstruido:${event.obstruido}, Libre:${event.libre}', 
          name: 'DescripcionEdificacionBloc');
    });

    on<SetNivelDiseno>((event, emit) {
      emit(state.copyWith(nivelDiseno: event.nivel));
      developer.log('SetNivelDiseno: ${event.nivel}', 
          name: 'DescripcionEdificacionBloc');
    });

    on<SetCalidadDiseno>((event, emit) {
      emit(state.copyWith(calidadDiseno: event.calidad));
      developer.log('SetCalidadDiseno: ${event.calidad}', 
          name: 'DescripcionEdificacionBloc');
    });

    on<SetEstadoEdificacion>((event, emit) {
      emit(state.copyWith(estadoEdificacion: event.estado));
      developer.log('SetEstadoEdificacion: ${event.estado}', 
          name: 'DescripcionEdificacionBloc');
    });
  }
} 