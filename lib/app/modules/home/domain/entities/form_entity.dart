import 'package:equatable/equatable.dart';

/// Entidad de dominio para formularios
/// Encapsula la lógica de negocio relacionada con formularios
class FormEntity extends Equatable {
  final String id;
  final String eventName;
  final FormStatus status;
  final DateTime createdAt;
  final DateTime lastModified;
  final Map<String, dynamic>? data;
  final bool isExplicitlyCompleted;

  const FormEntity({
    required this.id,
    required this.eventName,
    required this.status,
    required this.createdAt,
    required this.lastModified,
    this.data,
    this.isExplicitlyCompleted = false,
  });

  /// Factory constructor para crear formulario nuevo
  factory FormEntity.create({
    required String id,
    required String eventName,
    Map<String, dynamic>? data,
  }) {
    final now = DateTime.now();
    return FormEntity(
      id: id,
      eventName: eventName,
      status: FormStatus.inProgress,
      createdAt: now,
      lastModified: now,
      data: data,
      isExplicitlyCompleted: false,
    );
  }

  /// Factory constructor para crear formulario completado
  factory FormEntity.complete({
    required String id,
    required String eventName,
    Map<String, dynamic>? data,
  }) {
    final now = DateTime.now();
    return FormEntity(
      id: id,
      eventName: eventName,
      status: FormStatus.completed,
      createdAt: now,
      lastModified: now,
      data: data,
      isExplicitlyCompleted: true,
    );
  }

  /// Copia con cambios
  FormEntity copyWith({
    String? id,
    String? eventName,
    FormStatus? status,
    DateTime? createdAt,
    DateTime? lastModified,
    Map<String, dynamic>? data,
    bool? isExplicitlyCompleted,
  }) {
    return FormEntity(
      id: id ?? this.id,
      eventName: eventName ?? this.eventName,
      status: status ?? this.status,
      createdAt: createdAt ?? this.createdAt,
      lastModified: lastModified ?? this.lastModified,
      data: data ?? this.data,
      isExplicitlyCompleted: isExplicitlyCompleted ?? this.isExplicitlyCompleted,
    );
  }

  /// Lógica de negocio: ¿Es un formulario en progreso?
  bool get isInProgress => status == FormStatus.inProgress;

  /// Lógica de negocio: ¿Es un formulario completado?
  bool get isCompleted => status == FormStatus.completed;

  /// Lógica de negocio: ¿Es un formulario nuevo?
  bool get isNew => createdAt.difference(lastModified).abs().inSeconds < 5;

  /// Lógica de negocio: ¿Ha sido modificado recientemente?
  bool get isRecentlyModified {
    final diff = DateTime.now().difference(lastModified);
    return diff.inMinutes < 5;
  }

  /// Lógica de negocio: ¿Puede ser editado?
  bool get canBeEdited => isInProgress || (isCompleted && !isExplicitlyCompleted);

  /// Lógica de negocio: ¿Puede ser eliminado?
  bool get canBeDeleted => isInProgress || (isCompleted && !isExplicitlyCompleted);

  /// Lógica de negocio: ¿Puede ser completado?
  bool get canBeCompleted => isInProgress && data != null && data!.isNotEmpty;

  /// Lógica de negocio: Validar si el formulario es válido
  bool isValid() {
    return id.isNotEmpty && 
           eventName.isNotEmpty && 
           status != FormStatus.unknown;
  }

  /// Lógica de negocio: Obtener título del formulario
  String get title => '${eventName} - Análisis Completo';

  /// Lógica de negocio: Obtener descripción del estado
  String get statusDescription {
    switch (status) {
      case FormStatus.inProgress:
        return 'En progreso';
      case FormStatus.completed:
        return 'Completado';
      case FormStatus.unknown:
        return 'Estado desconocido';
    }
  }

  /// Lógica de negocio: Obtener tiempo transcurrido desde creación
  Duration get timeSinceCreation => DateTime.now().difference(createdAt);

  /// Lógica de negocio: Obtener tiempo transcurrido desde última modificación
  Duration get timeSinceLastModified => DateTime.now().difference(lastModified);

  @override
  List<Object?> get props => [
        id,
        eventName,
        status,
        createdAt,
        lastModified,
        data,
        isExplicitlyCompleted,
      ];

  /// Factory constructor desde JSON
  factory FormEntity.fromJson(Map<String, dynamic> json) {
    return FormEntity(
      id: json['id'] ?? '',
      eventName: json['eventName'] ?? '',
      status: FormStatus.values.firstWhere(
        (e) => e.name == json['status'],
        orElse: () => FormStatus.unknown,
      ),
      createdAt: DateTime.parse(json['createdAt'] ?? DateTime.now().toIso8601String()),
      lastModified: DateTime.parse(json['lastModified'] ?? DateTime.now().toIso8601String()),
      data: json['data'] != null ? Map<String, dynamic>.from(json['data']) : null,
      isExplicitlyCompleted: json['isExplicitlyCompleted'] ?? false,
    );
  }

  /// Convertir a JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'eventName': eventName,
      'status': status.name,
      'createdAt': createdAt.toIso8601String(),
      'lastModified': lastModified.toIso8601String(),
      'data': data,
      'isExplicitlyCompleted': isExplicitlyCompleted,
    };
  }


  /// Getter para la fecha de última modificación formateada
  String get formattedLastModified {
    final now = DateTime.now();
    final difference = now.difference(lastModified);
    
    if (difference.inDays > 0) {
      return 'Hace ${difference.inDays} días';
    } else if (difference.inHours > 0) {
      return 'Hace ${difference.inHours} horas';
    } else if (difference.inMinutes > 0) {
      return 'Hace ${difference.inMinutes} minutos';
    } else {
      return 'Hace un momento';
    }
  }

  /// Getter para el evento de riesgo
  String? get riskEvent => eventName;

  @override
  String toString() {
    return 'FormEntity(id: $id, eventName: $eventName, status: $status, '
           'createdAt: $createdAt, lastModified: $lastModified)';
  }
}

/// Enum para estados de formulario
enum FormStatus {
  inProgress,
  completed,
  unknown;

  /// Lógica de negocio: ¿Es un estado final?
  bool get isFinal => this == completed;

  /// Lógica de negocio: ¿Es un estado activo?
  bool get isActive => this == inProgress;

  /// Lógica de negocio: ¿Es un estado válido?
  bool get isValid => this != unknown;
}
