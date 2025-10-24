import 'package:caja_herramientas/app/shared/models/risk_level.dart';

/// Representa una clasificación dentro de un evento de riesgo
/// Ejemplo: Amenaza, Vulnerabilidad
class RiskClassification {
  final String id;
  final String name;
  final String description;
  final List<RiskSubClassification> subClassifications;
  final Map<String, dynamic>? metadata;

  const RiskClassification({
    required this.id,
    required this.name,
    required this.description,
    required this.subClassifications,
    this.metadata,
  });

  factory RiskClassification.fromMap(Map<String, dynamic> map) {
    return RiskClassification(
      id: map['id'] as String,
      name: map['name'] as String,
      description: map['description'] as String,
      subClassifications: (map['subClassifications'] as List)
          .map((e) => RiskSubClassification.fromMap(e as Map<String, dynamic>))
          .toList(),
      metadata: map['metadata'] as Map<String, dynamic>?,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'subClassifications': subClassifications.map((e) => e.toMap()).toList(),
      if (metadata != null) 'metadata': metadata,
    };
  }

  @override
  String toString() => 'RiskClassification(id: $id, name: $name)';
}

/// Representa una subclasificación dentro de una clasificación
/// Ejemplo: Probabilidad, Intensidad (dentro de Amenaza)
class RiskSubClassification {
  final String id;
  final String name;
  final String description;
  final List<RiskCategory> categories;
  final double weight; // Peso para cálculos
  final bool hasCriticalVariable; // Indica si usa lógica de variable crítica
  final Map<String, dynamic>? metadata;

  const RiskSubClassification({
    required this.id,
    required this.name,
    required this.description,
    required this.categories,
    this.weight = 1.0,
    this.hasCriticalVariable = false,
    this.metadata,
  });

  factory RiskSubClassification.fromMap(Map<String, dynamic> map) {
    return RiskSubClassification(
      id: map['id'] as String,
      name: map['name'] as String,
      description: map['description'] as String,
      categories: (map['categories'] as List)
          .map((e) => RiskCategory.fromMap(e as Map<String, dynamic>))
          .toList(),
      weight: (map['weight'] as num?)?.toDouble() ?? 1.0,
      hasCriticalVariable: map['hasCriticalVariable'] as bool? ?? false,
      metadata: map['metadata'] as Map<String, dynamic>?,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'categories': categories.map((e) => e.toMap()).toList(),
      'weight': weight,
      'hasCriticalVariable': hasCriticalVariable,
      if (metadata != null) 'metadata': metadata,
    };
  }

  RiskSubClassification copyWith({
    String? id,
    String? name,
    String? description,
    List<RiskCategory>? categories,
    double? weight,
    bool? hasCriticalVariable,
    Map<String, dynamic>? metadata,
  }) {
    return RiskSubClassification(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      categories: categories ?? this.categories,
      weight: weight ?? this.weight,
      hasCriticalVariable: hasCriticalVariable ?? this.hasCriticalVariable,
      metadata: metadata ?? this.metadata,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is RiskSubClassification &&
        other.id == id &&
        other.name == name &&
        other.description == description &&
        other.weight == weight &&
        other.hasCriticalVariable == hasCriticalVariable;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        name.hashCode ^
        description.hashCode ^
        weight.hashCode ^
        hasCriticalVariable.hashCode;
  }

  @override
  String toString() => 'RiskSubClassification(id: $id, name: $name, hasCriticalVariable: $hasCriticalVariable)';

}

/// Representa una categoría específica a evaluar
/// Ejemplo: "Características Geotécnicas", "Volumen del Deslizamiento"
class RiskCategory {
  final String id;
  final String title;
  final String description;
  final List<String> levels;
  final List<RiskLevel> detailedLevels;
  final bool isRequired;
  final int order;
  final int value; // Valor seleccionado de la categoría (1-4)
  final int wi; // Peso/weight para la calificación ponderada
  final Map<String, dynamic>? metadata;

  const RiskCategory({
    required this.id,
    required this.title,
    required this.description,
    required this.levels,
    required this.detailedLevels,
    required this.value,
    this.wi = 1, // Peso por defecto 1
    this.isRequired = true,
    this.order = 0,
    this.metadata,
  });

  factory RiskCategory.fromMap(Map<String, dynamic> map) {
    return RiskCategory(
      id: map['id'] as String,
      title: map['title'] as String,
      description: map['description'] as String,
      levels: List<String>.from(map['levels'] as List),
      detailedLevels: (map['detailedLevels'] as List)
          .map((e) => RiskLevel.fromMap(e as Map<String, dynamic>))
          .toList(),
      value: map['value'] as int? ?? 1, // Valor por defecto 1 si no existe
      wi: map['wi'] as int? ?? 1, // Peso por defecto 1 si no existe
      isRequired: map['isRequired'] as bool? ?? true,
      order: map['order'] as int? ?? 0,
      metadata: map['metadata'] as Map<String, dynamic>?,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'levels': levels,
      'detailedLevels': detailedLevels.map((e) => e.toMap()).toList(),
      'value': value,
      'wi': wi,
      'isRequired': isRequired,
      'order': order,
      if (metadata != null) 'metadata': metadata,
    };
  }

  /// Crea una copia de la categoría con los valores especificados
  RiskCategory copyWith({
    String? id,
    String? title,
    String? description,
    List<String>? levels,
    List<RiskLevel>? detailedLevels,
    int? value,
    int? wi,
    bool? isRequired,
    int? order,
    Map<String, dynamic>? metadata,
  }) {
    return RiskCategory(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      levels: levels ?? this.levels,
      detailedLevels: detailedLevels ?? this.detailedLevels,
      value: value ?? this.value,
      wi: wi ?? this.wi,
      isRequired: isRequired ?? this.isRequired,
      order: order ?? this.order,
      metadata: metadata ?? this.metadata,
    );
  }

  /// Calcula la calificación ponderada (value * wi)
  double get weightedScore => (value * wi).toDouble();

  /// Calcula la calificación como la multiplicación de wi * value
  /// Se actualiza automáticamente cuando el value cambia en el dropdown
  int get calificacion => wi * value;

  @override
  String toString() => 'RiskCategory(id: $id, title: $title, value: $value, wi: $wi, calificacion: $calificacion)';
}

/// Representa un evento de riesgo completo
/// Ejemplo: "Movimiento en Masa", "Incendio Forestal"
class RiskEventModel {
  final String id;
  final String name;
  final String description;
  final String iconAsset;
  final List<RiskClassification> classifications;
  final bool isActive;
  final DateTime createdAt;
  final Map<String, dynamic>? metadata;

  const RiskEventModel({
    required this.id,
    required this.name,
    required this.description,
    required this.iconAsset,
    required this.classifications,
    this.isActive = true,
    required this.createdAt,
    this.metadata,
  });

  factory RiskEventModel.fromMap(Map<String, dynamic> map) {
    return RiskEventModel(
      id: map['id'] as String,
      name: map['name'] as String,
      description: map['description'] as String,
      iconAsset: map['iconAsset'] as String,
      classifications: (map['classifications'] as List)
          .map((e) => RiskClassification.fromMap(e as Map<String, dynamic>))
          .toList(),
      isActive: map['isActive'] as bool? ?? true,
      createdAt: DateTime.parse(map['createdAt'] as String),
      metadata: map['metadata'] as Map<String, dynamic>?,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'iconAsset': iconAsset,
      'classifications': classifications.map((e) => e.toMap()).toList(),
      'isActive': isActive,
      'createdAt': createdAt.toIso8601String(),
      if (metadata != null) 'metadata': metadata,
    };
  }

  /// Obtiene una clasificación específica por ID
  RiskClassification? getClassificationById(String classificationId) {
    try {
      return classifications.firstWhere((c) => c.id == classificationId);
    } catch (e) {
      return null;
    }
  }

  /// Obtiene una subclasificación específica
  RiskSubClassification? getSubClassification(String classificationId, String subClassificationId) {
    final classification = getClassificationById(classificationId);
    if (classification == null) return null;
    
    try {
      return classification.subClassifications.firstWhere((sc) => sc.id == subClassificationId);
    } catch (e) {
      return null;
    }
  }

  /// Obtiene todas las categorías de una subclasificación
  List<RiskCategory> getCategoriesForSubClassification(String classificationId, String subClassificationId) {
    final subClassification = getSubClassification(classificationId, subClassificationId);
    return subClassification?.categories ?? [];
  }

  /// Obtiene categorías de probabilidad (para compatibilidad con el sistema actual)
  List<RiskCategory> getProbabilityCategories() {
    return getCategoriesForSubClassification('amenaza', 'probabilidad');
  }

  /// Obtiene categorías de intensidad (para compatibilidad con el sistema actual)
  List<RiskCategory> getIntensityCategories() {
    return getCategoriesForSubClassification('amenaza', 'intensidad');
  }

  @override
  String toString() => 'RiskEventModel(id: $id, name: $name)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is RiskEventModel &&
        other.id == id &&
        other.name == name;
  }

  @override
  int get hashCode => id.hashCode ^ name.hashCode;
}