abstract class DescripcionEdificacionEvent {}

// Características Generales
class SetCaracteristicasGenerales extends DescripcionEdificacionEvent {
  final String valor;
  SetCaracteristicasGenerales(this.valor);
}

// Usos Predominantes
class SetUsosPredominantes extends DescripcionEdificacionEvent {
  final String valor;
  SetUsosPredominantes(this.valor);
}

// Sistema Estructural y Material
class SetSistemaEstructural extends DescripcionEdificacionEvent {
  final String valor;
  SetSistemaEstructural(this.valor);
}

// Sistemas de Entrepiso
class SetSistemaEntrepiso extends DescripcionEdificacionEvent {
  final String material;
  final List<String>? tipos;
  final String? otroTipo;
  SetSistemaEntrepiso(this.material, {this.tipos, this.otroTipo});
}

// Sistemas de Cubierta
class SetSistemasCubierta extends DescripcionEdificacionEvent {
  final String valor;
  SetSistemasCubierta(this.valor);
}

// Elementos No Estructurales
class SetElementosNoEstructurales extends DescripcionEdificacionEvent {
  final String valor;
  SetElementosNoEstructurales(this.valor);
}

// Datos Adicionales
class SetDatosAdicionales extends DescripcionEdificacionEvent {
  final String valor;
  SetDatosAdicionales(this.valor);
}

// Eventos para Características Generales
class SetPisosSobreTerreno extends DescripcionEdificacionEvent {
  final int pisos;
  SetPisosSobreTerreno(this.pisos);
}

class SetSotanos extends DescripcionEdificacionEvent {
  final int sotanos;
  SetSotanos(this.sotanos);
}

class SetDimensiones extends DescripcionEdificacionEvent {
  final double frente;
  final double fondo;
  SetDimensiones(this.frente, this.fondo);
}

class SetUnidadesResidenciales extends DescripcionEdificacionEvent {
  final int unidades;
  SetUnidadesResidenciales(this.unidades);
}

class SetUnidadesComerciales extends DescripcionEdificacionEvent {
  final int unidades;
  SetUnidadesComerciales(this.unidades);
}

class SetUnidadesNoHabitadas extends DescripcionEdificacionEvent {
  final int unidades;
  SetUnidadesNoHabitadas(this.unidades);
}

class SetNumeroOcupantes extends DescripcionEdificacionEvent {
  final int ocupantes;
  SetNumeroOcupantes(this.ocupantes);
}

class SetMuertosHeridos extends DescripcionEdificacionEvent {
  final int? muertos;
  final int? heridos;
  final bool noSeSabe;
  SetMuertosHeridos({this.muertos, this.heridos, required this.noSeSabe});
}

class SetAcceso extends DescripcionEdificacionEvent {
  final bool obstruido;
  final bool libre;
  SetAcceso({required this.obstruido, required this.libre});
}

// Eventos para Usos Predominantes
class SetUsoPredominante extends DescripcionEdificacionEvent {
  final String uso;
  final String? otroUso;
  SetUsoPredominante(this.uso, {this.otroUso});
}

class SetFechaConstruccion extends DescripcionEdificacionEvent {
  final String fecha;
  SetFechaConstruccion(this.fecha);
}

// Eventos para Sistema Estructural y Material
class SetSistemaEstructuralYMaterial extends DescripcionEdificacionEvent {
  final String sistema;
  final String? material;
  final String? cualOtroSistema;
  SetSistemaEstructuralYMaterial(this.sistema, {this.material, this.cualOtroSistema});
}

class SetObservaciones extends DescripcionEdificacionEvent {
  final String observaciones;
  SetObservaciones(this.observaciones);
}

class SetSistemaMultiple extends DescripcionEdificacionEvent {
  final bool existe;
  final String? cual;
  SetSistemaMultiple(this.existe, {this.cual});
}

class SetSistemaSoporte extends DescripcionEdificacionEvent {
  final List<String> sistemas;
  final String? otroSistema;
  SetSistemaSoporte(this.sistemas, {this.otroSistema});
}

class SetRevestimiento extends DescripcionEdificacionEvent {
  final List<String> revestimientos;
  final String? otroRevestimiento;
  SetRevestimiento(this.revestimientos, {this.otroRevestimiento});
}

class SetMurosDivisorios extends DescripcionEdificacionEvent {
  final List<String> muros;
  final String? otroMuro;
  SetMurosDivisorios(this.muros, {this.otroMuro});
}

class SetFachadas extends DescripcionEdificacionEvent {
  final List<String> fachadas;
  final String? otraFachada;
  SetFachadas(this.fachadas, {this.otraFachada});
}

class SetEscaleras extends DescripcionEdificacionEvent {
  final List<String> escaleras;
  final String? otraEscalera;
  SetEscaleras(this.escaleras, {this.otraEscalera});
}

class SetNivelDiseno extends DescripcionEdificacionEvent {
  final String nivel;
  SetNivelDiseno(this.nivel);
}

class SetCalidadDiseno extends DescripcionEdificacionEvent {
  final String calidad;
  SetCalidadDiseno(this.calidad);
}

class SetEstadoEdificacion extends DescripcionEdificacionEvent {
  final String estado;
  SetEstadoEdificacion(this.estado);
} 