import 'package:flutter/material.dart';

class EvaluacionState {
  final DateTime? fechaInspeccion;
  final TimeOfDay? horaInspeccion;
  final String? nombreEvaluador;
  final String? idGrupo;
  final String? idEvento;
  final String? eventoSeleccionado;
  final String? descripcionOtro;
  final String? dependenciaEntidad;
  final String? firmaPath;

  EvaluacionState({
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

  EvaluacionState copyWith({
    DateTime? fechaInspeccion,
    TimeOfDay? horaInspeccion,
    String? nombreEvaluador,
    String? idGrupo,
    String? idEvento,
    String? eventoSeleccionado,
    String? descripcionOtro,
    String? dependenciaEntidad,
    String? firmaPath,
  }) {
    return EvaluacionState(
      fechaInspeccion: fechaInspeccion ?? this.fechaInspeccion,
      horaInspeccion: horaInspeccion ?? this.horaInspeccion,
      nombreEvaluador: nombreEvaluador ?? this.nombreEvaluador,
      idGrupo: idGrupo ?? this.idGrupo,
      idEvento: idEvento ?? this.idEvento,
      eventoSeleccionado: eventoSeleccionado ?? this.eventoSeleccionado,
      descripcionOtro: descripcionOtro ?? this.descripcionOtro,
      dependenciaEntidad: dependenciaEntidad ?? this.dependenciaEntidad,
      firmaPath: firmaPath ?? this.firmaPath,
    );
  }
} 