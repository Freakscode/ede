abstract class AccionesEvent {}

class UpdateAcciones extends AccionesEvent {
  final String? evaluacionesAdicionales;
  final String? medidasSeguridad;
  final String? entidadesRecomendadas;
  final String? observacionesAcciones;
  final List<String>? medidasSeguridadSeleccionadas;
  final List<String>? evaluacionesAdicionalesSeleccionadas;

  UpdateAcciones({
    this.evaluacionesAdicionales,
    this.medidasSeguridad,
    this.entidadesRecomendadas,
    this.observacionesAcciones,
    this.medidasSeguridadSeleccionadas,
    this.evaluacionesAdicionalesSeleccionadas,
  });
} 