/// Resultado de comando
/// Encapsula el resultado de la ejecución de un comando
class CommandResult {
  final bool isSuccess;
  final String? message;
  final dynamic data;
  final Exception? error;
  
  const CommandResult._({
    required this.isSuccess,
    this.message,
    this.data,
    this.error,
  });

  /// Crear resultado exitoso
  factory CommandResult.success({String? message, dynamic data}) {
    return CommandResult._(
      isSuccess: true,
      message: message,
      data: data,
    );
  }

  /// Crear resultado fallido
  factory CommandResult.failure({required String message, Exception? error}) {
    return CommandResult._(
      isSuccess: false,
      message: message,
      error: error,
    );
  }

  /// ¿Es exitoso?
  bool get isFailure => !isSuccess;

  @override
  String toString() {
    return 'CommandResult(isSuccess: $isSuccess, message: $message, hasData: ${data != null}, hasError: ${error != null})';
  }
}
