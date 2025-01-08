abstract class RiesgosExternosEvent {}

class SetRiesgoExterno extends RiesgosExternosEvent {
  final String riesgoId;
  final bool existeRiesgo;
  final bool? comprometeFuncionalidad;
  final bool? comprometeEstabilidad;

  SetRiesgoExterno({
    required this.riesgoId,
    required this.existeRiesgo,
    this.comprometeFuncionalidad,
    this.comprometeEstabilidad,
  });
}

class SetOtroRiesgo extends RiesgosExternosEvent {
  final String descripcion;
  SetOtroRiesgo(this.descripcion);
} 