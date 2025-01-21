class RiesgosExternosState {
  final Map<String, RiesgoItem> riesgos;
  final String? otroRiesgo;

  RiesgosExternosState({
    Map<String, RiesgoItem>? riesgos,
    this.otroRiesgo,
  }) : riesgos = riesgos ?? {
    '4.1': RiesgoItem(),
    '4.2': RiesgoItem(),
    '4.3': RiesgoItem(),
    '4.4': RiesgoItem(),
    '4.5': RiesgoItem(),
    '4.6': RiesgoItem(),
  };

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
      'comprometeAccesos': value.comprometeAccesos,
      'comprometeEstabilidad': value.comprometeEstabilidad,
    })),
    'otroRiesgo': otroRiesgo,
  };
}

class RiesgoItem {
  final bool existeRiesgo;            // Columna a)
  final bool comprometeAccesos;       // Columna b)
  final bool comprometeEstabilidad;   // Columna c)

  RiesgoItem({
    this.existeRiesgo = false,
    this.comprometeAccesos = false,
    this.comprometeEstabilidad = false,
  });

  RiesgoItem copyWith({
    bool? existeRiesgo,
    bool? comprometeAccesos,
    bool? comprometeEstabilidad,
  }) {
    return RiesgoItem(
      existeRiesgo: existeRiesgo ?? this.existeRiesgo,
      comprometeAccesos: comprometeAccesos ?? this.comprometeAccesos,
      comprometeEstabilidad: comprometeEstabilidad ?? this.comprometeEstabilidad,
    );
  }
} 