import 'package:equatable/equatable.dart';

class EvaluacionDanosState extends Equatable {
  // Primera subsección (5.1-5.6)
  final Map<String, bool> condicionesExistentes;
  
  // Segunda subsección (5.7-5.11)
  final Map<String, String> nivelesElementos;
  
  // Alcance de la evaluación
  final String? alcanceExterior;
  final String? alcanceInterior;

  // Campos de daños y condiciones
  final Map<String, dynamic> danosEstructurales;
  final Map<String, dynamic> danosNoEstructurales;
  final Map<String, dynamic> danosGeotecnicos;
  final Map<String, dynamic> condicionesPreexistentes;
  final String? alcanceEvaluacion;

  const EvaluacionDanosState({
    Map<String, dynamic>? danosEstructurales,
    Map<String, dynamic>? danosNoEstructurales,
    Map<String, dynamic>? danosGeotecnicos,
    Map<String, dynamic>? condicionesPreexistentes,
    this.alcanceEvaluacion,
    Map<String, bool>? condicionesExistentes,
    Map<String, String>? nivelesElementos,
    this.alcanceExterior,
    this.alcanceInterior,
  }) : danosEstructurales = danosEstructurales ?? const {},
       danosNoEstructurales = danosNoEstructurales ?? const {},
       danosGeotecnicos = danosGeotecnicos ?? const {},
       condicionesPreexistentes = condicionesPreexistentes ?? const {},
       condicionesExistentes = condicionesExistentes ?? const {
         '5.1': false,
         '5.2': false,
         '5.3': false,
         '5.4': false,
         '5.5': false,
         '5.6': false,
       },
       nivelesElementos = nivelesElementos ?? const {
         '5.7': 'Sin daño',
         '5.8': 'Sin daño',
         '5.9': 'Sin daño',
         '5.10': 'Sin daño',
         '5.11': 'Sin daño',
       };

  @override
  List<Object?> get props => [
    condicionesExistentes,
    nivelesElementos,
    alcanceExterior,
    alcanceInterior,
    danosEstructurales,
    danosNoEstructurales,
    danosGeotecnicos,
    condicionesPreexistentes,
    alcanceEvaluacion,
  ];

  EvaluacionDanosState copyWith({
    Map<String, dynamic>? danosEstructurales,
    Map<String, dynamic>? danosNoEstructurales,
    Map<String, dynamic>? danosGeotecnicos,
    Map<String, dynamic>? condicionesPreexistentes,
    String? alcanceEvaluacion,
    Map<String, bool>? condicionesExistentes,
    Map<String, String>? nivelesElementos,
    String? alcanceExterior,
    String? alcanceInterior,
  }) {
    return EvaluacionDanosState(
      danosEstructurales: danosEstructurales ?? this.danosEstructurales,
      danosNoEstructurales: danosNoEstructurales ?? this.danosNoEstructurales,
      danosGeotecnicos: danosGeotecnicos ?? this.danosGeotecnicos,
      condicionesPreexistentes: condicionesPreexistentes ?? this.condicionesPreexistentes,
      alcanceEvaluacion: alcanceEvaluacion ?? this.alcanceEvaluacion,
      condicionesExistentes: Map<String, bool>.from(condicionesExistentes ?? this.condicionesExistentes),
      nivelesElementos: Map<String, String>.from(nivelesElementos ?? this.nivelesElementos),
      alcanceExterior: alcanceExterior ?? this.alcanceExterior,
      alcanceInterior: alcanceInterior ?? this.alcanceInterior,
    );
  }

  Map<String, dynamic> toJson() => {
    'danosEstructurales': danosEstructurales,
    'danosNoEstructurales': danosNoEstructurales,
    'danosGeotecnicos': danosGeotecnicos,
    'condicionesPreexistentes': condicionesPreexistentes,
    'alcanceEvaluacion': alcanceEvaluacion,
    'condicionesExistentes': condicionesExistentes,
    'nivelesElementos': nivelesElementos,
    'alcanceExterior': alcanceExterior,
    'alcanceInterior': alcanceInterior,
  };

  static const EvaluacionDanosState initial = EvaluacionDanosState();
} 