import 'package:equatable/equatable.dart';

/// Value Object para datos de formulario
/// Encapsula la lógica de negocio relacionada con formularios
class FormData extends Equatable {
  final String eventName;
  final String classificationType;
  final Map<String, dynamic> data;
  final DateTime? lastModified;
  
  const FormData({
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
  static FormData forAmenaza(String eventName, Map<String, dynamic> data) {
    return FormData(
      eventName: eventName,
      classificationType: 'amenaza',
      data: data,
      lastModified: DateTime.now(),
    );
  }

  /// Factory method: Crear formulario de vulnerabilidad
  static FormData forVulnerabilidad(String eventName, Map<String, dynamic> data) {
    return FormData(
      eventName: eventName,
      classificationType: 'vulnerabilidad',
      data: data,
      lastModified: DateTime.now(),
    );
  }

  /// Método de negocio: Crear copia con cambios
  FormData copyWith({
    String? eventName,
    String? classificationType,
    Map<String, dynamic>? data,
    DateTime? lastModified,
  }) {
    return FormData(
      eventName: eventName ?? this.eventName,
      classificationType: classificationType ?? this.classificationType,
      data: data ?? this.data,
      lastModified: lastModified ?? this.lastModified,
    );
  }

  /// Método de negocio: Agregar datos
  FormData addData(String key, dynamic value) {
    final newData = Map<String, dynamic>.from(data);
    newData[key] = value;
    return copyWith(data: newData, lastModified: DateTime.now());
  }

  /// Método de negocio: Remover datos
  FormData removeData(String key) {
    final newData = Map<String, dynamic>.from(data);
    newData.remove(key);
    return copyWith(data: newData, lastModified: DateTime.now());
  }

  @override
  String toString() {
    return 'FormData(eventName: $eventName, classificationType: $classificationType, '
           'hasData: $hasData, lastModified: $lastModified)';
  }
}
