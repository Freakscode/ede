import 'package:equatable/equatable.dart';

class NivelDanoState extends Equatable {
  final String? porcentajeAfectacion;
  final String? severidadDanos;
  final String? nivelDano;

  const NivelDanoState({
    this.porcentajeAfectacion,
    this.severidadDanos,
    this.nivelDano,
  });

  NivelDanoState copyWith({
    String? severidadDanos,
    String? nivelDano,
    String? porcentajeAfectacion,
  }) {
    return NivelDanoState(
      severidadDanos: severidadDanos ?? this.severidadDanos,
      nivelDano: nivelDano ?? this.nivelDano,
      porcentajeAfectacion: porcentajeAfectacion ?? this.porcentajeAfectacion,
    );
  }

  @override
  List<Object?> get props => [severidadDanos, nivelDano, porcentajeAfectacion];

  Map<String, dynamic> toJson() => {
    'porcentajeAfectacion': porcentajeAfectacion,
    'severidadDanos': severidadDanos,
    'nivelDano': nivelDano,
  };
} 