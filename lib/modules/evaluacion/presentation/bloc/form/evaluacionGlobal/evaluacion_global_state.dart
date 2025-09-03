import 'package:equatable/equatable.dart';

class EvaluacionGlobalState extends Equatable {
  // Identificación de la Edificación
  final String? nombreEdificacion;
  final String? direccion;
  final String? comuna;
  final String? barrio;
  final String? cbml;
  final String? nombreContacto;
  final String? telefonoContacto;
  final String? emailContacto;
  final String? ocupacion;
  final String? latitud;
  final String? longitud;

  const EvaluacionGlobalState({
    this.nombreEdificacion,
    this.direccion,
    this.comuna,
    this.barrio,
    this.cbml,
    this.nombreContacto,
    this.telefonoContacto,
    this.emailContacto,
    this.ocupacion,
    this.latitud,
    this.longitud,
  });

  EvaluacionGlobalState copyWith({
    String? nombreEdificacion,
    String? direccion,
    String? comuna,
    String? barrio,
    String? cbml,
    String? nombreContacto,
    String? telefonoContacto,
    String? emailContacto,
    String? ocupacion,
    String? latitud,
    String? longitud,
  }) {
    return EvaluacionGlobalState(
      nombreEdificacion: nombreEdificacion ?? this.nombreEdificacion,
      direccion: direccion ?? this.direccion,
      comuna: comuna ?? this.comuna,
      barrio: barrio ?? this.barrio,
      cbml: cbml ?? this.cbml,
      nombreContacto: nombreContacto ?? this.nombreContacto,
      telefonoContacto: telefonoContacto ?? this.telefonoContacto,
      emailContacto: emailContacto ?? this.emailContacto,
      ocupacion: ocupacion ?? this.ocupacion,
      latitud: latitud ?? this.latitud,
      longitud: longitud ?? this.longitud,
    );
  }

  Map<String, dynamic> toJson() => {
    'nombreEdificacion': nombreEdificacion,
    'direccion': direccion,
    'comuna': comuna,
    'barrio': barrio,
    'cbml': cbml,
    'nombreContacto': nombreContacto,
    'telefonoContacto': telefonoContacto,
    'emailContacto': emailContacto,
    'ocupacion': ocupacion,
    'latitud': latitud,
    'longitud': longitud,
  };

  @override
  List<Object?> get props => [
    nombreEdificacion,
    direccion,
    comuna,
    barrio,
    cbml,
    nombreContacto,
    telefonoContacto,
    emailContacto,
    ocupacion,
    latitud,
    longitud,
  ];
} 