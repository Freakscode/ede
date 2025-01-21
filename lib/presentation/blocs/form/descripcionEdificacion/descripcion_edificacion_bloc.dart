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
      if (event.obstruido) {
        emit(state.copyWith(
          accesoObstruido: true,
          accesoLibre: false,
        ));
      } else if (event.libre) {
        emit(state.copyWith(
          accesoObstruido: false,
          accesoLibre: true,
        ));
      }
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

    on<SetSistemaMultiple>((event, emit) {
      emit(state.copyWith(
        sistemaMultiple: event.sistemaMultiple,
      ));
    });

    on<SetObservacionesSistema>((event, emit) {
      emit(state.copyWith(
        observacionesSistema: event.observaciones,
      ));
    });

    on<SetSistemasEstructuralesYMateriales>((event, emit) {
      emit(state.copyWith(
        sistemasEstructurales: event.sistemas,
        materialesPorSistema: event.materiales,
      ));
      developer.log(
        'SetSistemasEstructuralesYMateriales: Sistemas: ${event.sistemas}, Materiales: ${event.materiales}',
        name: 'DescripcionEdificacionBloc'
      );
    });

    on<SetFechaConstruccion>((event, emit) {
      emit(state.copyWith(fechaConstruccion: event.fecha));
      developer.log('SetFechaConstruccion: ${event.fecha}', 
          name: 'DescripcionEdificacionBloc');
    });

    on<SetSistemaEntrepiso>((event, emit) {
      developer.log('SetSistemaEntrepiso: sistemas=${event.sistemas}, tipos=${event.tiposEntrepiso}, otro=${event.otroTipo}');
      emit(state.copyWith(
        sistemasEntrepiso: event.sistemas,
        tiposEntrepisoPorMaterial: event.tiposEntrepiso,
        otroEntrepiso: event.otroTipo,
      ));
    });

    on<SetSistemaSoporte>((event, emit) {
      developer.log('SetSistemaSoporte: sistemas=${event.sistemas}, otro=${event.otroSistema}');
      emit(state.copyWith(
        sistemaSoporte: event.sistemas,
        otroSistemaSoporte: event.otroSistema,
      ));
    });

    on<SetRevestimiento>((event, emit) {
      developer.log('SetRevestimiento: revestimientos=${event.revestimientos}, otro=${event.otroRevestimiento}');
      emit(state.copyWith(
        revestimiento: event.revestimientos,
        otroRevestimiento: event.otroRevestimiento,
      ));
    });

    on<SetMurosDivisorios>((event, emit) {
      developer.log('SetMurosDivisorios: muros=${event.muros}, otro=${event.otroMuro}');
      emit(state.copyWith(
        murosDivisorios: event.muros,
        otroMuroDivisorio: event.otroMuro,
      ));
    });

    on<SetFachadas>((event, emit) {
      developer.log('SetFachadas: fachadas=${event.fachadas}, otra=${event.otraFachada}');
      emit(state.copyWith(
        fachadas: event.fachadas,
        otraFachada: event.otraFachada,
      ));
    });

    on<SetEscaleras>((event, emit) {
      developer.log('SetEscaleras: escaleras=${event.escaleras}, otra=${event.otraEscalera}');
      emit(state.copyWith(
        escaleras: event.escaleras,
        otraEscalera: event.otraEscalera,
      ));
    });
  }
} 