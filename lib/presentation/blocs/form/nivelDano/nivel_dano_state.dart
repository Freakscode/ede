class NivelDanoState {
  final String? porcentajeAfectacion;
  final String? severidadDanos;
  final String? nivelDano;

  NivelDanoState({
    this.porcentajeAfectacion,
    this.severidadDanos,
    this.nivelDano,
  });

  NivelDanoState copyWith({
    String? porcentajeAfectacion,
    String? severidadDanos,
    String? nivelDano,
  }) {
    return NivelDanoState(
      porcentajeAfectacion: porcentajeAfectacion ?? this.porcentajeAfectacion,
      severidadDanos: severidadDanos ?? this.severidadDanos,
      nivelDano: nivelDano ?? this.nivelDano,
    );
  }
} 