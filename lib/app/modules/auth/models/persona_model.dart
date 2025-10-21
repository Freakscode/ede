import 'package:equatable/equatable.dart';
import 'nombres_model.dart';
import 'apellidos_model.dart';
import 'telefono_model.dart';

/// Modelo para la información personal de un usuario
class PersonaModel extends Equatable {
  final int id;
  final String identificacion;
  final String? tipoDocumento;
  final String? nombreCompleto;
  final String? nombreCorto;
  final NombresModel? nombres;
  final ApellidosModel? apellidos;
  final String? genero;
  final String? profesion;
  final DateTime? fechaNacimiento;
  final int? edad;
  final List<TelefonoModel> telefonos;

  const PersonaModel({
    required this.id,
    required this.identificacion,
    this.tipoDocumento,
    this.nombreCompleto,
    this.nombreCorto,
    this.nombres,
    this.apellidos,
    this.genero,
    this.profesion,
    this.fechaNacimiento,
    this.edad,
    this.telefonos = const [],
  });

  /// Factory method: Crear desde JSON de la API
  factory PersonaModel.fromJson(Map<String, dynamic> json) {
    return PersonaModel(
      id: json['id'] as int,
      identificacion: json['identificacion'] as String,
      tipoDocumento: json['tipo_documento'] as String?,
      nombreCompleto: json['nombre_completo'] as String?,
      nombreCorto: json['nombre_corto'] as String?,
      nombres: json['nombres'] != null 
          ? NombresModel.fromJson(json['nombres'] as Map<String, dynamic>)
          : null,
      apellidos: json['apellidos'] != null 
          ? ApellidosModel.fromJson(json['apellidos'] as Map<String, dynamic>)
          : null,
      genero: json['genero'] as String?,
      profesion: json['profesion'] as String?,
      fechaNacimiento: json['fecha_nacimiento'] != null 
          ? DateTime.parse(json['fecha_nacimiento'] as String)
          : null,
      edad: json['edad'] as int?,
      telefonos: (json['telefonos'] as List<dynamic>?)
          ?.map((tel) => TelefonoModel.fromJson(tel as Map<String, dynamic>))
          .toList() ?? [],
    );
  }

  /// Convertir a JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'identificacion': identificacion,
      'tipo_documento': tipoDocumento,
      'nombre_completo': nombreCompleto,
      'nombre_corto': nombreCorto,
      'nombres': nombres?.toJson(),
      'apellidos': apellidos?.toJson(),
      'genero': genero,
      'profesion': profesion,
      'fecha_nacimiento': fechaNacimiento?.toIso8601String(),
      'edad': edad,
      'telefonos': telefonos.map((tel) => tel.toJson()).toList(),
    };
  }

  /// Obtener nombre completo (prioriza nombreCompleto, luego construye desde nombres y apellidos)
  String get nombreCompletoDisplay {
    if (nombreCompleto != null && nombreCompleto!.isNotEmpty) {
      return nombreCompleto!;
    }
    
    final nombresStr = nombres?.nombreCompleto ?? '';
    final apellidosStr = apellidos?.apellidosCompletos ?? '';
    
    return [nombresStr, apellidosStr].where((s) => s.isNotEmpty).join(' ');
  }

  /// Obtener primer teléfono disponible
  TelefonoModel? get primerTelefono {
    return telefonos.isNotEmpty ? telefonos.first : null;
  }

  /// Obtener número de teléfono principal
  String? get numeroTelefonoPrincipal {
    final telefonoPrincipal = telefonos.where((t) => t.principal == true).firstOrNull;
    if (telefonoPrincipal != null) {
      return telefonoPrincipal.numeroTelefono;
    }
    
    final primerTel = primerTelefono;
    return primerTel?.numeroTelefono;
  }

  @override
  List<Object?> get props => [
        id,
        identificacion,
        tipoDocumento,
        nombreCompleto,
        nombreCorto,
        nombres,
        apellidos,
        genero,
        profesion,
        fechaNacimiento,
        edad,
        telefonos,
      ];

  @override
  String toString() {
    return 'PersonaModel(id: $id, identificacion: $identificacion, nombreCompleto: $nombreCompletoDisplay)';
  }
}
