import 'package:flutter/material.dart';

abstract class EvaluacionEvent {}

class EvaluacionStarted extends EvaluacionEvent {}

class SetEvaluacionData extends EvaluacionEvent {
  final DateTime? fechaInspeccion;
  final TimeOfDay? horaInspeccion;
  final String? nombreEvaluador;
  final String? idGrupo;
  final String? idEvento;
  final String? eventoSeleccionado;
  final String? descripcionOtro;
  final String? dependenciaEntidad;
  final String? firmaPath;

  SetEvaluacionData({
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

class SignatureUpdated extends EvaluacionEvent {
  final String firmaPath;
  SignatureUpdated(this.firmaPath);
} 