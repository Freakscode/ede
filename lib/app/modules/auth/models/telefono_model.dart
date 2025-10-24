import 'package:equatable/equatable.dart';

/// Modelo para un teléfono de una persona
class TelefonoModel extends Equatable {
  final String? numero;
  final String? telefono;
  final String? tipo;
  final bool? principal;

  const TelefonoModel({
    this.numero,
    this.telefono,
    this.tipo,
    this.principal,
  });

  /// Factory method: Crear desde JSON de la API
  factory TelefonoModel.fromJson(Map<String, dynamic> json) {
    return TelefonoModel(
      numero: json['numero'] as String?,
      telefono: json['telefono'] as String?,
      tipo: json['tipo'] as String?,
      principal: json['principal'] as bool?,
    );
  }

  /// Convertir a JSON
  Map<String, dynamic> toJson() {
    return {
      'numero': numero,
      'telefono': telefono,
      'tipo': tipo,
      'principal': principal,
    };
  }

  /// Obtener el número de teléfono (prioriza 'numero' sobre 'telefono')
  String? get numeroTelefono => numero ?? telefono;

  /// Verificar si tiene número válido
  bool get tieneNumero => numeroTelefono != null && numeroTelefono!.isNotEmpty;

  @override
  List<Object?> get props => [numero, telefono, tipo, principal];

  @override
  String toString() {
    return 'TelefonoModel(numero: $numero, telefono: $telefono, tipo: $tipo, principal: $principal)';
  }
}
