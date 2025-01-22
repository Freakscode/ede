import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/material.dart';
import '../form/evaluacion/evaluacion_bloc.dart';
import '../form/evaluacion/evaluacion_state.dart';
import '../form/identificacionEdificacion/id_edificacion_bloc.dart';
import '../form/identificacionEdificacion/id_edificacion_state.dart';
import '../form/riesgosExternos/riesgos_externos_bloc.dart';
import '../form/riesgosExternos/riesgos_externos_state.dart';
import '../form/evaluacionDanos/evaluacion_danos_bloc.dart';
import '../form/evaluacionDanos/evaluacion_danos_state.dart';
import '../form/nivelDano/nivel_dano_bloc.dart';
import '../form/nivelDano/nivel_dano_state.dart';
import '../form/habitabilidad/habitabilidad_bloc.dart';
import '../form/habitabilidad/habitabilidad_state.dart';
import '../form/acciones/acciones_bloc.dart';
import '../form/acciones/acciones_state.dart';
import '../form/descripcionEdificacion/descripcion_edificacion_bloc.dart';
import '../form/descripcionEdificacion/descripcion_edificacion_state.dart';
import 'evaluacion_global_event.dart';
import 'evaluacion_global_state.dart';
import 'dart:developer' as developer;

class EvaluacionGlobalBloc extends Bloc<EvaluacionGlobalEvent, EvaluacionGlobalState> {
  final EvaluacionBloc evaluacionBloc;
  final EdificacionBloc idEdificacionBloc;
  final RiesgosExternosBloc riesgosExternosBloc;
  final EvaluacionDanosBloc evaluacionDanosBloc;
  final NivelDanoBloc nivelDanoBloc;
  final HabitabilidadBloc habitabilidadBloc;
  final AccionesBloc accionesBloc;
  final DescripcionEdificacionBloc descripcionEdificacionBloc;

  late final List<StreamSubscription> _subscriptions;

  EvaluacionGlobalBloc({
    required this.evaluacionBloc,
    required this.idEdificacionBloc,
    required this.riesgosExternosBloc,
    required this.evaluacionDanosBloc,
    required this.nivelDanoBloc,
    required this.habitabilidadBloc,
    required this.accionesBloc,
    required this.descripcionEdificacionBloc,
  }) : super(EvaluacionGlobalState()) {
    _subscriptions = [
      evaluacionBloc.stream.listen(_onEvaluacionStateChanged),
      idEdificacionBloc.stream.listen(_onIdEdificacionStateChanged),
      riesgosExternosBloc.stream.listen(_onRiesgosExternosChanged),
      evaluacionDanosBloc.stream.listen(_onEvaluacionDanosStateChanged),
      nivelDanoBloc.stream.listen(_onNivelDanoStateChanged),
      habitabilidadBloc.stream.listen(_onHabitabilidadStateChanged),
      accionesBloc.stream.listen(_onAccionesStateChanged),
      descripcionEdificacionBloc.stream.listen(_onDescripcionEdificacionChanged),
    ];

    // Inicializar el estado global con los estados actuales de todos los blocs
    _initializeGlobalState();

    on<UpdateIdentificacionEvaluacion>((event, emit) {
      emit(state.copyWith(
        fechaInspeccion: event.fechaInspeccion,
        horaInspeccion: event.horaInspeccion,
        nombreEvaluador: event.nombreEvaluador,
        idGrupo: event.idGrupo,
        idEvento: event.idEvento,
        eventoSeleccionado: event.eventoSeleccionado,
        descripcionOtro: event.descripcionOtro,
        dependenciaEntidad: event.dependenciaEntidad,
        firmaPath: event.firmaPath,
      ));
      developer.log('UpdateIdentificacionEvaluacion', name: 'EvaluacionGlobalBloc');
    });

    on<UpdateIdentificacionEdificacion>((event, emit) {
      emit(state.copyWith(
        nombreEdificacion: event.nombreEdificacion,
        direccion: event.direccion,
        comuna: event.comuna,
        barrio: event.barrio,
        codigoBarrio: event.codigoBarrio,
        cbml: event.cbml,
        nombreContacto: event.nombreContacto,
        telefonoContacto: event.telefonoContacto,
        emailContacto: event.emailContacto,
        ocupacion: event.ocupacion,
        latitud: double.tryParse(event.latitud?.toString() ?? ''),
        longitud: double.tryParse(event.longitud?.toString() ?? ''),
        tipoVia: event.tipoVia,
        numeroVia: event.numeroVia,
        apendiceVia: event.apendiceVia,
        orientacionVia: event.orientacionVia,
        numeroCruce: event.numeroCruce,
        apendiceCruce: event.apendiceCruce,
        orientacionCruce: event.orientacionCruce,
        numero: event.numero,
        complemento: event.complemento,
        departamento: event.departamento,
        municipio: event.municipio,
      ));
      developer.log('UpdateIdentificacionEdificacion', name: 'EvaluacionGlobalBloc');
    });

    on<UpdateDescripcionEdificacion>((event, emit) {
      emit(state.copyWith(
        uso: event.uso,
        niveles: event.niveles,
        ocupantes: event.ocupantes,
        sistemaConstructivo: event.sistemaConstructivo,
        tipoEntrepiso: event.tipoEntrepiso,
        tipoCubierta: event.tipoCubierta,
        elementosNoEstructurales: event.elementosNoEstructurales,
        caracteristicasAdicionales: event.caracteristicasAdicionales,
      ));
      developer.log('UpdateDescripcionEdificacion', name: 'EvaluacionGlobalBloc');
    });

    on<UpdateRiesgosExternos>((event, emit) {
      emit(state.copyWith(
        colapsoEstructuras: event.colapsoEstructuras,
        caidaObjetos: event.caidaObjetos,
        otrosRiesgos: event.otrosRiesgos,
        riesgoColapso: event.riesgoColapso,
        riesgoCaida: event.riesgoCaida,
        riesgoServicios: event.riesgoServicios,
        riesgoTerreno: event.riesgoTerreno,
        riesgoAccesos: event.riesgoAccesos,
      ));
      developer.log('UpdateRiesgosExternos', name: 'EvaluacionGlobalBloc');
    });

    on<UpdateEvaluacionDanos>((event, emit) {
      emit(state.copyWith(
        danosEstructurales: event.danosEstructurales,
        danosNoEstructurales: event.danosNoEstructurales,
        danosGeotecnicos: event.danosGeotecnicos,
        condicionesPreexistentes: event.condicionesPreexistentes,
        alcanceEvaluacion: event.alcanceEvaluacion,
      ));
      developer.log('UpdateEvaluacionDanos', name: 'EvaluacionGlobalBloc');
    });

    on<UpdateNivelDano>((event, emit) {
      emit(state.copyWith(
        nivelDanoEstructural: event.nivelDanoEstructural,
        nivelDanoNoEstructural: event.nivelDanoNoEstructural,
        nivelDanoGeotecnico: event.nivelDanoGeotecnico,
        severidadGlobal: event.severidadGlobal,
      ));
      developer.log('UpdateNivelDano', name: 'EvaluacionGlobalBloc');
    });

    on<UpdateHabitabilidad>((event, emit) {
      emit(state.copyWith(
        estadoHabitabilidad: event.estadoHabitabilidad,
        clasificacionHabitabilidad: event.clasificacionHabitabilidad,
        observacionesHabitabilidad: event.observacionesHabitabilidad,
        criterioHabitabilidad: event.criterioHabitabilidad,
      ));
      developer.log('UpdateHabitabilidad', name: 'EvaluacionGlobalBloc');
    });

    on<UpdateAcciones>((event, emit) {
      emit(state.copyWith(
        evaluacionesAdicionales: event.evaluacionesAdicionales,
        medidasSeguridad: event.medidasSeguridad,
        entidadesRecomendadas: event.entidadesRecomendadas,
        observacionesAcciones: event.observacionesAcciones,
        medidasSeguridadSeleccionadas: event.medidasSeguridadSeleccionadas,
        evaluacionesAdicionalesSeleccionadas: event.evaluacionesAdicionalesSeleccionadas,
      ));
      developer.log('UpdateAcciones', name: 'EvaluacionGlobalBloc');
    });
  }

  void _initializeGlobalState() {
    final evaluacionState = evaluacionBloc.state;
    final idEdificacionState = idEdificacionBloc.state;
    final riesgosExternosState = riesgosExternosBloc.state;
    final evaluacionDanosState = evaluacionDanosBloc.state;
    final nivelDanoState = nivelDanoBloc.state;
    final habitabilidadState = habitabilidadBloc.state;
    final accionesState = accionesBloc.state;

    emit(state.copyWith(
      // Identificación de la Evaluación
      fechaInspeccion: evaluacionState.fechaInspeccion,
      horaInspeccion: evaluacionState.horaInspeccion,
      nombreEvaluador: evaluacionState.nombreEvaluador,
      idGrupo: evaluacionState.idGrupo,
      idEvento: evaluacionState.idEvento,
      eventoSeleccionado: evaluacionState.eventoSeleccionado,
      descripcionOtro: evaluacionState.descripcionOtro,
      dependenciaEntidad: evaluacionState.dependenciaEntidad,
      firmaPath: evaluacionState.firmaPath,

      // Identificación de la Edificación
      nombreEdificacion: idEdificacionState.nombreEdificacion,
      direccion: idEdificacionState.direccion,
      comuna: idEdificacionState.comuna,
      barrio: idEdificacionState.barrio,
      codigoBarrio: idEdificacionState.codigoBarrio,
      cbml: idEdificacionState.cbml,
      nombreContacto: idEdificacionState.nombreContacto,
      telefonoContacto: idEdificacionState.telefonoContacto,
      emailContacto: idEdificacionState.emailContacto,
      ocupacion: idEdificacionState.ocupacion,
      latitud: double.tryParse(idEdificacionState.latitud ?? ''),
      longitud: double.tryParse(idEdificacionState.longitud ?? ''),
      tipoVia: idEdificacionState.tipoVia,
      numeroVia: idEdificacionState.numeroVia,
      apendiceVia: idEdificacionState.apendiceVia,
      orientacionVia: idEdificacionState.orientacionVia,
      numeroCruce: idEdificacionState.numeroCruce,
      apendiceCruce: idEdificacionState.apendiceCruce,
      orientacionCruce: idEdificacionState.orientacionCruce,
      numero: idEdificacionState.numero,
      complemento: idEdificacionState.complemento,
      departamento: idEdificacionState.departamento,
      municipio: idEdificacionState.municipio,

      // Riesgos Externos
      colapsoEstructuras: riesgosExternosState.riesgos['4.1']?.existeRiesgo ?? false,
      caidaObjetos: riesgosExternosState.riesgos['4.2']?.existeRiesgo ?? false,
      otrosRiesgos: riesgosExternosState.riesgos['4.6']?.existeRiesgo ?? false,
      riesgoColapso: riesgosExternosState.riesgos['4.1']?.comprometeEstabilidad ?? false,
      riesgoCaida: riesgosExternosState.riesgos['4.2']?.comprometeEstabilidad ?? false,
      riesgoServicios: riesgosExternosState.riesgos['4.3']?.comprometeEstabilidad ?? false,
      riesgoTerreno: riesgosExternosState.riesgos['4.4']?.comprometeEstabilidad ?? false,
      riesgoAccesos: riesgosExternosState.riesgos['4.5']?.comprometeEstabilidad ?? false,

      // Evaluación de Daños
      danosEstructurales: evaluacionDanosState.danosEstructurales,
      danosNoEstructurales: evaluacionDanosState.danosNoEstructurales,
      danosGeotecnicos: evaluacionDanosState.danosGeotecnicos,
      condicionesPreexistentes: evaluacionDanosState.condicionesPreexistentes,
      alcanceEvaluacion: evaluacionDanosState.alcanceEvaluacion,

      // Nivel de Daño
      nivelDanoEstructural: nivelDanoState.nivelDanoEstructural,
      nivelDanoNoEstructural: nivelDanoState.nivelDanoNoEstructural,
      nivelDanoGeotecnico: nivelDanoState.nivelDanoGeotecnico,
      severidadGlobal: nivelDanoState.severidadGlobal,

      // Habitabilidad
      estadoHabitabilidad: habitabilidadState.criterioHabitabilidad ?? '',
      clasificacionHabitabilidad: habitabilidadState.clasificacion ?? '',
      observacionesHabitabilidad: habitabilidadState.observaciones ?? '',

      // Acciones Recomendadas
      evaluacionesAdicionales: accionesState.evaluacionesAdicionales ?? {},
      medidasSeguridad: accionesState.medidasSeguridad ?? {},
      entidadesRecomendadas: accionesState.entidadesRecomendadas ?? {},
      observacionesAcciones: accionesState.observacionesAcciones,
      medidasSeguridadSeleccionadas: accionesState.medidasSeguridadSeleccionadas ?? [],
      evaluacionesAdicionalesSeleccionadas: accionesState.evaluacionesAdicionalesSeleccionadas ?? [],
    ));
    developer.log('Estado global inicializado', name: 'EvaluacionGlobalBloc');
  }

  void _onEvaluacionStateChanged(EvaluacionState state) {
    emit(this.state.copyWith(
      fechaInspeccion: state.fechaInspeccion,
      horaInspeccion: state.horaInspeccion,
      nombreEvaluador: state.nombreEvaluador,
      idGrupo: state.idGrupo,
      idEvento: state.idEvento,
      eventoSeleccionado: state.eventoSeleccionado,
      descripcionOtro: state.descripcionOtro,
      dependenciaEntidad: state.dependenciaEntidad,
      firmaPath: state.firmaPath,
    ));
    developer.log('Estado de evaluación actualizado', name: 'EvaluacionGlobalBloc');
  }

  void _onIdEdificacionStateChanged(EdificacionState state) {
    emit(this.state.copyWith(
      nombreEdificacion: state.nombreEdificacion,
      direccion: state.direccion,
      comuna: state.comuna,
      barrio: state.barrio,
      codigoBarrio: state.codigoBarrio,
      cbml: state.cbml,
      nombreContacto: state.nombreContacto,
      telefonoContacto: state.telefonoContacto,
      emailContacto: state.emailContacto,
      ocupacion: state.ocupacion,
      latitud: double.tryParse(state.latitud ?? ''),
      longitud: double.tryParse(state.longitud ?? ''),
      tipoVia: state.tipoVia,
      numeroVia: state.numeroVia,
      apendiceVia: state.apendiceVia,
      orientacionVia: state.orientacionVia,
      numeroCruce: state.numeroCruce,
      apendiceCruce: state.apendiceCruce,
      orientacionCruce: state.orientacionCruce,
      numero: state.numero,
      complemento: state.complemento,
      departamento: state.departamento,
      municipio: state.municipio,
    ));
    developer.log('Estado de identificación de edificación actualizado', name: 'EvaluacionGlobalBloc');
  }

  void _onRiesgosExternosChanged(RiesgosExternosState riesgosState) {
    final riesgos = riesgosState.riesgos;
    emit(state.copyWith(
      colapsoEstructuras: riesgos['4.1']?.existeRiesgo ?? false,
      caidaObjetos: riesgos['4.2']?.existeRiesgo ?? false,
      otrosRiesgos: riesgos['4.6']?.existeRiesgo ?? false,
      riesgoColapso: riesgos['4.1']?.comprometeEstabilidad ?? false,
      riesgoCaida: riesgos['4.2']?.comprometeEstabilidad ?? false,
      riesgoServicios: riesgos['4.3']?.comprometeEstabilidad ?? false,
      riesgoTerreno: riesgos['4.4']?.comprometeEstabilidad ?? false,
      riesgoAccesos: riesgos['4.5']?.comprometeAccesos ?? false,
    ));
    developer.log('Estado de riesgos externos actualizado', name: 'EvaluacionGlobalBloc');
  }

  void _onEvaluacionDanosStateChanged(EvaluacionDanosState state) {
    emit(this.state.copyWith(
      danosEstructurales: state.danosEstructurales,
      danosNoEstructurales: state.danosNoEstructurales,
      danosGeotecnicos: state.danosGeotecnicos,
      condicionesPreexistentes: state.condicionesPreexistentes,
      alcanceEvaluacion: state.alcanceEvaluacion,
    ));
    developer.log('Estado de evaluación de daños actualizado', name: 'EvaluacionGlobalBloc');
  }

  void _onNivelDanoStateChanged(NivelDanoState nivelDanoState) {
    emit(state.copyWith(
      nivelDanoEstructural: nivelDanoState.nivelDanoEstructural,
      nivelDanoNoEstructural: nivelDanoState.nivelDanoNoEstructural,
      nivelDanoGeotecnico: nivelDanoState.nivelDanoGeotecnico,
      severidadGlobal: nivelDanoState.severidadGlobal,
    ));
    developer.log('Estado de nivel de daño actualizado', name: 'EvaluacionGlobalBloc');
  }

  void _onHabitabilidadStateChanged(HabitabilidadState state) {
    emit(this.state.copyWith(
      estadoHabitabilidad: state.estadoHabitabilidad,
      clasificacionHabitabilidad: state.clasificacionHabitabilidad,
      observacionesHabitabilidad: state.observacionesHabitabilidad,
      criterioHabitabilidad: state.criterioHabitabilidad,
    ));
    developer.log('Estado de habitabilidad actualizado', name: 'EvaluacionGlobalBloc');
  }

  void _onAccionesStateChanged(AccionesState state) {
    add(UpdateAcciones(
      evaluacionesAdicionales: state.evaluacionesAdicionales,
      medidasSeguridad: state.medidasSeguridad,
      entidadesRecomendadas: state.entidadesRecomendadas,
      observacionesAcciones: state.observacionesAcciones,
      medidasSeguridadSeleccionadas: state.medidasSeguridadSeleccionadas,
      evaluacionesAdicionalesSeleccionadas: state.evaluacionesAdicionalesSeleccionadas,
    ));
    developer.log('Estado de acciones actualizado', name: 'EvaluacionGlobalBloc');
  }

  void _onDescripcionEdificacionChanged(DescripcionEdificacionState descripcionState) {
    emit(state.copyWith(
      uso: descripcionState.usoPredominante,
      niveles: descripcionState.pisosSobreTerreno,
      ocupantes: descripcionState.numeroOcupantes,
      sistemaConstructivo: descripcionState.sistemaEstructural,
      tipoEntrepiso: descripcionState.materialEntrepiso,
      tipoCubierta: descripcionState.sistemaMultiple,
      elementosNoEstructurales: _formatListToString(descripcionState.sistemaSoporte),
      caracteristicasAdicionales: descripcionState.observacionesSistema,
    ));
    developer.log('Estado de descripción de edificación actualizado', name: 'EvaluacionGlobalBloc');
  }

  String? _formatListToString(List<String>? list) {
    if (list == null || list.isEmpty) return null;
    return list.join(', ');
  }

  @override
  Future<void> close() {
    for (var subscription in _subscriptions) {
      subscription.cancel();
    }
    return super.close();
  }
} 