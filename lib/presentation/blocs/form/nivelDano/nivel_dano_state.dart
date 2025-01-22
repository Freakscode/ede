import 'package:equatable/equatable.dart';

class NivelDanoState extends Equatable {
  final String? porcentajeAfectacion;
  final String? severidadDanos;
  final String? nivelDano;
  final String? nivelDanoEstructural;
  final String? nivelDanoNoEstructural;
  final String? nivelDanoGeotecnico;
  final String? severidadGlobal;

  const NivelDanoState({
    this.porcentajeAfectacion,
    this.severidadDanos,
    this.nivelDano,
    this.nivelDanoEstructural,
    this.nivelDanoNoEstructural,
    this.nivelDanoGeotecnico,
    this.severidadGlobal,
  });

  // Add initial state constant
  static const NivelDanoState initial = NivelDanoState();

  factory NivelDanoState.fromJson(Map<String, dynamic> json) {
    return NivelDanoState(
      porcentajeAfectacion: json['porcentajeAfectacion'] as String?,
      severidadDanos: json['severidadDanos'] as String?,
      nivelDano: json['nivelDano'] as String?,
      nivelDanoEstructural: json['nivelDanoEstructural'] as String?,
      nivelDanoNoEstructural: json['nivelDanoNoEstructural'] as String?,
      nivelDanoGeotecnico: json['nivelDanoGeotecnico'] as String?,
      severidadGlobal: json['severidadGlobal'] as String?,
    );
  }

  @override
  List<Object?> get props => [
    porcentajeAfectacion,
    severidadDanos,
    nivelDano,
    nivelDanoEstructural,
    nivelDanoNoEstructural,
    nivelDanoGeotecnico,
    severidadGlobal,
  ];

  NivelDanoState copyWith({
    String? porcentajeAfectacion,
    String? severidadDanos,
    String? nivelDano,
    String? nivelDanoEstructural,
    String? nivelDanoNoEstructural,
    String? nivelDanoGeotecnico,
    String? severidadGlobal,
  }) {
    return NivelDanoState(
      porcentajeAfectacion: porcentajeAfectacion ?? this.porcentajeAfectacion,
      severidadDanos: severidadDanos ?? this.severidadDanos,
      nivelDano: nivelDano ?? this.nivelDano,
      nivelDanoEstructural: nivelDanoEstructural ?? this.nivelDanoEstructural,
      nivelDanoNoEstructural: nivelDanoNoEstructural ?? this.nivelDanoNoEstructural,
      nivelDanoGeotecnico: nivelDanoGeotecnico ?? this.nivelDanoGeotecnico,
      severidadGlobal: severidadGlobal ?? this.severidadGlobal,
    );
  }

  Map<String, dynamic> toJson() => {
    'porcentajeAfectacion': porcentajeAfectacion,
    'severidadDanos': severidadDanos,
    'nivelDano': nivelDano,
    'nivelDanoEstructural': nivelDanoEstructural,
    'nivelDanoNoEstructural': nivelDanoNoEstructural,
    'nivelDanoGeotecnico': nivelDanoGeotecnico,
    'severidadGlobal': severidadGlobal,
  };
}