class EvaluacionModel {
  final Map<String, dynamic> identificacionEvaluacion;
  final Map<String, dynamic> identificacionEdificacion;
  final Map<String, dynamic> descripcionEdificacion;
  final Map<String, dynamic> riesgosExternos;
  final Map<String, dynamic> evaluacionDanos;
  final Map<String, dynamic> nivelDano;
  final Map<String, dynamic> habitabilidad;
  final Map<String, dynamic> acciones;
  final DateTime? ultimaModificacion;
  final bool sincronizado;
  final String? id;

  EvaluacionModel({
    required this.identificacionEvaluacion,
    required this.identificacionEdificacion,
    required this.descripcionEdificacion,
    required this.riesgosExternos,
    required this.evaluacionDanos,
    required this.nivelDano,
    required this.habitabilidad,
    required this.acciones,
    this.ultimaModificacion,
    this.sincronizado = false,
    this.id,
  });

  Map<String, dynamic> toJson() => {
    'identificacionEvaluacion': identificacionEvaluacion,
    'identificacionEdificacion': identificacionEdificacion,
    'descripcionEdificacion': descripcionEdificacion,
    'riesgosExternos': riesgosExternos,
    'evaluacionDanos': evaluacionDanos,
    'nivelDano': nivelDano,
    'habitabilidad': habitabilidad,
    'acciones': acciones,
    'ultimaModificacion': ultimaModificacion?.toIso8601String(),
    'sincronizado': sincronizado,
    'id': id,
  };

  factory EvaluacionModel.fromJson(Map<String, dynamic> json) => EvaluacionModel(
    identificacionEvaluacion: json['identificacionEvaluacion'],
    identificacionEdificacion: json['identificacionEdificacion'],
    descripcionEdificacion: json['descripcionEdificacion'],
    riesgosExternos: json['riesgosExternos'],
    evaluacionDanos: json['evaluacionDanos'],
    nivelDano: json['nivelDano'],
    habitabilidad: json['habitabilidad'],
    acciones: json['acciones'],
    ultimaModificacion: json['ultimaModificacion'] != null 
      ? DateTime.parse(json['ultimaModificacion'])
      : null,
    sincronizado: json['sincronizado'] ?? false,
    id: json['id'],
  );
} 