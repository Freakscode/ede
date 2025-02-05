import 'package:flutter/material.dart';

abstract class EdificacionEvent {}

// Eventos para Datos Generales
class SetNombreEdificacion extends EdificacionEvent {
  final String nombre;
  SetNombreEdificacion(this.nombre);
}

class SetDireccion extends EdificacionEvent {
  final String direccion;
  SetDireccion(this.direccion);
}

class SetComuna extends EdificacionEvent {
  final String comuna;
  SetComuna(this.comuna);
}

class SetBarrio extends EdificacionEvent {
  final String barrio;
  SetBarrio(this.barrio);
}

class SetCodigoBarrio extends EdificacionEvent {
  final String codigo;
  SetCodigoBarrio(this.codigo);
}

// Eventos para Identificación Catastral
class SetCBML extends EdificacionEvent {
  final String cbml;
  SetCBML(this.cbml);
}

// Eventos para Persona de Contacto
class SetNombreContacto extends EdificacionEvent {
  final String nombre;
  SetNombreContacto(this.nombre);
}

class SetTelefonoContacto extends EdificacionEvent {
  final String telefono;
  SetTelefonoContacto(this.telefono);
}

class SetEmailContacto extends EdificacionEvent {
  final String email;
  final BuildContext context;
  SetEmailContacto(this.email, this.context);
}

class SetOcupacion extends EdificacionEvent {
  final String ocupacion;
  SetOcupacion(this.ocupacion);
}

class LoadTemporaryData extends EdificacionEvent {
  LoadTemporaryData();
}

class SetCoordenadas extends EdificacionEvent {
  final double latitud;
  final double longitud;
  final BuildContext context;
  
  SetCoordenadas({
    required this.latitud, 
    required this.longitud,
    required this.context
  });
}

class SetNumeroVia extends EdificacionEvent {
  final String numeroVia;
  SetNumeroVia(this.numeroVia);
}

class SetApendiceVia extends EdificacionEvent {
  final String apendiceVia;
  SetApendiceVia(this.apendiceVia);
}

class SetOrientacionVia extends EdificacionEvent {
  final String orientacionVia;
  final BuildContext context;
  
  SetOrientacionVia(this.orientacionVia, this.context);
}

class SetTipoVia extends EdificacionEvent {
  final String tipoVia;
  
  SetTipoVia(this.tipoVia);
}

class SetNumeroCruce extends EdificacionEvent {
  final String numeroCruce;
  SetNumeroCruce(this.numeroCruce);
}

class SetApendiceCruce extends EdificacionEvent {
  final String apendiceCruce;
  SetApendiceCruce(this.apendiceCruce);
}

class SetOrientacionCruce extends EdificacionEvent {
  final String orientacionCruce;
  final BuildContext context;
  
  SetOrientacionCruce(this.orientacionCruce, this.context);
}

class SetNumero extends EdificacionEvent {
  final String numero;
  SetNumero(this.numero);
}

class SetComplemento extends EdificacionEvent {
  final String complemento;
  SetComplemento(this.complemento);
}

class SetDepartamento extends EdificacionEvent {
  final String departamento;
  SetDepartamento(this.departamento);
}

class SetMunicipio extends EdificacionEvent {
  final String municipio;
  final BuildContext context;
  SetMunicipio(this.municipio, this.context);
}

class SetLatitud extends EdificacionEvent {
  final String latitud;

  SetLatitud(this.latitud);

  @override
  List<Object> get props => [latitud];
}

class SetLongitud extends EdificacionEvent {
  final String longitud;

  SetLongitud(this.longitud);

  @override
  List<Object> get props => [longitud];
}

abstract class IdEdificacionEvent {}

class UpdateIdEdificacion extends IdEdificacionEvent {
  final String? calle;
  final String? numero;
  final String? colonia;
  final String? codigoPostal;
  final String? referencias;
  final String? comuna;
  final String? barrio;
  final String? codigoCatastral;
  final String? nombreContacto;
  final String? telefonoContacto;
  final String? emailContacto;

  UpdateIdEdificacion({
    this.calle,
    this.numero,
    this.colonia,
    this.codigoPostal,
    this.referencias,
    this.comuna,
    this.barrio,
    this.codigoCatastral,
    this.nombreContacto,
    this.telefonoContacto,
    this.emailContacto,
  });
} 