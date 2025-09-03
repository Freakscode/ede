abstract class RiesgosExternosEvent {}

class SetRiesgoExterno extends RiesgosExternosEvent {
  final String riesgoId;
  final bool valor;
  SetRiesgoExterno({required this.riesgoId, required this.valor});
}

class SetComprometeAccesos extends RiesgosExternosEvent {
  final String riesgoId;
  final bool valor;
  SetComprometeAccesos({required this.riesgoId, required this.valor});
}

class SetComprometeEstabilidad extends RiesgosExternosEvent {
  final String riesgoId;
  final bool valor;
  SetComprometeEstabilidad({required this.riesgoId, required this.valor});
}

class SetOtroRiesgo extends RiesgosExternosEvent {
  final String valor;
  SetOtroRiesgo({required this.valor});
} 