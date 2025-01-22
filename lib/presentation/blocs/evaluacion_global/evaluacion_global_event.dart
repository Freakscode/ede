import 'package:flutter/material.dart';
import '../form/evaluacion/evaluacion_state.dart';
import '../form/identificacionEdificacion/id_edificacion_state.dart';
import '../form/riesgosExternos/riesgos_externos_state.dart';
import '../form/nivelDano/nivel_dano_state.dart';

abstract class EvaluacionGlobalEvent {
  const EvaluacionGlobalEvent();
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
}

class UpdateRiesgosExternos extends EvaluacionGlobalEvent {
  final bool? colapsoEstructuras;
  final bool? caidaObjetos;
  final bool? otrosRiesgos;
  final bool? riesgoColapso;
  final bool? riesgoCaida;
  final bool? riesgoServicios;
  final bool? riesgoTerreno;
  final bool? riesgoAccesos;

  UpdateRiesgosExternos({
    this.colapsoEstructuras,
    this.caidaObjetos,
    this.otrosRiesgos,
    this.riesgoColapso,
    this.riesgoCaida,
    this.riesgoServicios,
    this.riesgoTerreno,
    this.riesgoAccesos,
  });
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
}

class UpdateNivelDano extends EvaluacionGlobalEvent {
  final String? nivelDanoEstructural;
  final String? nivelDanoNoEstructural;
  final String? nivelDanoGeotecnico;
  final String? severidadGlobal;

  UpdateNivelDano({
    this.nivelDanoEstructural,
    this.nivelDanoNoEstructural,
    this.nivelDanoGeotecnico,
    this.severidadGlobal,
  });
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
} 