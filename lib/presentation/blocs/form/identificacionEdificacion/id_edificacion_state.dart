class EdificacionState {
  final String? nombreEdificacion;
  final String? direccion;
  final String? comuna;
  final String? barrio;
  final String? codigoBarrio;
  
  // Identificación Catastral
  final String? cbml;
  final String? matriculaInmobiliaria;
  final String? numeroPisos;
  final String? subterraneos;
  final int? yearConstruccion;
  
  // Persona de Contacto
  final String? nombreContacto;
  final String? telefonoContacto;
  final String? emailContacto;
  final String? ocupacion; // Propietario, Administrador, etc.

  final double? latitud;
  final double? longitud;

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

  EdificacionState({
    this.nombreEdificacion,
    this.direccion,
    this.comuna,
    this.barrio,
    this.codigoBarrio,
    this.cbml,
    this.matriculaInmobiliaria,
    this.numeroPisos,
    this.subterraneos,
    this.yearConstruccion,
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
  });

  EdificacionState copyWith({
    String? nombreEdificacion,
    String? direccion,
    String? comuna,
    String? barrio,
    String? codigoBarrio,
    String? cbml,
    String? matriculaInmobiliaria,
    String? numeroPisos,
    String? subterraneos,
    int? yearConstruccion,
    String? nombreContacto,
    String? telefonoContacto,
    String? emailContacto,
    String? ocupacion,
    double? latitud,
    double? longitud,
    String? tipoVia,
    String? numeroVia,
    String? apendiceVia,
    String? orientacionVia,
    String? numeroCruce,
    String? apendiceCruce,
    String? orientacionCruce,
    String? numero,
    String? complemento,
  }) {
    return EdificacionState(
      nombreEdificacion: nombreEdificacion ?? this.nombreEdificacion,
      direccion: direccion ?? this.direccion,
      comuna: comuna ?? this.comuna,
      barrio: barrio ?? this.barrio,
      codigoBarrio: codigoBarrio ?? this.codigoBarrio,
      cbml: cbml ?? this.cbml,
      matriculaInmobiliaria: matriculaInmobiliaria ?? this.matriculaInmobiliaria,
      numeroPisos: numeroPisos ?? this.numeroPisos,
      subterraneos: subterraneos ?? this.subterraneos,
      yearConstruccion: yearConstruccion ?? this.yearConstruccion,
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
    'latitud': latitud,
    'longitud': longitud,
  };
} 