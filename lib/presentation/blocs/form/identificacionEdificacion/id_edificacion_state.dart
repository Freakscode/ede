import 'package:equatable/equatable.dart';

class EdificacionState extends Equatable {
  final String? nombreEdificacion;
  final String? direccion;
  final String? comuna;
  final String? barrio;
  final String? codigoBarrio;
  
  // Identificación Catastral
  final String? cbml;
  
  // Persona de Contacto
  final String? nombreContacto;
  final String? telefonoContacto;
  final String? emailContacto;
  final String? ocupacion; // Propietario, Administrador, etc.

  final String? latitud;
  final String? longitud;

  // Agregar estos campos al EdificacionState
  final String? tipoVia;
  final String? numeroVia;
  final String? apendiceVia;
  final String? orientacionVia;
  final String? numeroCruce;
  final String? apendiceCruce;
  final String? orientacionCruce;
  final String? numero;
  final String? complemento;

  final String? departamento;
  final String? municipio;

  const EdificacionState({
    this.nombreEdificacion,
    this.direccion,
    this.comuna,
    this.barrio,
    this.codigoBarrio,
    this.cbml,
    this.nombreContacto,
    this.telefonoContacto,
    this.emailContacto,
    this.ocupacion,
    this.latitud,
    this.longitud,
    this.tipoVia,
    this.numeroVia,
    this.apendiceVia,
    this.orientacionVia,
    this.numeroCruce,
    this.apendiceCruce,
    this.orientacionCruce,
    this.numero,
    this.complemento,
    this.departamento,
    this.municipio,
  });

  EdificacionState copyWith({
    String? nombreEdificacion,
    String? direccion,
    String? comuna,
    String? barrio,
    String? codigoBarrio,
    String? cbml,
    String? nombreContacto,
    String? telefonoContacto,
    String? emailContacto,
    String? ocupacion,
    String? latitud,
    String? longitud,
    String? tipoVia,
    String? numeroVia,
    String? apendiceVia,
    String? orientacionVia,
    String? numeroCruce,
    String? apendiceCruce,
    String? orientacionCruce,
    String? numero,
    String? complemento,
    String? departamento,
    String? municipio,
  }) {
    return EdificacionState(
      nombreEdificacion: nombreEdificacion ?? this.nombreEdificacion,
      direccion: direccion ?? this.direccion,
      comuna: comuna ?? this.comuna,
      barrio: barrio ?? this.barrio,
      codigoBarrio: codigoBarrio ?? this.codigoBarrio,
      cbml: cbml ?? this.cbml,
      nombreContacto: nombreContacto ?? this.nombreContacto,
      telefonoContacto: telefonoContacto ?? this.telefonoContacto,
      emailContacto: emailContacto ?? this.emailContacto,
      ocupacion: ocupacion ?? this.ocupacion,
      latitud: latitud ?? this.latitud,
      longitud: longitud ?? this.longitud,
      tipoVia: tipoVia ?? this.tipoVia,
      numeroVia: numeroVia ?? this.numeroVia,
      apendiceVia: apendiceVia ?? this.apendiceVia,
      orientacionVia: orientacionVia ?? this.orientacionVia,
      numeroCruce: numeroCruce ?? this.numeroCruce,
      apendiceCruce: apendiceCruce ?? this.apendiceCruce,
      orientacionCruce: orientacionCruce ?? this.orientacionCruce,
      numero: numero ?? this.numero,
      complemento: complemento ?? this.complemento,
      departamento: departamento ?? this.departamento,
      municipio: municipio ?? this.municipio,
    );
  }

  Map<String, dynamic> toJson() => {
        'nombreEdificacion': nombreEdificacion,
        'direccion': direccion,
        'comuna': comuna,
        'barrio': barrio,
        'codigoBarrio': codigoBarrio,
        'cbml': cbml,
        'nombreContacto': nombreContacto,
        'telefonoContacto': telefonoContacto,
        'emailContacto': emailContacto,
        'ocupacion': ocupacion,
        'latitud': latitud,
        'longitud': longitud,
        'tipoVia': tipoVia,
        'numeroVia': numeroVia,
        'apendiceVia': apendiceVia,
        'orientacionVia': orientacionVia,
        'numeroCruce': numeroCruce,
        'apendiceCruce': apendiceCruce,
        'orientacionCruce': orientacionCruce,
        'numero': numero,
        'complemento': complemento,
        'departamento': departamento,
        'municipio': municipio,
      };

  @override
  List<Object?> get props => [
        nombreEdificacion,
        direccion,
        comuna,
        barrio,
        codigoBarrio,
        cbml,
        nombreContacto,
        telefonoContacto,
        emailContacto,
        ocupacion,
        latitud,
        longitud,
        tipoVia,
        numeroVia,
        apendiceVia,
        orientacionVia,
        numeroCruce,
        apendiceCruce,
        orientacionCruce,
        numero,
        complemento,
        departamento,
        municipio,
      ];
}