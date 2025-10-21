import 'package:equatable/equatable.dart';

/// Value Object para datos de comandos de formularios
/// Encapsula la lógica de negocio relacionada con acciones/comandos
class FormCommandData extends Equatable {
  final String formId;
  final String eventName;
  final FormCommandType commandType;
  final Map<String, dynamic>? data;
  final DateTime timestamp;
  
  const FormCommandData({
    required this.formId,
    required this.eventName,
    required this.commandType,
    this.data,
    required this.timestamp,
  });

  @override
  List<Object?> get props => [formId, eventName, commandType, data, timestamp];

  /// Lógica de negocio: ¿Es un comando de creación?
  bool get isCreateCommand => commandType == FormCommandType.create;

  /// Lógica de negocio: ¿Es un comando de actualización?
  bool get isUpdateCommand => commandType == FormCommandType.update;

  /// Lógica de negocio: ¿Es un comando de eliminación?
  bool get isDeleteCommand => commandType == FormCommandType.delete;

  /// Lógica de negocio: ¿Es un comando de finalización?
  bool get isCompleteCommand => commandType == FormCommandType.complete;

  /// Lógica de negocio: Validar si el comando es válido
  bool isValid() {
    return formId.isNotEmpty && 
           eventName.isNotEmpty && 
           commandType != FormCommandType.unknown;
  }

  /// Método de negocio: Crear copia con cambios
  FormCommandData copyWith({
    String? formId,
    String? eventName,
    FormCommandType? commandType,
    Map<String, dynamic>? data,
    DateTime? timestamp,
  }) {
    return FormCommandData(
      formId: formId ?? this.formId,
      eventName: eventName ?? this.eventName,
      commandType: commandType ?? this.commandType,
      data: data ?? this.data,
      timestamp: timestamp ?? this.timestamp,
    );
  }

  /// Factory method: Crear comando de creación
  static FormCommandData create({
    required String formId,
    required String eventName,
    Map<String, dynamic>? data,
  }) {
    return FormCommandData(
      formId: formId,
      eventName: eventName,
      commandType: FormCommandType.create,
      data: data,
      timestamp: DateTime.now(),
    );
  }

  /// Factory method: Crear comando de actualización
  static FormCommandData update({
    required String formId,
    required String eventName,
    required Map<String, dynamic> data,
  }) {
    return FormCommandData(
      formId: formId,
      eventName: eventName,
      commandType: FormCommandType.update,
      data: data,
      timestamp: DateTime.now(),
    );
  }

  /// Factory method: Crear comando de eliminación
  static FormCommandData delete({
    required String formId,
    required String eventName,
  }) {
    return FormCommandData(
      formId: formId,
      eventName: eventName,
      commandType: FormCommandType.delete,
      timestamp: DateTime.now(),
    );
  }

  /// Factory method: Crear comando de finalización
  static FormCommandData complete({
    required String formId,
    required String eventName,
    Map<String, dynamic>? data,
  }) {
    return FormCommandData(
      formId: formId,
      eventName: eventName,
      commandType: FormCommandType.complete,
      data: data,
      timestamp: DateTime.now(),
    );
  }

  @override
  String toString() {
    return 'FormCommandData(formId: $formId, eventName: $eventName, '
           'commandType: $commandType, timestamp: $timestamp)';
  }
}

/// Enum para tipos de comandos
enum FormCommandType {
  create,
  update,
  delete,
  complete,
  unknown;

  /// Lógica de negocio: ¿Es un comando destructivo?
  bool get isDestructive => this == delete;

  /// Lógica de negocio: ¿Es un comando de creación?
  bool get isCreation => this == create;

  /// Lógica de negocio: ¿Es un comando de modificación?
  bool get isModification => this == update || this == complete;
}
