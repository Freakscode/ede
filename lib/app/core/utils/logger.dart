import 'dart:developer' as developer;

class Logger {
  static void log(String message, {
    String? name,
    Object? error,
    StackTrace? stackTrace,
  }) {
    developer.log(
      message,
      name: name ?? 'App',
      error: error,
      stackTrace: stackTrace,
    );
  }

  static void info(String message, [String? name]) {
    log('[INFO] $message', name: name);
  }

  static void warning(String message, [String? name]) {
    log('[WARNING] $message', name: name);
  }

  static void error(String message, {
    Object? error,
    StackTrace? stackTrace,
    String? name,
  }) {
    log('[ERROR] $message', 
      name: name, 
      error: error, 
      stackTrace: stackTrace
    );
  }

  static void debug(String message, [String? name]) {
    log('[DEBUG] $message', name: name);
  }
}
