import 'package:caja_herramientas/app/shared/models/risk_event_model.dart';
import 'package:caja_herramientas/app/shared/models/risk_level.dart';

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
                _createPotencialDanoEdificaciones(),
                _createCapacidadGenerarPerdidaVidas(),
                _createAlteracionLineasVitales(),
              ],
            ),
          ],
        ),
        // VULNERABILIDAD
        RiskClassification(
          id: 'vulnerabilidad',
          name: 'Vulnerabilidad',
          description: 'Factores de vulnerabilidad de la población y elementos expuestos',
          subClassifications: [
            // FRAGILIDAD FÍSICA
            RiskSubClassification(
              id: 'fragilidad_fisica',
              name: 'Fragilidad Física',
              description: 'Vulnerabilidad de infraestructura y edificaciones',
              weight: 0.33,
              categories: [
                _createCalidadMaterialesProcesos(),
                _createEstadoConservacion(),
                _createTipologiaEstructural(),
              ],
            ),
            // FRAGILIDAD EN PERSONAS
            RiskSubClassification(
              id: 'fragilidad_personas',
              name: 'Fragilidad en Personas',
              description: 'Vulnerabilidad de la población y capacidad de respuesta',
              weight: 0.33,
              categories: [
                _createNivelOrganizacion(),
                _createSuficienciaEconomica(),
              ],
            ),
            // EXPOSICIÓN
            RiskSubClassification(
              id: 'exposicion',
              name: 'Exposición',
              description: 'Elementos expuestos al riesgo',
              weight: 0.34,
              categories: [
                _createEdificacionesExpuestas(),
                _createOtrosElementosExpuestos(),
                _createEscalaAfectacion(),
              ],
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
      value: 2, // Valor inicial (1-4, donde 1=BAJO, 2=MEDIO BAJO, 3=MEDIO ALTO, 4=ALTO)
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
            'Pendientes muy altas modeladas en suelos ( > 30°).',
            'Pendientes altas modeladas en suelos (15° - 30°), en condiciones saturadas.',
            'Pendientes medias o altas, modeladas en llenos antrópicos.',
          ],
          customNote: 'NOTA: En caso de tratarse de llenos antrópicos constituidos sin sustento técnico (vertimiento libre de materiales de excavación, escombros y basuras), ASIGNAR EL VALOR DE 4',
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
      value: 2, // Valor según tabla (1-4, donde 1=BAJO, 2=MEDIO BAJO, 3=MEDIO ALTO, 4=ALTO)
      detailedLevels: [
        RiskLevel.bajo(
          customItems: [
            'No se evidencian intervenciones antrópicas que condicionen la estabilidad del terreno.',
            'Se han desarrollado cortes o excavaciones que pueden afectar la estabilidad del terreno, pero se han ejecutado obras de estabilización o mitigación aparentemente adecuadas.',
          ],
        ),
        RiskLevel.medioBajo(
          customItems: [
            'Se presentan cortes o excavaciones menores de 3 metros de altura que no tienden a comprometer la estabilidad del terreno.',
          ],
        ),
        RiskLevel.medioAlto(
          customItems: [
            'Se presentan cortes o excavaciones que comprometen la estabilidad del terreno, pero se han desarrollado obras de mitigación menores (bioingeniería, drenaje superficial y subsuperficial, entre otros) que no garantizan su estabilidad.',
          ],
        ),
        RiskLevel.alto(
          customItems: [
            'Se presentan cortes o excavaciones que comprometen la estabilidad del terreno y no se han desarrollado obras de estabilización o mitigación.',
            'Se presenta acumulación de material de excavación, escombros y basuras sobre la parte alta o media del talud/ladera, generando sobrecargas que condicionan su estabilidad.',
            'Existen sobrecargas asociadas a la construcción de edificaciones, adiciones o infraestructura que pueden comprometer la estabilidad del talud/ladera.',
          ],
        ),
      ],
    );
  }

  static RiskCategory _createManejoAguasLluvia() {
    return RiskCategory(
      id: 'manejo_aguas_lluvia',
      title: 'Manejo de Aguas de Lluvia',
      description: 'Evaluación del sistema de drenaje y manejo pluvial (canoas, bajantes, cunetas, sumideros, entre otros)',
      levels: ['BAJO', 'MEDIO\nBAJO', 'MEDIO\nALTO', 'ALTO'],
      order: 3,
      value: 3, // Valor según tabla (1-4, donde 1=BAJO, 2=MEDIO BAJO, 3=MEDIO ALTO, 4=ALTO)
      detailedLevels: [
        RiskLevel.bajo(
          customItems: [
            'Existen obras de captación y manejo de aguas lluvias y de escorrentía de buena capacidad hidráulica.',
          ],
        ),
        RiskLevel.medioBajo(
          customItems: [
            'Existen obras de captación y manejo de aguas lluvias y de escorrentía de insuficiente capacidad hidráulica.',
          ],
        ),
        RiskLevel.medioAlto(
          customItems: [
            'Deficientes sistemas de captación de aguas lluvias y de escorrentía.',
          ],
        ),
        RiskLevel.alto(
          customItems: [
            'Ausencia total de sistemas de captación y manejo de aguas lluvias y de escorrentía.',
            'Descoles inadecuados de obras de captación.',
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
      value: 4, // Valor según tabla (1-4)
      detailedLevels: [
        RiskLevel.bajo(
          customItems: [
            'Existen redes convencionales de servicios públicos que funcionan adecuadamente.',
          ],
        ),
        RiskLevel.medioBajo(
          customItems: [
            'Existen redes de servicios públicos no convencionales o comunitarias, cuyo funcionamiento es aceptable.',
          ],
        ),
        RiskLevel.medioAlto(
          customItems: [
            'Se presentan deficiencias en las redes de servicio existentes.',
          ],
        ),
        RiskLevel.alto(
          customItems: [
            'No existen redes de servicio.',
            'Se presentan descargas de aguas residuales a media ladera, fugas de agua en tuberías o mangueras y/o rebose de tanques de almacenamiento de aguas.',
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
      value: 3, // Valor según tabla (1-4)
      detailedLevels: [
        RiskLevel.bajo(
          customItems: [
            'No se presentan rasgos indicadores de inestabilidad en el entorno, ni características morfológicas que evidencien la ocurrencia de procesos morfodinámicos en el pasado.',
          ],
        ),
        RiskLevel.medioBajo(
          customItems: [
            'Se presentan algunas características en el entorno que sugieren el desarrollo de procesos morfodinámicos en el pasado, los cuales ya se encuentran inactivos y/o revegetalizados.',
          ],
        ),
        RiskLevel.medioAlto(
          customItems: [
            'Existen evidencias morfológicas en el entorno que podrían sugerir el desarrollo de procesos morfodinámicos superficiales recientes (desgarres).',
          ],
        ),
        RiskLevel.alto(
          customItems: [
            'Existen múltiples rasgos indicadores de inestabilidad en el entorno.',
            'Se presentan movimientos en masa activos y procesos de erosión concentrada.',
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
      value: 3, // Valor según tabla (1-4)
      detailedLevels: [
        RiskLevel.bajo(
          customItems: [
            'No hay evidencias o manifestaciones que indiquen la posibilidad de ocurrencia del evento.',
            'El evento no tiene probabilidad de expandirse.',
          ],
        ),
        RiskLevel.medioBajo(
          customItems: [
            'Las evidencias o manifestaciones que sugieren la ocurrencia del evento no están muy definidas, pero las condiciones propias del terreno no permiten descartar la posibilidad de que se desarrolle el fenómeno.',
            'El evento no muestra rasgos indicadores de evolución, sin embargo, las características físicas del talud podrían favorecer su expansión.',
          ],
        ),
        RiskLevel.medioAlto(
          customItems: [
            'Existen evidencias y manifestaciones que sugieren la ocurrencia del evento, pero puede no ser inminente en el futuro inmediato.',
            'El evento muestra algunos rasgos indicadores de evolución (grietas incipientes, material suspendido y acumulado).',
          ],
        ),
        RiskLevel.alto(
          customItems: [
            'Existen evidencias y manifestaciones que hacen inminente la ocurrencia del evento.',
            'El evento tiene tendencia retrogresiva, progresiva y de crecimiento lateral a corto plazo, y presenta rasgos indicadores de evolución rápida (grietas de tracción, gran cantidad de material suspendido, acumulado e inestable).',
          ],
          customNote: 'NOTA: Si durante el proceso de calificación se asigna en esta categoría el valor de 4, se deben ignorar las demás variables de la POSIBILIDAD.',
        ),
      ],
    );
  }

  // ========== CATEGORÍAS DE INTENSIDAD ==========

  static RiskCategory _createPotencialDanoEdificaciones() {
    return RiskCategory(
      id: 'potencial_dano_edificaciones',
      title: 'Potencial de Daño en Edificaciones',
      description: 'Evaluación del potencial de daño a las edificaciones',
      levels: ['BAJO', 'MEDIO\nBAJO', 'MEDIO\nALTO', 'ALTO'],
      order: 1,
      value: 1, // Valor según tabla oficial
      detailedLevels: [
        RiskLevel.bajo(
          customItems: [
            'Las características del fenómeno sugieren un bajo potencial de daño, por lo que las edificaciones no se verían afectadas.',
          ],
        ),
        RiskLevel.medioBajo(
          customItems: [
            'Las características del fenómeno sugieren la ocurrencia de daños leves en las edificaciones, recuperables fácilmente.',
          ],
        ),
        RiskLevel.medioAlto(
          customItems: [
            'Las características del fenómeno sugieren la ocurrencia de daños importantes en las edificaciones.',
          ],
        ),
        RiskLevel.alto(
          customItems: [
            'Las características del fenómeno sugieren un potencial de daño muy alto, por lo que podría ser inminente el colapso o la falla de las edificaciones.',
          ],
        ),
      ],
    );
  }

  static RiskCategory _createCapacidadGenerarPerdidaVidas() {
    return RiskCategory(
      id: 'capacidad_generar_perdida_vidas',
      title: 'Capacidad de Generar Pérdida de Vidas Humanas',
      description: 'Evaluación del potencial de generar víctimas mortales y lesionados',
      levels: ['BAJO', 'MEDIO\nBAJO', 'MEDIO\nALTO', 'ALTO'],
      order: 2,
      value: 2, // Valor según tabla oficial
      detailedLevels: [
        RiskLevel.bajo(
          customItems: [
            'No se estiman personas lesionadas ni muertos.',
          ],
        ),
        RiskLevel.medioBajo(
          customItems: [
            'Difícilmente genera personas muertas o lesionadas.',
          ],
        ),
        RiskLevel.medioAlto(
          customItems: [
            'Puede presentar personas lesionadas y posiblemente algún muerto.',
          ],
        ),
        RiskLevel.alto(
          customItems: [
            'Puede presentar numerosos muertos y lesionados.',
          ],
        ),
      ],
    );
  }

  static RiskCategory _createAlteracionLineasVitales() {
    return RiskCategory(
      id: 'alteracion_lineas_vitales',
      title: 'Alteración del Funcionamiento de Líneas Vitales y Espacio Público',
      description: 'Evaluación del impacto en servicios públicos e infraestructura vital',
      levels: ['BAJO', 'MEDIO\nBAJO', 'MEDIO\nALTO', 'ALTO'],
      order: 3,
      value: 3, // Valor según tabla oficial
      detailedLevels: [
        RiskLevel.bajo(
          customItems: [
            'No se altera el funcionamiento u operación de los elementos, de manera que no se compromete la prestación del servicio.',
          ],
        ),
        RiskLevel.medioBajo(
          customItems: [
            'Se presentan daños leves en los elementos pero no se compromete la prestación del servicio.',
          ],
        ),
        RiskLevel.medioAlto(
          customItems: [
            'El funcionamiento u operación de los elementos se ve alterado, de manera que se compromete la prestación del servicio pero se puede recuperar en el corto plazo (acciones de reparación).',
          ],
        ),
        RiskLevel.alto(
          customItems: [
            'Se altera completamente el funcionamiento u operación de los elementos y su recuperación es difícil en el corto plazo (acciones de reconstrucción).',
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
      value: 2, // Valor inicial (1-4)
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
      value: 2, // Valor inicial (1-4)
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
      value: 2, // Valor inicial (1-4)
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
      value: 2, // Valor inicial (1-4)
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
      value: 2, // Valor inicial (1-4)
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
      value: 2, // Valor inicial (1-4)
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
      value: 2, // Valor inicial (1-4)
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
      value: 2, // Valor inicial (1-4)
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
      value: 2, // Valor inicial (1-4)
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
      value: 2, // Valor inicial (1-4)
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
      value: 2, // Valor inicial (1-4)
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
      value: 2, // Valor inicial (1-4)
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
      value: 2, // Valor inicial (1-4)
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
      value: 2, // Valor inicial (1-4)
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
      value: 2, // Valor inicial (1-4)
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
      value: 2, // Valor inicial (1-4)
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
      value: 2, // Valor inicial (1-4)
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
      value: 2, // Valor inicial (1-4)
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
      value: 2, // Valor inicial (1-4)
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
      value: 2, // Valor inicial (1-4)
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
      value: 2, // Valor inicial (1-4)
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
      value: 2, // Valor inicial (1-4)
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
      value: 2, // Valor inicial (1-4)
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
      value: 2, // Valor inicial (1-4)
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
      value: 2, // Valor inicial (1-4)
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
      value: 2, // Valor inicial (1-4)
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

  // ========== CATEGORÍAS DE VULNERABILIDAD - FRAGILIDAD FÍSICA ==========

  static RiskCategory _createCalidadMaterialesProcesos() {
    return RiskCategory(
      id: 'calidad_materiales_procesos',
      title: 'Calidad de los Materiales y Procesos Constructivos',
      description: 'Evaluación de la calidad de materiales y técnicas constructivas',
      levels: ['BAJO', 'MEDIO\nBAJO', 'MEDIO\nALTO', 'ALTO'],
      order: 1,
      value: 3, // Valor según tabla oficial
      detailedLevels: [
        RiskLevel.bajo(
          customItems: [
            'Estructura con materiales de muy buena calidad y adecuada técnica constructiva.',
          ],
        ),
        RiskLevel.medioBajo(
          customItems: [
            'Estructura con materiales de regular calidad, pero adecuada técnica constructiva.',
          ],
        ),
        RiskLevel.medioAlto(
          customItems: [
            'Estructura con materiales de buena calidad, pero con deficiencias constructivas.',
          ],
        ),
        RiskLevel.alto(
          customItems: [
            'Estructura con materiales de mala calidad y con deficiencias constructivas.',
          ],
        ),
      ],
    );
  }

  static RiskCategory _createEstadoConservacion() {
    return RiskCategory(
      id: 'estado_conservacion',
      title: 'Estado de Conservación',
      description: 'Evaluación del estado actual de conservación de la estructura',
      levels: ['BAJO', 'MEDIO\nBAJO', 'MEDIO\nALTO', 'ALTO'],
      order: 2,
      value: 2, // Valor según tabla oficial
      detailedLevels: [
        RiskLevel.bajo(
          customItems: [
            'Buen estado de conservación. No hay lesiones considerables o solo observan daños superficiales leves en los acabados.',
          ],
        ),
        RiskLevel.medioBajo(
          customItems: [
            'Buen estado de conservación. Hay lesiones menores que no comprometen la seguridad de la edificación.',
          ],
        ),
        RiskLevel.medioAlto(
          customItems: [
            'Estado de deterioro moderado. Hay evidencia de lesiones importantes pero no comprometen la seguridad de la estructura.',
          ],
        ),
        RiskLevel.alto(
          customItems: [
            'Estado precario de conservación. Alta densidad de lesiones que comprometen la seguridad de la estructura y deformaciones graves (unidades de mampostería o concreto con fallas por aplastamiento, inclinaciones del elemento fuera de su plano vertical).',
          ],
        ),
      ],
    );
  }

  static RiskCategory _createTipologiaEstructural() {
    return RiskCategory(
      id: 'tipologia_estructural',
      title: 'Tipología Estructural',
      description: 'Evaluación del tipo de sistema estructural y su resistencia',
      levels: ['BAJO', 'MEDIO\nBAJO', 'MEDIO\nALTO', 'ALTO'],
      order: 3,
      value: 3, // Valor según tabla oficial
      detailedLevels: [
        RiskLevel.bajo(
          customItems: [
            'Edificaciones reforzadas o con reforzamiento especial. Edificaciones en concreto reforzado y acero, diseñadas y construidas con requerimientos de norma o superiores (pórticos, sistemas combinados, duales, muros de concreto reforzado).',
          ],
        ),
        RiskLevel.medioBajo(
          customItems: [
            'Mampostería confinada o reforzada.',
          ],
        ),
        RiskLevel.medioAlto(
          customItems: [
            'Edificaciones con confinamiento deficiente, estructuras híbridas. Mampostería no reforzada, no confinada, pero con una configuración estructural que brinda cierta resistencia al evento.',
          ],
        ),
        RiskLevel.alto(
          customItems: [
            'Estructuras ligeras y construcciones simples. Edificaciones no reforzadas, no confinadas, con baja resistencia a cargas laterales y/o impactos generados por los fenómenos.',
          ],
        ),
      ],
    );
  }

  // ========== CATEGORÍAS DE VULNERABILIDAD - FRAGILIDAD EN PERSONAS ==========

  static RiskCategory _createNivelOrganizacion() {
    return RiskCategory(
      id: 'nivel_organizacion',
      title: 'Nivel de Organización',
      description: 'Evaluación del nivel de preparación y organización comunitaria',
      levels: ['BAJO', 'MEDIO\nBAJO', 'MEDIO\nALTO', 'ALTO'],
      order: 1,
      value: 1, // Valor según tabla oficial
      detailedLevels: [
        RiskLevel.bajo(
          customItems: [
            'La comunidad tiene total conocimiento de los riesgos presentes en el territorio y asume su compromiso frente al tema. La población cuenta con sistemas de alerta temprana.',
          ],
        ),
        RiskLevel.medioBajo(
          customItems: [
            'La comunidad tiene conocimiento de los riesgos presentes y manifiesta un compromiso frente al tema. La población cuenta con planes comunitarios para la gestión del riesgo de desastres.',
          ],
        ),
        RiskLevel.medioAlto(
          customItems: [
            'La población tiene conocimiento de los riesgos presentes, pero manifiesta poco compromiso frente al tema.',
          ],
        ),
        RiskLevel.alto(
          customItems: [
            'La población no tiene conocimiento de los riesgos presentes, y no manifiesta compromiso frente al tema.',
          ],
        ),
      ],
    );
  }

  static RiskCategory _createSuficienciaEconomica() {
    return RiskCategory(
      id: 'suficiencia_economica',
      title: 'Suficiencia Económica',
      description: 'Evaluación de la capacidad económica para enfrentar el riesgo',
      levels: ['BAJO', 'MEDIO\nBAJO', 'MEDIO\nALTO', 'ALTO'],
      order: 2,
      value: 1, // Valor según tabla oficial
      detailedLevels: [
        RiskLevel.bajo(
          customItems: [
            'El actor responsable tiene la capacidad de resolver la problemática con sus propios medios.',
          ],
        ),
        RiskLevel.medioBajo(
          customItems: [
            'El actor responsable tiene la capacidad de resolver parcialmente la problemática en el corto plazo.',
          ],
        ),
        RiskLevel.medioAlto(
          customItems: [
            'El actor responsable tiene la capacidad de resolver parcialmente la problemática en el largo plazo.',
          ],
        ),
        RiskLevel.alto(
          customItems: [
            'El actor responsable no tiene la capacidad de resolver la problemática y requiere de apoyo de terceros.',
          ],
        ),
      ],
    );
  }

  // ========== CATEGORÍAS DE VULNERABILIDAD - EXPOSICIÓN ==========

  static RiskCategory _createEdificacionesExpuestas() {
    return RiskCategory(
      id: 'edificaciones_expuestas',
      title: 'Edificaciones Expuestas',
      description: 'Evaluación del tipo de edificaciones según su importancia',
      levels: ['BAJO', 'MEDIO\nBAJO', 'MEDIO\nALTO', 'ALTO'],
      order: 1,
      value: 1, // Valor según tabla oficial
      detailedLevels: [
        RiskLevel.bajo(
          customItems: [
            'Estructuras de ocupación normal según NSR-10.',
          ],
        ),
        RiskLevel.medioBajo(
          customItems: [
            'Estructuras de ocupación especial según NSR-10.',
          ],
        ),
        RiskLevel.medioAlto(
          customItems: [
            'Edificaciones de atención a la comunidad según NSR-10.',
          ],
        ),
        RiskLevel.alto(
          customItems: [
            'Edificaciones indispensables según la NSR-10.',
          ],
        ),
      ],
    );
  }

  static RiskCategory _createOtrosElementosExpuestos() {
    return RiskCategory(
      id: 'otros_elementos_expuestos',
      title: 'Otros Elementos Expuestos (Líneas vitales y drenajes)',
      description: 'Evaluación de infraestructura vital y servicios expuestos',
      levels: ['BAJO', 'MEDIO\nBAJO', 'MEDIO\nALTO', 'ALTO'],
      order: 2,
      value: 2, // Valor según tabla oficial
      detailedLevels: [
        RiskLevel.bajo(
          customItems: [
            'Redes eléctricas y de telecomunicaciones.',
          ],
        ),
        RiskLevel.medioBajo(
          customItems: [
            'Vías y senderos peatonales que no representan únicas rutas de acceso y evacuación.',
          ],
        ),
        RiskLevel.medioAlto(
          customItems: [
            'Redes locales de servicios públicos.',
          ],
        ),
        RiskLevel.alto(
          customItems: [
            'Puentes, vías principales o vías que representen una única ruta de acceso y evacuación.',
            'Redes primarias de servicios públicos (acueducto, alcantarillado y gas).',
            'Drenajes.',
          ],
        ),
      ],
    );
  }

  static RiskCategory _createEscalaAfectacion() {
    return RiskCategory(
      id: 'escala_afectacion',
      title: 'Escala de Afectación',
      description: 'Evaluación del número de elementos expuestos',
      levels: ['BAJO', 'MEDIO\nBAJO', 'MEDIO\nALTO', 'ALTO'],
      order: 3,
      value: 3, // Valor según tabla oficial
      detailedLevels: [
        RiskLevel.bajo(
          customItems: [
            'Puntual (1 vivienda).',
          ],
        ),
        RiskLevel.medioBajo(
          customItems: [
            'Entre 2 y 3 viviendas.',
          ],
        ),
        RiskLevel.medioAlto(
          customItems: [
            'Entre 4 y 5 viviendas.',
          ],
        ),
        RiskLevel.alto(
          customItems: [
            'Zonal (Cuadra, manzana, barrio).',
          ],
        ),
      ],
    );
  }
}