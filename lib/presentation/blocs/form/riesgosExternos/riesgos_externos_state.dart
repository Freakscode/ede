class RiesgosExternosState {
  final Map<String, RiesgoItem> riesgos;
  final String? otroRiesgo;

  RiesgosExternosState({
    this.riesgos = const {},
    this.otroRiesgo,
  });

  RiesgosExternosState copyWith({
    Map<String, RiesgoItem>? riesgos,
    String? otroRiesgo,
  }) {
    return RiesgosExternosState(
      riesgos: riesgos ?? this.riesgos,
      otroRiesgo: otroRiesgo ?? this.otroRiesgo,
    );
  }

  Map<String, dynamic> toJson() => {
    'riesgos': riesgos.map((key, value) => MapEntry(key, {
      'existeRiesgo': value.existeRiesgo,
      'comprometeEstabilidad': value.comprometeEstabilidad,
      'comprometeFuncionalidad': value.comprometeFuncionalidad,
    })),
  };
}

class RiesgoItem {
  final bool existeRiesgo;
  final bool comprometeEstabilidad;
  final bool comprometeFuncionalidad;

  RiesgoItem({
    this.existeRiesgo = false,
    this.comprometeEstabilidad = false,
    this.comprometeFuncionalidad = false,
  });

  RiesgoItem copyWith({
    bool? existeRiesgo,
    bool? comprometeEstabilidad,
    bool? comprometeFuncionalidad,
  }) {
    return RiesgoItem(
      existeRiesgo: existeRiesgo ?? this.existeRiesgo,
      comprometeEstabilidad: comprometeEstabilidad ?? this.comprometeEstabilidad,
      comprometeFuncionalidad: comprometeFuncionalidad ?? this.comprometeFuncionalidad,
    );
  }
} 