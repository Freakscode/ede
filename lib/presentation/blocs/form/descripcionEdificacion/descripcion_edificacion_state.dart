import 'package:equatable/equatable.dart';

class DescripcionEdificacionState extends Equatable {
  final int? pisosSobreTerreno;
  final int? sotanos;
  final double? frenteDimension;
  final double? fondoDimension;
  final int? unidadesResidenciales;
  final int? unidadesComerciales;
  final int? unidadesNoHabitadas;
  final int? numeroOcupantes;
  final int? muertos;
  final int? heridos;
  final bool? noSeSabe;
  final bool? accesoObstruido;
  final bool? accesoLibre;
  final String? usoPredominante;
  final String? otroUso;
  final String? fechaConstruccion;
  final String? sistemaEstructural;
  final String? material;
  final String? cualOtroSistema;
  final String? materialEntrepiso;
  final List<String>? sistemasEntrepiso;
  final Map<String, List<String>>? tiposEntrepisoPorMaterial;
  final String? otroEntrepiso;
  final List<String>? sistemaSoporte;
  final String? otroSistemaSoporte;
  final List<String>? revestimiento;
  final String? otroRevestimiento;
  final List<String>? murosDivisorios;
  final String? otroMuroDivisorio;
  final List<String>? fachadas;
  final String? otraFachada;
  final List<String>? escaleras;
  final String? otraEscalera;
  final String? nivelDiseno;
  final String? calidadDiseno;
  final String? estadoEdificacion;
  final String? sistemaMultiple;
  final String? observacionesSistema;
  final List<String>? sistemasEstructurales;
  final Map<String, List<String>>? materialesPorSistema;

  const DescripcionEdificacionState({
    this.pisosSobreTerreno,
    this.sotanos,
    this.frenteDimension,
    this.fondoDimension,
    this.unidadesResidenciales,
    this.unidadesComerciales,
    this.unidadesNoHabitadas,
    this.numeroOcupantes,
    this.muertos,
    this.heridos,
    this.noSeSabe,
    this.accesoObstruido,
    this.accesoLibre,
    this.usoPredominante,
    this.otroUso,
    this.fechaConstruccion,
    this.sistemaEstructural,
    this.material,
    this.cualOtroSistema,
    this.materialEntrepiso,
    this.sistemasEntrepiso,
    this.tiposEntrepisoPorMaterial,
    this.otroEntrepiso,
    this.sistemaSoporte,
    this.otroSistemaSoporte,
    this.revestimiento,
    this.otroRevestimiento,
    this.murosDivisorios,
    this.otroMuroDivisorio,
    this.fachadas,
    this.otraFachada,
    this.escaleras,
    this.otraEscalera,
    this.nivelDiseno,
    this.calidadDiseno,
    this.estadoEdificacion,
    this.sistemaMultiple,
    this.observacionesSistema,
    this.sistemasEstructurales,
    this.materialesPorSistema,
  });

  DescripcionEdificacionState copyWith({
    int? pisosSobreTerreno,
    int? sotanos,
    double? frenteDimension,
    double? fondoDimension,
    int? unidadesResidenciales,
    int? unidadesComerciales,
    int? unidadesNoHabitadas,
    int? numeroOcupantes,
    int? muertos,
    int? heridos,
    bool? noSeSabe,
    bool? accesoObstruido,
    bool? accesoLibre,
    String? usoPredominante,
    String? otroUso,
    String? fechaConstruccion,
    String? sistemaEstructural,
    String? material,
    String? cualOtroSistema,
    String? materialEntrepiso,
    List<String>? sistemasEntrepiso,
    Map<String, List<String>>? tiposEntrepisoPorMaterial,
    String? otroEntrepiso,
    List<String>? sistemaSoporte,
    String? otroSistemaSoporte,
    List<String>? revestimiento,
    String? otroRevestimiento,
    List<String>? murosDivisorios,
    String? otroMuroDivisorio,
    List<String>? fachadas,
    String? otraFachada,
    List<String>? escaleras,
    String? otraEscalera,
    String? nivelDiseno,
    String? calidadDiseno,
    String? estadoEdificacion,
    String? sistemaMultiple,
    String? observacionesSistema,
    List<String>? sistemasEstructurales,
    Map<String, List<String>>? materialesPorSistema,
  }) {
    return DescripcionEdificacionState(
      pisosSobreTerreno: pisosSobreTerreno ?? this.pisosSobreTerreno,
      sotanos: sotanos ?? this.sotanos,
      frenteDimension: frenteDimension ?? this.frenteDimension,
      fondoDimension: fondoDimension ?? this.fondoDimension,
      unidadesResidenciales: unidadesResidenciales ?? this.unidadesResidenciales,
      unidadesComerciales: unidadesComerciales ?? this.unidadesComerciales,
      unidadesNoHabitadas: unidadesNoHabitadas ?? this.unidadesNoHabitadas,
      numeroOcupantes: numeroOcupantes ?? this.numeroOcupantes,
      muertos: muertos ?? this.muertos,
      heridos: heridos ?? this.heridos,
      noSeSabe: noSeSabe ?? this.noSeSabe,
      accesoObstruido: accesoObstruido ?? this.accesoObstruido,
      accesoLibre: accesoLibre ?? this.accesoLibre,
      usoPredominante: usoPredominante ?? this.usoPredominante,
      otroUso: otroUso ?? this.otroUso,
      fechaConstruccion: fechaConstruccion ?? this.fechaConstruccion,
      sistemaEstructural: sistemaEstructural ?? this.sistemaEstructural,
      material: material ?? this.material,
      cualOtroSistema: cualOtroSistema ?? this.cualOtroSistema,
      materialEntrepiso: materialEntrepiso ?? this.materialEntrepiso,
      sistemasEntrepiso: sistemasEntrepiso ?? this.sistemasEntrepiso,
      tiposEntrepisoPorMaterial: tiposEntrepisoPorMaterial ?? this.tiposEntrepisoPorMaterial,
      otroEntrepiso: otroEntrepiso ?? this.otroEntrepiso,
      sistemaSoporte: sistemaSoporte ?? this.sistemaSoporte,
      otroSistemaSoporte: otroSistemaSoporte ?? this.otroSistemaSoporte,
      revestimiento: revestimiento ?? this.revestimiento,
      otroRevestimiento: otroRevestimiento ?? this.otroRevestimiento,
      murosDivisorios: murosDivisorios ?? this.murosDivisorios,
      otroMuroDivisorio: otroMuroDivisorio ?? this.otroMuroDivisorio,
      fachadas: fachadas ?? this.fachadas,
      otraFachada: otraFachada ?? this.otraFachada,
      escaleras: escaleras ?? this.escaleras,
      otraEscalera: otraEscalera ?? this.otraEscalera,
      nivelDiseno: nivelDiseno ?? this.nivelDiseno,
      calidadDiseno: calidadDiseno ?? this.calidadDiseno,
      estadoEdificacion: estadoEdificacion ?? this.estadoEdificacion,
      sistemaMultiple: sistemaMultiple ?? this.sistemaMultiple,
      observacionesSistema: observacionesSistema ?? this.observacionesSistema,
      sistemasEstructurales: sistemasEstructurales ?? this.sistemasEstructurales,
      materialesPorSistema: materialesPorSistema ?? this.materialesPorSistema,
    );
  }

  @override
  List<Object?> get props => [
    pisosSobreTerreno,
    sotanos,
    frenteDimension,
    fondoDimension,
    unidadesResidenciales,
    unidadesComerciales,
    unidadesNoHabitadas,
    numeroOcupantes,
    muertos,
    heridos,
    noSeSabe,
    accesoObstruido,
    accesoLibre,
    usoPredominante,
    otroUso,
    fechaConstruccion,
    sistemaEstructural,
    material,
    cualOtroSistema,
    materialEntrepiso,
    sistemasEntrepiso,
    tiposEntrepisoPorMaterial,
    otroEntrepiso,
    sistemaSoporte,
    otroSistemaSoporte,
    revestimiento,
    otroRevestimiento,
    murosDivisorios,
    otroMuroDivisorio,
    fachadas,
    otraFachada,
    escaleras,
    otraEscalera,
    nivelDiseno,
    calidadDiseno,
    estadoEdificacion,
    sistemaMultiple,
    observacionesSistema,
    sistemasEstructurales,
    materialesPorSistema,
  ];
} 