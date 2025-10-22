import 'package:equatable/equatable.dart';

/// Entidad de dominio para datos de formulario
/// Encapsula la lógica de negocio relacionada con formularios
class FormEntity extends Equatable {
  final String eventName;
  final String classificationType;
  final Map<String, dynamic> data;
  final DateTime? lastModified;
  
  const FormEntity({
    required this.eventName,
    required this.classificationType,
    required this.data,
    this.lastModified,
  });

  @override
  List<Object?> get props => [eventName, classificationType, data, lastModified];

  /// Lógica de negocio: ¿Es un formulario válido?
  bool get isValid => eventName.isNotEmpty && classificationType.isNotEmpty;

  /// Lógica de negocio: ¿Es un formulario de amenaza?
  bool get isAmenaza => classificationType.toLowerCase() == 'amenaza';

  /// Lógica de negocio: ¿Es un formulario de vulnerabilidad?
  bool get isVulnerabilidad => classificationType.toLowerCase() == 'vulnerabilidad';

  /// Lógica de negocio: ¿Está vacío el formulario?
  bool get isEmpty => data.isEmpty;

  /// Lógica de negocio: ¿Tiene datos?
  bool get hasData => data.isNotEmpty;

  /// Factory method: Crear formulario de amenaza
  static FormEntity forAmenaza(String eventName, Map<String, dynamic> data) {
    return FormEntity(
      eventName: eventName,
      classificationType: 'amenaza',
      data: data,
      lastModified: DateTime.now(),
    );
  }

  /// Factory method: Crear formulario de vulnerabilidad
  static FormEntity forVulnerabilidad(String eventName, Map<String, dynamic> data) {
    return FormEntity(
      eventName: eventName,
      classificationType: 'vulnerabilidad',
      data: data,
      lastModified: DateTime.now(),
    );
  }

  /// Método de negocio: Crear copia con cambios
  FormEntity copyWith({
    String? eventName,
    String? classificationType,
    Map<String, dynamic>? data,
    DateTime? lastModified,
  }) {
    return FormEntity(
      eventName: eventName ?? this.eventName,
      classificationType: classificationType ?? this.classificationType,
      data: data ?? this.data,
      lastModified: lastModified ?? this.lastModified,
    );
  }

  /// Método de negocio: Agregar datos
  FormEntity addData(String key, dynamic value) {
    final newData = Map<String, dynamic>.from(data);
    newData[key] = value;
    return copyWith(data: newData, lastModified: DateTime.now());
  }

  /// Método de negocio: Remover datos
  FormEntity removeData(String key) {
    final newData = Map<String, dynamic>.from(data);
    newData.remove(key);
    return copyWith(data: newData, lastModified: DateTime.now());
  }

  @override
  String toString() {
    return 'FormEntity(eventName: $eventName, classificationType: $classificationType, '
           'hasData: $hasData, lastModified: $lastModified)';
  }
}
