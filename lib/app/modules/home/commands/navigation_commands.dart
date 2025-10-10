import 'package:equatable/equatable.dart';
import '../models/domain/form_navigation_data.dart';

/// Comandos de navegación usando Command Pattern
/// Sigue los principios SOLID (especialmente OCP y LSP)
abstract class NavigationCommand extends Equatable {
  final String commandId;
  final DateTime timestamp;
  
  const NavigationCommand({
    required this.commandId,
    required this.timestamp,
  });

  @override
  List<Object?> get props => [commandId, timestamp];

  /// Método para ejecutar el comando
  Future<NavigationResult> execute();

  /// Método para deshacer el comando (si es posible)
  Future<NavigationResult> undo();

  /// Lógica de negocio: ¿Se puede deshacer?
  bool get canUndo;

  @override
  String toString() => 'NavigationCommand($commandId)';
}

/// Comando para navegar a eventos de riesgo
class NavigateToRiskEventsCommand extends NavigationCommand {
  const NavigateToRiskEventsCommand({
    required super.commandId,
    required super.timestamp,
  });

  @override
  Future<NavigationResult> execute() async {
    return NavigationResult.success(
      message: 'Navegando a eventos de riesgo',
      navigationData: {'section': 'risk_events'},
    );
  }

  @override
  Future<NavigationResult> undo() async {
    return NavigationResult.failure(message: 'La navegación no se puede deshacer');
  }

  @override
  bool get canUndo => false;
}

/// Comando para navegar a categorías de riesgo
class NavigateToRiskCategoriesCommand extends NavigationCommand {
  final FormNavigationData navigationData;
  
  const NavigateToRiskCategoriesCommand({
    required super.commandId,
    required super.timestamp,
    required this.navigationData,
  });

  @override
  List<Object?> get props => [...super.props, navigationData];

  @override
  Future<NavigationResult> execute() async {
    return NavigationResult.success(
      message: 'Navegando a categorías de riesgo',
      navigationData: {
        'section': 'risk_categories',
        'eventName': navigationData.eventName,
        'formId': navigationData.formId,
        'loadSavedForm': navigationData.loadSavedForm,
        'showProgressInfo': navigationData.showProgressInfo,
      },
    );
  }

  @override
  Future<NavigationResult> undo() async {
    return NavigationResult.failure(message: 'La navegación no se puede deshacer');
  }

  @override
  bool get canUndo => false;
}

/// Comando para navegar a formulario completado
class NavigateToFormCompletedCommand extends NavigationCommand {
  const NavigateToFormCompletedCommand({
    required super.commandId,
    required super.timestamp,
  });

  @override
  Future<NavigationResult> execute() async {
    return NavigationResult.success(
      message: 'Navegando a formulario completado',
      navigationData: {'section': 'form_completed'},
    );
  }

  @override
  Future<NavigationResult> undo() async {
    return NavigationResult.failure(message: 'La navegación no se puede deshacer');
  }

  @override
  bool get canUndo => false;
}

/// Comando para navegar en la barra inferior
class NavigateBottomBarCommand extends NavigationCommand {
  final int tabIndex;
  final String? previousTab;
  
  const NavigateBottomBarCommand({
    required super.commandId,
    required super.timestamp,
    required this.tabIndex,
    this.previousTab,
  });

  @override
  List<Object?> get props => [...super.props, tabIndex, previousTab];

  @override
  Future<NavigationResult> execute() async {
    return NavigationResult.success(
      message: 'Navegando a tab $tabIndex',
      navigationData: {
        'tabIndex': tabIndex,
        'previousTab': previousTab,
      },
    );
  }

  @override
  Future<NavigationResult> undo() async {
    if (previousTab != null) {
      return NavigationResult.success(
        message: 'Regresando a tab $previousTab',
        navigationData: {
          'tabIndex': previousTab,
          'previousTab': tabIndex,
        },
      );
    }
    return NavigationResult.failure(message: 'No hay tab anterior para regresar');
  }

  @override
  bool get canUndo => previousTab != null;
}

/// Resultado de navegación
class NavigationResult {
  final bool isSuccess;
  final String message;
  final Map<String, dynamic>? navigationData;
  final String? error;
  final DateTime timestamp;

  const NavigationResult({
    required this.isSuccess,
    required this.message,
    this.navigationData,
    this.error,
    required this.timestamp,
  });

  /// Factory method: Navegación exitosa
  factory NavigationResult.success({
    required String message,
    Map<String, dynamic>? navigationData,
  }) {
    return NavigationResult(
      isSuccess: true,
      message: message,
      navigationData: navigationData,
      timestamp: DateTime.now(),
    );
  }

  /// Factory method: Navegación fallida
  factory NavigationResult.failure({
    required String message,
    String? error,
  }) {
    return NavigationResult(
      isSuccess: false,
      message: message,
      error: error,
      timestamp: DateTime.now(),
    );
  }

  /// Lógica de negocio: ¿Tiene datos de navegación?
  bool get hasNavigationData => navigationData != null;

  /// Lógica de negocio: ¿Tiene error?
  bool get hasError => !isSuccess;

  @override
  String toString() {
    if (isSuccess) {
      return 'NavigationResult(success: $message${hasNavigationData ? ', data: $navigationData' : ''})';
    } else {
      return 'NavigationResult(failure: $message${error != null ? ', error: $error' : ''})';
    }
  }
}
