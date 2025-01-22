import 'package:equatable/equatable.dart';

/// Represents the state of external risks assessment
class RiesgosExternosState extends Equatable {
  final Map<String, RiesgoItem> riesgos;
  final String? otroRiesgo;

  const RiesgosExternosState({
    Map<String, RiesgoItem>? riesgos,
    this.otroRiesgo,
  }) : riesgos = riesgos ?? const {
    '4.1': RiesgoItem(),
    '4.2': RiesgoItem(),
    '4.3': RiesgoItem(),
    '4.4': RiesgoItem(),
    '4.5': RiesgoItem(),
    '4.6': RiesgoItem(),
  };

  factory RiesgosExternosState.fromJson(Map<String, dynamic> json) {
    return RiesgosExternosState(
      riesgos: (json['riesgos'] as Map<String, dynamic>?)?.map(
        (key, value) => MapEntry(key, RiesgoItem.fromJson(value as Map<String, dynamic>)),
      ) ?? {},
      otroRiesgo: json['otroRiesgo'] as String?,
    );
  }

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
    'riesgos': riesgos.map((key, value) => MapEntry(key, value.toJson())),
    'otroRiesgo': otroRiesgo,
  };

  @override
  List<Object?> get props => [riesgos, otroRiesgo];

  // Add initial state constant
  static final RiesgosExternosState initial = RiesgosExternosState();
}

/// Represents an individual risk item with its assessment details
class RiesgoItem extends Equatable {
  final bool existeRiesgo;
  final bool comprometeAccesos;
  final bool comprometeEstabilidad;

  const RiesgoItem({
    this.existeRiesgo = false,
    this.comprometeAccesos = false,
    this.comprometeEstabilidad = false,
  });

  factory RiesgoItem.fromJson(Map<String, dynamic> json) {
    return RiesgoItem(
      existeRiesgo: json['existeRiesgo'] as bool? ?? false,
      comprometeAccesos: json['comprometeAccesos'] as bool? ?? false,
      comprometeEstabilidad: json['comprometeEstabilidad'] as bool? ?? false,
    );
  }

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

  @override
  List<Object> get props => [
        existeRiesgo,
        comprometeAccesos,
        comprometeEstabilidad,
      ];

  Map<String, dynamic> toJson() => {
    'existeRiesgo': existeRiesgo,
    'comprometeAccesos': comprometeAccesos,
    'comprometeEstabilidad': comprometeEstabilidad,
  };
}