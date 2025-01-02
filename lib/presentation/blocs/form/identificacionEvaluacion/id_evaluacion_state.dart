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

  EvaluacionState({
    this.fechaInspeccion,
    this.horaInspeccion,
    this.nombreEvaluador,
    this.idGrupo,
    this.dependenciaEntidad,
    this.firma,
    this.eventoSeleccionado,
    this.descripcionOtro,
  });

  EvaluacionState copyWith({
    DateTime? fechaInspeccion,
    TimeOfDay? horaInspeccion,
    String? nombreEvaluador,
    String? idGrupo,
    String? dependenciaEntidad,
    String? firma,
    TipoEvento? eventoSeleccionado,
    String? descripcionOtro,
  }) {
    return EvaluacionState(
      fechaInspeccion: fechaInspeccion ?? this.fechaInspeccion,
      horaInspeccion: horaInspeccion ?? this.horaInspeccion,
      nombreEvaluador: nombreEvaluador ?? this.nombreEvaluador,
      idGrupo: idGrupo ?? this.idGrupo,
      dependenciaEntidad: dependenciaEntidad ?? this.dependenciaEntidad,
      firma: firma ?? this.firma,
      eventoSeleccionado: eventoSeleccionado ?? this.eventoSeleccionado,
      descripcionOtro: descripcionOtro ?? this.descripcionOtro,
    );
  }
}