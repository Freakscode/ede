import 'package:flutter/material.dart';

class EvaluacionState {
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
  final String? calle;
  final String? numero;
  final String? colonia;
  final String? codigoPostal;
  final String? referencias;
  final String? comuna;
  final String? barrio;
  final String? codigoCatastral;
  final String? nombreContacto;
  final String? telefonoContacto;
  final String? emailContacto;

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
  final String? colapsoEstructuras;
  final String? caidaObjetos;
  final String? otrosRiesgos;
  final bool? riesgoColapso;
  final bool? riesgoCaida;
  final bool? riesgoServicios;
  final bool? riesgoTerreno;
  final bool? riesgoAccesos;

  // Evaluación de Daños
  final String? danosEstructurales;
  final String? danosNoEstructurales;
  final String? danosGeotecnicos;
  final String? condicionesPreexistentes;
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
  final String? evaluacionesAdicionales;
  final String? medidasSeguridad;
  final String? entidadesRecomendadas;
  final String? observacionesAcciones;
  final List<String>? medidasSeguridadSeleccionadas;
  final List<String>? evaluacionesAdicionalesSeleccionadas;

  EvaluacionState({
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
    this.calle,
    this.numero,
    this.colonia,
    this.codigoPostal,
    this.referencias,
    this.comuna,
    this.barrio,
    this.codigoCatastral,
    this.nombreContacto,
    this.telefonoContacto,
    this.emailContacto,
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
    this.entidadesRecomendadas,
    this.observacionesAcciones,
    this.medidasSeguridadSeleccionadas,
    this.evaluacionesAdicionalesSeleccionadas,
  });

  EvaluacionState copyWith({
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
    String? calle,
    String? numero,
    String? colonia,
    String? codigoPostal,
    String? referencias,
    String? comuna,
    String? barrio,
    String? codigoCatastral,
    String? nombreContacto,
    String? telefonoContacto,
    String? emailContacto,
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
    String? colapsoEstructuras,
    String? caidaObjetos,
    String? otrosRiesgos,
    bool? riesgoColapso,
    bool? riesgoCaida,
    bool? riesgoServicios,
    bool? riesgoTerreno,
    bool? riesgoAccesos,
    // Evaluación de Daños
    String? danosEstructurales,
    String? danosNoEstructurales,
    String? danosGeotecnicos,
    String? condicionesPreexistentes,
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
    String? evaluacionesAdicionales,
    String? medidasSeguridad,
    String? entidadesRecomendadas,
    String? observacionesAcciones,
    List<String>? medidasSeguridadSeleccionadas,
    List<String>? evaluacionesAdicionalesSeleccionadas,
  }) {
    return EvaluacionState(
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
      calle: calle ?? this.calle,
      numero: numero ?? this.numero,
      colonia: colonia ?? this.colonia,
      codigoPostal: codigoPostal ?? this.codigoPostal,
      referencias: referencias ?? this.referencias,
      comuna: comuna ?? this.comuna,
      barrio: barrio ?? this.barrio,
      codigoCatastral: codigoCatastral ?? this.codigoCatastral,
      nombreContacto: nombreContacto ?? this.nombreContacto,
      telefonoContacto: telefonoContacto ?? this.telefonoContacto,
      emailContacto: emailContacto ?? this.emailContacto,
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