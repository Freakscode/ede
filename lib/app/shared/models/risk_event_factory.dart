import 'package:caja_herramientas/app/shared/models/risk_event_model.dart';
import 'package:caja_herramientas/app/shared/models/risk_level.dart';

/// Factory para crear eventos de riesgo con sus clasificaciones completas
class RiskEventFactory {
  
  /// Crea el evento "Movimiento en Masa" completo
  static RiskEventModel createMovimientoEnMasa() {
    return RiskEventModel(
      id: 'movimiento_en_masa',
      name: 'Movimiento en Masa',
      description: 'Análisis de riesgo para movimientos en masa, deslizamientos y procesos gravitacionales',
      iconAsset: 'assets/icons/caja_herramientas/movimiento_masa.svg',
      createdAt: DateTime.now(),
      classifications: [
        // AMENAZA
        RiskClassification(
          id: 'amenaza',
          name: 'Amenaza',
          description: 'Factores que determinan la amenaza por movimiento en masa',
          subClassifications: [
            // PROBABILIDAD
            RiskSubClassification(
              id: 'probabilidad',
              name: 'Probabilidad',
              description: 'Factores que influyen en la probabilidad de ocurrencia',
              weight: 0.5,
              categories: [
                _createCaracteristicasGeotecnicas(),
                _createIntervencionAntropica(),
                _createManejoAguasLluvia(),
                _createManejoRedesHidroSanitarias(),
                _createAntecedentes(),
                _createEvidenciasMaterializacion(),
              ],
            ),
            // INTENSIDAD
            RiskSubClassification(
              id: 'intensidad',
              name: 'Intensidad',
              description: 'Factores que determinan la magnitud e impacto del evento',
              weight: 0.5,
              categories: [
                _createVolumenDeslizamiento(),
                _createVelocidadMovimiento(),
                _createAlcanceImpacto(),
              ],
            ),
          ],
        ),
        // VULNERABILIDAD (para futura implementación)
        RiskClassification(
          id: 'vulnerabilidad',
          name: 'Vulnerabilidad',
          description: 'Factores de vulnerabilidad de la población y elementos expuestos',
          subClassifications: [
            RiskSubClassification(
              id: 'social',
              name: 'Social',
              description: 'Vulnerabilidad de la población',
              categories: [],
            ),
            RiskSubClassification(
              id: 'fisica',
              name: 'Física',
              description: 'Vulnerabilidad de infraestructura y edificaciones',
              categories: [],
            ),
          ],
        ),
      ],
    );
  }

  /// Crea el evento "Incendio Forestal" completo
  static RiskEventModel createIncendioForestal() {
    return RiskEventModel(
      id: 'incendio_forestal',
      name: 'Incendio Forestal',
      description: 'Análisis de riesgo para incendios forestales y de vegetación',
      iconAsset: 'assets/icons/caja_herramientas/incendio_forestal.svg',
      createdAt: DateTime.now(),
      classifications: [
        RiskClassification(
          id: 'amenaza',
          name: 'Amenaza',
          description: 'Factores que determinan la amenaza por incendio forestal',
          subClassifications: [
            RiskSubClassification(
              id: 'probabilidad',
              name: 'Probabilidad',
              description: 'Factores que influyen en la probabilidad de ocurrencia',
              weight: 0.5,
              categories: [
                _createCombustible(),
                _createCondicionesMeteorologicas(),
              ],
            ),
            RiskSubClassification(
              id: 'intensidad',
              name: 'Intensidad',
              description: 'Factores que determinan la magnitud e impacto del evento',
              weight: 0.5,
              categories: [
                _createVelocidadPropagacion(),
                _createAlturaLlama(),
                _createAreaAfectada(),
              ],
            ),
          ],
        ),
      ],
    );
  }

  /// Crea el evento "Inundación" completo
  static RiskEventModel createInundacion() {
    return RiskEventModel(
      id: 'inundacion',
      name: 'Inundación',
      description: 'Análisis de riesgo para inundaciones y encharcamientos',
      iconAsset: 'assets/icons/caja_herramientas/inundacion.svg',
      createdAt: DateTime.now(),
      classifications: [
        RiskClassification(
          id: 'amenaza',
          name: 'Amenaza',
          description: 'Factores que determinan la amenaza por inundación',
          subClassifications: [
            RiskSubClassification(
              id: 'probabilidad',
              name: 'Probabilidad',
              description: 'Factores que influyen en la probabilidad de ocurrencia',
              weight: 0.5,
              categories: [
                _createCaracteristicasHidrologicas(),
                _createPrecipitacion(),
              ],
            ),
            RiskSubClassification(
              id: 'intensidad',
              name: 'Intensidad',
              description: 'Factores que determinan la magnitud e impacto del evento',
              weight: 0.5,
              categories: [
                _createProfundidadAgua(),
                _createVelocidadFlujo(),
                _createDuracionInundacion(),
              ],
            ),
          ],
        ),
      ],
    );
  }

  /// Crea el evento "Avenida Torrencial" completo
  static RiskEventModel createAvenidaTorrencial() {
    return RiskEventModel(
      id: 'avenida_torrencial',
      name: 'Avenida Torrencial',
      description: 'Análisis de riesgo para avenidas torrenciales y flujos de detritos',
      iconAsset: 'assets/icons/caja_herramientas/avenida_torrencial.svg',
      createdAt: DateTime.now(),
      classifications: [
        RiskClassification(
          id: 'amenaza',
          name: 'Amenaza',
          description: 'Factores que determinan la amenaza por avenida torrencial',
          subClassifications: [
            RiskSubClassification(
              id: 'probabilidad',
              name: 'Probabilidad',
              description: 'Factores que influyen en la probabilidad de ocurrencia',
              weight: 0.5,
              categories: [
                _createCaracteristicasCuenca(),
                _createSedimentosDetritos(),
              ],
            ),
            RiskSubClassification(
              id: 'intensidad',
              name: 'Intensidad',
              description: 'Factores que determinan la magnitud e impacto del evento',
              weight: 0.5,
              categories: [
                _createCaudalPico(),
                _createConcentracionSedimentos(),
                _createPoderDestructivo(),
              ],
            ),
          ],
        ),
      ],
    );
  }

  /// Crea el evento "Estructural" completo
  static RiskEventModel createEstructural() {
    return RiskEventModel(
      id: 'estructural',
      name: 'Estructural',
      description: 'Análisis de riesgo para eventos relacionados con fallas estructurales en edificaciones e infraestructura',
      iconAsset: 'assets/icons/caja_herramientas/estructural.svg',
      createdAt: DateTime.now(),
      classifications: [
        RiskClassification(
          id: 'amenaza',
          name: 'Amenaza',
          description: 'Factores que determinan la amenaza estructural',
          subClassifications: [
            RiskSubClassification(
              id: 'probabilidad',
              name: 'Probabilidad',
              description: 'Factores que influyen en la probabilidad de falla estructural',
              weight: 0.5,
              categories: [
                _createEstadoEstructural(),
                _createCalidadMateriales(),
                _createAntiguedadEstructura(),
                _createMantenimientoEstructura(),
              ],
            ),
            RiskSubClassification(
              id: 'intensidad',
              name: 'Intensidad',
              description: 'Factores que determinan la magnitud e impacto de la falla',
              weight: 0.5,
              categories: [
                _createTipoFalla(),
                _createMagnitudColapso(),
                _createAreaAfectadaEstructural(),
              ],
            ),
          ],
        ),
      ],
    );
  }

  /// Crea el evento "Otros" completo (eventos genéricos o no clasificados)
  static RiskEventModel createOtros() {
    return RiskEventModel(
      id: 'otros',
      name: 'Otros',
      description: 'Análisis de riesgo para eventos no clasificados en las categorías principales',
      iconAsset: 'assets/icons/caja_herramientas/otros.svg',
      createdAt: DateTime.now(),
      classifications: [
        RiskClassification(
          id: 'amenaza',
          name: 'Amenaza',
          description: 'Factores que determinan la amenaza del evento específico',
          subClassifications: [
            RiskSubClassification(
              id: 'probabilidad',
              name: 'Probabilidad',
              description: 'Factores que influyen en la probabilidad de ocurrencia del evento',
              weight: 0.5,
              categories: [
                _createFactorGenerico1(),
                _createFactorGenerico2(),
              ],
            ),
            RiskSubClassification(
              id: 'intensidad',
              name: 'Intensidad',
              description: 'Factores que determinan la magnitud e impacto del evento',
              weight: 0.5,
              categories: [
                _createMagnitudGenerica(),
                _createAlcanceGenerico(),
              ],
            ),
          ],
        ),
      ],
    );
  }

  /// Obtiene todos los eventos disponibles
  static List<RiskEventModel> getAllEvents() {
    return [
      createMovimientoEnMasa(),
      createAvenidaTorrencial(),
      createInundacion(),
      createEstructural(),
      createOtros(),
    ];
  }

  /// Busca un evento por ID
  static RiskEventModel? getEventById(String eventId) {
    try {
      return getAllEvents().firstWhere((event) => event.id == eventId);
    } catch (e) {
      return null;
    }
  }

  /// Busca un evento por nombre
  static RiskEventModel? getEventByName(String eventName) {
    try {
      return getAllEvents().firstWhere((event) => event.name == eventName);
    } catch (e) {
      return null;
    }
  }

  // ========== CATEGORÍAS DE PROBABILIDAD ==========

  static RiskCategory _createCaracteristicasGeotecnicas() {
    return RiskCategory(
      id: 'caracteristicas_geotecnicas',
      title: 'Características Geotécnicas',
      description: 'Evaluación de las condiciones del suelo y pendientes',
      levels: ['BAJO', 'MEDIO\nBAJO', 'MEDIO\nALTO', 'ALTO'],
      order: 1,
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
          customNote: 'NOTA: En caso de tratarse de llenos antrópicos constituidos sin sustento técnico',
        ),
      ],
    );
  }

  static RiskCategory _createIntervencionAntropica() {
    return RiskCategory(
      id: 'intervencion_antropica',
      title: 'Intervención Antrópica',
      description: 'Evaluación del impacto de las actividades humanas en la estabilidad',
      levels: ['BAJO', 'MEDIO\nBAJO', 'MEDIO\nALTO', 'ALTO'],
      order: 2,
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
    );
  }

  static RiskCategory _createManejoAguasLluvia() {
    return RiskCategory(
      id: 'manejo_aguas_lluvia',
      title: 'Manejo de Aguas de Lluvia',
      description: 'Evaluación del sistema de drenaje y manejo pluvial',
      levels: ['BAJO', 'MEDIO\nBAJO', 'MEDIO\nALTO', 'ALTO'],
      order: 3,
      detailedLevels: [
        RiskLevel.bajo(
          customItems: [
            'Sistema de drenaje excelente.',
            'Obras de protección adecuadas.',
          ],
        ),
        RiskLevel.medioBajo(
          customItems: [
            'Sistema de drenaje bueno.',
            'Obras de protección parciales.',
          ],
        ),
        RiskLevel.medioAlto(
          customItems: [
            'Sistema de drenaje deficiente.',
            'Concentración de aguas sin control.',
          ],
        ),
        RiskLevel.alto(
          customItems: [
            'Sin sistema de drenaje.',
            'Concentración severa de aguas.',
            'Saturación permanente del suelo.',
          ],
        ),
      ],
    );
  }

  static RiskCategory _createManejoRedesHidroSanitarias() {
    return RiskCategory(
      id: 'manejo_redes_hidro_sanitarias',
      title: 'Manejo de Redes Hidro-Sanitarias',
      description: 'Estado y manejo de las redes de servicios públicos',
      levels: ['BAJO', 'MEDIO\nBAJO', 'MEDIO\nALTO', 'ALTO'],
      order: 4,
      detailedLevels: [
        RiskLevel.bajo(
          customItems: [
            'Redes en excelente estado.',
            'Sin fugas ni infiltraciones.',
          ],
        ),
        RiskLevel.medioBajo(
          customItems: [
            'Redes en buen estado.',
            'Fugas menores controladas.',
          ],
        ),
        RiskLevel.medioAlto(
          customItems: [
            'Redes con deterioro moderado.',
            'Fugas frecuentes.',
          ],
        ),
        RiskLevel.alto(
          customItems: [
            'Redes en mal estado.',
            'Fugas permanentes y significativas.',
            'Saturación del suelo por filtraciones.',
          ],
        ),
      ],
    );
  }

  static RiskCategory _createAntecedentes() {
    return RiskCategory(
      id: 'antecedentes',
      title: 'Antecedentes',
      description: 'Historial de eventos previos en la zona',
      levels: ['BAJO', 'MEDIO\nBAJO', 'MEDIO\nALTO', 'ALTO'],
      order: 5,
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
    );
  }

  static RiskCategory _createEvidenciasMaterializacion() {
    return RiskCategory(
      id: 'evidencias_materializacion',
      title: 'Evidencias de Materialización o Reactivación',
      description: 'Signos visibles de inestabilidad actual',
      levels: ['BAJO', 'MEDIO\nBAJO', 'MEDIO\nALTO', 'ALTO'],
      order: 6,
      detailedLevels: [
        RiskLevel.bajo(
          customItems: [
            'Sin evidencias visibles.',
            'Terreno estable.',
          ],
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
    );
  }

  // ========== CATEGORÍAS DE INTENSIDAD ==========

  static RiskCategory _createVolumenDeslizamiento() {
    return RiskCategory(
      id: 'volumen_deslizamiento',
      title: 'Volumen del Deslizamiento',
      description: 'Volumen estimado de material en movimiento',
      levels: ['BAJO', 'MEDIO\nBAJO', 'MEDIO\nALTO', 'ALTO'],
      order: 1,
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
    );
  }

  static RiskCategory _createVelocidadMovimiento() {
    return RiskCategory(
      id: 'velocidad_movimiento',
      title: 'Velocidad del Movimiento',
      description: 'Velocidad estimada del proceso de movimiento',
      levels: ['BAJO', 'MEDIO\nBAJO', 'MEDIO\nALTO', 'ALTO'],
      order: 2,
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
    );
  }

  static RiskCategory _createAlcanceImpacto() {
    return RiskCategory(
      id: 'alcance_impacto',
      title: 'Alcance del Impacto',
      description: 'Área de influencia y alcance del movimiento',
      levels: ['BAJO', 'MEDIO\nBAJO', 'MEDIO\nALTO', 'ALTO'],
      order: 3,
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
    );
  }

  // ========== CATEGORÍAS PARA INCENDIO FORESTAL ==========

  static RiskCategory _createCombustible() {
    return RiskCategory(
      id: 'combustible',
      title: 'Combustible',
      description: 'Disponibilidad y características del material combustible',
      levels: ['BAJO', 'MEDIO\nBAJO', 'MEDIO\nALTO', 'ALTO'],
      order: 1,
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
    );
  }

  static RiskCategory _createCondicionesMeteorologicas() {
    return RiskCategory(
      id: 'condiciones_meteorologicas',
      title: 'Condiciones Meteorológicas',
      description: 'Factores climáticos que favorecen los incendios',
      levels: ['BAJO', 'MEDIO\nBAJO', 'MEDIO\nALTO', 'ALTO'],
      order: 2,
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
    );
  }

  // Continuaré con las demás categorías...
  // Por brevedad, incluyo solo algunos ejemplos más importantes
  
  static RiskCategory _createVelocidadPropagacion() {
    return RiskCategory(
      id: 'velocidad_propagacion',
      title: 'Velocidad de Propagación',
      description: 'Velocidad de avance del fuego',
      levels: ['BAJO', 'MEDIO\nBAJO', 'MEDIO\nALTO', 'ALTO'],
      order: 1,
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
    );
  }

  static RiskCategory _createAlturaLlama() {
    return RiskCategory(
      id: 'altura_llama',
      title: 'Altura de Llama',
      description: 'Altura característica de las llamas',
      levels: ['BAJO', 'MEDIO\nBAJO', 'MEDIO\nALTO', 'ALTO'],
      order: 2,
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
    );
  }

  static RiskCategory _createAreaAfectada() {
    return RiskCategory(
      id: 'area_afectada',
      title: 'Área Afectada',
      description: 'Extensión del área potencialmente afectada',
      levels: ['BAJO', 'MEDIO\nBAJO', 'MEDIO\nALTO', 'ALTO'],
      order: 3,
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
    );
  }

  // ========== CATEGORÍAS PARA INUNDACIÓN ==========

  static RiskCategory _createCaracteristicasHidrologicas() {
    return RiskCategory(
      id: 'caracteristicas_hidrologicas',
      title: 'Características Hidrológicas',
      description: 'Características de la cuenca y drenaje',
      levels: ['BAJO', 'MEDIO\nBAJO', 'MEDIO\nALTO', 'ALTO'],
      order: 1,
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
    );
  }

  static RiskCategory _createPrecipitacion() {
    return RiskCategory(
      id: 'precipitacion',
      title: 'Precipitación',
      description: 'Características de las precipitaciones en la zona',
      levels: ['BAJO', 'MEDIO\nBAJO', 'MEDIO\nALTO', 'ALTO'],
      order: 2,
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
    );
  }

  static RiskCategory _createProfundidadAgua() {
    return RiskCategory(
      id: 'profundidad_agua',
      title: 'Profundidad del Agua',
      description: 'Profundidad estimada del agua en inundación',
      levels: ['BAJO', 'MEDIO\nBAJO', 'MEDIO\nALTO', 'ALTO'],
      order: 1,
      detailedLevels: [
        RiskLevel.bajo(
          customItems: [
            'Profundidad menor a 0.5 metros.',
            'Inundación superficial manejable.',
          ],
        ),
        RiskLevel.medioBajo(
          customItems: [
            'Profundidad entre 0.5-1 metro.',
            'Dificultad para circulación peatonal.',
          ],
        ),
        RiskLevel.medioAlto(
          customItems: [
            'Profundidad entre 1-2 metros.',
            'Imposibilidad de circulación peatonal.',
          ],
        ),
        RiskLevel.alto(
          customItems: [
            'Profundidad mayor a 2 metros.',
            'Inundación severa con riesgo extremo.',
            'Colapso potencial de estructuras.',
          ],
        ),
      ],
    );
  }

  static RiskCategory _createVelocidadFlujo() {
    return RiskCategory(
      id: 'velocidad_flujo',
      title: 'Velocidad del Flujo',
      description: 'Velocidad del agua durante la inundación',
      levels: ['BAJO', 'MEDIO\nBAJO', 'MEDIO\nALTO', 'ALTO'],
      order: 2,
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
    );
  }

  static RiskCategory _createDuracionInundacion() {
    return RiskCategory(
      id: 'duracion_inundacion',
      title: 'Duración de la Inundación',
      description: 'Tiempo estimado de permanencia del agua',
      levels: ['BAJO', 'MEDIO\nBAJO', 'MEDIO\nALTO', 'ALTO'],
      order: 3,
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
    );
  }

  // ========== CATEGORÍAS PARA AVENIDA TORRENCIAL ==========

  static RiskCategory _createCaracteristicasCuenca() {
    return RiskCategory(
      id: 'caracteristicas_cuenca',
      title: 'Características de la Cuenca',
      description: 'Características geomorfológicas de la cuenca',
      levels: ['BAJO', 'MEDIO\nBAJO', 'MEDIO\nALTO', 'ALTO'],
      order: 1,
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
    );
  }

  static RiskCategory _createSedimentosDetritos() {
    return RiskCategory(
      id: 'sedimentos_detritos',
      title: 'Sedimentos y Detritos',
      description: 'Disponibilidad de material sólido transportable',
      levels: ['BAJO', 'MEDIO\nBAJO', 'MEDIO\nALTO', 'ALTO'],
      order: 2,
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
    );
  }

  static RiskCategory _createCaudalPico() {
    return RiskCategory(
      id: 'caudal_pico',
      title: 'Caudal Pico',
      description: 'Caudal máximo estimado durante el evento',
      levels: ['BAJO', 'MEDIO\nBAJO', 'MEDIO\nALTO', 'ALTO'],
      order: 1,
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
    );
  }

  static RiskCategory _createConcentracionSedimentos() {
    return RiskCategory(
      id: 'concentracion_sedimentos',
      title: 'Concentración de Sedimentos',
      description: 'Porcentaje de sedimentos en el flujo',
      levels: ['BAJO', 'MEDIO\nBAJO', 'MEDIO\nALTO', 'ALTO'],
      order: 2,
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
    );
  }

  static RiskCategory _createPoderDestructivo() {
    return RiskCategory(
      id: 'poder_destructivo',
      title: 'Poder Destructivo',
      description: 'Capacidad de daño del flujo torrencial',
      levels: ['BAJO', 'MEDIO\nBAJO', 'MEDIO\nALTO', 'ALTO'],
      order: 3,
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
    );
  }

  // ========== CATEGORÍAS PARA ESTRUCTURAL ==========

  static RiskCategory _createEstadoEstructural() {
    return RiskCategory(
      id: 'estado_estructural',
      title: 'Estado Estructural',
      description: 'Condición actual de los elementos estructurales',
      levels: ['BAJO', 'MEDIO\nBAJO', 'MEDIO\nALTO', 'ALTO'],
      order: 1,
      detailedLevels: [
        RiskLevel.bajo(
          customItems: [
            'Estructura en excelente estado.',
            'Sin grietas ni deformaciones visibles.',
            'Elementos estructurales íntegros.',
          ],
        ),
        RiskLevel.medioBajo(
          customItems: [
            'Estructura en buen estado general.',
            'Grietas menores no estructurales.',
            'Desgaste normal por uso.',
          ],
        ),
        RiskLevel.medioAlto(
          customItems: [
            'Deterioro moderado de elementos.',
            'Grietas en elementos no críticos.',
            'Signos de fatiga en materiales.',
          ],
        ),
        RiskLevel.alto(
          customItems: [
            'Deterioro severo de la estructura.',
            'Grietas en elementos estructurales críticos.',
            'Deformaciones visibles.',
            'Comprometimiento de la integridad estructural.',
          ],
        ),
      ],
    );
  }

  static RiskCategory _createCalidadMateriales() {
    return RiskCategory(
      id: 'calidad_materiales',
      title: 'Calidad de Materiales',
      description: 'Calidad y especificaciones de los materiales de construcción',
      levels: ['BAJO', 'MEDIO\nBAJO', 'MEDIO\nALTO', 'ALTO'],
      order: 2,
      detailedLevels: [
        RiskLevel.bajo(
          customItems: [
            'Materiales de alta calidad y especificación.',
            'Cumplimiento total de normas técnicas.',
            'Certificaciones de calidad vigentes.',
          ],
        ),
        RiskLevel.medioBajo(
          customItems: [
            'Materiales de buena calidad.',
            'Cumplimiento parcial de normas.',
            'Algunas deficiencias menores.',
          ],
        ),
        RiskLevel.medioAlto(
          customItems: [
            'Materiales de calidad regular.',
            'Incumplimiento de algunas normas.',
            'Deficiencias evidentes en la construcción.',
          ],
        ),
        RiskLevel.alto(
          customItems: [
            'Materiales de baja calidad o inadecuados.',
            'Incumplimiento grave de normas técnicas.',
            'Uso de materiales no certificados.',
            'Construcción sin supervisión técnica.',
          ],
        ),
      ],
    );
  }

  static RiskCategory _createAntiguedadEstructura() {
    return RiskCategory(
      id: 'antiguedad_estructura',
      title: 'Antigüedad de la Estructura',
      description: 'Tiempo transcurrido desde la construcción y vida útil',
      levels: ['BAJO', 'MEDIO\nBAJO', 'MEDIO\nALTO', 'ALTO'],
      order: 3,
      detailedLevels: [
        RiskLevel.bajo(
          customItems: [
            'Estructura nueva (0-10 años).',
            'Dentro de la vida útil de diseño.',
            'Tecnología de construcción moderna.',
          ],
        ),
        RiskLevel.medioBajo(
          customItems: [
            'Estructura relativamente nueva (10-25 años).',
            'Buen estado considerando la edad.',
            'Tecnología de construcción adecuada.',
          ],
        ),
        RiskLevel.medioAlto(
          customItems: [
            'Estructura madura (25-50 años).',
            'Cerca del fin de vida útil de diseño.',
            'Requiere evaluación especializada.',
          ],
        ),
        RiskLevel.alto(
          customItems: [
            'Estructura antigua (>50 años).',
            'Superó la vida útil de diseño.',
            'Tecnología de construcción obsoleta.',
            'Normas de diseño no vigentes.',
          ],
        ),
      ],
    );
  }

  static RiskCategory _createMantenimientoEstructura() {
    return RiskCategory(
      id: 'mantenimiento_estructura',
      title: 'Mantenimiento de la Estructura',
      description: 'Historial y calidad del mantenimiento estructural',
      levels: ['BAJO', 'MEDIO\nBAJO', 'MEDIO\nALTO', 'ALTO'],
      order: 4,
      detailedLevels: [
        RiskLevel.bajo(
          customItems: [
            'Mantenimiento preventivo regular.',
            'Inspecciones técnicas periódicas.',
            'Reparaciones oportunas y adecuadas.',
          ],
        ),
        RiskLevel.medioBajo(
          customItems: [
            'Mantenimiento ocasional.',
            'Algunas inspecciones realizadas.',
            'Reparaciones básicas ejecutadas.',
          ],
        ),
        RiskLevel.medioAlto(
          customItems: [
            'Mantenimiento deficiente.',
            'Pocas o ninguna inspección técnica.',
            'Reparaciones inadecuadas o tardías.',
          ],
        ),
        RiskLevel.alto(
          customItems: [
            'Ausencia total de mantenimiento.',
            'Sin inspecciones técnicas.',
            'Deterioro progresivo sin atención.',
            'Abandono de la estructura.',
          ],
        ),
      ],
    );
  }

  static RiskCategory _createTipoFalla() {
    return RiskCategory(
      id: 'tipo_falla',
      title: 'Tipo de Falla Estructural',
      description: 'Tipo y mecanismo de falla esperado',
      levels: ['BAJO', 'MEDIO\nBAJO', 'MEDIO\nALTO', 'ALTO'],
      order: 1,
      detailedLevels: [
        RiskLevel.bajo(
          customItems: [
            'Falla localizada en elementos no críticos.',
            'Degradación gradual de acabados.',
            'Sin compromiso estructural.',
          ],
        ),
        RiskLevel.medioBajo(
          customItems: [
            'Falla en elementos secundarios.',
            'Fisuración controlada.',
            'Funcionalidad parcialmente comprometida.',
          ],
        ),
        RiskLevel.medioAlto(
          customItems: [
            'Falla en elementos estructurales importantes.',
            'Pérdida de capacidad portante.',
            'Riesgo de colapso parcial.',
          ],
        ),
        RiskLevel.alto(
          customItems: [
            'Falla catastrófica de elementos críticos.',
            'Colapso total o parcial inminente.',
            'Pérdida completa de funcionalidad.',
            'Riesgo extremo para ocupantes.',
          ],
        ),
      ],
    );
  }

  static RiskCategory _createMagnitudColapso() {
    return RiskCategory(
      id: 'magnitud_colapso',
      title: 'Magnitud del Colapso',
      description: 'Extensión y severidad del colapso estructural',
      levels: ['BAJO', 'MEDIO\nBAJO', 'MEDIO\nALTO', 'ALTO'],
      order: 2,
      detailedLevels: [
        RiskLevel.bajo(
          customItems: [
            'Daños menores localizados.',
            'Sin colapso de elementos principales.',
            'Estructura funcionalmente estable.',
          ],
        ),
        RiskLevel.medioBajo(
          customItems: [
            'Colapso de elementos no estructurales.',
            'Daños moderados en acabados.',
            'Funcionalidad parcialmente afectada.',
          ],
        ),
        RiskLevel.medioAlto(
          customItems: [
            'Colapso parcial de elementos estructurales.',
            'Daños severos en áreas específicas.',
            'Pérdida significativa de funcionalidad.',
          ],
        ),
        RiskLevel.alto(
          customItems: [
            'Colapso total o de grandes secciones.',
            'Destrucción masiva de la estructura.',
            'Pérdida completa de funcionalidad.',
            'Ruina total del inmueble.',
          ],
        ),
      ],
    );
  }

  static RiskCategory _createAreaAfectadaEstructural() {
    return RiskCategory(
      id: 'area_afectada_estructural',
      title: 'Área Afectada',
      description: 'Extensión del área comprometida por la falla estructural',
      levels: ['BAJO', 'MEDIO\nBAJO', 'MEDIO\nALTO', 'ALTO'],
      order: 3,
      detailedLevels: [
        RiskLevel.bajo(
          customItems: [
            'Afectación menor al 25% del área.',
            'Daños localizados y controlables.',
            'Resto de la estructura estable.',
          ],
        ),
        RiskLevel.medioBajo(
          customItems: [
            'Afectación del 25-50% del área.',
            'Daños en múltiples elementos.',
            'Compromiso moderado de la estructura.',
          ],
        ),
        RiskLevel.medioAlto(
          customItems: [
            'Afectación del 50-75% del área.',
            'Daños extensos y generalizados.',
            'Compromiso severo de la estructura.',
          ],
        ),
        RiskLevel.alto(
          customItems: [
            'Afectación mayor al 75% del área.',
            'Daños masivos y generalizados.',
            'Compromiso total de la estructura.',
            'Afectación de estructuras adyacentes.',
          ],
        ),
      ],
    );
  }

  // ========== CATEGORÍAS PARA OTROS EVENTOS ==========

  static RiskCategory _createFactorGenerico1() {
    return RiskCategory(
      id: 'factor_generico_1',
      title: 'Factor de Probabilidad Específico',
      description: 'Factor específico que influye en la probabilidad del evento particular',
      levels: ['BAJO', 'MEDIO\nBAJO', 'MEDIO\nALTO', 'ALTO'],
      order: 1,
      detailedLevels: [
        RiskLevel.bajo(
          customItems: [
            'Condiciones favorables para prevención.',
            'Factores de riesgo mínimos.',
            'Controles efectivos implementados.',
          ],
        ),
        RiskLevel.medioBajo(
          customItems: [
            'Condiciones moderadamente favorables.',
            'Algunos factores de riesgo presentes.',
            'Controles parciales implementados.',
          ],
        ),
        RiskLevel.medioAlto(
          customItems: [
            'Condiciones desfavorables.',
            'Múltiples factores de riesgo.',
            'Controles insuficientes.',
          ],
        ),
        RiskLevel.alto(
          customItems: [
            'Condiciones muy desfavorables.',
            'Alto número de factores de riesgo.',
            'Ausencia de controles efectivos.',
            'Situación crítica de vulnerabilidad.',
          ],
        ),
      ],
    );
  }

  static RiskCategory _createFactorGenerico2() {
    return RiskCategory(
      id: 'factor_generico_2',
      title: 'Factor Complementario',
      description: 'Factor adicional que contribuye a la probabilidad del evento',
      levels: ['BAJO', 'MEDIO\nBAJO', 'MEDIO\nALTO', 'ALTO'],
      order: 2,
      detailedLevels: [
        RiskLevel.bajo(
          customItems: [
            'Factor contribuyente mínimo.',
            'Impacto reducido en la probabilidad.',
            'Condiciones estables y controladas.',
          ],
        ),
        RiskLevel.medioBajo(
          customItems: [
            'Factor contribuyente moderado.',
            'Impacto medio en la probabilidad.',
            'Condiciones variables.',
          ],
        ),
        RiskLevel.medioAlto(
          customItems: [
            'Factor contribuyente significativo.',
            'Impacto alto en la probabilidad.',
            'Condiciones inestables.',
          ],
        ),
        RiskLevel.alto(
          customItems: [
            'Factor contribuyente crítico.',
            'Impacto máximo en la probabilidad.',
            'Condiciones altamente inestables.',
            'Situación de riesgo extremo.',
          ],
        ),
      ],
    );
  }

  static RiskCategory _createMagnitudGenerica() {
    return RiskCategory(
      id: 'magnitud_generica',
      title: 'Magnitud del Evento',
      description: 'Escala e intensidad estimada del evento específico',
      levels: ['BAJO', 'MEDIO\nBAJO', 'MEDIO\nALTO', 'ALTO'],
      order: 1,
      detailedLevels: [
        RiskLevel.bajo(
          customItems: [
            'Evento de baja magnitud.',
            'Impactos localizados y menores.',
            'Fácil control y manejo.',
          ],
        ),
        RiskLevel.medioBajo(
          customItems: [
            'Evento de magnitud moderada.',
            'Impactos de escala media.',
            'Requiere respuesta coordinada.',
          ],
        ),
        RiskLevel.medioAlto(
          customItems: [
            'Evento de gran magnitud.',
            'Impactos significativos y extensos.',
            'Requiere recursos especializados.',
          ],
        ),
        RiskLevel.alto(
          customItems: [
            'Evento de magnitud extrema.',
            'Impactos masivos y generalizados.',
            'Situación de emergencia mayor.',
            'Requiere respuesta excepcional.',
          ],
        ),
      ],
    );
  }

  static RiskCategory _createAlcanceGenerico() {
    return RiskCategory(
      id: 'alcance_generico',
      title: 'Alcance del Impacto',
      description: 'Extensión geográfica y temporal del impacto del evento',
      levels: ['BAJO', 'MEDIO\nBAJO', 'MEDIO\nALTO', 'ALTO'],
      order: 2,
      detailedLevels: [
        RiskLevel.bajo(
          customItems: [
            'Alcance limitado y localizado.',
            'Duración corta del impacto.',
            'Afectación mínima de población.',
          ],
        ),
        RiskLevel.medioBajo(
          customItems: [
            'Alcance moderado.',
            'Duración media del impacto.',
            'Afectación parcial de comunidades.',
          ],
        ),
        RiskLevel.medioAlto(
          customItems: [
            'Alcance extenso.',
            'Duración prolongada del impacto.',
            'Afectación significativa de población.',
          ],
        ),
        RiskLevel.alto(
          customItems: [
            'Alcance masivo y regional.',
            'Impacto de larga duración.',
            'Afectación masiva de población.',
            'Consecuencias a largo plazo.',
          ],
        ),
      ],
    );
  }
}