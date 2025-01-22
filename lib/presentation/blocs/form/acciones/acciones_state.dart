import 'package:equatable/equatable.dart';

class AccionesState extends Equatable {
  final Map<String, dynamic> evaluacionesAdicionales;
  final Map<String, dynamic> medidasSeguridad;
  final Map<String, bool> entidadesRecomendadas;
  final String? observacionesAcciones;
  final List<String> medidasSeguridadSeleccionadas;
  final List<String> evaluacionesAdicionalesSeleccionadas;
  final Map<String, String> evaluacionAdicional;
  final Map<String, bool> recomendaciones;
  final String? otraEntidad;
  final String? recomendacionesEspecificas;

  const AccionesState({
    Map<String, dynamic>? evaluacionesAdicionales,
    Map<String, dynamic>? medidasSeguridad,
    Map<String, bool>? entidadesRecomendadas,
    this.observacionesAcciones,
    List<String>? medidasSeguridadSeleccionadas,
    List<String>? evaluacionesAdicionalesSeleccionadas,
    Map<String, String>? evaluacionAdicional,
    Map<String, bool>? recomendaciones,
    this.otraEntidad,
    this.recomendacionesEspecificas,
  }) : evaluacionesAdicionales = evaluacionesAdicionales ?? const {},
       medidasSeguridad = medidasSeguridad ?? const {},
       entidadesRecomendadas = entidadesRecomendadas ?? const {},
       medidasSeguridadSeleccionadas = medidasSeguridadSeleccionadas ?? const [],
       evaluacionesAdicionalesSeleccionadas = evaluacionesAdicionalesSeleccionadas ?? const [],
       evaluacionAdicional = evaluacionAdicional ?? const {},
       recomendaciones = recomendaciones ?? const {};

  @override
  List<Object?> get props => [
        evaluacionesAdicionales,
        medidasSeguridad,
        entidadesRecomendadas,
        observacionesAcciones,
        medidasSeguridadSeleccionadas,
        evaluacionesAdicionalesSeleccionadas,
        evaluacionAdicional,
        recomendaciones,
        otraEntidad,
        recomendacionesEspecificas,
      ];

  AccionesState copyWith({
    Map<String, dynamic>? evaluacionesAdicionales,
    Map<String, dynamic>? medidasSeguridad,
    Map<String, bool>? entidadesRecomendadas,
    String? observacionesAcciones,
    List<String>? medidasSeguridadSeleccionadas,
    List<String>? evaluacionesAdicionalesSeleccionadas,
    Map<String, String>? evaluacionAdicional,
    Map<String, bool>? recomendaciones,
    String? otraEntidad,
    String? recomendacionesEspecificas,
  }) {
    return AccionesState(
      evaluacionesAdicionales: evaluacionesAdicionales ?? this.evaluacionesAdicionales,
      medidasSeguridad: medidasSeguridad ?? this.medidasSeguridad,
      entidadesRecomendadas: entidadesRecomendadas ?? this.entidadesRecomendadas,
      observacionesAcciones: observacionesAcciones ?? this.observacionesAcciones,
      medidasSeguridadSeleccionadas: medidasSeguridadSeleccionadas ?? this.medidasSeguridadSeleccionadas,
      evaluacionesAdicionalesSeleccionadas: evaluacionesAdicionalesSeleccionadas ?? this.evaluacionesAdicionalesSeleccionadas,
      evaluacionAdicional: evaluacionAdicional ?? this.evaluacionAdicional,
      recomendaciones: recomendaciones ?? this.recomendaciones,
      otraEntidad: otraEntidad ?? this.otraEntidad,
      recomendacionesEspecificas: recomendacionesEspecificas ?? this.recomendacionesEspecificas,
    );
  }

  Map<String, dynamic> toJson() => {
    'evaluacionesAdicionales': evaluacionesAdicionales,
    'medidasSeguridad': medidasSeguridad,
    'entidadesRecomendadas': entidadesRecomendadas,
    'observacionesAcciones': observacionesAcciones,
    'medidasSeguridadSeleccionadas': medidasSeguridadSeleccionadas,
    'evaluacionesAdicionalesSeleccionadas': evaluacionesAdicionalesSeleccionadas,
    'evaluacionAdicional': evaluacionAdicional,
    'recomendaciones': recomendaciones,
    'otraEntidad': otraEntidad,
    'recomendacionesEspecificas': recomendacionesEspecificas,
  };

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is AccionesState &&
          runtimeType == other.runtimeType &&
          evaluacionesAdicionales == other.evaluacionesAdicionales &&
          medidasSeguridad == other.medidasSeguridad &&
          entidadesRecomendadas == other.entidadesRecomendadas &&
          observacionesAcciones == other.observacionesAcciones &&
          medidasSeguridadSeleccionadas == other.medidasSeguridadSeleccionadas &&
          evaluacionesAdicionalesSeleccionadas == other.evaluacionesAdicionalesSeleccionadas &&
          evaluacionAdicional == other.evaluacionAdicional &&
          recomendaciones == other.recomendaciones &&
          otraEntidad == other.otraEntidad &&
          recomendacionesEspecificas == other.recomendacionesEspecificas;

  @override
  int get hashCode =>
      evaluacionesAdicionales.hashCode ^
      medidasSeguridad.hashCode ^
      entidadesRecomendadas.hashCode ^
      observacionesAcciones.hashCode ^
      medidasSeguridadSeleccionadas.hashCode ^
      evaluacionesAdicionalesSeleccionadas.hashCode ^
      evaluacionAdicional.hashCode ^
      recomendaciones.hashCode ^
      otraEntidad.hashCode ^
      recomendacionesEspecificas.hashCode;

  static final AccionesState initial = AccionesState();
}