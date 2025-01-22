class AccionesState {
  final String? evaluacionesAdicionales;
  final String? medidasSeguridad;
  final String? entidadesRecomendadas;
  final String? observacionesAcciones;
  final List<String>? medidasSeguridadSeleccionadas;
  final List<String>? evaluacionesAdicionalesSeleccionadas;

  AccionesState({
    this.evaluacionesAdicionales,
    this.medidasSeguridad,
    this.entidadesRecomendadas,
    this.observacionesAcciones,
    this.medidasSeguridadSeleccionadas,
    this.evaluacionesAdicionalesSeleccionadas,
  });

  AccionesState copyWith({
    String? evaluacionesAdicionales,
    String? medidasSeguridad,
    String? entidadesRecomendadas,
    String? observacionesAcciones,
    List<String>? medidasSeguridadSeleccionadas,
    List<String>? evaluacionesAdicionalesSeleccionadas,
  }) {
    return AccionesState(
      evaluacionesAdicionales: evaluacionesAdicionales ?? this.evaluacionesAdicionales,
      medidasSeguridad: medidasSeguridad ?? this.medidasSeguridad,
      entidadesRecomendadas: entidadesRecomendadas ?? this.entidadesRecomendadas,
      observacionesAcciones: observacionesAcciones ?? this.observacionesAcciones,
      medidasSeguridadSeleccionadas: medidasSeguridadSeleccionadas ?? this.medidasSeguridadSeleccionadas,
      evaluacionesAdicionalesSeleccionadas: evaluacionesAdicionalesSeleccionadas ?? this.evaluacionesAdicionalesSeleccionadas,
    );
  }
} 