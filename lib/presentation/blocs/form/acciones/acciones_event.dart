abstract class AccionesEvent {}

class SetEvaluacionAdicional extends AccionesEvent {
  final String tipo;
  final String descripcion;
  
  SetEvaluacionAdicional({
    required this.tipo,
    required this.descripcion,
  });
}

class SetRecomendacion extends AccionesEvent {
  final String recomendacion;
  final bool valor;
  
  SetRecomendacion({
    required this.recomendacion,
    required this.valor,
  });
}

class SetEntidadRecomendada extends AccionesEvent {
  final String entidad;
  final bool valor;
  final String? otraEntidad;
  
  SetEntidadRecomendada({
    required this.entidad,
    required this.valor,
    this.otraEntidad,
  });
}

class SetRecomendacionesEspecificas extends AccionesEvent {
  final String recomendaciones;
  
  SetRecomendacionesEspecificas(this.recomendaciones);
}

class UpdateAcciones extends AccionesEvent {
  final String? evaluacionesAdicionales;
  final String? medidasSeguridad;
  final Map<String, bool>? entidadesRecomendadas;
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