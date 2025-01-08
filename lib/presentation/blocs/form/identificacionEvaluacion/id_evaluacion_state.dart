import 'package:flutter/material.dart';

enum TipoEvento {
  inundacion,
  deslizamiento,
  sismo,
  viento,
  incendio,
  explosion,
  estructural,
  otro
}

class EvaluacionState {
  final DateTime? fechaInspeccion;
  final TimeOfDay? horaInspeccion;
  final String? nombreEvaluador;
  final String? idGrupo;
  final String? dependenciaEntidad;
  final String? firma;
  final TipoEvento? eventoSeleccionado;
  final String? descripcionOtro;
  final String? idEvento;
  final String? direccion;
  final String? comuna;
  final String? barrio;

  EvaluacionState({
    this.idEvento,
    this.fechaInspeccion,
    this.horaInspeccion,
    this.nombreEvaluador,
    this.idGrupo,
    this.dependenciaEntidad,
    this.firma,
    this.eventoSeleccionado,
    this.descripcionOtro,
    this.direccion,
    this.comuna,
    this.barrio,
  });

  EvaluacionState copyWith({
    String? idEvento,
    DateTime? fechaInspeccion,
    TimeOfDay? horaInspeccion,
    String? nombreEvaluador,
    String? idGrupo,
    String? dependenciaEntidad,
    String? firma,
    TipoEvento? eventoSeleccionado,
    String? descripcionOtro,
    String? direccion,
    String? comuna,
    String? barrio,
  }) {
    return EvaluacionState(
      idEvento: idEvento ?? this.idEvento,
      fechaInspeccion: fechaInspeccion ?? this.fechaInspeccion,
      horaInspeccion: horaInspeccion ?? this.horaInspeccion,
      nombreEvaluador: nombreEvaluador ?? this.nombreEvaluador,
      idGrupo: idGrupo ?? this.idGrupo,
      dependenciaEntidad: dependenciaEntidad ?? this.dependenciaEntidad,
      firma: firma ?? this.firma,
      eventoSeleccionado: eventoSeleccionado ?? this.eventoSeleccionado,
      descripcionOtro: descripcionOtro ?? this.descripcionOtro,
      direccion: direccion ?? this.direccion,
      comuna: comuna ?? this.comuna,
      barrio: barrio ?? this.barrio,
    );
  }

  Map<String, dynamic> toJson() => {
    'fechaInspeccion': fechaInspeccion?.toIso8601String(),
    'horaInspeccion': horaInspeccion?.toString(),
    'idGrupo': idGrupo,
    'idEvento': idEvento,
    'eventoSeleccionado': eventoSeleccionado?.name,
    'descripcionOtro': descripcionOtro,
    'dependenciaEntidad': dependenciaEntidad,
  };
}