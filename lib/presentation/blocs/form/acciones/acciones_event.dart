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