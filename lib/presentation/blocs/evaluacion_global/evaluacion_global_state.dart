import 'package:flutter/material.dart';

class EvaluacionGlobalState {
  // Identificación de la Evaluación
  final DateTime? fechaInspeccion;
  final TimeOfDay? horaInspeccion;
  final String? nombreEvaluador;
  final String? idGrupo;
  final String? idEvento;
  final String? eventoSeleccionado;
  final String? descripcionOtro;
  final String? dependenciaEntidad;
  final String? firmaPath;

  // Identificación de la Edificación
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

  // Descripción de la Edificación
  final String? uso;
  final int? niveles;
  final int? ocupantes;
  final String? sistemaConstructivo;
  final String? tipoEntrepiso;
  final String? tipoCubierta;
  final String? elementosNoEstructurales;
  final String? caracteristicasAdicionales;

  // Riesgos Externos
  final bool? colapsoEstructuras;
  final bool? caidaObjetos;
  final bool? otrosRiesgos;
  final bool? riesgoColapso;
  final bool? riesgoCaida;
  final bool? riesgoServicios;
  final bool? riesgoTerreno;
  final bool? riesgoAccesos;

  // Evaluación de Daños
  final Map<String, dynamic>? danosEstructurales;
  final Map<String, dynamic>? danosNoEstructurales;
  final Map<String, dynamic>? danosGeotecnicos;
  final Map<String, dynamic>? condicionesPreexistentes;
  final String? alcanceEvaluacion;

  // Nivel de Daño
  final String? nivelDanoEstructural;
  final String? nivelDanoNoEstructural;
  final String? nivelDanoGeotecnico;
  final String? severidadGlobal;

  // Habitabilidad
  final String? estadoHabitabilidad;
  final String? clasificacionHabitabilidad;
  final String? observacionesHabitabilidad;
  final String? criterioHabitabilidad;

  // Acciones Recomendadas
  final Map<String, dynamic>? evaluacionesAdicionales;
  final Map<String, dynamic>? medidasSeguridad;
  final Map<String, bool> entidadesRecomendadas;
  final String? observacionesAcciones;
  final List<String>? medidasSeguridadSeleccionadas;
  final List<String>? evaluacionesAdicionalesSeleccionadas;

  const EvaluacionGlobalState({
    // Identificación de la Evaluación
    this.fechaInspeccion,
    this.horaInspeccion,
    this.nombreEvaluador,
    this.idGrupo,
    this.idEvento,
    this.eventoSeleccionado,
    this.descripcionOtro,
    this.dependenciaEntidad,
    this.firmaPath,
    // Identificación de la Edificación
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
    // Descripción de la Edificación
    this.uso,
    this.niveles,
    this.ocupantes,
    this.sistemaConstructivo,
    this.tipoEntrepiso,
    this.tipoCubierta,
    this.elementosNoEstructurales,
    this.caracteristicasAdicionales,
    // Riesgos Externos
    this.colapsoEstructuras,
    this.caidaObjetos,
    this.otrosRiesgos,
    this.riesgoColapso,
    this.riesgoCaida,
    this.riesgoServicios,
    this.riesgoTerreno,
    this.riesgoAccesos,
    // Evaluación de Daños
    this.danosEstructurales,
    this.danosNoEstructurales,
    this.danosGeotecnicos,
    this.condicionesPreexistentes,
    this.alcanceEvaluacion,
    // Nivel de Daño
    this.nivelDanoEstructural,
    this.nivelDanoNoEstructural,
    this.nivelDanoGeotecnico,
    this.severidadGlobal,
    // Habitabilidad
    this.estadoHabitabilidad,
    this.clasificacionHabitabilidad,
    this.observacionesHabitabilidad,
    this.criterioHabitabilidad,
    // Acciones Recomendadas
    this.evaluacionesAdicionales,
    this.medidasSeguridad,
    this.entidadesRecomendadas = const {},
    this.observacionesAcciones,
    this.medidasSeguridadSeleccionadas,
    this.evaluacionesAdicionalesSeleccionadas,
  });

  EvaluacionGlobalState copyWith({
    // Identificación de la Evaluación
    DateTime? fechaInspeccion,
    TimeOfDay? horaInspeccion,
    String? nombreEvaluador,
    String? idGrupo,
    String? idEvento,
    String? eventoSeleccionado,
    String? descripcionOtro,
    String? dependenciaEntidad,
    String? firmaPath,
    // Identificación de la Edificación
    String? nombreEdificacion,
    String? direccion,
    String? comuna,
    String? barrio,
    String? codigoBarrio,
    String? cbml,
    String? nombreContacto,
    String? telefonoContacto,
    String? emailContacto,
    String? ocupacion,
    double? latitud,
    double? longitud,
    String? tipoVia,
    String? numeroVia,
    String? apendiceVia,
    String? orientacionVia,
    String? numeroCruce,
    String? apendiceCruce,
    String? orientacionCruce,
    String? numero,
    String? complemento,
    String? departamento,
    String? municipio,
    // Descripción de la Edificación
    String? uso,
    int? niveles,
    int? ocupantes,
    String? sistemaConstructivo,
    String? tipoEntrepiso,
    String? tipoCubierta,
    String? elementosNoEstructurales,
    String? caracteristicasAdicionales,
    // Riesgos Externos
    bool? colapsoEstructuras,
    bool? caidaObjetos,
    bool? otrosRiesgos,
    bool? riesgoColapso,
    bool? riesgoCaida,
    bool? riesgoServicios,
    bool? riesgoTerreno,
    bool? riesgoAccesos,
    // Evaluación de Daños
    Map<String, dynamic>? danosEstructurales,
    Map<String, dynamic>? danosNoEstructurales,
    Map<String, dynamic>? danosGeotecnicos,
    Map<String, dynamic>? condicionesPreexistentes,
    String? alcanceEvaluacion,
    // Nivel de Daño
    String? nivelDanoEstructural,
    String? nivelDanoNoEstructural,
    String? nivelDanoGeotecnico,
    String? severidadGlobal,
    // Habitabilidad
    String? estadoHabitabilidad,
    String? clasificacionHabitabilidad,
    String? observacionesHabitabilidad,
    String? criterioHabitabilidad,
    // Acciones Recomendadas
    Map<String, dynamic>? evaluacionesAdicionales,
    Map<String, dynamic>? medidasSeguridad,
    Map<String, bool>? entidadesRecomendadas,
    String? observacionesAcciones,
    List<String>? medidasSeguridadSeleccionadas,
    List<String>? evaluacionesAdicionalesSeleccionadas,
  }) {
    return EvaluacionGlobalState(
      // Identificación de la Evaluación
      fechaInspeccion: fechaInspeccion ?? this.fechaInspeccion,
      horaInspeccion: horaInspeccion ?? this.horaInspeccion,
      nombreEvaluador: nombreEvaluador ?? this.nombreEvaluador,
      idGrupo: idGrupo ?? this.idGrupo,
      idEvento: idEvento ?? this.idEvento,
      eventoSeleccionado: eventoSeleccionado ?? this.eventoSeleccionado,
      descripcionOtro: descripcionOtro ?? this.descripcionOtro,
      dependenciaEntidad: dependenciaEntidad ?? this.dependenciaEntidad,
      firmaPath: firmaPath ?? this.firmaPath,
      // Identificación de la Edificación
      nombreEdificacion: nombreEdificacion ?? this.nombreEdificacion,
      direccion: direccion ?? this.direccion,
      comuna: comuna ?? this.comuna,
      barrio: barrio ?? this.barrio,
      codigoBarrio: codigoBarrio ?? this.codigoBarrio,
      cbml: cbml ?? this.cbml,
      nombreContacto: nombreContacto ?? this.nombreContacto,
      telefonoContacto: telefonoContacto ?? this.telefonoContacto,
      emailContacto: emailContacto ?? this.emailContacto,
      ocupacion: ocupacion ?? this.ocupacion,
      latitud: latitud ?? this.latitud,
      longitud: longitud ?? this.longitud,
      tipoVia: tipoVia ?? this.tipoVia,
      numeroVia: numeroVia ?? this.numeroVia,
      apendiceVia: apendiceVia ?? this.apendiceVia,
      orientacionVia: orientacionVia ?? this.orientacionVia,
      numeroCruce: numeroCruce ?? this.numeroCruce,
      apendiceCruce: apendiceCruce ?? this.apendiceCruce,
      orientacionCruce: orientacionCruce ?? this.orientacionCruce,
      numero: numero ?? this.numero,
      complemento: complemento ?? this.complemento,
      departamento: departamento ?? this.departamento,
      municipio: municipio ?? this.municipio,
      // Descripción de la Edificación
      uso: uso ?? this.uso,
      niveles: niveles ?? this.niveles,
      ocupantes: ocupantes ?? this.ocupantes,
      sistemaConstructivo: sistemaConstructivo ?? this.sistemaConstructivo,
      tipoEntrepiso: tipoEntrepiso ?? this.tipoEntrepiso,
      tipoCubierta: tipoCubierta ?? this.tipoCubierta,
      elementosNoEstructurales: elementosNoEstructurales ?? this.elementosNoEstructurales,
      caracteristicasAdicionales: caracteristicasAdicionales ?? this.caracteristicasAdicionales,
      // Riesgos Externos
      colapsoEstructuras: colapsoEstructuras ?? this.colapsoEstructuras,
      caidaObjetos: caidaObjetos ?? this.caidaObjetos,
      otrosRiesgos: otrosRiesgos ?? this.otrosRiesgos,
      riesgoColapso: riesgoColapso ?? this.riesgoColapso,
      riesgoCaida: riesgoCaida ?? this.riesgoCaida,
      riesgoServicios: riesgoServicios ?? this.riesgoServicios,
      riesgoTerreno: riesgoTerreno ?? this.riesgoTerreno,
      riesgoAccesos: riesgoAccesos ?? this.riesgoAccesos,
      // Evaluación de Daños
      danosEstructurales: danosEstructurales ?? this.danosEstructurales,
      danosNoEstructurales: danosNoEstructurales ?? this.danosNoEstructurales,
      danosGeotecnicos: danosGeotecnicos ?? this.danosGeotecnicos,
      condicionesPreexistentes: condicionesPreexistentes ?? this.condicionesPreexistentes,
      alcanceEvaluacion: alcanceEvaluacion ?? this.alcanceEvaluacion,
      // Nivel de Daño
      nivelDanoEstructural: nivelDanoEstructural ?? this.nivelDanoEstructural,
      nivelDanoNoEstructural: nivelDanoNoEstructural ?? this.nivelDanoNoEstructural,
      nivelDanoGeotecnico: nivelDanoGeotecnico ?? this.nivelDanoGeotecnico,
      severidadGlobal: severidadGlobal ?? this.severidadGlobal,
      // Habitabilidad
      estadoHabitabilidad: estadoHabitabilidad ?? this.estadoHabitabilidad,
      clasificacionHabitabilidad: clasificacionHabitabilidad ?? this.clasificacionHabitabilidad,
      observacionesHabitabilidad: observacionesHabitabilidad ?? this.observacionesHabitabilidad,
      criterioHabitabilidad: criterioHabitabilidad ?? this.criterioHabitabilidad,
      // Acciones Recomendadas
      evaluacionesAdicionales: evaluacionesAdicionales ?? this.evaluacionesAdicionales,
      medidasSeguridad: medidasSeguridad ?? this.medidasSeguridad,
      entidadesRecomendadas: entidadesRecomendadas ?? this.entidadesRecomendadas,
      observacionesAcciones: observacionesAcciones ?? this.observacionesAcciones,
      medidasSeguridadSeleccionadas: medidasSeguridadSeleccionadas ?? this.medidasSeguridadSeleccionadas,
      evaluacionesAdicionalesSeleccionadas: evaluacionesAdicionalesSeleccionadas ?? this.evaluacionesAdicionalesSeleccionadas,
    );
  }
} 