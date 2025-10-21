import 'package:equatable/equatable.dart';
import '../models/domain/form_command_data.dart';
import '../models/domain/form_navigation_data.dart';

/// Comandos de formularios usando Command Pattern
/// Sigue los principios SOLID (especialmente OCP y LSP)
abstract class FormCommand extends Equatable {
  final String commandId;
  final DateTime timestamp;
  
  const FormCommand({
    required this.commandId,
    required this.timestamp,
  });

  @override
  List<Object?> get props => [commandId, timestamp];

  /// Método para ejecutar el comando
  Future<CommandResult> execute();

  /// Método para deshacer el comando (si es posible)
  Future<CommandResult> undo();

  /// Lógica de negocio: ¿Se puede deshacer?
  bool get canUndo;

  /// Lógica de negocio: ¿Es un comando destructivo?
  bool get isDestructive;

  @override
  String toString() => 'FormCommand($commandId)';
}

/// Comando para crear formulario
class CreateFormCommand extends FormCommand {
  final FormCommandData commandData;
  
  const CreateFormCommand({
    required super.commandId,
    required super.timestamp,
    required this.commandData,
  });

  @override
  List<Object?> get props => [...super.props, commandData];

  @override
  Future<CommandResult> execute() async {
    // Implementación específica para crear formulario
    return CommandResult.success(
      message: 'Formulario creado exitosamente',
      data: {'formId': commandData.formId},
    );
  }

  @override
  Future<CommandResult> undo() async {
    // Crear formulario se puede deshacer eliminándolo
    return CommandResult.success(
      message: 'Formulario eliminado',
      data: {'formId': commandData.formId},
    );
  }

  @override
  bool get canUndo => true;

  @override
  bool get isDestructive => false;
}

/// Comando para actualizar formulario
class UpdateFormCommand extends FormCommand {
  final FormCommandData commandData;
  final Map<String, dynamic> previousData;
  
  const UpdateFormCommand({
    required super.commandId,
    required super.timestamp,
    required this.commandData,
    required this.previousData,
  });

  @override
  List<Object?> get props => [...super.props, commandData, previousData];

  @override
  Future<CommandResult> execute() async {
    // Implementación específica para actualizar formulario
    return CommandResult.success(
      message: 'Formulario actualizado exitosamente',
      data: {'formId': commandData.formId},
    );
  }

  @override
  Future<CommandResult> undo() async {
    // Actualizar se puede deshacer restaurando datos anteriores
    return CommandResult.success(
      message: 'Formulario restaurado a estado anterior',
      data: {'formId': commandData.formId, 'restoredData': previousData},
    );
  }

  @override
  bool get canUndo => true;

  @override
  bool get isDestructive => false;
}

/// Comando para eliminar formulario
class DeleteFormCommand extends FormCommand {
  final FormCommandData commandData;
  final Map<String, dynamic> deletedData;
  
  const DeleteFormCommand({
    required super.commandId,
    required super.timestamp,
    required this.commandData,
    required this.deletedData,
  });

  @override
  List<Object?> get props => [...super.props, commandData, deletedData];

  @override
  Future<CommandResult> execute() async {
    // Implementación específica para eliminar formulario
    return CommandResult.success(
      message: 'Formulario eliminado exitosamente',
      data: {'formId': commandData.formId},
    );
  }

  @override
  Future<CommandResult> undo() async {
    // Eliminar se puede deshacer restaurando el formulario
    return CommandResult.success(
      message: 'Formulario restaurado',
      data: {'formId': commandData.formId, 'restoredData': deletedData},
    );
  }

  @override
  bool get canUndo => true;

  @override
  bool get isDestructive => true;
}

/// Comando para completar formulario
class CompleteFormCommand extends FormCommand {
  final FormCommandData commandData;
  
  const CompleteFormCommand({
    required super.commandId,
    required super.timestamp,
    required this.commandData,
  });

  @override
  List<Object?> get props => [...super.props, commandData];

  @override
  Future<CommandResult> execute() async {
    // Implementación específica para completar formulario
    return CommandResult.success(
      message: 'Formulario completado exitosamente',
      data: {'formId': commandData.formId},
    );
  }

  @override
  Future<CommandResult> undo() async {
    // Completar se puede deshacer marcando como incompleto
    return CommandResult.success(
      message: 'Formulario marcado como incompleto',
      data: {'formId': commandData.formId},
    );
  }

  @override
  bool get canUndo => true;

  @override
  bool get isDestructive => false;
}

/// Comando para navegar a formulario
class NavigateToFormCommand extends FormCommand {
  final FormNavigationData navigationData;
  
  const NavigateToFormCommand({
    required super.commandId,
    required super.timestamp,
    required this.navigationData,
  });

  @override
  List<Object?> get props => [...super.props, navigationData];

  @override
  Future<CommandResult> execute() async {
    // Implementación específica para navegar
    return CommandResult.success(
      message: 'Navegación exitosa',
      data: {
        'eventName': navigationData.eventName,
        'formId': navigationData.formId,
      },
    );
  }

  @override
  Future<CommandResult> undo() async {
    // Navegación no se puede deshacer
    return CommandResult.failure(message: 'La navegación no se puede deshacer');
  }

  @override
  bool get canUndo => false;

  @override
  bool get isDestructive => false;
}

/// Resultado de ejecución de comando
class CommandResult {
  final bool isSuccess;
  final String message;
  final Map<String, dynamic>? data;
  final String? error;
  final DateTime timestamp;

  const CommandResult({
    required this.isSuccess,
    required this.message,
    this.data,
    this.error,
    required this.timestamp,
  });

  /// Factory method: Comando exitoso
  factory CommandResult.success({
    required String message,
    Map<String, dynamic>? data,
  }) {
    return CommandResult(
      isSuccess: true,
      message: message,
      data: data,
      timestamp: DateTime.now(),
    );
  }

  /// Factory method: Comando fallido
  factory CommandResult.failure({
    required String message,
    String? error,
  }) {
    return CommandResult(
      isSuccess: false,
      message: message,
      error: error,
      timestamp: DateTime.now(),
    );
  }

  /// Lógica de negocio: ¿Tiene datos?
  bool get hasData => data != null;

  /// Lógica de negocio: ¿Tiene error?
  bool get hasError => !isSuccess;

  @override
  String toString() {
    if (isSuccess) {
      return 'CommandResult(success: $message${hasData ? ', data: $data' : ''})';
    } else {
      return 'CommandResult(failure: $message${error != null ? ', error: $error' : ''})';
    }
  }
}
