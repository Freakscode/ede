abstract class NivelDanoEvent {}

class UpdateNivelDano extends NivelDanoEvent {
  final String nivelDano;
  UpdateNivelDano(this.nivelDano);
}

class UpdateNivelDanoEstructural extends NivelDanoEvent {
  final String nivelDanoEstructural;
  UpdateNivelDanoEstructural(this.nivelDanoEstructural);
}

class UpdateNivelDanoNoEstructural extends NivelDanoEvent {
  final String nivelDanoNoEstructural;
  UpdateNivelDanoNoEstructural(this.nivelDanoNoEstructural);
}

class UpdateNivelDanoGeotecnico extends NivelDanoEvent {
  final String nivelDanoGeotecnico;
  UpdateNivelDanoGeotecnico(this.nivelDanoGeotecnico);
}

class UpdateSeveridadGlobal extends NivelDanoEvent {
  final String severidadGlobal;
  UpdateSeveridadGlobal(this.severidadGlobal);
}

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