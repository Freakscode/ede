import 'package:equatable/equatable.dart';

/// Modelo para los nombres de una persona
class NombresModel extends Equatable {
  final String? nombre1;
  final String? nombre2;

  const NombresModel({
    this.nombre1,
    this.nombre2,
  });

  /// Factory method: Crear desde JSON de la API
  factory NombresModel.fromJson(Map<String, dynamic> json) {
    return NombresModel(
      nombre1: json['nombre1'] as String?,
      nombre2: json['nombre2'] as String?,
    );
  }

  /// Convertir a JSON
  Map<String, dynamic> toJson() {
    return {
      'nombre1': nombre1,
      'nombre2': nombre2,
    };
  }

  /// Obtener nombre completo
  String get nombreCompleto {
    final nombres = [nombre1, nombre2].where((n) => n != null && n.isNotEmpty).join(' ');
    return nombres;
  }

  /// Obtener primer nombre
  String get primerNombre => nombre1 ?? '';

  @override
  List<Object?> get props => [nombre1, nombre2];

  @override
  String toString() {
    return 'NombresModel(nombre1: $nombre1, nombre2: $nombre2)';
  }
}
