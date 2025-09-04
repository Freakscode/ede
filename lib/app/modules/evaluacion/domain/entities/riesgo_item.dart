class RiesgoItem {
  final bool existeRiesgo;
  final bool comprometeAccesos;
  final bool implicaRiesgoVida;

  const RiesgoItem({
    required this.existeRiesgo,
    required this.comprometeAccesos,
    required this.implicaRiesgoVida,
  });

  RiesgoItem copyWith({
    bool? existeRiesgo,
    bool? comprometeAccesos,
    bool? implicaRiesgoVida,
  }) {
    return RiesgoItem(
      existeRiesgo: existeRiesgo ?? this.existeRiesgo,
      comprometeAccesos: comprometeAccesos ?? this.comprometeAccesos,
      implicaRiesgoVida: implicaRiesgoVida ?? this.implicaRiesgoVida,
    );
  }

  @override
  String toString() => 'RiesgoItem('
      'existeRiesgo: $existeRiesgo, '
      'comprometeAccesos: $comprometeAccesos, '
      'implicaRiesgoVida: $implicaRiesgoVida)';
} 