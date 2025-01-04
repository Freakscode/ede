import 'package:flutter/material.dart';
import 'id_evaluacion_state.dart';

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

class SetIdEvento extends EvaluacionEvent {
  final String idEvento;
  SetIdEvento(this.idEvento);
}

class LoadTemporaryEvaluacionData extends EvaluacionEvent {
  LoadTemporaryEvaluacionData();
}

class SetDependencia extends EvaluacionEvent {
  final String dependencia;
  SetDependencia(this.dependencia);
}

class LoadEvaluacionData extends EvaluacionEvent {}

class SetDireccion extends EvaluacionEvent {
  final String direccion;
  SetDireccion(this.direccion);
}

class SetComuna extends EvaluacionEvent {
  final String comuna;
  SetComuna(this.comuna);
}

class SetBarrio extends EvaluacionEvent {
  final String barrio;
  SetBarrio(this.barrio);
}