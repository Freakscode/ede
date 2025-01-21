class EvaluacionDanosState {
  // Primera subsección (5.1-5.6)
  final Map<String, bool> condicionesExistentes;
  
  // Segunda subsección (5.7-5.11)
  final Map<String, String> nivelesElementos;
  
  // Alcance de la evaluación
  final String? alcanceExterior;
  final String? alcanceInterior;

  EvaluacionDanosState({
    Map<String, bool>? condicionesExistentes,
    Map<String, String>? nivelesElementos,
    this.alcanceExterior,
    this.alcanceInterior,
  }) : condicionesExistentes = condicionesExistentes ?? {
         '5.1': false, // Colapso total
         '5.2': false, // Colapso parcial
         '5.3': false, // Asentamiento severo
         '5.4': false, // Inclinación o desviación
         '5.5': false, // Problemas de inestabilidad
         '5.6': false, // Riesgo de caídas
       },
       nivelesElementos = nivelesElementos ?? {
         '5.7': 'Sin daño',  // Elementos estructurales
         '5.8': 'Sin daño',  // Sistemas de contrapiso
         '5.9': 'Sin daño',  // Muros divisorios
         '5.10': 'Sin daño', // Cubierta
         '5.11': 'Sin daño', // Elementos no estructurales
       };

  EvaluacionDanosState copyWith({
    Map<String, bool>? condicionesExistentes,
    Map<String, String>? nivelesElementos,
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

  Map<String, dynamic> toJson() => {
    'condicionesExistentes': condicionesExistentes,
    'nivelesElementos': nivelesElementos,
    'alcanceExterior': alcanceExterior,
    'alcanceInterior': alcanceInterior,
  };
} 