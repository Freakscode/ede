import 'package:caja_herramientas/app/shared/models/models.dart';

/// Adaptador para facilitar la migración del sistema actual al nuevo modelo jerárquico
/// Mantiene compatibilidad con DropdownCategory mientras se migra gradualmente
class RiskModelAdapter {
  
  /// Convierte las categorías del nuevo modelo a DropdownCategory (para compatibilidad)
  static List<DropdownCategory> convertToDropdownCategories(List<RiskCategory> riskCategories) {
    return riskCategories.map((riskCategory) {
      return DropdownCategory.custom(
        title: riskCategory.title,
        levels: riskCategory.levels,
        detailedLevels: riskCategory.detailedLevels,
        additionalData: {
          'id': riskCategory.id,
          'description': riskCategory.description,
          'isRequired': riskCategory.isRequired,
          'order': riskCategory.order,
          ...?riskCategory.metadata,
        },
      );
    }).toList();
  }

  /// Obtiene categorías de probabilidad para un evento (compatibilidad con sistema actual)
  static List<DropdownCategory> getProbabilityCategoriesForEvent(String eventName) {
    final event = RiskEventFactory.getEventByName(eventName);
    if (event == null) return DropdownCategory.defaultCategories;
    
    final probabilityCategories = event.getProbabilityCategories();
    return convertToDropdownCategories(probabilityCategories);
  }

  /// Obtiene categorías de intensidad para un evento (compatibilidad con sistema actual)
  static List<DropdownCategory> getIntensityCategoriesForEvent(String eventName) {
    final event = RiskEventFactory.getEventByName(eventName);
    if (event == null) return DropdownCategory.defaultIntensidadCategories;
    
    final intensityCategories = event.getIntensityCategories();
    return convertToDropdownCategories(intensityCategories);
  }

  /// Mapea nombres de eventos del sistema actual al nuevo modelo
  static String mapEventName(String oldEventName) {
    switch (oldEventName) {
      case 'Movimiento en Masa':
        return 'Movimiento en Masa';
      case 'Avenidas torrenciales':
      case 'Avenida Torrencial':
        return 'Avenida Torrencial';
      case 'Inundación':
        return 'Inundación';
      case 'Estructural':
        return 'Estructural';
      case 'Otros':
        return 'Otros';
      // Mantener compatibilidad con nombres anteriores
      case 'Incendio Forestal':
        return 'Incendio Forestal';
      default:
        return oldEventName;
    }
  }

  /// Obtiene el modelo completo de un evento
  static RiskEventModel? getEventModel(String eventName) {
    final mappedName = mapEventName(eventName);
    return RiskEventFactory.getEventByName(mappedName);
  }

  /// Obtiene todas las clasificaciones de un evento
  static List<RiskClassification> getEventClassifications(String eventName) {
    final event = getEventModel(eventName);
    return event?.classifications ?? [];
  }

  /// Obtiene una clasificación específica de un evento
  static RiskClassification? getEventClassification(String eventName, String classificationId) {
    final event = getEventModel(eventName);
    return event?.getClassificationById(classificationId);
  }

  /// Obtiene las subclasificaciones de amenaza de un evento
  static List<RiskSubClassification> getThreatSubClassifications(String eventName) {
    final classification = getEventClassification(eventName, 'amenaza');
    return classification?.subClassifications ?? [];
  }

  /// Obtiene información detallada de una categoría específica
  static RiskCategory? getCategoryDetails(String eventName, String classificationId, 
                                         String subClassificationId, String categoryId) {
    final event = getEventModel(eventName);
    if (event == null) return null;
    
    final subClassification = event.getSubClassification(classificationId, subClassificationId);
    if (subClassification == null) return null;
    
    try {
      return subClassification.categories.firstWhere((cat) => cat.id == categoryId);
    } catch (e) {
      return null;
    }
  }

  /// Valida si un evento existe en el nuevo modelo
  static bool isValidEvent(String eventName) {
    return getEventModel(eventName) != null;
  }

  /// Obtiene la lista de eventos disponibles
  static List<String> getAvailableEventNames() {
    return RiskEventFactory.getAllEvents().map((event) => event.name).toList();
  }

  /// Obtiene estadísticas de un evento
  static Map<String, int> getEventStatistics(String eventName) {
    final event = getEventModel(eventName);
    if (event == null) {
      return {
        'classifications': 0,
        'subClassifications': 0,
        'categories': 0,
      };
    }
    
    int totalSubClassifications = 0;
    int totalCategories = 0;
    
    for (final classification in event.classifications) {
      totalSubClassifications += classification.subClassifications.length;
      for (final subClassification in classification.subClassifications) {
        totalCategories += subClassification.categories.length;
      }
    }
    
    return {
      'classifications': event.classifications.length,
      'subClassifications': totalSubClassifications,
      'categories': totalCategories,
    };
  }

  /// Obtiene información de debug para un evento
  static Map<String, dynamic> getEventDebugInfo(String eventName) {
    final event = getEventModel(eventName);
    if (event == null) {
      return {
        'exists': false,
        'eventName': eventName,
      };
    }
    
    final stats = getEventStatistics(eventName);
    
    return {
      'exists': true,
      'eventId': event.id,
      'eventName': event.name,
      'description': event.description,
      'iconAsset': event.iconAsset,
      'isActive': event.isActive,
      'createdAt': event.createdAt.toIso8601String(),
      'statistics': stats,
      'classifications': event.classifications.map((c) => {
        'id': c.id,
        'name': c.name,
        'subClassifications': c.subClassifications.map((sc) => {
          'id': sc.id,
          'name': sc.name,
          'weight': sc.weight,
          'categoriesCount': sc.categories.length,
        }).toList(),
      }).toList(),
    };
  }

  /// Migra gradualmente del sistema de DropdownCategory al nuevo modelo
  static void migrateEventData(String eventName, Map<String, String> selections) {
    final debugInfo = getEventDebugInfo(eventName);
    print('🔄 Migrating event data for: $eventName');
    print('📊 Event info: ${debugInfo.toString()}');
    print('📝 Selections: ${selections.toString()}');
    
    // Aquí se puede implementar lógica de migración de datos
    // Por ahora solo registramos la información para debugging
  }
}