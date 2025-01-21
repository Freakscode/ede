abstract class NivelDanoEvent {}

class SetPorcentajeAfectacion extends NivelDanoEvent {
  final String porcentaje;
  
  SetPorcentajeAfectacion(this.porcentaje);
}

class SetSeveridadDanos extends NivelDanoEvent {
  final String severidad;
  
  SetSeveridadDanos(this.severidad);
}

class CalcularNivelDano extends NivelDanoEvent {}

class CalcularSeveridadDanos extends NivelDanoEvent {
  final Map<String, bool> condicionesExistentes;
  final Map<String, String> nivelesElementos;
  
  CalcularSeveridadDanos({
    required this.condicionesExistentes,
    required this.nivelesElementos,
  });
} 