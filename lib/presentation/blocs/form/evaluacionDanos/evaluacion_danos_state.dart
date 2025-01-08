class EvaluacionDanosState {
  // Primera subsección (5.1-5.6)
  final Map<String, bool?> condicionesExistentes;
  
  // Segunda subsección (5.7-5.11)
  final Map<String, String?> nivelesElementos;
  
  // Alcance de la evaluación
  final String? alcanceExterior;
  final String? alcanceInterior;

  EvaluacionDanosState({
    Map<String, bool?>? condicionesExistentes,
    Map<String, String?>? nivelesElementos,
    this.alcanceExterior,
    this.alcanceInterior,
  }) : condicionesExistentes = condicionesExistentes ?? {},
       nivelesElementos = nivelesElementos ?? {};

  EvaluacionDanosState copyWith({
    Map<String, bool?>? condicionesExistentes,
    Map<String, String?>? nivelesElementos,
    String? alcanceExterior,
    String? alcanceInterior,
  }) {
    return EvaluacionDanosState(
      condicionesExistentes: condicionesExistentes ?? this.condicionesExistentes,
      nivelesElementos: nivelesElementos ?? this.nivelesElementos,
      alcanceExterior: alcanceExterior ?? this.alcanceExterior,
      alcanceInterior: alcanceInterior ?? this.alcanceInterior,
    );
  }
} 