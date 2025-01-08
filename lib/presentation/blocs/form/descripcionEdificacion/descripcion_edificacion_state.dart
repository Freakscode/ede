class DescripcionEdificacionState {
  // Características Generales
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

  // Usos Predominantes
  final String? usoPredominante;
  final String? otroUso;
  final String? fechaConstruccion;

  // Sistema Estructural y Material
  final String? sistemaEstructural;
  final String? material;
  final String? cualOtroSistema;
  final String? observaciones;
  final bool? existeMasDeUnSistema;
  final String? cualOtroSistemaMultiple;

  // Sistemas de Cubierta
  final List<String>? sistemaSoporte;
  final List<String>? revestimiento;
  final String? otroSistemaSoporte;
  final String? otroRevestimiento;

  // Elementos No Estructurales
  final List<String>? murosDivisorios;
  final String? otroMuroDivisorio;
  final List<String>? fachadas;
  final String? otraFachada;
  final List<String>? escaleras;
  final String? otraEscalera;

  // Sistemas de Entrepiso
  final String? materialEntrepiso;
  final List<String>? tiposEntrepiso;
  final String? otroEntrepiso;

  // Datos Adicionales
  final String? nivelDiseno;
  final String? calidadDiseno;
  final String? estadoEdificacion;

  final String? numeroPisos;
  final String? numeroSotanos;
  final String? areaConstruida;
  final String? anoConstruccion;
  final String? usoPrincipal;

  DescripcionEdificacionState({
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
    this.observaciones,
    this.existeMasDeUnSistema,
    this.cualOtroSistemaMultiple,
    this.sistemaSoporte,
    this.revestimiento,
    this.otroSistemaSoporte,
    this.otroRevestimiento,
    this.murosDivisorios,
    this.otroMuroDivisorio,
    this.fachadas,
    this.otraFachada,
    this.escaleras,
    this.otraEscalera,
    this.materialEntrepiso,
    this.tiposEntrepiso,
    this.otroEntrepiso,
    this.nivelDiseno,
    this.calidadDiseno,
    this.estadoEdificacion,
    this.numeroPisos,
    this.numeroSotanos,
    this.areaConstruida,
    this.anoConstruccion,
    this.usoPrincipal,
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
    String? observaciones,
    bool? existeMasDeUnSistema,
    String? cualOtroSistemaMultiple,
    List<String>? sistemaSoporte,
    List<String>? revestimiento,
    String? otroSistemaSoporte,
    String? otroRevestimiento,
    List<String>? murosDivisorios,
    String? otroMuroDivisorio,
    List<String>? fachadas,
    String? otraFachada,
    List<String>? escaleras,
    String? otraEscalera,
    String? materialEntrepiso,
    List<String>? tiposEntrepiso,
    String? otroEntrepiso,
    String? nivelDiseno,
    String? calidadDiseno,
    String? estadoEdificacion,
    String? numeroPisos,
    String? numeroSotanos,
    String? areaConstruida,
    String? anoConstruccion,
    String? usoPrincipal,
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
      observaciones: observaciones ?? this.observaciones,
      existeMasDeUnSistema: existeMasDeUnSistema ?? this.existeMasDeUnSistema,
      cualOtroSistemaMultiple: cualOtroSistemaMultiple ?? this.cualOtroSistemaMultiple,
      sistemaSoporte: sistemaSoporte ?? this.sistemaSoporte,
      revestimiento: revestimiento ?? this.revestimiento,
      otroSistemaSoporte: otroSistemaSoporte ?? this.otroSistemaSoporte,
      otroRevestimiento: otroRevestimiento ?? this.otroRevestimiento,
      murosDivisorios: murosDivisorios ?? this.murosDivisorios,
      otroMuroDivisorio: otroMuroDivisorio ?? this.otroMuroDivisorio,
      fachadas: fachadas ?? this.fachadas,
      otraFachada: otraFachada ?? this.otraFachada,
      escaleras: escaleras ?? this.escaleras,
      otraEscalera: otraEscalera ?? this.otraEscalera,
      materialEntrepiso: materialEntrepiso ?? this.materialEntrepiso,
      tiposEntrepiso: tiposEntrepiso ?? this.tiposEntrepiso,
      otroEntrepiso: otroEntrepiso ?? this.otroEntrepiso,
      nivelDiseno: nivelDiseno ?? this.nivelDiseno,
      calidadDiseno: calidadDiseno ?? this.calidadDiseno,
      estadoEdificacion: estadoEdificacion ?? this.estadoEdificacion,
      numeroPisos: numeroPisos ?? this.numeroPisos,
      numeroSotanos: numeroSotanos ?? this.numeroSotanos,
      areaConstruida: areaConstruida ?? this.areaConstruida,
      anoConstruccion: anoConstruccion ?? this.anoConstruccion,
      usoPrincipal: usoPrincipal ?? this.usoPrincipal,
    );
  }
} 