import 'package:caja_herramientas/app/shared/models/risk_level.dart';

class DropdownCategory {
  final String title;
  final List<String> levels;
  final List<RiskLevel>? detailedLevels;
  final Map<String, dynamic>? additionalData;

  const DropdownCategory({
    required this.title,
    required this.levels,
    this.detailedLevels,
    this.additionalData,
  });

  factory DropdownCategory.fromMap(Map<String, dynamic> map) {
    return DropdownCategory(
      title: map['title'] as String,
      levels: List<String>.from(map['levels'] as List),
      detailedLevels: map['detailedLevels'] != null
          ? (map['detailedLevels'] as List)
              .map((e) => e is RiskLevel ? e : RiskLevel.fromMap(e as Map<String, dynamic>))
              .toList()
          : null,
      additionalData: map['additionalData'] as Map<String, dynamic>?,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'levels': levels,
      if (detailedLevels != null)
        'detailedLevels': detailedLevels!.map((e) => e.toMap()).toList(),
      if (additionalData != null) 'additionalData': additionalData,
    };
  }


  // Factory para categoría de intensidad
  factory DropdownCategory.intensidad() {
    return DropdownCategory(
      title: 'Intensidad',
      levels: ['BAJO', 'MEDIO', 'MEDIO ALTO', 'ALTO'],
      detailedLevels: [
        RiskLevel.bajo(
          customItems: [
            'Desplazamientos lentos y de poca magnitud.',
            'Afectación menor a la infraestructura.',
          ],
        ),
        RiskLevel.medioBajo(
          customItems: [
            'Desplazamientos moderados.',
            'Afectación parcial a la infraestructura.',
          ],
        ),
        RiskLevel.medioAlto(
          customItems: [
            'Desplazamientos significativos.',
            'Afectación considerable a la infraestructura.',
          ],
        ),
        RiskLevel.alto(
          customItems: [
            'Desplazamientos rápidos y de gran magnitud.',
            'Destrucción total de la infraestructura.',
            'Pérdidas humanas posibles.',
          ],
          customNote: 'NOTA: En eventos de alta intensidad, la evacuación inmediata es necesaria',
        ),
      ],
    );
  }

  // Factory para categoría personalizada
  factory DropdownCategory.custom({
    required String title,
    required List<String> levels,
    List<RiskLevel>? detailedLevels,
    Map<String, dynamic>? additionalData,
  }) {
    return DropdownCategory(
      title: title,
      levels: levels,
      detailedLevels: detailedLevels,
      additionalData: additionalData,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is DropdownCategory &&
        other.title == title &&
        _listEquals(other.levels, levels) &&
        _listEquals(other.detailedLevels, detailedLevels) &&
        _mapEquals(other.additionalData, additionalData);
  }

  @override
  int get hashCode {
    return Object.hash(
      title,
      levels,
      detailedLevels,
      additionalData,
    );
  }

 

  @override
  String toString() {
    return 'DropdownCategory(title: $title, levels: $levels, detailedLevels: $detailedLevels, additionalData: $additionalData)';
  }

  bool _listEquals<T>(List<T>? a, List<T>? b) {
    if (a == null) return b == null;
    if (b == null || a.length != b.length) return false;
    for (int index = 0; index < a.length; index += 1) {
      if (a[index] != b[index]) return false;
    }
    return true;
  }

  bool _mapEquals<K, V>(Map<K, V>? a, Map<K, V>? b) {
    if (a == null) return b == null;
    if (b == null || a.length != b.length) return false;
    for (final key in a.keys) {
      if (!b.containsKey(key) || a[key] != b[key]) return false;
    }
    return true;
  }

  // ============== CATEGORÍAS ESPECÍFICAS POR EVENTO ==============

  // Categorías por defecto (cuando no hay evento seleccionado)
  static List<DropdownCategory> get defaultCategories => [
    DropdownCategory.custom(
      title: 'Probabilidad',
      levels: ['BAJO', 'MEDIO\nBAJO', 'MEDIO\nALTO', 'ALTO'],
      detailedLevels: [
        RiskLevel.bajo(
          customItems: ['Seleccione un evento específico para ver las categorías correspondientes.'],
        ),
        RiskLevel.medioBajo(
          customItems: ['Seleccione un evento específico para ver las categorías correspondientes.'],
        ),
        RiskLevel.medioAlto(
          customItems: ['Seleccione un evento específico para ver las categorías correspondientes.'],
        ),
        RiskLevel.alto(
          customItems: ['Seleccione un evento específico para ver las categorías correspondientes.'],
        ),
      ],
    ),
  ];

  // Categorías para Movimiento en Masa
  static List<DropdownCategory> get movimientoEnMasaCategories => [
    DropdownCategory.custom(
      title: 'Características Geotécnicas',
      levels: ['BAJO', 'MEDIO\nBAJO', 'MEDIO\nALTO', 'ALTO'],
      detailedLevels: [
        RiskLevel.bajo(
          customItems: [
            'Pendientes bajas modeladas en suelos (< 5°).',
            'Pendientes bajas, medias o altas, modeladas en roca sana o levemente meteorizada sin fracturas.',
          ],
        ),
        RiskLevel.medioBajo(
          customItems: [
            'Pendientes moderadas modeladas en suelos (5° - 15°).',
            'Pendientes bajas modeladas en suelos (< 5°), en condiciones saturadas.',
          ],
        ),
        RiskLevel.medioAlto(
          customItems: [
            'Pendientes altas modeladas en suelos (15° - 30°).',
            'Pendientes moderadas modeladas en suelos (5° - 15°), en condiciones saturadas.',
          ],
        ),
        RiskLevel.alto(
          customItems: [
            'Pendientes medias o altas modeladas en roca fracturada.',
            'Pendientes muy altas modeladas en suelos (> 30°).',
            'Pendientes altas modeladas en suelos (15° - 30°), en condiciones saturadas.',
            'Pendientes medias o altas, modeladas en llenos antrópicos.',
          ],
          customNote:
              'NOTA: En caso de tratarse de llenos antrópicos constituidos sin sustento técnico (vertimiento libre de materiales de excavación, escombros y basuras)',
        ),
      ],
    ),
    DropdownCategory.custom(
      title: 'Intervención Antrópica',
      levels: ['BAJO', 'MEDIO\nBAJO', 'MEDIO\nALTO', 'ALTO'],
      detailedLevels: [
        RiskLevel.bajo(
          customItems: [
            'Sin intervención antrópica significativa.',
            'Manejo adecuado del terreno.',
          ],
        ),
        RiskLevel.medioBajo(
          customItems: [
            'Intervención mínima controlada.',
            'Medidas de control implementadas.',
          ],
        ),
        RiskLevel.medioAlto(
          customItems: [
            'Intervención moderada sin control adecuado.',
            'Cortes y rellenos sin técnica apropiada.',
          ],
        ),
        RiskLevel.alto(
          customItems: [
            'Intervención severa descontrolada.',
            'Cortes verticales sin soporte.',
            'Rellenos sin compactación.',
            'Modificación drástica del drenaje natural.',
          ],
        ),
      ],
    ),
    DropdownCategory.custom(
      title: 'Manejo aguas lluvia',
      levels: ['BAJO', 'MEDIO\nBAJO', 'MEDIO\nALTO', 'ALTO'],
      detailedLevels: [
        RiskLevel.bajo(
          customItems: [
            'Sistema de drenaje completo y funcional.',
            'Mantenimiento regular del sistema.',
          ],
        ),
        RiskLevel.medioBajo(
          customItems: [
            'Sistema de drenaje básico funcional.',
            'Mantenimiento ocasional.',
          ],
        ),
        RiskLevel.medioAlto(
          customItems: [
            'Sistema de drenaje deficiente.',
            'Encharcamientos frecuentes.',
          ],
        ),
        RiskLevel.alto(
          customItems: [
            'Sin sistema de drenaje.',
            'Concentración de aguas superficiales.',
            'Erosión activa por escorrentía.',
          ],
        ),
      ],
    ),
    DropdownCategory.custom(
      title: 'Manejo de redes hidro sanitarias',
      levels: ['BAJO', 'MEDIO\nBAJO', 'MEDIO\nALTO', 'ALTO'],
      detailedLevels: [
        RiskLevel.bajo(
          customItems: [
            'Redes en excelente estado.',
            'Sin fugas ni infiltraciones.',
          ],
        ),
        RiskLevel.medioBajo(
          customItems: ['Redes en buen estado.', 'Fugas menores controladas.'],
        ),
        RiskLevel.medioAlto(
          customItems: ['Redes con deterioro moderado.', 'Fugas frecuentes.'],
        ),
        RiskLevel.alto(
          customItems: [
            'Redes en mal estado.',
            'Fugas permanentes y significativas.',
            'Saturación del suelo por filtraciones.',
          ],
        ),
      ],
    ),
    DropdownCategory.custom(
      title: 'Antecedentes',
      levels: ['BAJO', 'MEDIO\nBAJO', 'MEDIO\nALTO', 'ALTO'],
      detailedLevels: [
        RiskLevel.bajo(
          customItems: [
            'Sin antecedentes de movimientos.',
            'Zona estable históricamente.',
          ],
        ),
        RiskLevel.medioBajo(
          customItems: [
            'Antecedentes menores aislados.',
            'Eventos de baja magnitud.',
          ],
        ),
        RiskLevel.medioAlto(
          customItems: [
            'Antecedentes moderados documentados.',
            'Eventos recurrentes de magnitud media.',
          ],
        ),
        RiskLevel.alto(
          customItems: [
            'Antecedentes de eventos mayores.',
            'Historial de deslizamientos significativos.',
            'Eventos recientes y recurrentes.',
          ],
        ),
      ],
    ),
    DropdownCategory.custom(
      title: 'Evidencias de materialización o reactivación',
      levels: ['BAJO', 'MEDIO\nBAJO', 'MEDIO\nALTO', 'ALTO'],
      detailedLevels: [
        RiskLevel.bajo(
          customItems: ['Sin evidencias visibles.', 'Terreno estable.'],
        ),
        RiskLevel.medioBajo(
          customItems: [
            'Evidencias menores localizadas.',
            'Grietas superficiales aisladas.',
          ],
        ),
        RiskLevel.medioAlto(
          customItems: [
            'Evidencias moderadas.',
            'Grietas en desarrollo.',
            'Deformaciones menores.',
          ],
        ),
        RiskLevel.alto(
          customItems: [
            'Evidencias claras de inestabilidad.',
            'Grietas activas y en expansión.',
            'Movimientos visibles recientes.',
            'Deformaciones significativas.',
          ],
        ),
      ],
    ),
  ];

  // Categorías para Incendio Forestal
  static List<DropdownCategory> get incendioForestalCategories => [
    DropdownCategory.custom(
      title: 'Combustible',
      levels: ['BAJO', 'MEDIO\nBAJO', 'MEDIO\nALTO', 'ALTO'],
      detailedLevels: [
        RiskLevel.bajo(
          customItems: [
            'Vegetación dispersa con bajo contenido de materia seca.',
            'Zonas con alta humedad y poca acumulación de material vegetal.',
          ],
        ),
        RiskLevel.medioBajo(
          customItems: [
            'Vegetación moderada con contenido medio de materia seca.',
            'Algunas zonas con acumulación de material vegetal.',
          ],
        ),
        RiskLevel.medioAlto(
          customItems: [
            'Vegetación densa con alto contenido de materia seca.',
            'Acumulación considerable de material vegetal combustible.',
          ],
        ),
        RiskLevel.alto(
          customItems: [
            'Vegetación muy densa y seca.',
            'Gran acumulación de material vegetal combustible.',
            'Presencia de especies altamente inflamables.',
          ],
        ),
      ],
    ),
    DropdownCategory.custom(
      title: 'Condiciones Meteorológicas',
      levels: ['BAJO', 'MEDIO\nBAJO', 'MEDIO\nALTO', 'ALTO'],
      detailedLevels: [
        RiskLevel.bajo(
          customItems: [
            'Alta humedad relativa (>60%).',
            'Temperaturas bajas a moderadas.',
            'Vientos débiles.',
          ],
        ),
        RiskLevel.medioBajo(
          customItems: [
            'Humedad relativa moderada (40-60%).',
            'Temperaturas moderadas.',
            'Vientos moderados.',
          ],
        ),
        RiskLevel.medioAlto(
          customItems: [
            'Baja humedad relativa (20-40%).',
            'Temperaturas altas.',
            'Vientos fuertes.',
          ],
        ),
        RiskLevel.alto(
          customItems: [
            'Muy baja humedad relativa (<20%).',
            'Temperaturas muy altas.',
            'Vientos muy fuertes.',
            'Sequía prolongada.',
          ],
        ),
      ],
    ),
  ];

  // Categorías para Inundación
  static List<DropdownCategory> get inundacionCategories => [
    DropdownCategory.custom(
      title: 'Características Hidrológicas',
      levels: ['BAJO', 'MEDIO\nBAJO', 'MEDIO\nALTO', 'ALTO'],
      detailedLevels: [
        RiskLevel.bajo(
          customItems: [
            'Cuenca con buen sistema de drenaje.',
            'Pendientes adecuadas para evacuación de agua.',
            'Sin antecedentes de inundación.',
          ],
        ),
        RiskLevel.medioBajo(
          customItems: [
            'Sistema de drenaje moderado.',
            'Pendientes variables.',
            'Antecedentes menores de inundación.',
          ],
        ),
        RiskLevel.medioAlto(
          customItems: [
            'Sistema de drenaje deficiente.',
            'Pendientes inadecuadas.',
            'Antecedentes moderados de inundación.',
          ],
        ),
        RiskLevel.alto(
          customItems: [
            'Sin sistema de drenaje.',
            'Zona de planicie inundable.',
            'Historial recurrente de inundaciones.',
            'Desbordamiento frecuente de cauces.',
          ],
        ),
      ],
    ),
    DropdownCategory.custom(
      title: 'Precipitación',
      levels: ['BAJO', 'MEDIO\nBAJO', 'MEDIO\nALTO', 'ALTO'],
      detailedLevels: [
        RiskLevel.bajo(
          customItems: [
            'Precipitaciones bajas y regulares.',
            'Buena distribución temporal de lluvias.',
          ],
        ),
        RiskLevel.medioBajo(
          customItems: [
            'Precipitaciones moderadas.',
            'Algunas concentraciones temporales.',
          ],
        ),
        RiskLevel.medioAlto(
          customItems: [
            'Precipitaciones altas.',
            'Concentración temporal significativa.',
          ],
        ),
        RiskLevel.alto(
          customItems: [
            'Precipitaciones muy altas.',
            'Lluvias torrenciales concentradas.',
            'Eventos extremos recurrentes.',
          ],
        ),
      ],
    ),
  ];

  // Categorías para Avenida Torrencial
  static List<DropdownCategory> get avenidaTorrencialCategories => [
    DropdownCategory.custom(
      title: 'Características de la Cuenca',
      levels: ['BAJO', 'MEDIO\nBAJO', 'MEDIO\nALTO', 'ALTO'],
      detailedLevels: [
        RiskLevel.bajo(
          customItems: [
            'Cuenca amplia con pendientes suaves.',
            'Buena cobertura vegetal.',
            'Tiempo de concentración alto.',
          ],
        ),
        RiskLevel.medioBajo(
          customItems: [
            'Cuenca moderada con pendientes medias.',
            'Cobertura vegetal regular.',
            'Tiempo de concentración medio.',
          ],
        ),
        RiskLevel.medioAlto(
          customItems: [
            'Cuenca pequeña con pendientes altas.',
            'Cobertura vegetal escasa.',
            'Tiempo de concentración bajo.',
          ],
        ),
        RiskLevel.alto(
          customItems: [
            'Cuenca muy pequeña y empinada.',
            'Sin cobertura vegetal.',
            'Tiempo de concentración muy bajo.',
            'Cauces encañonados.',
          ],
        ),
      ],
    ),
    DropdownCategory.custom(
      title: 'Sedimentos y Detritos',
      levels: ['BAJO', 'MEDIO\nBAJO', 'MEDIO\nALTO', 'ALTO'],
      detailedLevels: [
        RiskLevel.bajo(
          customItems: [
            'Baja disponibilidad de sedimentos.',
            'Cauces estables.',
          ],
        ),
        RiskLevel.medioBajo(
          customItems: [
            'Disponibilidad moderada de sedimentos.',
            'Estabilidad relativa de cauces.',
          ],
        ),
        RiskLevel.medioAlto(
          customItems: [
            'Alta disponibilidad de sedimentos.',
            'Cauces con procesos erosivos activos.',
          ],
        ),
        RiskLevel.alto(
          customItems: [
            'Muy alta disponibilidad de sedimentos.',
            'Cauces muy inestables.',
            'Procesos erosivos intensos.',
            'Acumulación de detritos y material sólido.',
          ],
        ),
      ],
    ),
  ];

  // ============== CATEGORÍAS DE INTENSIDAD ==============

  // Categorías de intensidad por defecto
  static List<DropdownCategory> get defaultIntensidadCategories => [
    DropdownCategory.custom(
      title: 'Intensidad',
      levels: ['BAJO', 'MEDIO\nBAJO', 'MEDIO\nALTO', 'ALTO'],
      detailedLevels: [
        RiskLevel.bajo(
          customItems: ['Seleccione un evento específico para ver las categorías de intensidad correspondientes.'],
        ),
        RiskLevel.medioBajo(
          customItems: ['Seleccione un evento específico para ver las categorías de intensidad correspondientes.'],
        ),
        RiskLevel.medioAlto(
          customItems: ['Seleccione un evento específico para ver las categorías de intensidad correspondientes.'],
        ),
        RiskLevel.alto(
          customItems: ['Seleccione un evento específico para ver las categorías de intensidad correspondientes.'],
        ),
      ],
    ),
  ];

  // Categorías de intensidad para Movimiento en Masa
  static List<DropdownCategory> get movimientoEnMasaIntensidadCategories => [
    DropdownCategory.custom(
      title: 'Volumen del Deslizamiento',
      levels: ['BAJO', 'MEDIO\nBAJO', 'MEDIO\nALTO', 'ALTO'],
      detailedLevels: [
        RiskLevel.bajo(
          customItems: [
            'Volumen menor a 100 m³.',
            'Movimientos superficiales localizados.',
          ],
        ),
        RiskLevel.medioBajo(
          customItems: [
            'Volumen entre 100 - 1,000 m³.',
            'Movimientos de tamaño moderado.',
          ],
        ),
        RiskLevel.medioAlto(
          customItems: [
            'Volumen entre 1,000 - 10,000 m³.',
            'Movimientos de gran escala.',
          ],
        ),
        RiskLevel.alto(
          customItems: [
            'Volumen mayor a 10,000 m³.',
            'Movimientos masivos que afectan grandes áreas.',
            'Deslizamientos que pueden generar represamientos.',
          ],
        ),
      ],
    ),
    DropdownCategory.custom(
      title: 'Velocidad del Movimiento',
      levels: ['BAJO', 'MEDIO\nBAJO', 'MEDIO\nALTO', 'ALTO'],
      detailedLevels: [
        RiskLevel.bajo(
          customItems: [
            'Movimiento muy lento (<1 cm/año).',
            'Deformación progresiva imperceptible.',
          ],
        ),
        RiskLevel.medioBajo(
          customItems: [
            'Movimiento lento (1 cm/año - 1 cm/mes).',
            'Deformación visible con el tiempo.',
          ],
        ),
        RiskLevel.medioAlto(
          customItems: [
            'Movimiento moderado (1 cm/mes - 1 cm/día).',
            'Desarrollo de grietas y deformaciones evidentes.',
          ],
        ),
        RiskLevel.alto(
          customItems: [
            'Movimiento rápido (>1 cm/día).',
            'Movimiento súbito y catastrófico.',
            'Sin tiempo para evacuación preventiva.',
          ],
        ),
      ],
    ),
    DropdownCategory.custom(
      title: 'Alcance del Impacto',
      levels: ['BAJO', 'MEDIO\nBAJO', 'MEDIO\nALTO', 'ALTO'],
      detailedLevels: [
        RiskLevel.bajo(
          customItems: [
            'Impacto localizado (<50 m de alcance).',
            'Afectación mínima de infraestructura.',
          ],
        ),
        RiskLevel.medioBajo(
          customItems: [
            'Impacto moderado (50-200 m de alcance).',
            'Afectación parcial de infraestructura.',
          ],
        ),
        RiskLevel.medioAlto(
          customItems: [
            'Impacto extenso (200-500 m de alcance).',
            'Afectación significativa de infraestructura y viviendas.',
          ],
        ),
        RiskLevel.alto(
          customItems: [
            'Impacto masivo (>500 m de alcance).',
            'Destrucción total de infraestructura.',
            'Afectación de múltiples comunidades.',
          ],
        ),
      ],
    ),
  ];

  // Categorías de intensidad para Incendio Forestal
  static List<DropdownCategory> get incendioForestalIntensidadCategories => [
    DropdownCategory.custom(
      title: 'Velocidad de Propagación',
      levels: ['BAJO', 'MEDIO\nBAJO', 'MEDIO\nALTO', 'ALTO'],
      detailedLevels: [
        RiskLevel.bajo(
          customItems: [
            'Propagación muy lenta (<0.5 km/h).',
            'Fuego rastrero de baja intensidad.',
          ],
        ),
        RiskLevel.medioBajo(
          customItems: [
            'Propagación lenta (0.5-2 km/h).',
            'Fuego de superficie controlable.',
          ],
        ),
        RiskLevel.medioAlto(
          customItems: [
            'Propagación moderada (2-5 km/h).',
            'Fuego de superficie con focos de corona.',
          ],
        ),
        RiskLevel.alto(
          customItems: [
            'Propagación rápida (>5 km/h).',
            'Fuego de copa con comportamiento errático.',
            'Generación de focos secundarios.',
          ],
        ),
      ],
    ),
    DropdownCategory.custom(
      title: 'Altura de Llama',
      levels: ['BAJO', 'MEDIO\nBAJO', 'MEDIO\nALTO', 'ALTO'],
      detailedLevels: [
        RiskLevel.bajo(
          customItems: [
            'Llamas menores a 1 metro.',
            'Fuego de pasto de baja intensidad.',
          ],
        ),
        RiskLevel.medioBajo(
          customItems: [
            'Llamas entre 1-2 metros.',
            'Fuego de arbusto moderado.',
          ],
        ),
        RiskLevel.medioAlto(
          customItems: [
            'Llamas entre 2-4 metros.',
            'Fuego de arbustos altos y árboles pequeños.',
          ],
        ),
        RiskLevel.alto(
          customItems: [
            'Llamas mayores a 4 metros.',
            'Fuego de copa en árboles grandes.',
            'Columnas de fuego y comportamiento extremo.',
          ],
        ),
      ],
    ),
    DropdownCategory.custom(
      title: 'Área Afectada',
      levels: ['BAJO', 'MEDIO\nBAJO', 'MEDIO\nALTO', 'ALTO'],
      detailedLevels: [
        RiskLevel.bajo(
          customItems: [
            'Área menor a 1 hectárea.',
            'Incendio localizado y controlable.',
          ],
        ),
        RiskLevel.medioBajo(
          customItems: [
            'Área entre 1-10 hectáreas.',
            'Incendio de tamaño moderado.',
          ],
        ),
        RiskLevel.medioAlto(
          customItems: [
            'Área entre 10-100 hectáreas.',
            'Incendio de gran escala.',
          ],
        ),
        RiskLevel.alto(
          customItems: [
            'Área mayor a 100 hectáreas.',
            'Mega-incendio con múltiples focos.',
            'Afectación de ecosistemas completos.',
          ],
        ),
      ],
    ),
  ];

  // Categorías de intensidad para Inundación
  static List<DropdownCategory> get inundacionIntensidadCategories => [
    DropdownCategory.custom(
      title: 'Profundidad del Agua',
      levels: ['BAJO', 'MEDIO\nBAJO', 'MEDIO\nALTO', 'ALTO'],
      detailedLevels: [
        RiskLevel.bajo(
          customItems: [
            'Profundidad menor a 0.5 metros.',
            'Agua que permite el tránsito peatonal.',
          ],
        ),
        RiskLevel.medioBajo(
          customItems: [
            'Profundidad entre 0.5-1 metro.',
            'Agua que dificulta el tránsito peatonal.',
          ],
        ),
        RiskLevel.medioAlto(
          customItems: [
            'Profundidad entre 1-2 metros.',
            'Agua que impide el tránsito peatonal.',
          ],
        ),
        RiskLevel.alto(
          customItems: [
            'Profundidad mayor a 2 metros.',
            'Inundación que cubre completamente el primer piso.',
            'Riesgo de ahogamiento y arrastre.',
          ],
        ),
      ],
    ),
    DropdownCategory.custom(
      title: 'Velocidad del Flujo',
      levels: ['BAJO', 'MEDIO\nBAJO', 'MEDIO\nALTO', 'ALTO'],
      detailedLevels: [
        RiskLevel.bajo(
          customItems: [
            'Flujo lento (<0.5 m/s).',
            'Agua prácticamente estancada.',
          ],
        ),
        RiskLevel.medioBajo(
          customItems: [
            'Flujo moderado (0.5-1 m/s).',
            'Corriente perceptible pero manejable.',
          ],
        ),
        RiskLevel.medioAlto(
          customItems: [
            'Flujo rápido (1-2 m/s).',
            'Corriente fuerte que dificulta el movimiento.',
          ],
        ),
        RiskLevel.alto(
          customItems: [
            'Flujo muy rápido (>2 m/s).',
            'Corriente torrencial con capacidad de arrastre.',
            'Riesgo extremo de arrastre de personas y vehículos.',
          ],
        ),
      ],
    ),
    DropdownCategory.custom(
      title: 'Duración de la Inundación',
      levels: ['BAJO', 'MEDIO\nBAJO', 'MEDIO\nALTO', 'ALTO'],
      detailedLevels: [
        RiskLevel.bajo(
          customItems: [
            'Duración menor a 6 horas.',
            'Inundación rápidamente evacuable.',
          ],
        ),
        RiskLevel.medioBajo(
          customItems: [
            'Duración entre 6-24 horas.',
            'Inundación de corta duración.',
          ],
        ),
        RiskLevel.medioAlto(
          customItems: [
            'Duración entre 1-7 días.',
            'Inundación prolongada.',
          ],
        ),
        RiskLevel.alto(
          customItems: [
            'Duración mayor a 7 días.',
            'Inundación persistente.',
            'Afectación prolongada de servicios y suministros.',
          ],
        ),
      ],
    ),
  ];

  // Categorías de intensidad para Avenida Torrencial
  static List<DropdownCategory> get avenidaTorrencialIntensidadCategories => [
    DropdownCategory.custom(
      title: 'Caudal Pico',
      levels: ['BAJO', 'MEDIO\nBAJO', 'MEDIO\nALTO', 'ALTO'],
      detailedLevels: [
        RiskLevel.bajo(
          customItems: [
            'Caudal menor a 10 m³/s.',
            'Flujo manejable dentro del cauce.',
          ],
        ),
        RiskLevel.medioBajo(
          customItems: [
            'Caudal entre 10-50 m³/s.',
            'Flujo que ocupa la totalidad del cauce.',
          ],
        ),
        RiskLevel.medioAlto(
          customItems: [
            'Caudal entre 50-200 m³/s.',
            'Desbordamiento moderado del cauce.',
          ],
        ),
        RiskLevel.alto(
          customItems: [
            'Caudal mayor a 200 m³/s.',
            'Desbordamiento severo con inundación de áreas adyacentes.',
            'Capacidad de arrastre de grandes objetos.',
          ],
        ),
      ],
    ),
    DropdownCategory.custom(
      title: 'Concentración de Sedimentos',
      levels: ['BAJO', 'MEDIO\nBAJO', 'MEDIO\nALTO', 'ALTO'],
      detailedLevels: [
        RiskLevel.bajo(
          customItems: [
            'Concentración menor al 10%.',
            'Agua con poca turbidez.',
          ],
        ),
        RiskLevel.medioBajo(
          customItems: [
            'Concentración entre 10-30%.',
            'Agua turbia con sedimentos visibles.',
          ],
        ),
        RiskLevel.medioAlto(
          customItems: [
            'Concentración entre 30-60%.',
            'Flujo denso con alta carga de sedimentos.',
          ],
        ),
        RiskLevel.alto(
          customItems: [
            'Concentración mayor al 60%.',
            'Flujo de detritos con comportamiento viscoso.',
            'Transporte de rocas, troncos y material de gran tamaño.',
          ],
        ),
      ],
    ),
    DropdownCategory.custom(
      title: 'Poder Destructivo',
      levels: ['BAJO', 'MEDIO\nBAJO', 'MEDIO\nALTO', 'ALTO'],
      detailedLevels: [
        RiskLevel.bajo(
          customItems: [
            'Capacidad de arrastre de objetos pequeños.',
            'Daño mínimo a infraestructura.',
          ],
        ),
        RiskLevel.medioBajo(
          customItems: [
            'Capacidad de mover vehículos pequeños.',
            'Daño moderado a estructuras débiles.',
          ],
        ),
        RiskLevel.medioAlto(
          customItems: [
            'Capacidad de destruir muros y estructuras menores.',
            'Arrastre de vehículos y mobiliario urbano.',
          ],
        ),
        RiskLevel.alto(
          customItems: [
            'Capacidad de destruir edificaciones.',
            'Arrastre de estructuras completas.',
            'Modificación permanente del paisaje.',
            'Formación de represamientos y lagos.',
          ],
        ),
      ],
    ),
  ];
}