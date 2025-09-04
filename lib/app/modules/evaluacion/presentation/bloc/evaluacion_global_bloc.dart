import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/material.dart';
import 'form/evaluacion/evaluacion_bloc.dart';
import 'form/evaluacion/evaluacion_state.dart';
import 'form/identificacionEdificacion/id_edificacion_bloc.dart';
import 'form/identificacionEdificacion/id_edificacion_state.dart';
import 'form/riesgosExternos/riesgos_externos_bloc.dart';
import 'form/riesgosExternos/riesgos_externos_state.dart';
import 'form/evaluacionDanos/evaluacion_danos_bloc.dart';
import 'form/evaluacionDanos/evaluacion_danos_state.dart';
import 'form/nivelDano/nivel_dano_bloc.dart';
import 'form/nivelDano/nivel_dano_state.dart';
import 'form/habitabilidad/habitabilidad_bloc.dart';
import 'form/habitabilidad/habitabilidad_state.dart';
import 'form/acciones/acciones_bloc.dart';
import 'form/acciones/acciones_state.dart';
import 'form/descripcionEdificacion/descripcion_edificacion_bloc.dart';
import 'form/descripcionEdificacion/descripcion_edificacion_state.dart';
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

  final List<StreamSubscription> _subscriptions = [];
  StreamSubscription<EdificacionState>? _edificacionSubscription;

  EvaluacionGlobalBloc({
    required this.evaluacionBloc,
    required this.idEdificacionBloc,
    required this.riesgosExternosBloc,
    required this.evaluacionDanosBloc,
    required this.nivelDanoBloc,
    required this.habitabilidadBloc,
    required this.accionesBloc,
    required this.descripcionEdificacionBloc,
  }) : super(const EvaluacionGlobalState()) {
    // Inicializar el estado global con los estados actuales de todos los blocs
    _initializeGlobalState();

    _subscriptions.addAll([
      evaluacionBloc.stream.listen((state) {
        developer.log('Stream Evaluacion actualizado', name: 'EvaluacionGlobalBloc');
        _onEvaluacionStateChanged(state);
      }),
      idEdificacionBloc.stream.listen((state) {
        developer.log('Stream IdEdificacion actualizado', name: 'EvaluacionGlobalBloc');
        add(IdEdificacionStateChanged(state));
      }),
      riesgosExternosBloc.stream.listen((state) {
        developer.log('Stream RiesgosExternos actualizado', name: 'EvaluacionGlobalBloc');
        _onRiesgosExternosChanged(state);
      }),
      evaluacionDanosBloc.stream.listen((state) {
        developer.log('Stream EvaluacionDanos actualizado', name: 'EvaluacionGlobalBloc');
        _onEvaluacionDanosStateChanged(state);
      }),
      nivelDanoBloc.stream.listen((state) {
        developer.log('Stream NivelDano actualizado', name: 'EvaluacionGlobalBloc');
        _onNivelDanoStateChanged(state);
      }),
      habitabilidadBloc.stream.listen((state) {
        developer.log('Stream Habitabilidad actualizado', name: 'EvaluacionGlobalBloc');
        _onHabitabilidadStateChanged(state);
      }),
      accionesBloc.stream.listen((state) {
        developer.log('Stream Acciones actualizado', name: 'EvaluacionGlobalBloc');
        _onAccionesStateChanged(state);
      }),
      descripcionEdificacionBloc.stream.listen((state) {
        developer.log('Stream DescripcionEdificacion actualizado: ${state.toString()}', name: 'EvaluacionGlobalBloc');
        _onDescripcionEdificacionChanged(state);
      }),
    ]);

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
        riesgosExternos: Map<String, RiesgoItem>.from(event.riesgosExternos),
        otroRiesgoExterno: event.otroRiesgoExterno,
      ));
      developer.log('RiesgosExternos actualizados', name: 'EvaluacionGlobalBloc');
    });

    on<UpdateEvaluacionDanos>((event, emit) {
      emit(state.copyWith(
        danosEstructurales: event.danosEstructurales != null ? Map<String, dynamic>.from(event.danosEstructurales!) : null,
        danosNoEstructurales: event.danosNoEstructurales != null ? Map<String, dynamic>.from(event.danosNoEstructurales!) : null,
        danosGeotecnicos: event.danosGeotecnicos != null ? Map<String, dynamic>.from(event.danosGeotecnicos!) : null,
        condicionesPreexistentes: event.condicionesPreexistentes != null ? Map<String, dynamic>.from(event.condicionesPreexistentes!) : null,
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
        porcentajeAfectacion: event.porcentajeAfectacion,
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

    on<IdEdificacionStateChanged>((event, emit) {
      developer.log('Manejando evento IdEdificacionStateChanged');
      _onIdEdificacionStateChanged(event, emit);
    });

    _edificacionSubscription = idEdificacionBloc.stream.listen((edificacionState) {
      developer.log('Cambio detectado en el estado de identificación de edificación');
      final event = IdEdificacionStateChanged(edificacionState);
      add(event);
      developer.log('Evento IdEdificacionStateChanged enviado al bloc');
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
    final descripcionEdificacionState = descripcionEdificacionBloc.state;

    developer.log('Inicializando estado global con datos de descripción de edificación', name: 'EvaluacionGlobalBloc');

    // Formatear uso predominante
    String usoStr = descripcionEdificacionState.usoPredominante ?? '';
    if (descripcionEdificacionState.otroUso != null && descripcionEdificacionState.otroUso!.isNotEmpty) {
      usoStr = '${descripcionEdificacionState.usoPredominante} - ${descripcionEdificacionState.otroUso}';
    }

    // Calcular niveles totales
    int nivelesTotal = (descripcionEdificacionState.pisosSobreTerreno ?? 0) + 
                      (descripcionEdificacionState.sotanos ?? 0);

    // Formatear los datos de descripción de edificación
    final sistemasEstructuralesStr = _formatSistemasEstructurales(descripcionEdificacionState);
    final sistemasEntrepisoStr = _formatSistemasEntrepiso(descripcionEdificacionState);
    final elementosNoEstructuralesStr = _formatElementosNoEstructurales(descripcionEdificacionState);
    final caracteristicasAdicionalesStr = _formatCaracteristicasAdicionales(descripcionEdificacionState);

    emit(state.copyWith(
      // Datos de identificación de evaluación
      fechaInspeccion: evaluacionState.fechaInspeccion,
      horaInspeccion: evaluacionState.horaInspeccion,
      nombreEvaluador: evaluacionState.nombreEvaluador,
      idGrupo: evaluacionState.idGrupo,
      idEvento: evaluacionState.idEvento,
      eventoSeleccionado: evaluacionState.eventoSeleccionado,
      descripcionOtro: evaluacionState.descripcionOtro,
      dependenciaEntidad: evaluacionState.dependenciaEntidad,
      firmaPath: evaluacionState.firmaPath,
      // Datos de identificación de edificación
      nombreEdificacion: idEdificacionState.nombreEdificacion,
      direccion: _construirDireccion(idEdificacionState),
      comuna: idEdificacionState.comuna,
      barrio: idEdificacionState.barrio,
      cbml: idEdificacionState.cbml,
      nombreContacto: idEdificacionState.nombreContacto,
      telefonoContacto: idEdificacionState.telefonoContacto,
      emailContacto: idEdificacionState.emailContacto,
      ocupacion: idEdificacionState.ocupacion,
      latitud: idEdificacionState.latitud != null ? double.tryParse(idEdificacionState.latitud!) : null,
      longitud: idEdificacionState.longitud != null ? double.tryParse(idEdificacionState.longitud!) : null,
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
      // Datos de descripción de edificación
      uso: usoStr,
      niveles: nivelesTotal,
      ocupantes: descripcionEdificacionState.numeroOcupantes,
      sistemaConstructivo: sistemasEstructuralesStr,
      tipoEntrepiso: sistemasEntrepisoStr,
      tipoCubierta: _formatSistemaCubierta(descripcionEdificacionState),
      elementosNoEstructurales: elementosNoEstructuralesStr,
      caracteristicasAdicionales: caracteristicasAdicionalesStr,
      // Riesgos Externos
      riesgosExternos: Map<String, RiesgoItem>.from(riesgosExternosState.riesgos),
      otroRiesgoExterno: riesgosExternosState.otroRiesgo,
      // Evaluación de Daños
      danosEstructurales: Map<String, dynamic>.from({
        ...evaluacionDanosState.danosEstructurales,
        'condicionesExistentes': Map<String, bool>.from(evaluacionDanosState.condicionesExistentes),
        'nivelesElementos': Map<String, String>.from(evaluacionDanosState.nivelesElementos),
      }),
      danosNoEstructurales: Map<String, dynamic>.from(evaluacionDanosState.danosNoEstructurales),
      danosGeotecnicos: Map<String, dynamic>.from(evaluacionDanosState.danosGeotecnicos),
      condicionesPreexistentes: Map<String, dynamic>.from(evaluacionDanosState.condicionesPreexistentes),
      alcanceEvaluacion: _formatearAlcanceEvaluacion(evaluacionDanosState.alcanceExterior, evaluacionDanosState.alcanceInterior),
      // Nivel de Daño
      nivelDanoEstructural: nivelDanoState.nivelDanoEstructural,
      nivelDanoNoEstructural: nivelDanoState.nivelDanoNoEstructural,
      nivelDanoGeotecnico: nivelDanoState.nivelDanoGeotecnico,
      severidadGlobal: nivelDanoState.severidadDanos,
      porcentajeAfectacion: nivelDanoState.porcentajeAfectacion,
      // Habitabilidad
      estadoHabitabilidad: habitabilidadState.criterioHabitabilidad,
      clasificacionHabitabilidad: habitabilidadState.clasificacion,
      observacionesHabitabilidad: habitabilidadState.observaciones,
      criterioHabitabilidad: habitabilidadState.criterioHabitabilidad,
      // Acciones Recomendadas
      evaluacionesAdicionales: Map<String, dynamic>.from(accionesState.evaluacionesAdicionales),
      medidasSeguridad: Map<String, dynamic>.from(accionesState.medidasSeguridad),
      entidadesRecomendadas: Map<String, bool>.from(accionesState.entidadesRecomendadas),
      observacionesAcciones: accionesState.observacionesAcciones,
      medidasSeguridadSeleccionadas: List<String>.from(accionesState.medidasSeguridadSeleccionadas),
      evaluacionesAdicionalesSeleccionadas: List<String>.from(accionesState.evaluacionesAdicionalesSeleccionadas),
    ));

    developer.log('Estado global inicializado correctamente', name: 'EvaluacionGlobalBloc');
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

  void _onIdEdificacionStateChanged(IdEdificacionStateChanged event, Emitter<EvaluacionGlobalState> emit) {
    emit(state.copyWith(
      nombreEdificacion: event.state.nombreEdificacion,
      direccion: _construirDireccion(event.state),
      comuna: event.state.comuna,
      barrio: event.state.barrio,
      cbml: event.state.cbml,
      nombreContacto: event.state.nombreContacto,
      telefonoContacto: event.state.telefonoContacto,
      emailContacto: event.state.emailContacto,
      ocupacion: event.state.ocupacion,
      latitud: event.state.latitud != null ? double.tryParse(event.state.latitud!) : null,
      longitud: event.state.longitud != null ? double.tryParse(event.state.longitud!) : null,
      tipoVia: event.state.tipoVia,
      numeroVia: event.state.numeroVia,
      apendiceVia: event.state.apendiceVia,
      orientacionVia: event.state.orientacionVia,
      numeroCruce: event.state.numeroCruce,
      apendiceCruce: event.state.apendiceCruce,
      orientacionCruce: event.state.orientacionCruce,
      numero: event.state.numero,
      complemento: event.state.complemento,
      departamento: event.state.departamento,
      municipio: event.state.municipio,
    ));
    developer.log('Estado de identificación de edificación actualizado', name: 'EvaluacionGlobalBloc');
  }

  String _construirDireccion(EdificacionState state) {
    final List<String> componentes = [];
    
    // Vía principal
    if (state.tipoVia?.isNotEmpty == true) {
      componentes.add(state.tipoVia!);
      if (state.numeroVia?.isNotEmpty == true) componentes.add(state.numeroVia!);
      if (state.apendiceVia?.isNotEmpty == true) componentes.add(state.apendiceVia!);
      if (state.orientacionVia?.isNotEmpty == true) componentes.add(state.orientacionVia!);
    }
    
    // Cruce
    if (state.numeroCruce?.isNotEmpty == true) {
      componentes.add("#");
      componentes.add(state.numeroCruce!);
      if (state.apendiceCruce?.isNotEmpty == true) componentes.add(state.apendiceCruce!);
      if (state.orientacionCruce?.isNotEmpty == true) componentes.add(state.orientacionCruce!);
    }
    
    // Número y complemento
    if (state.numero?.isNotEmpty == true) {
      componentes.add("-");
      componentes.add(state.numero!);
    }
    if (state.complemento?.isNotEmpty == true) {
      componentes.add("(${state.complemento})");
    }
    
    return componentes.isEmpty ? 'No especificada' : componentes.join(" ");
  }

  void _onRiesgosExternosChanged(RiesgosExternosState state) {
    emit(this.state.copyWith(
      riesgosExternos: Map<String, RiesgoItem>.from(state.riesgos),
      otroRiesgoExterno: state.otroRiesgo,
    ));
    developer.log('RiesgosExternos actualizados en estado global', name: 'EvaluacionGlobalBloc');
  }

  void _onEvaluacionDanosStateChanged(EvaluacionDanosState state) {
    emit(this.state.copyWith(
      danosEstructurales: Map<String, dynamic>.from({
        ...state.danosEstructurales,
        'condicionesExistentes': Map<String, bool>.from(state.condicionesExistentes),
        'nivelesElementos': Map<String, String>.from(state.nivelesElementos),
      }),
      danosNoEstructurales: Map<String, dynamic>.from(state.danosNoEstructurales),
      danosGeotecnicos: Map<String, dynamic>.from(state.danosGeotecnicos),
      condicionesPreexistentes: Map<String, dynamic>.from(state.condicionesPreexistentes),
      alcanceEvaluacion: _formatearAlcanceEvaluacion(state.alcanceExterior, state.alcanceInterior),
    ));
    developer.log('Estado de evaluación de daños actualizado', name: 'EvaluacionGlobalBloc');
  }

  String? _formatearAlcanceEvaluacion(String? exterior, String? interior) {
    List<String> alcances = [];
    if (exterior != null) alcances.add('Exterior: $exterior');
    if (interior != null) alcances.add('Interior: $interior');
    return alcances.isEmpty ? null : alcances.join(', ');
  }

  void _onNivelDanoStateChanged(NivelDanoState state) {
    emit(this.state.copyWith(
      nivelDanoEstructural: state.nivelDanoEstructural,
      nivelDanoNoEstructural: state.nivelDanoNoEstructural,
      nivelDanoGeotecnico: state.nivelDanoGeotecnico,
      severidadGlobal: state.severidadDanos,
      porcentajeAfectacion: state.porcentajeAfectacion,
    ));
    developer.log('Estado de nivel de daño actualizado', name: 'EvaluacionGlobalBloc');
  }

  void _onHabitabilidadStateChanged(HabitabilidadState state) {
    emit(this.state.copyWith(
      estadoHabitabilidad: state.criterioHabitabilidad ?? '',
      clasificacionHabitabilidad: state.clasificacion ?? '',
      observacionesHabitabilidad: state.observaciones ?? '',
      criterioHabitabilidad: state.criterioHabitabilidad,
    ));
    developer.log('Estado de habitabilidad actualizado', name: 'EvaluacionGlobalBloc');
  }

  void _onAccionesStateChanged(AccionesState state) {
    emit(this.state.copyWith(
      evaluacionesAdicionales: state.evaluacionesAdicionales,
      medidasSeguridad: state.medidasSeguridad,
      entidadesRecomendadas: state.entidadesRecomendadas,
      observacionesAcciones: state.observacionesAcciones,
      medidasSeguridadSeleccionadas: state.medidasSeguridadSeleccionadas,
      evaluacionesAdicionalesSeleccionadas: state.evaluacionesAdicionalesSeleccionadas,
    ));
    developer.log('Estado de acciones actualizado', name: 'EvaluacionGlobalBloc');
  }

  void _onDescripcionEdificacionChanged(DescripcionEdificacionState state) {
    developer.log('Actualizando estado global con descripción de edificación', name: 'EvaluacionGlobalBloc');

    // Formatear uso predominante
    String usoStr = state.usoPredominante ?? 'No especificado';
    if (state.otroUso != null && state.otroUso!.isNotEmpty && state.usoPredominante == 'Otro') {
      usoStr = '${state.usoPredominante} - ${state.otroUso}';
    }
    developer.log('Uso formateado: $usoStr', name: 'EvaluacionGlobalBloc');

    // Calcular niveles totales
    int nivelesTotal = (state.pisosSobreTerreno ?? 0) + 
                      (state.sotanos ?? 0);
    developer.log('Niveles totales: $nivelesTotal', name: 'EvaluacionGlobalBloc');

    // Formatear sistemas estructurales
    final sistemasEstructuralesStr = _formatSistemasEstructurales(state);
    developer.log('Sistemas estructurales formateados: $sistemasEstructuralesStr', name: 'EvaluacionGlobalBloc');

    // Formatear sistemas de entrepiso
    final sistemasEntrepisoStr = _formatSistemasEntrepiso(state);
    developer.log('Sistemas de entrepiso formateados: $sistemasEntrepisoStr', name: 'EvaluacionGlobalBloc');

    // Formatear sistema de cubierta
    final sistemaCubiertaStr = _formatSistemaCubierta(state);
    developer.log('Sistema de cubierta formateado: $sistemaCubiertaStr', name: 'EvaluacionGlobalBloc');

    // Formatear elementos no estructurales
    final elementosNoEstructuralesStr = _formatElementosNoEstructurales(state);
    developer.log('Elementos no estructurales formateados: $elementosNoEstructuralesStr', name: 'EvaluacionGlobalBloc');

    // Formatear características adicionales
    final caracteristicasAdicionalesStr = _formatCaracteristicasAdicionales(state);
    developer.log('Características adicionales formateadas: $caracteristicasAdicionalesStr', name: 'EvaluacionGlobalBloc');

    // Emitir nuevo estado con todos los campos actualizados
    emit(this.state.copyWith(
      uso: usoStr,
      niveles: nivelesTotal,
      ocupantes: state.numeroOcupantes,
      sistemaConstructivo: sistemasEstructuralesStr,
      tipoEntrepiso: sistemasEntrepisoStr,
      tipoCubierta: sistemaCubiertaStr,
      elementosNoEstructurales: elementosNoEstructuralesStr,
      caracteristicasAdicionales: caracteristicasAdicionalesStr,
    ));

    developer.log('Estado global actualizado - Uso: $usoStr', name: 'EvaluacionGlobalBloc');
  }

  String _formatSistemasEstructurales(DescripcionEdificacionState state) {
    if (state.sistemasEstructurales == null || state.sistemasEstructurales!.isEmpty) {
      return 'No especificado';
    }

    final buffer = StringBuffer();
    for (var i = 0; i < state.sistemasEstructurales!.length; i++) {
      final sistema = state.sistemasEstructurales![i];
      final materiales = state.materialesPorSistema?[sistema];
      
      buffer.write(sistema);
      if (materiales != null && materiales.isNotEmpty) {
        buffer.write(' (${materiales.join(', ')})');
      }
      
      if (i < state.sistemasEstructurales!.length - 1) {
        buffer.write('\n');
      }
    }
    return buffer.toString();
  }

  String _formatSistemasEntrepiso(DescripcionEdificacionState state) {
    if (state.sistemasEntrepiso == null || state.sistemasEntrepiso!.isEmpty) {
      return 'No especificado';
    }

    final buffer = StringBuffer();
    for (var i = 0; i < state.sistemasEntrepiso!.length; i++) {
      final sistema = state.sistemasEntrepiso![i];
      final tipos = state.tiposEntrepisoPorMaterial?[sistema];
      
      buffer.write(sistema);
      if (tipos != null && tipos.isNotEmpty) {
        buffer.write(' (${tipos.join(', ')})');
      }
      
      if (i < state.sistemasEntrepiso!.length - 1) {
        buffer.write('\n');
      }
    }
    return buffer.toString();
  }

  String _formatSistemaCubierta(DescripcionEdificacionState state) {
    if ((state.sistemaSoporte == null || state.sistemaSoporte!.isEmpty) &&
        (state.revestimiento == null || state.revestimiento!.isEmpty)) {
      return 'No especificado';
    }

    final buffer = StringBuffer();
    
    if (state.sistemaSoporte != null && state.sistemaSoporte!.isNotEmpty) {
      buffer.write('Soporte: ${state.sistemaSoporte!.join(', ')}');
      if (state.otroSistemaSoporte != null && state.otroSistemaSoporte!.isNotEmpty) {
        buffer.write(' (${state.otroSistemaSoporte})');
      }
    }

    if (state.revestimiento != null && state.revestimiento!.isNotEmpty) {
      if (buffer.isNotEmpty) buffer.write('\n');
      buffer.write('Revestimiento: ${state.revestimiento!.join(', ')}');
      if (state.otroRevestimiento != null && state.otroRevestimiento!.isNotEmpty) {
        buffer.write(' (${state.otroRevestimiento})');
      }
    }

    return buffer.toString();
  }

  String _formatElementosNoEstructurales(DescripcionEdificacionState state) {
    final buffer = StringBuffer();
    bool hasContent = false;

    if (state.murosDivisorios != null && state.murosDivisorios!.isNotEmpty) {
      buffer.write('Muros: ${state.murosDivisorios!.join(', ')}');
      if (state.otroMuroDivisorio != null && state.otroMuroDivisorio!.isNotEmpty) {
        buffer.write(' (${state.otroMuroDivisorio})');
      }
      hasContent = true;
    }

    if (state.fachadas != null && state.fachadas!.isNotEmpty) {
      if (hasContent) buffer.write('\n');
      buffer.write('Fachadas: ${state.fachadas!.join(', ')}');
      if (state.otraFachada != null && state.otraFachada!.isNotEmpty) {
        buffer.write(' (${state.otraFachada})');
      }
      hasContent = true;
    }

    if (state.escaleras != null && state.escaleras!.isNotEmpty) {
      if (hasContent) buffer.write('\n');
      buffer.write('Escaleras: ${state.escaleras!.join(', ')}');
      if (state.otraEscalera != null && state.otraEscalera!.isNotEmpty) {
        buffer.write(' (${state.otraEscalera})');
      }
      hasContent = true;
    }

    return hasContent ? buffer.toString() : 'No especificado';
  }

  String _formatCaracteristicasAdicionales(DescripcionEdificacionState state) {
    final buffer = StringBuffer();
    bool hasContent = false;

    if (state.nivelDiseno != null && state.nivelDiseno!.isNotEmpty) {
      buffer.write('Nivel de diseño: ${state.nivelDiseno}');
      hasContent = true;
    }

    if (state.calidadDiseno != null && state.calidadDiseno!.isNotEmpty) {
      if (hasContent) buffer.write('\n');
      buffer.write('Calidad de diseño: ${state.calidadDiseno}');
      hasContent = true;
    }

    if (state.estadoEdificacion != null && state.estadoEdificacion!.isNotEmpty) {
      if (hasContent) buffer.write('\n');
      buffer.write('Estado de la edificación: ${state.estadoEdificacion}');
      hasContent = true;
    }

    if (state.sistemaMultiple != null && state.sistemaMultiple!.isNotEmpty) {
      if (hasContent) buffer.write('\n');
      buffer.write('Sistema múltiple: ${state.sistemaMultiple}');
      hasContent = true;
    }

    if (state.observacionesSistema != null && state.observacionesSistema!.isNotEmpty) {
      if (hasContent) buffer.write('\n');
      buffer.write('Observaciones: ${state.observacionesSistema}');
      hasContent = true;
    }

    return hasContent ? buffer.toString() : 'No especificado';
  }

  String? _formatListToString(List<String>? list) {
    if (list == null || list.isEmpty) return null;
    return list.join(', ');
  }

  @override
  Future<void> close() async {
    for (var subscription in _subscriptions) {
      await subscription.cancel();
    }
    await _edificacionSubscription?.cancel();
    return super.close();
  }
} 