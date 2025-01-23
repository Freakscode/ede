import 'package:flutter/material.dart';
import 'package:equatable/equatable.dart';
import '../form/identificacionEdificacion/id_edificacion_state.dart';
import '../form/riesgosExternos/riesgos_externos_state.dart';

abstract class EvaluacionGlobalEvent extends Equatable {
  const EvaluacionGlobalEvent();

  @override
  List<Object?> get props => [];
}

class UpdateIdentificacionEvaluacion extends EvaluacionGlobalEvent {
  final DateTime? fechaInspeccion;
  final TimeOfDay? horaInspeccion;
  final String? nombreEvaluador;
  final String? idGrupo;
  final String? idEvento;
  final String? eventoSeleccionado;
  final String? descripcionOtro;
  final String? dependenciaEntidad;
  final String? firmaPath;

  UpdateIdentificacionEvaluacion({
    this.fechaInspeccion,
    this.horaInspeccion,
    this.nombreEvaluador,
    this.idGrupo,
    this.idEvento,
    this.eventoSeleccionado,
    this.descripcionOtro,
    this.dependenciaEntidad,
    this.firmaPath,
  });

  @override
  List<Object?> get props => [
    fechaInspeccion,
    horaInspeccion,
    nombreEvaluador,
    idGrupo,
    idEvento,
    eventoSeleccionado,
    descripcionOtro,
    dependenciaEntidad,
    firmaPath
  ];
}

class UpdateIdentificacionEdificacion extends EvaluacionGlobalEvent {
  final String? nombreEdificacion;
  final String? direccion;
  final String? comuna;
  final String? barrio;
  final String? codigoBarrio;
  final String? cbml;
  final String? nombreContacto;
  final String? telefonoContacto;
  final String? emailContacto;
  final String? ocupacion;
  final double? latitud;
  final double? longitud;
  final String? tipoVia;
  final String? numeroVia;
  final String? apendiceVia;
  final String? orientacionVia;
  final String? numeroCruce;
  final String? apendiceCruce;
  final String? orientacionCruce;
  final String? numero;
  final String? complemento;
  final String? departamento;
  final String? municipio;

  UpdateIdentificacionEdificacion({
    this.nombreEdificacion,
    this.direccion,
    this.comuna,
    this.barrio,
    this.codigoBarrio,
    this.cbml,
    this.nombreContacto,
    this.telefonoContacto,
    this.emailContacto,
    this.ocupacion,
    this.latitud,
    this.longitud,
    this.tipoVia,
    this.numeroVia,
    this.apendiceVia,
    this.orientacionVia,
    this.numeroCruce,
    this.apendiceCruce,
    this.orientacionCruce,
    this.numero,
    this.complemento,
    this.departamento,
    this.municipio,
  });

  @override
  List<Object?> get props => [
    nombreEdificacion,
    direccion,
    comuna,
    barrio,
    codigoBarrio,
    cbml,
    nombreContacto,
    telefonoContacto,
    emailContacto,
    ocupacion,
    latitud,
    longitud,
    tipoVia,
    numeroVia,
    apendiceVia,
    orientacionVia,
    numeroCruce,
    apendiceCruce,
    orientacionCruce,
    numero,
    complemento,
    departamento,
    municipio
  ];
}

class UpdateDescripcionEdificacion extends EvaluacionGlobalEvent {
  final String? uso;
  final int? niveles;
  final int? ocupantes;
  final String? sistemaConstructivo;
  final String? tipoEntrepiso;
  final String? tipoCubierta;
  final String? elementosNoEstructurales;
  final String? caracteristicasAdicionales;

  UpdateDescripcionEdificacion({
    this.uso,
    this.niveles,
    this.ocupantes,
    this.sistemaConstructivo,
    this.tipoEntrepiso,
    this.tipoCubierta,
    this.elementosNoEstructurales,
    this.caracteristicasAdicionales,
  });

  @override
  List<Object?> get props => [
    uso,
    niveles,
    ocupantes,
    sistemaConstructivo,
    tipoEntrepiso,
    tipoCubierta,
    elementosNoEstructurales,
    caracteristicasAdicionales
  ];
}

class UpdateRiesgosExternos extends EvaluacionGlobalEvent {
  final Map<String, RiesgoItem> riesgosExternos;
  final String? otroRiesgoExterno;

  const UpdateRiesgosExternos({
    required this.riesgosExternos,
    this.otroRiesgoExterno,
  });

  @override
  List<Object?> get props => [riesgosExternos, otroRiesgoExterno];
}

class UpdateEvaluacionDanos extends EvaluacionGlobalEvent {
  final Map<String, dynamic>? danosEstructurales;
  final Map<String, dynamic>? danosNoEstructurales;
  final Map<String, dynamic>? danosGeotecnicos;
  final Map<String, dynamic>? condicionesPreexistentes;
  final String? alcanceEvaluacion;

  const UpdateEvaluacionDanos({
    this.danosEstructurales,
    this.danosNoEstructurales,
    this.danosGeotecnicos,
    this.condicionesPreexistentes,
    this.alcanceEvaluacion,
  });

  @override
  List<Object?> get props => [
    danosEstructurales,
    danosNoEstructurales,
    danosGeotecnicos,
    condicionesPreexistentes,
    alcanceEvaluacion
  ];
}

class UpdateNivelDano extends EvaluacionGlobalEvent {
  final String? nivelDanoEstructural;
  final String? nivelDanoNoEstructural;
  final String? nivelDanoGeotecnico;
  final String? severidadGlobal;
  final String? porcentajeAfectacion;

  const UpdateNivelDano({
    this.nivelDanoEstructural,
    this.nivelDanoNoEstructural,
    this.nivelDanoGeotecnico,
    this.severidadGlobal,
    this.porcentajeAfectacion,
  });

  @override
  List<Object?> get props => [
    nivelDanoEstructural,
    nivelDanoNoEstructural,
    nivelDanoGeotecnico,
    severidadGlobal,
    porcentajeAfectacion,
  ];
}

class UpdateHabitabilidad extends EvaluacionGlobalEvent {
  final String? estadoHabitabilidad;
  final String? clasificacionHabitabilidad;
  final String? observacionesHabitabilidad;
  final String? criterioHabitabilidad;

  UpdateHabitabilidad({
    this.estadoHabitabilidad,
    this.clasificacionHabitabilidad,
    this.observacionesHabitabilidad,
    this.criterioHabitabilidad,
  });

  @override
  List<Object?> get props => [
    estadoHabitabilidad,
    clasificacionHabitabilidad,
    observacionesHabitabilidad,
    criterioHabitabilidad
  ];
}

class UpdateAcciones extends EvaluacionGlobalEvent {
  final Map<String, dynamic>? evaluacionesAdicionales;
  final Map<String, dynamic>? medidasSeguridad;
  final Map<String, bool>? entidadesRecomendadas;
  final String? observacionesAcciones;
  final List<String>? medidasSeguridadSeleccionadas;
  final List<String>? evaluacionesAdicionalesSeleccionadas;

  const UpdateAcciones({
    this.evaluacionesAdicionales,
    this.medidasSeguridad,
    this.entidadesRecomendadas,
    this.observacionesAcciones,
    this.medidasSeguridadSeleccionadas,
    this.evaluacionesAdicionalesSeleccionadas,
  });

  @override
  List<Object?> get props => [
    evaluacionesAdicionales,
    medidasSeguridad,
    entidadesRecomendadas,
    observacionesAcciones,
    medidasSeguridadSeleccionadas,
    evaluacionesAdicionalesSeleccionadas
  ];
}

class IdEdificacionStateChanged extends EvaluacionGlobalEvent {
  final EdificacionState state;

  const IdEdificacionStateChanged(this.state);

  @override
  List<Object?> get props => [state];
} 