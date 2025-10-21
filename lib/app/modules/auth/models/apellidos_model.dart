import 'package:equatable/equatable.dart';

/// Modelo para los apellidos de una persona
class ApellidosModel extends Equatable {
  final String? apellido1;
  final String? apellido2;

  const ApellidosModel({
    this.apellido1,
    this.apellido2,
  });

  /// Factory method: Crear desde JSON de la API
  factory ApellidosModel.fromJson(Map<String, dynamic> json) {
    return ApellidosModel(
      apellido1: json['apellido1'] as String?,
      apellido2: json['apellido2'] as String?,
    );
  }

  /// Convertir a JSON
  Map<String, dynamic> toJson() {
    return {
      'apellido1': apellido1,
      'apellido2': apellido2,
    };
  }

  /// Obtener apellidos completos
  String get apellidosCompletos {
    final apellidos = [apellido1, apellido2].where((a) => a != null && a.isNotEmpty).join(' ');
    return apellidos;
  }

  /// Obtener primer apellido
  String get primerApellido => apellido1 ?? '';

  @override
  List<Object?> get props => [apellido1, apellido2];

  @override
  String toString() {
    return 'ApellidosModel(apellido1: $apellido1, apellido2: $apellido2)';
  }
}
