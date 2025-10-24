import 'package:equatable/equatable.dart';
import '../../domain/entities/form_entity.dart';

/// Modelo de datos para formulario
/// Mapea entre la entidad de dominio y los datos persistentes
class FormDataModel extends Equatable {
  final String eventName;
  final String classificationType;
  final Map<String, dynamic> data;
  final DateTime? lastModified;

  const FormDataModel({
    required this.eventName,
    required this.classificationType,
    required this.data,
    this.lastModified,
  });

  /// Factory constructor desde entidad de dominio
  factory FormDataModel.fromEntity(FormEntity entity) {
    return FormDataModel(
      eventName: entity.eventName,
      classificationType: entity.classificationType,
      data: entity.data,
      lastModified: entity.lastModified,
    );
  }

  /// Convertir a entidad de dominio
  FormEntity toEntity() {
    return FormEntity(
      eventName: eventName,
      classificationType: classificationType,
      data: data,
      lastModified: lastModified,
    );
  }

  /// Factory constructor desde JSON
  factory FormDataModel.fromJson(Map<String, dynamic> json) {
    return FormDataModel(
      eventName: json['eventName'] ?? '',
      classificationType: json['classificationType'] ?? '',
      data: Map<String, dynamic>.from(json['data'] ?? {}),
      lastModified: json['lastModified'] != null 
          ? DateTime.parse(json['lastModified']) 
          : null,
    );
  }

  /// Convertir a JSON
  Map<String, dynamic> toJson() {
    return {
      'eventName': eventName,
      'classificationType': classificationType,
      'data': data,
      'lastModified': lastModified?.toIso8601String(),
    };
  }

  /// Copia con cambios
  FormDataModel copyWith({
    String? eventName,
    String? classificationType,
    Map<String, dynamic>? data,
    DateTime? lastModified,
  }) {
    return FormDataModel(
      eventName: eventName ?? this.eventName,
      classificationType: classificationType ?? this.classificationType,
      data: data ?? this.data,
      lastModified: lastModified ?? this.lastModified,
    );
  }

  @override
  List<Object?> get props => [eventName, classificationType, data, lastModified];
}
