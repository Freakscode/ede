class AccionesState {
  final Map<String, String> evaluacionAdicional;
  final Map<String, bool> recomendaciones;
  final Map<String, bool> entidadesRecomendadas;
  final String? otraEntidad;
  final String? recomendacionesEspecificas;

  AccionesState({
    Map<String, String>? evaluacionAdicional,
    Map<String, bool>? recomendaciones,
    Map<String, bool>? entidadesRecomendadas,
    this.otraEntidad,
    this.recomendacionesEspecificas,
  }) : 
    evaluacionAdicional = evaluacionAdicional ?? {
      'Estructural': '',
      'Geotécnica': '',
      'Otra': '',
    },
    recomendaciones = recomendaciones ?? {
      'restringirPeatones': false,
      'restringirVehiculos': false,
      'evacuarParcialmente': false,
      'evacuarTotalmente': false,
      'evacuarVecinas': false,
      'vigilanciaPermanente': false,
      'monitoreoEstructural': false,
      'aislamiento': false,
      'apuntalar': false,
      'demoler': false,
      'manejoSustancias': false,
      'desconectarServicios': false,
      'seguimiento': false,
    },
    entidadesRecomendadas = entidadesRecomendadas ?? {
      'Planeación': false,
      'Bomberos': false,
      'Policía': false,
      'Ejército': false,
      'Tránsito': false,
      'Rescate': false,
      'Otra': false,
    };

  AccionesState copyWith({
    Map<String, String>? evaluacionAdicional,
    Map<String, bool>? recomendaciones,
    Map<String, bool>? entidadesRecomendadas,
    String? otraEntidad,
    String? recomendacionesEspecificas,
  }) {
    return AccionesState(
      evaluacionAdicional: evaluacionAdicional ?? this.evaluacionAdicional,
      recomendaciones: recomendaciones ?? this.recomendaciones,
      entidadesRecomendadas: entidadesRecomendadas ?? this.entidadesRecomendadas,
      otraEntidad: otraEntidad ?? this.otraEntidad,
      recomendacionesEspecificas: recomendacionesEspecificas ?? this.recomendacionesEspecificas,
    );
  }

  Map<String, dynamic> toJson() => {
    'evaluacionAdicional': evaluacionAdicional,
    'recomendaciones': recomendaciones,
    'entidadesRecomendadas': entidadesRecomendadas,
    'otraEntidad': otraEntidad,
    'recomendacionesEspecificas': recomendacionesEspecificas,
  };
} 