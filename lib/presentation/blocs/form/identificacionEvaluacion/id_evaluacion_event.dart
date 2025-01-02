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

abstract class EvaluacionEvent {}

class SetFechaInspeccion extends EvaluacionEvent {
  final DateTime fecha;
  SetFechaInspeccion(this.fecha);
}

class SetHoraInspeccion extends EvaluacionEvent {
  final TimeOfDay hora;
  SetHoraInspeccion(this.hora);
}

class SetNombreEvaluador extends EvaluacionEvent {
  final String nombre;
  SetNombreEvaluador(this.nombre);
}

class SetIdGrupo extends EvaluacionEvent {
  final String idGrupo;
  SetIdGrupo(this.idGrupo);
}

class SetDependenciaEntidad extends EvaluacionEvent {
  final String dependencia;
  SetDependenciaEntidad(this.dependencia);
}

class SetFirma extends EvaluacionEvent {
  final String rutaFirma;
  SetFirma(this.rutaFirma);
}

class SetEvento extends EvaluacionEvent {
  final TipoEvento evento;
  final String? descripcionOtro;
  SetEvento(this.evento, {this.descripcionOtro});
}